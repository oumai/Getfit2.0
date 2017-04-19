//
//  UserInfoHelper.m
//  AJBracelet
//
//  Created by zorro on 15/7/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserInfoHelper.h"
#import "BLTSendModel.h"
#import "XYSandbox.h"
#import "BLTSimpleSend.h"
#import "DateTools.h"
#import "TestViewController.h"

@implementation UserInfoHelper

DEF_SINGLETON(UserInfoHelper)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [ShareData sharedInstance].isAllowUserInfoSave = NO;
        _userModel = [UserInfoModel getUserInfoFromDB];
        [ShareData sharedInstance].isAllowUserInfoSave = YES;
    }
    
    return self;
}

// 保证一直持有最新的bltmodel. 所以有可能这一次与上一次返回的完全不一样...
- (BLTModel *)bltModel
{
    BLTModel *model = [BLTManager sharedInstance].model;
    
    if (model)
    {
        _bltModel = model;
    }
    else
    {
        model = [BLTModel getModelFromDBWtihUUID:[AJ_LastWareUUID getObjectValue]];
        if (model)
        {
            _bltModel = model;
        }
        else
        {
            model = [BLTModel initWithUUID:[AJ_LastWareUUID getObjectValue]];
            _bltModel = model;
        }
    }
    
    return _bltModel;
}

- (void)removeUserHeadImage
{
    NSString *filePath = [self getUserHeadImageFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:filePath error:nil];
}

// 缓存用户头像到本地.
- (void)saveHeadImageToFileCacheWithPicker:(UIImagePickerController *)picker withInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *scaleImage = [image imageScaleToSize:CGSizeMake(200.0, 200.0)];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    
    NSString *filePath = [self getUserHeadImageFilePath];
    NSData *data = UIImageJPEGRepresentation(scaleImage, 1.0);
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
}

// 获取用户头像.
- (UIImage *)getUserHeadImage
{
    NSString *filePath = [self getUserHeadImageFilePath];
    
    if ([self completePathDetermineIsThere:filePath])
    {
        return [UIImage imageWithPath:filePath];
    }
    else
    {
        // 默认头像图片
        return UIImageNamed(@"mine_big_circle_5s@2x.png");
    }
}

- (NSString *)getUserHeadImageFilePath
{
    NSString *headFold = [[XYSandbox libCachePath] stringByAppendingPathComponent:AJ_FileCache_HeadImage];
    NSString *filePath = [headFold stringByAppendingPathComponent:AJ_HeadImage];
    
    return filePath;
}

- (void)sendAlarmClockSetting
{
    if ([BLTManager sharedInstance].isConnected)
    {
        if (_bltModel.alarmArray.count > _alarmCount)
        {
            AlarmClockModel *model = _bltModel.alarmArray[_alarmCount];
            
            NSLog(@"model.isChanged>>>>%i..%d",model.isChanged, _alarmCount);
            
            if (model.isChanged)
            {
                [BLTSendModel sendSetDeviceAlarmClock:model
                                      withUpdateBlock:^(id object, BLTAcceptModelType type) {
                                          if (type == BLTAcceptModelTypeSetAlarmClock)
                                          {
                                              // NSString *title = [NSString stringWithFormat:@"闹钟%ld设置成功", (long)_alarmCount];
                                              // SHOWMBProgressHUD(title, nil, nil, NO, 2.0);
                                              model.isChanged = NO;
                                              model.isSys = YES;
                                          }
                                          else
                                          {
                                              // _alarmCount--;
                                          }
                                          
                                          _alarmCount ++;
                                          
                                          [self performSelector:@selector(sendAlarmClockSetting)
                                                     withObject:nil
                                                     afterDelay:BLT_InfoDelayTime];
                                      }];
            }
            else
            {
                _alarmCount ++;
                
                [self performSelector:@selector(sendAlarmClockSetting)
                           withObject:nil
                           afterDelay:BLT_InfoDelayTime];
            }
        }
        else if (_bltModel.alarmArray.count == _alarmCount)
        {
            SHOWMBProgressHUD(NSLocalizedString(@"设置成功.", nil), nil, nil, NO, 2.0);
        }
        
    }
    else
    {
        SHOWMBProgressHUD(NSLocalizedString(@"Device not Connected.", nil), nil, nil, NO, 2.0);
    }
}

- (void)startSetAlarmClock
{
    _alarmCount = 0;
//    [self sendAlarmClockSetting];
    
    if ([BLTManager sharedInstance].isConnected || 1)
    {
        [BLTSendModel sendSysAlarm:^(id object, BLTAcceptModelType type) {
            
        }];
        SHOWMBProgressHUD(NSLocalizedString(@"设置成功.", nil), nil, nil, NO, 2.0);
    }
    else
    {
         SHOWMBProgressHUD(NSLocalizedString(@"Device not Connected.", nil), nil, nil, NO, 2.0);
    }
    

}

- (void)sendSedentaryRemindSetting
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendSysRemind:^(id object, BLTAcceptModelType type)
         {
            
        }];
          SHOWMBProgressHUD(NSLocalizedString(@"设置成功.", nil), nil, nil, NO, 2.0);
//        [BLTSendModel sendSetDeviceSedentaryRemind:model withUpdateBlock:^(id object, BLTAcceptModelType type) {
////            NSLog(@"%d",type);
//            if (type == BLTAcceptModelTypeSetRemind)
//            {
//                SHOWMBProgressHUD(NSLocalizedString(@"设置成功.", nil), nil, nil, NO, 2.0);
//            }
//        }];
    }
    else
    {
        SHOWMBProgressHUD(NSLocalizedString(@"Device not Connected.", nil), nil, nil, NO, 2.0);
    }
}

- (void)sendDrinkWater
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendDrinkWater:^(id object, BLTAcceptModelType type) {
            
        }];
        SHOWMBProgressHUD(NSLocalizedString(@"设置成功.", nil), nil, nil, NO, 2.0);
    }
    else
    {
        SHOWMBProgressHUD(NSLocalizedString(@"Device not Connected.", nil), nil, nil, NO, 2.0);
    }
}

// 拍照模式
- (void)sendPhotoControl:(BOOL)type
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendControlTakePhotoState:type WithUpdateBlock:^(id object, BLTAcceptModelType type)
        {
            if (type == BLTAcceptModelPhotoControl)
            {
                NSLog(@"拍照模式  object>>>>>>%@",object);
                if (type)
                {
//                 SHOWMBProgressHUD(@"开启拍照", nil, nil, NO, 1.0);
                }
                else
                {
//                  SHOWMBProgressHUD(@"关闭拍照", nil, nil, NO, 1.0);
                }
                
            }
        }];
    }
}

- (void)updateBraceletInfoToDevice:(BOOL)isShow
{
    
}

- (void)updateUserInfoToDevice:(BOOL)isShow
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendSetUserInfoWithUpdateBlock:^(id object, BLTAcceptModelType type) {
            if (type == BLTAcceptModelTypeSetUserInfo)
            {
                if (isShow)
                {
                    SHOWMBProgressHUD(NSLocalizedString(@"设置成功.", nil), nil, nil, NO, 2.0);
                }
            }
        }];
    }
    else
    {
        SHOWMBProgressHUD(NSLocalizedString(@"Device not Connected.", nil), nil, nil, NO, 2.0);
    }
}

// 设置时间制
- (void)sendTimeMode
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendSetUnitwithUpdateBlock:^(id object, BLTAcceptModelType type) {
            if (type == BLTAcceptModelTypeUnitSuccess)
            {
                NSLog(@"BLTAcceptModelTypeUnitSuccess>>>>");
                [self performSelector:@selector(sendDateInfo) withObject:nil afterDelay:BLT_InfoDelayTime];
            }
            else
            {
                NSLog(@"BLTAcceptModelTypeUnitFail>>>>");
            }
            }
         ];
    }
}


// 设置来电提醒模式
- (void)sendCallRemind:(BOOL)type WithBackBlock:(NSObjectSimpleBlock)block;
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendNoticePhoneCallsReminding:type withUpdateBlock:^(id object, BLTAcceptModelType type) {
            
            if (type == NO)
            {
                if (block)
                {
                    block (@(0));
                }
            }
            else if (type == YES)
            {
                if (block)
                {
                    block (@(1));
                }
            }

        }];
    }
}

// 获取日志
- (void)sendDeviceReportWithBackBlock:(NSObjectSimpleBlock)Dateblock WithFinishBlcok:(NSObjectSimpleBlock)Finishblock
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendSetReport:^(id object, BLTAcceptModelType type)
        {
            
            if (type == BLTAcceptModelReport)
            {
                if (Dateblock)
                {
                    Dateblock(object);
                }
            }
            else if (type == BLTAcceptModelReportFinish)
            {
                if (Finishblock)
                {
                    Finishblock (@(YES));
                }
            }
            
        }];
    }
}

// 重启设备
- (void)senddeviceRoloadWithBackBlock:(NSObjectSimpleBlock)block
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendSetReloadDevice:^(id object, BLTAcceptModelType type) {
            
            if (type == BLTAcceptModelReLoad)
            {
                if (block)
                {
                    block (@(YES));
                }
            }
        }];
    }
}

// 设置防丢模式
- (void)sendLostMode:(BOOL)type WithBackBlock:(NSObjectSimpleBlock)block
{
    [BLTSendModel sendLostWithUpdateBlockState:type WithUpdateBlock:^(id object, BLTAcceptModelType type) {
          }];
}

// 设置翻手亮屏
- (void)sendTurnHand:(BOOL)type WithBackBlock:(NSObjectSimpleBlock)block
{
    [BLTSendModel sendTurnHandWithUpdateBlockState:type WithUpdateBlock:^(id object, BLTAcceptModelType type) {
    }];
}

- (void)sendDateInfo
{
    [BLTSendModel sendSetDeviceTimeWithUpdateBlock:^(id object, BLTAcceptModelType type) {
        if (type == BLTAcceptModelTypeSetDateInfo)
        {
         [self performSelector:@selector(sendStartSynHistory) withObject:nil afterDelay:BLT_InfoDelayTime];
        }
    }];
}

- (void)sendStartSynHistory
{
    // 进入前台同步数据
    if ([BLTManager sharedInstance].isConnected)
    {
        if (![BLTSimpleSend sharedInstance].isSyning && ![UserInfoHelper sharedInstance].isUpdating)
        {
            [[BLTSimpleSend sharedInstance] startSynHistoryAndTodayData:YES];
//            [[TestViewController shareInstance] updateLog:@"进入前台同步数据"];
        }
    }
//    else
//    {
//        [[BLTManager sharedInstance] repeatScan];
//    }
}




// 获取设备支持模式
- (void)sendDeviceFunctionWithBackBlock:(NSObjectSimpleBlock)block
{
    NSLog(@"请求设备支持类型>>>>>>");
    
    
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendSetDeviceFuctionWithBlock:^(id object, BLTAcceptModelType type)
         {
//             NSLog(@"%d",type);
             
             if (type == BLTAcceptModelTypeFunction)
             {
//                 NSLog(@"设备支持功能 >>>>>%@",object);
//                 [[TestViewController shareInstance] updateLog:@"功能过滤成功"];
                 NSData *data = object;
                 UInt8 val[20] = {0};
                 [data getBytes:&val length:data.length];
//                 0001 0011
                 NSMutableArray *functionArray = [[NSMutableArray alloc] init];
                 NSMutableArray *mainfunction = [[NSMutableArray alloc] init];
                 NSMutableArray *alarmFunction = [[NSMutableArray alloc] init];
//                 NSMutableArray *controlFunction = [[NSMutableArray alloc] init];
//                 NSMutableArray *callFunction = [[NSMutableArray alloc] init];
//                 NSMutableArray *messageFunction = [[NSMutableArray alloc] init];
//                 NSMutableArray *ortherFunction = [[NSMutableArray alloc] init];
//                 [[TestViewController shareInstance] updateLog:[NSString stringWithFormat:@"val[2] == %hhu",val[2]]];
                 if (val[6] & 0x01)
                 {
                     [mainfunction addObject:@"来电提醒"];
                     NSLog(@"来电提醒");
                 }
                 
                 if (val[8] & 0x01)
                 {
                     [mainfunction addObject:@"久坐提醒"];
                     NSLog(@"久坐提醒");
                 }

//                NSLog(@"主要功能:>>>>>>>%@",mainfunction);
//                 [mainfunction addObject:@(val[3])];
                 [alarmFunction addObject:@(val[3])];
                 
                 if (val[4] & 0x01)
                 {
                     [alarmFunction addObject:@"起床"];
                     NSLog(@"起床");
                 }
                 if (val[4] & 0x02)
                 {
                     [alarmFunction addObject:@"睡觉"];
                     NSLog(@"睡觉");
                 }
                 if (val[4] & 0x04)
                 {
                     [alarmFunction addObject:@"锻炼"];
                     NSLog(@"锻炼");
                 }
                 if (val[4] & 0x08)
                 {
                     [alarmFunction addObject:@"吃药"];
                     NSLog(@"吃药");
                 }
                 if (val[4] & 0x10)
                 {
                     [alarmFunction addObject:@"约会"];
                     NSLog(@"约会");
                 }
                 if (val[4] & 0x20)
                 {
                     [alarmFunction addObject:@"聚会"];
                     NSLog(@"聚会");
                 }
                 if (val[4] & 0x40)
                 {
                     [alarmFunction addObject:@"会议"];
                     NSLog(@"会议");
                 }
                 if (val[4] & 0x80)
                 {
                     [alarmFunction addObject:@"自定义"];
                     NSLog(@"自定义");
                 }

                 NSLog(@"闹钟类型:>>>>>>>%@",alarmFunction);
                 if (alarmFunction.count !=0) {
                     [mainfunction addObject:@"自定义闹钟提醒"];
                 }
                 
                 if (val[5] & 0x01)
                 {
                     [mainfunction addObject:@"拍照"];
                     NSLog(@"拍照");
                 }
                 if (val[8] & 0x02)
                 {
                     [mainfunction addObject:@"防丢提醒"];
                     NSLog(@"防丢提醒");
                 }
                
                 if (val[2] & 0x10)
                 {
                     NSLog(@"设备更新");
                     [mainfunction addObject:@"设备升级"];
                 }
                 
           
                 if (val[5] & 0x02)
                 {
                     [mainfunction addObject:@"音乐"];
                     NSLog(@"音乐");
                 }

//                 NSLog(@"控制功能:>>>>>>>%@",controlFunction);
                 
             
                 if (val[6] & 0x02)
                 {
                     [mainfunction addObject:@"来电联系人"];
                     NSLog(@"来电联系人");
                 }
                 if (val[6] & 0x04)
                 {
                     [mainfunction addObject:@"来电号码"];
                     NSLog(@"来电号码");
                 }
//                 NSLog(@"来电提醒:>>>>>>>%@",callFunction);
                 
                 if (val[7] & 0x01)
                 {
                     [mainfunction addObject:@"短信"];
                     NSLog(@"短信");
                 }
                 if (val[7] & 0x02)
                 {
                     [mainfunction addObject:@"邮件"];
                     NSLog(@"邮件");
                 }
                 if (val[7] & 0x04)
                 {
                     [mainfunction addObject:@"qq"];
                     NSLog(@"qq");
                 }
                 if (val[7] & 0x08)
                 {
                     [mainfunction addObject:@"微信"];
                     NSLog(@"微信");
                 }
                 if (val[7] & 0x10)
                 {
                     [mainfunction addObject:@"新浪微博"];
                      NSLog(@"新浪微博");
                 }
                 if (val[7] & 0x20)
                 {
                     [mainfunction addObject:@"facebook"];
                     NSLog(@"facebook");
                 }
                 if (val[7] & 0x40)
                 {
                     [mainfunction addObject:@"twitter"];
                     NSLog(@"twitter");
                 }
                 if (val[7] & 0x80)
                 {
                     [mainfunction addObject:@"其他"];
                     NSLog(@"其他");
                 }
//                 NSLog(@"信息提醒功能:>>>>>>>%@",messageFunction);
                 
              
          
                 if (val[8] & 0x04)
                 {
                     [mainfunction addObject:@"一键呼叫"];
                     NSLog(@"一键呼叫");
                 }
                 if (val[8] & 0x08)
                 {
                     [mainfunction addObject:@"寻找手机"];
                     NSLog(@"寻找手机");
                 }
                 if (val[8] & 0x10)
                 {
                     [mainfunction addObject:@"寻找手环"];
                      NSLog(@"寻找手环");
                 }
                 
                 if (val[2] & 0x01)
                 {
                     NSLog(@"计步");
                     [mainfunction addObject:@"计步"];
                 }
                 if (val[2] & 0x02)
                 {
                     NSLog(@"睡眠监测");
                     [mainfunction addObject:@"睡眠监测"];
                 }
                 if (val[2] & 0x04)
                 {
                     NSLog(@"单次运动");
                     [mainfunction addObject:@"单次运动"];
                 }
                 if (val[2] & 0x08)
                 {
                     NSLog(@"实时数据");
                     [mainfunction addObject:@"实时数据"];
                 }
//                 NSLog(@"其他功能:>>>>>>>%@",ortherFunction);
//                 [[TestViewController shareInstance] updateLog:[NSString stringWithFormat:@"%@",functionArray]];
                 [functionArray addObject:mainfunction];
                 [functionArray addObject:alarmFunction];
//                 [functionArray addObject:controlFunction];
//                 [functionArray addObject:callFunction];
//                 [functionArray addObject:messageFunction];
//                 [functionArray addObject:ortherFunction];
//                 NSLog(@"%@",functionArray);
                 [UserInfoHelper sharedInstance].userModel.functionList = functionArray;
                 if (block)
                 {
                     block(@(YES));
                 }
             }

         }];
        
    }else {
        NSMutableArray *UnLineArray = [[NSMutableArray alloc] init];
        [UnLineArray addObject:@"来电提醒"];
//        [UnLineArray addObject:@"久坐提醒"];
        [UnLineArray addObject:@"自定义闹钟提醒"];
        [UnLineArray addObject:@"拍照"];
        [UnLineArray addObject:@"防丢提醒"];
         [UnLineArray addObject:@"设备升级"];
        NSMutableArray *UnLineFunction = [[NSMutableArray alloc] init];
        [UnLineFunction addObject:UnLineArray];
        [UserInfoHelper sharedInstance].userModel.functionList = UnLineFunction;
    }

}

- (void)updateUserSportTargetAndSleepTarget:(BOOL)isShow
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendSetSportTargetWithUpdateBlock:^(id object, BLTAcceptModelType type) {
            if (type == BLTAcceptModelTypeSetSportTarget)
            {
                if (isShow)
                {
                    SHOWMBProgressHUD(NSLocalizedString(@"设置成功.", nil), nil, nil, NO, 2.0);
                }
            }
        }];
    }
    else
    {
        SHOWMBProgressHUD(NSLocalizedString(@"Device not Connected.", nil), nil, nil, NO, 2.0);
    }
}

// 目前蓝牙省电模式 不适宜一起延迟发送.必须一个接一个的发送指令
- (void)updateUserInfoAndTarget
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendSetUserInfoWithUpdateBlock:^(id object, BLTAcceptModelType type) {
            if (type == BLTAcceptModelTypeSetUserInfo)
            {
                [self performSelector:@selector(delaySettingUserSportTargetAndSleepTarget)
                           withObject:nil
                           afterDelay:BLT_InfoDelayTime];
            }
        }];
    }
    else
    {
        SHOWMBProgressHUD(NSLocalizedString(@"Device not Connected.", nil), nil, nil, NO, 2.0);
    }
}

- (void)delaySettingUserSportTargetAndSleepTarget
{
    [self updateUserSportTargetAndSleepTarget:NO];
}

// 解绑当前设备
- (void)unpairCurrentDeviceWithBackBlock:(NSObjectSimpleBlock)block
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [UserInfoHelper sharedInstance].bltModel.isBinding = NO;
          BLTModel *model = [UserInfoHelper sharedInstance].bltModel;
          [[BLTManager sharedInstance] disConnectPeripheralWithModel:model];///断开连接
          [BLTManager sharedInstance].model.isRepeatConnect = NO;   ///解绑断开后不重连
          SHOWMBProgressHUD(NSLocalizedString(@"解绑成功", nil), nil, nil, NO, 2.0);

          if (block) {
              block(@(YES));
          }
    }

//    if ([BLTManager sharedInstance].isConnected)
//    {
//      [BLTSendModel sendDeviceBindingWithCMDType:BLTDeviceUnbundling withUpdateBlock:^(id object, BLTAcceptModelType type) {
//          if (type == BLTAcceptModelTypeUnBindingSuccess)
//          {
//              [UserInfoHelper sharedInstance].bltModel.isBinding = NO;
//              BLTModel *model = [UserInfoHelper sharedInstance].bltModel;
//              [[BLTManager sharedInstance] disConnectPeripheralWithModel:model];///断开连接
//              [BLTManager sharedInstance].model.isRepeatConnect = NO;   ///解绑断开后不重连
//              SHOWMBProgressHUD(NSLocalizedString(@"解绑成功", nil), nil, nil, NO, 2.0);
//              
//              if (block)
//              {
//                  block(@(YES));
//              }
//          }
//      }];
//    }
}

- (NSInteger)userDays
{
    NSDate *date = [SAVEFIRSTUSERDATE getObjectValue];
    NSInteger beforeIndex = date.dayOfYear;
    NSInteger nowIndex = [NSDate date].dayOfYear;
    NSInteger longTime = nowIndex - beforeIndex + 1;
    return longTime;
}

// 获取使用过的时间
- (NSMutableArray*)getUserDateArray
{
    NSInteger maxCount = [self userDays];
    
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <maxCount; i ++)
    {
        [dateArray addObject:[self backDate:(maxCount - i -1)]];
    }
    
    return dateArray;
}

- (NSString *)backDate:(NSInteger)dateIndex
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[NSDate dateFormatterTemp];
    [dateformatter setDateFormat:@"YYYY/MM/dd"];
    NSTimeInterval time = - 24 * 3600 * dateIndex;
    NSDate *beforeData =[senddate initWithTimeIntervalSinceNow:time];
    NSString *  before=[dateformatter stringFromDate:beforeData];
    return before;
}

- (void)writeDataToFile:(NSData *)data className:(NSString *)className fileType:(NSString *)name
{
    return;
    
    UInt8 val[20] = {0};
    
    [data getBytes:&val length:data.length];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fiaeNameStr = [NSString stringWithFormat:@"/%ld月%ld日%@.txt",[NSDate date].month,[NSDate date].day,name];
    NSString *filePath = [documentsDirectory stringByAppendingString:fiaeNameStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtPath:filePath error:nil];
    if(![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }else {
        NSData *Data = [fileManager contentsAtPath:filePath];
        NSMutableData *write = [NSMutableData dataWithData:Data];
        NSString *timeString = [NSString stringWithFormat:@"[%@]:(%@)", [[NSDate date] dateToString],className];
        [write appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [write appendData:[timeString dataUsingEncoding:NSUTF8StringEncoding]];
        
        for(int t = 0;t < 20;t++) {
            NSString *valStr = [NSString stringWithFormat:@"%hhu",val[t]];
            if (![valStr isEqualToString:@""]) {
                [write appendData:[valStr dataUsingEncoding:NSUTF8StringEncoding]];
                [write appendData:[@" " dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        [write writeToFile:filePath atomically:YES];
    }
}

@end
