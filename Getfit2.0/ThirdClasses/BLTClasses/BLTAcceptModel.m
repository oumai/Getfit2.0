//
//  BLTAcceptModel.m
//  PlaneCup
//
//  Created by zorro on 15/3/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTAcceptModel.h"
#import "ShareData.h"
#import "BLTSendModel.h"
#import "BLTSimpleSend.h"
#import "TestViewController.h"
#import "PedometerHelper.h"
#import "AudioHelper.h"

@implementation BLTAcceptModel

DEF_SINGLETON(BLTAcceptModel)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _lastSerial = -999;
        _shakeArray = [[NSMutableArray alloc] init];
        _heartArray = [[NSMutableArray alloc] init];
        _syncData = [[NSMutableData alloc] init];
        _indexArray = [[NSMutableArray alloc] init];
        
        // 直接启动蓝牙
        [BLTManager sharedInstance];

        [BLTPeripheral sharedInstance].updateBigDataBlock = ^(NSData *data) {
            [self updateBigData:data];
        };
        [BLTPeripheral sharedInstance].updateBlock = ^(NSData *data, CBPeripheral *peripheral) {
            [self acceptData:data withPeripheral:peripheral];
        };
    }
    
    return self;
}

- (void)setType:(BLTAcceptModelType)type
{
    _type = type;
    
    // 5秒后没有回复信息表示通讯失败.
    if (_type == BLTAcceptModelTypeUnKnown)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkWhetherCommunicationError) object:nil];
        [self performSelector:@selector(checkWhetherCommunicationError) withObject:nil afterDelay:5.0];
    }
}

- (void)cancelSyncingStatus
{
    //SHOWMBProgressHUD(KK_Text(@"Sync Done"), nil, nil, NO, 2.0);
    
    [BLTSendModel sharedInstance].isSyncing = NO;
    
    [self performSelectorInBackground:@selector(saveNewData) withObject:nil];
}

- (void)exitBeforeSave
{
    if ([BLTSendModel sharedInstance].isSyncing) {
        [PedometerHelper saveDataToModel:_syncData withEnd:^(NSDate *date, BOOL success) {}];
    }
}

- (void)saveNewData
{
    // 保存数据并更新
    [PedometerHelper saveDataToModel:_syncData withEnd:^(NSDate *date, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_detailDataBlock) {
                _detailDataBlock(nil, 0);
            }
        });
    }];
}

- (void)acceptData:(NSData *)data withPeripheral:(CBPeripheral *)peripheral
{
    _type = BLTAcceptModelTypeSuccess;
    UInt8 val[20] = {0};
    [data getBytes:&val length:data.length];
    [[UserInfoHelper sharedInstance] writeDataToFile:data className:@"AC" fileType:@"获取"];
    
    NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接受到的数据： %@ %@", data, str1);
    
    id object = nil;
    if (data.length == 4)
    {
        // 历史数据
        _type = BLTAcceptModelSysData;
        object = data;
        
        [_syncData appendData:data];
        [BLTSendModel sharedInstance].isSyncing = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelSyncingStatus) object:nil];
        [self performSelector:@selector(cancelSyncingStatus) withObject:nil afterDelay:5.0];
        
        return;
    } else if(data.length == 8)
    {
        // 实时运动数据
        
        _type = BLTAcceptModelSysData;
        object = data;
        [PedometerHelper saverealTimeDataToModel:data withEnd:nil];
        
        if (_realTimeBlock) {
            _realTimeBlock(object, 0);
        }
        
        return;
        
    } else if(data.length == 2) {
        
        
        if (val[0] ==0xFF) {
            [_BLTControlTDelegate bltControlTakePhoto];
        } else if(val[0] ==0xFE) {
            
            _isOpenHeart = YES;
            
            // 实时心率数据
            NSInteger value = val[1];
            [_heartArray addObject:@(value)];
            if (_heartArray.count > 96) {
                [_heartArray removeObjectAtIndex:0];
            }
            
            if (value > _maxHeart) {
                _maxHeart = value;
            }
            
            if (_minHeart == 0) {
                _minHeart = value;
            } else if (_minHeart > 0) {
                if (_minHeart > value) {
                    _minHeart = value;
                }
            }
            
            if (_averageHeart > 0) {
                _averageHeart = (_averageHeart + value) / 2;
            } else {
                _averageHeart = value;
            }

            if (_realTimeHeartBlock) {
                _realTimeHeartBlock(@[@(_maxHeart), @(_averageHeart), @(_minHeart), @(value)], 0);
            }
            
            return;
            
        } else if(val[0] == 0xFC) {
            [UserInfoHelper sharedInstance].bltModel.batteryQuantity = val[1];
            
            if (_baseInfoBlock) {
                _baseInfoBlock(data, 0);
            }
            
            return;
        } else if(val[0] == 0xFB) {
            [UserInfoHelper sharedInstance].bltModel.bltVersion = val[1];
            
            if (_baseInfoBlock) {
                _baseInfoBlock(data, 0);
            }
            
            return;
        } else if (val[0] == 0xFD) {
            /*
            if (val[1] == 0x02) {
                // 退出测试
                _maxHeart = 0;
                _averageHeart = 0;
                _minHeart = 0;
                _isOpenHeart = NO;
                
                [UserInfoHelper sharedInstance].userModel.heartOpen = NO;
            } else {
                _isOpenHeart = YES;
                [UserInfoHelper sharedInstance].userModel.heartOpen = YES;
            }
            
            if (_heartStatusBlock) {
                _heartStatusBlock(nil, 0);
            } */
            
        } else if (val[0] == 0xFA && val[1] == 0X00){
            [KK_AudioHelper playAudio];
        }
    }
    else if (data.length == 5)
    {
        _type = BLTAcceptModelSysData;
        /*
        object = data;
        
        [PedometerHelper saveHeartDataToModel:data withEnd:^(NSDate *date, BOOL success) {
        }];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateHeartChart) object:nil];
        [self performSelector:@selector(updateHeartChart) withObject:nil afterDelay:3.0]; */

        return;
    } else if (data.length == 9) {
        NSString *str = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(2, 6)] encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (val[1]==1) {
            //气压
            [dic  setValue:str forKey:@"pressure"];
        } else if (val[1]==2) {
            //海拔
            NSString *cutOutAltitudeString = [str substringWithRange:NSMakeRange(0, 5)]; //截取五位  ，然后保存
            [dic  setValue:cutOutAltitudeString forKey:@"altitude"];
        } else if (val[1]==3) {
            //温度
            NSString *cutOutTemperatureString = [str substringWithRange:NSMakeRange(0, 5)]; //截取五位  ，然后保存
            [dic  setValue:cutOutTemperatureString forKey:@"temperature"];
        }
        NSLog(@"Michael  data = %@  str = %@ pressure= %@  altitude = %@ temperature = %@ ",data,str,[dic  objectForKey:@"pressure"],[dic  objectForKey:@"altitude"],[dic  objectForKey:@"temperature"]);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"X7通知" object:nil userInfo:dic];
    } else if (data.length == 6){
        [UserInfoHelper sharedInstance].bltModel.macAddress =
        [NSString stringWithFormat:@"%X:%X:%X:%X:%X:%X", val[0], val[1], val[2], val[3], val[4], val[5]];
    }
    
    if (_updateValue) {
        _updateValue(object, _type);
        _updateValue = nil;
    }
}

- (void)updateHeartChart
{
    if (_heartBlock) {
        _heartBlock(nil, 0);
    }
}

- (void)updateBigData:(NSData *)data
{
    
}

- (void)startCheckPackagesCount
{
}

- (void)hiddenProgress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        HIDDENMBProgressHUD;
    });
}

- (BOOL)isOpenHeart
{
    if ([UserInfoHelper sharedInstance].bltModel.isConnected) {
        return _isOpenHeart;
    } else {
        return NO;
    }
}

#pragma mark --- syncData 数据清空 ---
- (void)cleanMutableData
{
    _isAcceptEnd = NO;
    _lastMissIndex = 1;
    _acceptCount = 0;
    _packagesCount = 0;
    [_indexArray removeAllObjects];
    
    [_syncData resetBytesInRange:NSMakeRange(0, _syncData.length)];
    [_syncData setLength:0];
}

// 检查当次通讯是否发生错误
- (void)checkWhetherCommunicationError
{
    if (_type == BLTAcceptModelTypeUnKnown)
    {
        [self updateFailInfo];
    }
}

// 提示失败信息
- (void)updateFailInfo
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkWhetherCommunicationError) object:nil];
    
    NSLog(@" 提示失败信息");
    _type = BLTAcceptModelTypeError;
    if (_updateValue)
    {
        _updateValue(nil, _type);
        _updateValue = nil;
    }
}

@end
