//
//  BLTSendModel.m
//  PlaneCup
//
//  Created by zorro on 15/3/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTSendModel.h"
#import "BLTManager.h"
#import "UserInfoHelper.h"
#import "BLTSimpleSend.h"
#import "TestViewController.h"

@implementation BLTSendModel

DEF_SINGLETON(BLTSendModel)

#pragma mark 01

// 升级指令
+ (void)sendUpdateFirmwareWithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    return;
}

#pragma mark 02

+ (void)sendObtainDeviceInfoWithFunc:(BLTDeviceKeyList)key
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    return;
}

#pragma mark 03

// 时间设置.
+ (void)sendSetDeviceTimeWithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    return;
}

// 重启设备
+ (void)sendSetReloadDevice:(BLTAcceptModelUpdateValue)block
{
    UInt8 val[12] = {0xF0,0x01,0x55,0x55,0xAA,0xAA,0x55,0x55,0xAA,0xAA,0x55,0x55};
    [self sendDataToWare:val
              withLength:12
              withUpdate:block];
}

// 获取日志
+ (void)sendSetReport:(BLTAcceptModelUpdateValue)block
{
    UInt8 val[2] = {0x21,0x06};
    [self sendDataToWare:val
              withLength:2
              withUpdate:block];

}

// 单位设置(新的协议)
+ (void)sendSetUnitwithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    return;
}

// 闹钟提醒设置.
+ (void)sendSetDeviceAlarmClock:(AlarmClockModel *)model
                withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 设置运动目标. 0722改一起设置睡眠
+ (void)sendSetSportTargetWithUpdateBlock:(BLTAcceptModelUpdateValue)block;
{
}

// 设置睡眠目标.
+ (void)sendSetSleepTargetWithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 设置设备支持功能
+ (void)sendSetDeviceFuctionWithBlock:(BLTAcceptModelUpdateValue)block
{

}

// 设置用户信息
+ (void)sendSetUserInfoWithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 单位设置
+ (void)sendSetUnit:(UInt8 *)info
    withUpdateBlock:(BLTAcceptModelUpdateValue)block
{

}

// 久坐提醒设置
+ (void)sendSetDeviceSedentaryRemind:(RemindModel *)model
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block
{

}

// 设置防丢模式
+ (void)sendLostWithUpdateBlockState:(BOOL)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    NSString *string = @"";
    
    if(type) {
        string = @"$LLS1";
    } else {
       string = @"$LLS0";
    }
    
    [[TestViewController shareInstance]updateLog:[NSString stringWithFormat:@"防丢开关:%@",string]];
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
    
    NSLog(@"同步防丢>>>>>>>%@",string);
}
//抬腕亮屏
+ (void)sendTurnHandWithUpdateBlockState:(BOOL)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    NSString *string = @"";
    
    if(type) {
        string = @"$D1";
        [UserInfoHelper sharedInstance].bltModel.isTurnHand = YES;
    } else {
        string = @"$D0";
        [UserInfoHelper sharedInstance].bltModel.isTurnHand = NO;
    }
    
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
}

// 防丢设置
+ (void)sendSetDeviceLossPrevention:(UInt8 *)info
                    withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 左右手佩戴设置.
+ (void)sendSetDeviceWearingWay:(UInt8 *)info
                withUpdateBlock:(BLTAcceptModelUpdateValue)block
{

}

// 手机操作系统设置.
+ (void)sendSetOperatingSystem:(UInt8 *)info
               withUpdateBlock:(BLTAcceptModelUpdateValue)block
{

}

// 来电通知开关设置
+ (void)sendSetCallToInform:(UInt8 *)info
            withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 信息通知开关设置
+ (void)sendSetNotifications:(UInt8 *)info
             withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

#pragma mark 04

// 设备绑定
+ (void)sendDeviceBindingWithCMDType:(BLTDeviceBindCMD)type
          withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    if (type == BLTDeviceBinding)
    {
        UInt8 val[6] = {0x04, 0x01, 0x01, 83, 0x55, 0xaa};
        [self sendDataToWare:val
                  withLength:6
                  withUpdate:block];
    }
    else
    {
        UInt8 val[6] = {0x04, 0x02, 0x55, 0xaa, 0x55, 0xaa};
        [self sendDataToWare:val
                  withLength:6
                  withUpdate:block];
    }
}

#pragma mark 05

// 来电提醒
+ (void)sendNoticePhoneCallsReminding:(BOOL)type withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    NSString *string = @"$P";
    
    if(type)
    {
        string = @"$P";
    }
    else
    {
        string = @"$P";
    }
    
    UInt8 val[2] = {'$', 'P'};

    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    NSLog(@"发送来电指令.");
    
    [self sendDataToWare:val
              withLength:2
              withUpdate:block];
}

// 短信提醒
+ (void)sendSMSAlert:(BOOL)isAlert withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    UInt8 val[4] = {0x11, 0x02, 0x01, isAlert};
    [self sendDataToWare:val
              withLength:4
              withUpdate:block];
}

// 通知提醒
+ (void)sendNoticeAlert:(BOOL)isAlert withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    UInt8 val[4] = {0x11, 0x02, 0x02, isAlert};
    [self sendDataToWare:val
              withLength:4
              withUpdate:block];
}

// 信息提醒
+ (void)sendNoticeInformationToRemind:(UInt8 *)info
                      withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    UInt8 val[5] = {0x70, 0x11, info[0], info[1], info[2]};
    [self sendDataToWare:val
              withLength:5
              withUpdate:block];
}

#pragma mark 06

// 音乐播放控制
+ (void)sendControlMusicPlay:(UInt8 *)info
             withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    UInt8 val[5] = {0x70, 0x11, info[0], info[1], info[2]};
    [self sendDataToWare:val
              withLength:5
              withUpdate:block];
}

// 拍照控制
+ (void)sendControlTakePhoto:(UInt8 *)info
             withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    UInt8 val[5] = {0x70, 0x11, info[0], info[1], info[2]};
    [self sendDataToWare:val
              withLength:5
              withUpdate:block];
}

// 新的同步请求
+ (void)sendSysDeviceDataWithUpdate:(BLTAcceptModelUpdateValue)block
{
    if (![BLTSendModel sharedInstance].isSyncing) {
        NSString *currentDateString = [[[NSDate date]dateToString] componentsSeparatedByString:@" "][0];
        [SAVEUPDATETIME setObjectValue:currentDateString];
        [BLTSendModel sharedInstance].isSyncing = YES;
    } else {
        return ;
    }
    
    [[BLTAcceptModel sharedInstance] cleanMutableData];
    
    NSString *string = @"S";
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
}

// 同步久坐提醒
+ (void)sendSysRemind:(BLTAcceptModelUpdateValue)block
{
    NSString *string = @"$J30";
    
    RemindModel *model = [[UserInfoHelper sharedInstance].bltModel.remindArray lastObject];
    if (model.interval == 30)
    {
      string = @"$J30";
    }
    else if (model.interval == 60)
    {
       string = @"$J60";
    }
    else if(model.interval == 90)
    {
        string = @"$J90";
    }
    
    if (!model.isOpen)
    {
         string = @"$J00";
    }
    
    NSLog(@"设置久坐提醒>>>>>%@",string);
    [[TestViewController shareInstance]updateLog:[NSString stringWithFormat:@"久坐提醒:%@",string]];
    
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
//    $J30 / $J60 / $J90
}

// 同步喝水提醒
+ (void)sendDrinkWater:(BLTAcceptModelUpdateValue)block
{
    DrinkModel *model = [UserInfoHelper sharedInstance].bltModel.drinkModel;
    UInt8 val[10] = {'$', 'W', model.isOpen, model.startTime, model.endTime,
        model.timeInterval, (UInt8)model.drinkWater, (UInt8)(model.drinkWater >> 8)};
    
    [self sendDataToWare:val
              withLength:10
              withUpdate:block];
    //    $J30 / $J60 / $J90
}


// 同步闹钟
+ (void)sendSysAlarm:(BLTAcceptModelUpdateValue)block
{
//    AlarmClockModel
    NSString *alarm1 = @"00000";
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"$A"];
    
    NSArray *alarmArray = [UserInfoHelper sharedInstance].bltModel.alarmArray;
    
    for (int i = 0; i < 3; i++)
    {
        AlarmClockModel *model = alarmArray[i];
        if (model.isOpen)
        {
            NSLog(@"model.daySplit<>>>>%d",model.daySplit);
            
            /*
            if (model.daySplit == 0)
            {
                NSString *time =[NSString stringWithFormat:@"1%02d%02d",model.hour - 12,model.minutes];
                [string appendString:time];
            }
            else
            {
                NSString *time =[NSString stringWithFormat:@"1%02d%02d",model.hour, model.minutes];
                [string appendString:time];
            } */
            
            NSString *time =[NSString stringWithFormat:@"1%02d%02d",model.hour, model.minutes];
            [string appendString:time];
            
            model.isChanged = NO;
            model.isSys = YES;
        }
        else
        {
            [string appendString:alarm1];
        }
        
    }
    
    [[TestViewController shareInstance]updateLog:[NSString stringWithFormat:@"同步闹钟:%@",string]];
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];

    NSLog(@"同步闹钟>>>>>>>%@",string);
}

// 重启
+ (void)sendReSetInfo:(BLTAcceptModelUpdateValue)block
{
     NSString *string = @"$E";
    [[TestViewController shareInstance]updateLog:[NSString stringWithFormat:@"重启设备:%@",string]];
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
}

// 心率开关
+ (void)sendHeartOpenWith:(BOOL)state withBlock:(BLTAcceptModelUpdateValue)block
{
    NSString *string = @"";
    
    if(state)
    {
        string = @"$H1";
    }
    else
    {
        string = @"$H0";
    }
    [[TestViewController shareInstance]updateLog:[NSString stringWithFormat:@"心率开关:%@",string]];
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
    
    NSLog(@"同步心率>>>>>>>%@",string);
}

// 固件信息
+ (void)sendDeviceInfoWithBlock:(BLTAcceptModelUpdateValue)block
{
    NSString *string = @"$RV";
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
    
    NSLog(@"固件信息>>>>>>>%@",string);
}

// 寻找设备
+ (void)sendFindDeviceWithBlock:(BLTAcceptModelUpdateValue)block
{
    NSString *string = @"$RSN";
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
    
    NSLog(@"同步心率>>>>>>>%@",string);
}


// 同步用户信息
+ (void)sendSysUserInfo:(BLTAcceptModelUpdateValue)block
{
    //    $B18012045
    // 公制为1英制为0 24小时为1 12小时为0 华氏为1 摄氏为0
    
    int height = KK_User.showHeight.intValue;
    int weight = KK_User.showWeight.intValue;
    int step = (int)(height *0.45);
    int MetricSystem = !KK_User.isMetricSystem;
    int AMPM = [self isHasAMPMTimeSystem];
    int isFahrenheit = KK_User.isFahrenheit;
    
    UInt8 val[8] = {36, 66, height , weight, step, MetricSystem, AMPM, isFahrenheit};
    
    NSLog(@"step = %d  height = %d  == %hhu",step,height,val[8]);

    [self sendDataToWare:val
              withLength:8
              withUpdate:block];
}

// 同步系统时间
+ (void)sendsysTime:(BLTAcceptModelUpdateValue)block
{
    NSDate *date = [NSDate date];
    NSString *string = [NSString stringWithFormat:@"$T%02d%02d%02d%02d%02d%02d",date.year %100,date.month,date.day,date.hour,date.minute,date.second];
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];

    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
}

// 拍照控制
+ (void)sendControlTakePhotoState:(BOOL)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    NSString *string = @"";
    
    if(type)
    {
      string = @"$X1";
    }
    else
    {
     string = @"$X0";
    }

    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    for(int i=0;i<[aData length];i++)
        printf("testByte = %d\n",testByte[i]);

    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
}

// 单次运动控制
+ (void)sendControlSingleMotion:(UInt8 *)info
                withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 寻找手环
+ (void)sendControlFindBracelet:(UInt8 *)info
                withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

#pragma mark 07

// 回复事件控制
+ (void)sendReplyControlEvents:(UInt8 *)info
               withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 回复寻找手机请求
+ (void)sendReplyFindMobilePhone:(UInt8 *)info
                 withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    UInt8 val[5] = {0x70, 0x11, info[0], info[1], info[2]};
    [self sendDataToWare:val
              withLength:5
              withUpdate:block];
}

// 回复一键呼救
+ (void)sendReplyAKeyForHelp:(UInt8 *)info
             withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    UInt8 val[5] = {0x70, 0x11, info[0], info[1], info[2]};
    [self sendDataToWare:val
              withLength:5
              withUpdate:block];
}

#pragma mark 08

// 发送同步数据开始请求
+ (void)sendStartRequestDataWithType:(BLTRequestDataType)type
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 发送同步数据结束请求
+ (void)sendEndRequestSportData:(UInt8 *)info
                withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 发送同步当天的运动详情请求
+ (void)sendRequestSportDataForToday:(UInt8 *)info
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 发送历史运动详情请求
+ (void)sendRequestSportDataForHistory:(UInt8 *)info
                       withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 发送同步当天的睡眠详情请求
+ (void)sendRequestSleepDataForToday:(UInt8 *)info
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block
{

}

// 发送历史睡眠详情请求
+ (void)sendRequestSleepDataForHistory:(UInt8 *)info
                       withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 请求重发
+ (void)sendRequestRetryData:(UInt8 *)info
{
    
    NSData *sData = [[NSData alloc] initWithBytes:&info length:4];
    [[BLTPeripheral sharedInstance] senderDataToPeripheral:sData];
}

#pragma mark 20

// 蓝牙设备部分功能关闭或者打开
+ (void)sendOpenLogSendingFunction:(UInt8 *)info
                      withFuncType:(BLTDeviceFunc)type
                   withUpdateBlock:(BLTAcceptModelUpdateValue)block
{
}

// 恢复数据指令
+ (void)sendRestoreDataWithUpdate:(BLTAcceptModelUpdateValue)block
{
}

#pragma mark AA

#pragma mark --- 命令转发中心 ---
+ (void)sendDataToWare:(UInt8 *)val
            withLength:(NSInteger)length
            withUpdate:(BLTAcceptModelUpdateValue)block
{
    usleep(50000);
    [BLTPeripheral sharedInstance].lastInfo = val;
    [BLTAcceptModel sharedInstance].updateValue = block;
    [BLTAcceptModel sharedInstance].type = BLTAcceptModelTypeUnKnown;
    [BLTAcceptModel sharedInstance].dataType = BLTAcceptModelDataTypeUnKnown;

    NSData *sData = [[NSData alloc] initWithBytes:val length:length];
    [[BLTPeripheral sharedInstance] senderDataToPeripheral:sData];
}

// 进入后台启动定时器
- (void)startTimingCommunication
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(communication) userInfo:nil repeats:YES];
    }
}

// 通信命令.
- (void)communication
{
   
}

// 停止定时器
- (void)stopTimingCommunication
{
    if (_timer)
    {
        if ([_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

// 连接响应的设备后进行设置
+ (void)setAfterConnectionResponseEquipmentWithPeripheral:(CBPeripheral *)peripheral
{
    
}

// 设置绑定
- (void)setBinding:(BLTModel *)model
{
}

// 设置丢失的方法
- (void)setLostFunction:(BLTModel *)model
{
    
}

// 设置寻找报警的方法
- (void)setAlertFunction:(BLTModel *)model
{

}
+(void)sendGetDeviceTemperature:(BLTAcceptModelUpdateValue)block
{
    NSLog(@"获取温度");
    NSString *string = @"$C";
    NSData *aData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[aData bytes];
    
    [self sendDataToWare:testByte
              withLength:[aData length]
              withUpdate:block];
}

@end
