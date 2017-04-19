

//
//  BLTService.m
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTManager.h"
#import "BLTPeripheral.h"
#import "BLTUUID.h"
#import "AppDelegate.h"
#import "BLTSendModel.h"
#import "ShareData.h"
#import "TestViewController.h"

@interface BLTManager () <CBCentralManagerDelegate>


@property (nonatomic, strong) CBPeripheral *discoverPeripheral;
@property (nonatomic, assign) NSInteger RSSI;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *alarmTimer;


@end

@implementation BLTManager

DEF_SINGLETON(BLTManager)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        if (![AJ_LastWareUUID getObjectValue]) {
            [AJ_LastWareUUID setObjectValue:AJ_LastWareUUID];
        }
    
        _allWareArray = [[NSMutableArray alloc] initWithCapacity:0];
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        [BLTPeripheral sharedInstance].connectBlock = ^() {
            if (_connectBlock)
            {
                _connectBlock();
            }
        };
        
        [BLTPeripheral sharedInstance].RSSIBlock = ^(NSInteger RSSI) {
            [self updateRSSI:RSSI];
        };
        _isConnectNext = NO;
    }
    
    return self;
}

- (void)updateRSSI:(NSInteger)RSSI
{
    _model.bltRSSI = [NSString stringWithFormat:@"%ld", (long)RSSI];
    
    if (_updateModelBlock)
    {
        _updateModelBlock(_model);
    }
}

- (BOOL)isConnected
{
    if (_model.peripheral.state == CBPeripheralStateConnected)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark --- 通知界面的更新 ---

#pragma mark --- 操作移动设备的蓝牙链接 ---
- (void)startCan
{
    NSLog(@"完全的开始重新扫描...");
    [self resetDiscoverPeripheral];
    [self scan];
}

#pragma mark --- CBCentralManagerDelegate ---
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn)
    {
        if (_disConnectBlock)
        {
            _disConnectBlock();
        }
        return;
    }
    
    [self scan];
}

- (void)scan
{
    if (_centralManager.state != CBCentralManagerStatePoweredOn)
    {
        /*
         // 提示用户打开蓝牙.
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
         message:nil
         delegate:nil
         cancelButtonTitle:nil
         otherButtonTitles:@"OK", nil];
         [alert show];
         
         return;
         */
    }
    
    // 先停止扫描然后继续扫描. 避免因为多线程操作设备数组导致崩溃.
    [_centralManager stopScan];
//    [[TestViewController shareInstance] updateLog:@"开始扫描设备...."];
    // SHOWMBProgressHUD(BL_Text(@"Searching"), nil, nil, NO, 2.0);
    
    [_allWareArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BLTModel *model = obj;
        switch (model.peripheral.state)
        {
            case CBPeripheralStateConnected:
                
                break;
                
            default:
            {
                [_allWareArray removeObject:model];
            }
                break;
        }
    }];
    
    // [self updateViewsFromModel];
    [self.centralManager scanForPeripheralsWithServices:_isUpdateing ? nil : @[BLTUUID.uartServiceUUID]
                                                options:nil];
}

- (void)stopScan
{
//    [[TestViewController shareInstance] updateLog:@"停止扫描设备....."];
    [self.centralManager stopScan];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // NSLog(@"..%@..%@..%@", advertisementData, [peripheral.identifier UUIDString], peripheral.name);

    NSString *deviceName1 = peripheral.name;
    NSString *deviceName2 = [advertisementData objectForKey:@"kCBAdvDataLocalName"];

    // NSRange range = [[deviceName lowercaseString] rangeOfString:[proName lowercaseString]];
    
    if (![deviceName1 isEqualToString:AJ_DeviceName] &&
        ![deviceName2 isEqualToString:AJ_DeviceName])
    {
        // 目前设备种类很多. 不唯一, 用服务过滤
        // return;
    }
    
    NSString *idString = [peripheral.identifier UUIDString];
    
    if (!idString)
    {
        return;
    }
//    [[TestViewController shareInstance] updateLog:[NSString stringWithFormat:@"发现设备ID:\n%@",idString]];
    NSLog(@"找到手环 >>>>..%@..%@..%@", advertisementData, [peripheral.identifier UUIDString], peripheral.name);

    if (!_isUpdateing)
    {
        // 先在设备列表数组里面查找有没有.
        BLTModel *model = [self checkIsAddInAllWareWithID:idString];
       
        if (model)
        {
            model.bltRSSI = [NSString stringWithFormat:@"%d", ABS(RSSI.intValue)];
            model.peripheral = peripheral;
        }
        else
        {
            // 从数据库取当前设备的模型.
            model = [BLTModel getModelFromDBWtihUUID:idString];
            model.bltName = deviceName1 ? deviceName1 : (deviceName2 ? deviceName2 : @"");
            model.bltRSSI = [NSString stringWithFormat:@"%d", ABS(RSSI.intValue)];
            model.peripheral = peripheral;
            
            [_allWareArray addObject:model];
            [self quiteSort:0 and:_allWareArray.count - 1]; //排序
        }
        
        // 每次都初始化确保正确性.
        model.isInitiative = NO;
        model.isRepeatConnect = NO;
        
        NSString *lastUUID = [AJ_LastWareUUID getObjectValue];
        if ([lastUUID isEqualToString:model.bltUUID] && model.isBinding) {
//             [[TestViewController shareInstance] updateLog:[NSString stringWithFormat:@"匹配绑定的ID:\n%@",model.bltUUID]];
            // 如果该设备已经绑定并且没有连接设备时就直接连接.
            [self connectPeripheralWithModel:model];
        }
        
        [self updateViewsFromModel];
    }
    else
    {
        if ([idString isEqualToString:_updateModel.bltUUID])
        {
            [self connectPeripheralWithModel:_updateModel];
        }
    }
}

- (void)connectPeripheralWithModel:(BLTModel *)model
{
    // [[TestViewController shareInstance] updateLog:[NSString stringWithFormat:@"开始连接设备,连接的ID:\n%@",model.bltUUID]];
    if (!model.isConnected)
    {
        if (_model)
        {
            // 将当前连接的模型干掉...
            NSLog(@"准备连接新的设备...");
            [self initiativeDismissCurrentModel:_model];
        }
        
        _model = model;
        _discoverPeripheral = model.peripheral;
        [_centralManager connectPeripheral:_model.peripheral options:nil];
        [self updateViewsFromModel];
        
        [_centralManager stopScan];
    }
}

- (BLTModel *)checkIsAddInAllWareWithID:(NSString *)idString
{
    for (BLTModel *model in _allWareArray)
    {
        if ([model.bltUUID isEqualToString:idString])
        {
            return model;
        }
    }
    
    return nil;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
//    [[TestViewController shareInstance] updateLog:[NSString stringWithFormat:@"连接成功,连接的ID:\n%@",[peripheral.identifier UUIDString]]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"连接蓝牙" object:nil];
    _discoverPeripheral = peripheral;
    _discoverPeripheral.delegate = [BLTPeripheral sharedInstance];
    [BLTPeripheral sharedInstance].peripheral = _discoverPeripheral;
    
    if (_model)
    {
        // 如果设备组没有设备就添加进去.
        BLTModel *model = [self checkIsAddInAllWareWithID:_model.bltUUID];
        if (!model)
        {
            [_allWareArray addObject:_model];
            [self quiteSort:0 and:_allWareArray.count - 1];
        }
        
        if([UserInfoHelper sharedInstance].bltModel.isBinding) {
            _model.isRepeatConnect = YES;
        }
    }
    
    [self updateViewsFromModel];
    
    if (!_isUpdateing)
    {
        [_discoverPeripheral discoverServices:@[BLTUUID.uartServiceUUID]];
    }
    else
    {
        [_discoverPeripheral discoverServices:@[BLTUUID.updateServiceUUID]];
        [BLTDFUHelper sharedInstance].updatePeripheral = _discoverPeripheral;
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
//    [[TestViewController shareInstance] updateLog:@"连接失败....."];
    [self startCan];
    [self updateViewsFromModel];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (_disConnectBlock)
    {
        _disConnectBlock();
    }
    
    BLTModel *model = [self findModelWithPeripheral:peripheral];
    
    if (model)
    {
        // 是否主动断开的
        if (!model.isInitiative)
        {
//            [[TestViewController shareInstance] updateLog:@"自然失去链接....."];
//            [[UserInfoHelper sharedInstance] writeDataToFile:nil className:@"失去连接" fileType:@"debug"];
            // 是否需要重连接.
            if (model.isRepeatConnect)
            {
//                [[TestViewController shareInstance] updateLog:[NSString stringWithFormat:@"断开重连"]];
                [self repeatConnect:peripheral begin:0];
//                [[UserInfoHelper sharedInstance] writeDataToFile:nil className:@"开始重连" fileType:@"debug"];
//                [self waitFewSecondsBeforeRepeatScan];  ////十秒后没连上的话，重新扫描
            }
            else
            {
                NSLog(@"非重连,扫描....");
                [self startCan];
            }
        }
        else
        {
            // 主动断开的.
//            [[TestViewController shareInstance] updateLog:@"主动失去链接....."];
            model.isInitiative = NO;
            [self waitFewSecondsBeforeRepeatScan];
        }
    }
    else
    {
        [self startCan];
    }
    
    [self updateViewsFromModel];
}


- (void) repeatConnect:(CBPeripheral *)peripheral begin:(NSInteger)time {
    
    if (time > 5 &&! [UserInfoHelper sharedInstance].bltModel.isConnected){
        [self repeatScan];  /////反复连五次，没成功，重新扫描
        return;
    }
    if ([UserInfoHelper sharedInstance].bltModel.isConnected) {
        return;
    }
//    [[TestViewController shareInstance] updateLog:[NSString stringWithFormat:@"第%ld次重连..",time + 1 ]];
    [_centralManager connectPeripheral:peripheral options:nil];
    time ++;
    _count = time;
    _bondPeripheral = peripheral;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reConnect) object:nil];
    [self performSelector:@selector(reConnect) withObject:nil afterDelay:5.0];
}

- (void)reConnect{
    [self repeatConnect:_bondPeripheral begin:_count];
}

// 10秒内没连接上就重新扫描
- (void)waitFewSecondsBeforeRepeatScan
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeatScan) object:nil];
    [self performSelector:@selector(repeatScan) withObject:nil afterDelay:10.0];
}

- (void)repeatScan
{
    if (!_model || _model.peripheral.state != CBPeripheralStateConnected)
    {
//        [[TestViewController shareInstance] updateLog:@"重连失败,重新扫描....."];
//         [[UserInfoHelper sharedInstance] writeDataToFile:nil className:@"重连失败,重新扫描....." fileType:@"debug"];
        [self startCan];
    }
}

// 只要外围设备发生变化了就通知刷新
- (void)updateViewsFromModel
{
    if (_updateModelBlock)
    {
        _updateModelBlock(nil);
    }
}



/***********************    下面关于很多防丢的功能暂时用不到    ****************************/




// 设备丢失后10秒之后没有重新连接上就尖叫.
- (void)prepareAlarmWithPeripheral:(CBPeripheral *)peripheral
{
   
}

// 设备双击令设备尖叫.
- (void)keyEventControlAlertWithPeripheral:(CBPeripheral *)peripheral
{
}

// 达到一定的距离启动
- (void)distanceLostControlAlertWithPeripheral:(CBPeripheral *)peripheral withStart:(BOOL)isStart
{
}

// 因距离的问题, 可能是信号干扰的问题, 避免是误报, 延迟5秒, 减少误报的可能性
- (void)delayDistanceLostControlAlertWithPeripheral:(CBPeripheral *)peripheral
{
    
}

- (void)updateDeviceView:(BLTModel *)model
{
}

- (void)testCancelNotify:(BLTModel *)model
{
    //[[LocNotifyHelper sharedInstance] cancelNotificationWithModel:model];
}

// 按键触发某个设备尖叫.
- (void)keyEventControlAlarmWithPeripheral:(CBPeripheral *)peripheral
{
}

// 从连接的设备组里面移除掉某个设备.
- (void)removeModelWithPeripheral:(CBPeripheral *)peripheral withArray:(NSMutableArray *)array
{
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BLTModel *model = obj;
        if (model.peripheral == peripheral)
        {
            [array removeObject:model];
            *stop = YES;
        }
    }];
}

// 在所有准备连接的数组中 根据设备寻找模型.
- (BLTModel *)findModelWithPeripheral:(CBPeripheral *)peripheral
{
    for (BLTModel *model in _allWareArray)
    {
        if ([model.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString])
        {
            return model;
        }
    }
    
    return nil;
}

- (void)disConnectPeripheralWithModel:(BLTModel *)model
{
    [_centralManager cancelPeripheralConnection:model.peripheral];
}

- (void)dismissLinkAndRepeatConnect
{
    if (_discoverPeripheral)
    {
        [self dismissLinkAndRepeatConnect:_discoverPeripheral];
    }
}

// 主动断开重连接
- (void)dismissLinkAndRepeatConnect:(CBPeripheral *)peripheral
{
    if (peripheral)
    {
        BLTModel *model = [self findModelWithPeripheral:peripheral];
        
        if (model)
        {
            // 非主动断开会重连.
            model.isInitiative = NO;
            model.isRepeatConnect = YES;
        }
        
        [_centralManager cancelPeripheralConnection:peripheral];
    }
}

// 主动断开设备.
- (void)initiativeDismissCurrentModel:(BLTModel *)model
{
    NSLog(@"主动断开设备.");
    model.isInitiative = YES;
    [_centralManager cancelPeripheralConnection:model.peripheral];
}

// 解除绑定并且断开连接
- (void)removeBindingAndDisconnect:(BLTModel *)model withEndBlock:(NSObjectSimpleBlock)endBlock
{
}

- (void)connectNextPeripheral
{
    
    
}

// 主动断开, 去除显示在当前的设备
- (void)deleteModelFromAllWaresWith:(BLTModel *)model
{
    model.isInitiative = YES;
    [self disConnectPeripheralWithModel:model];
}

// 重置外围设备.
- (void)resetDiscoverPeripheral
{
    if (_discoverPeripheral)
    {
        _discoverPeripheral.delegate = nil;
        [_centralManager cancelPeripheralConnection:_discoverPeripheral];
        _discoverPeripheral = nil;
    }
    
    _model = nil;
}

- (void)dismissLink
{
    [self resetDiscoverPeripheral];
}

/**
 *  准备固件更新.
 */
- (void)checkIsAllownUpdateFirmWare
{
    if (self.discoverPeripheral.state == CBPeripheralStateConnected)
    {
        if ([UserInfoHelper sharedInstance].bltModel.batteryStatus == 2)
        {
            SHOWMBProgressHUD(NSLocalizedString(@"设备没有足够的电量.", nil), nil, nil, NO, 2);
        }
        else
        {
            [self startUpdateFirmWare];
        }
    }
    else
    {
        SHOWMBProgressHUD(NSLocalizedString(@"设备没有链接.", nil), nil, nil, NO, 2.0);
    }
}

// 开始对设备进行空中升级.
- (void)startUpdateFirmWare
{
    _isUpdateing = YES;
    _updateModel = _model;
    [BLTSendModel sendUpdateFirmwareWithUpdateBlock:^(id object, BLTAcceptModelType type) {
        if (type == BLTAcceptModelTypeNoMuchElec)
        {
        }
        else if (type == BLTAcceptModelTypeNoSupport)
        {
        }
        else
        {
           
        }
    }];
    
    [BLTDFUHelper sharedInstance].endBlock = ^(BOOL success) {
        [self firmWareUpdateEnd:success];
    };
}

// 升级结束 可能失败 可能成功.
- (void)firmWareUpdateEnd:(BOOL)success
{
    _isUpdateing = NO;
    _updateModel = nil;
    _model = nil;
    
    if (success)
    {
        SHOWMBProgressHUD(NSLocalizedString(@"固件更新成功.", nil), nil, nil, NO, 2.0);
    }
    else
    {
        SHOWMBProgressHUD(NSLocalizedString(@"升级失败.", nil), nil, nil, NO, 2.0);
    }
}
//////快速排序
- (void)quiteSort:(NSInteger)left and:(NSInteger)right {
    /*
    if (left >= right) {
        return;
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    BLTModel *letfModel = _allWareArray[left];
    NSInteger i = left;
    NSInteger j = right;
    NSInteger base = [letfModel.bltRSSI integerValue];
    for (BLTModel *models in _allWareArray) {
        [str appendString:models.bltRSSI];
        [str appendFormat:@" "];
    }
    while (i < j) {
        BLTModel *iModel = _allWareArray[i];
        BLTModel *jModel = _allWareArray[j];
        while ((i < j) && (base <= [jModel.bltRSSI integerValue])) {
            j--;
        }
        _allWareArray[i] = _allWareArray[j];
        
        while ((i < j)&& (base >= [iModel.bltRSSI integerValue])) {
            i++;
        }
        _allWareArray[j] = _allWareArray[i];
    }
//    NSLog(@"base = %ld",base);
//    NSLog(@"str = %@",str);
    _allWareArray[i] = letfModel;
    [self quiteSort:left and:i - 1];
    [self quiteSort:i + 1 and:right]; */
    
    [_allWareArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         BLTModel *model1 = (BLTModel *)obj1;
         BLTModel *model2 = (BLTModel *)obj2;
         
         if (model1.bltRSSI.integerValue > model2.bltRSSI.integerValue)
         {
             return NSOrderedAscending;
         }
         else
         {
             return NSOrderedDescending;
         }
     }];
}

@end
