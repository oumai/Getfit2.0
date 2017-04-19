//
//  BLTSimpleSend.m
//  BopLost
//
//  Created by zorro on 15/4/9.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTSimpleSend.h"
#import "PedometerModel.h"
#import "KKASIHelper.h"

@implementation BLTSimpleSend

DEF_SINGLETON(BLTSimpleSend)

/**
 *   ---------------------------------   外部调用的命令   --------------------------------------
 */
#pragma mark --- 蓝牙连接后发送连续的指令 ---
- (void)sendContinuousInstruction
{
    NSLog(@"设备连接上 开始同步 基本信息>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    // 纪录最后一次连的设备的uuid。
    
    if ([BLTManager sharedInstance].model.bltUUID.length > 0)
    {
        [AJ_LastWareUUID setObjectValue:[BLTManager sharedInstance].model.bltUUID];
    }
    
    NSLog(@"AJ_LastWareUUID = ..%@", [AJ_LastWareUUID getObjectValue]);
    
    // 重连时将相关信息重置.
    _synState = BLTSimpleSendSynWait;
    [BLTSendModel sharedInstance].isSyncing = NO;
    [BLTAcceptModel sharedInstance].updateValue = nil;
    
    if ([BLTManager sharedInstance].isAutoUpdate) {
    } else {
        [self performSelector:@selector(sendSysDeviceInfo) withObject:nil afterDelay:0.2];
    }
}

// 开始同步手环信息>>>
- (void)sendSysDeviceInfo
{
        [BLTSendModel sendsysTime:^(id object, BLTAcceptModelType type)
         {
        }];
        [self performSelector:@selector(sendSysDeviceInfo2) withObject:nil afterDelay:0.2];
}

// 同步用户信息
- (void)sendSysDeviceInfo2
{
    [BLTSendModel sendSysUserInfo:^(id object, BLTAcceptModelType type) {
    }];
    [self performSelector:@selector(sendSysDeviceInfo3) withObject:nil afterDelay:0.2];
}

// 同步闹钟
- (void)sendSysDeviceInfo3
{
    [BLTSendModel sendSysAlarm:^(id object, BLTAcceptModelType type) {
    }];
    [self performSelector:@selector(sendSysDeviceInfo4) withObject:nil afterDelay:0.2];
}

// 同步久坐
- (void)sendSysDeviceInfo4
{
    [BLTSendModel sendSysRemind:^(id object, BLTAcceptModelType type) {
    }];
    [self performSelector:@selector(sendLost) withObject:nil afterDelay:0.2];
}

// 同步防丢开关
- (void)sendLost
{
    [[UserInfoHelper sharedInstance] sendLostMode: [UserInfoHelper sharedInstance].bltModel.isLostModel WithBackBlock:^(id object)
     {
     }];
    [self performSelector:@selector(sendTurnHand) withObject:nil afterDelay:0.2];
}

// 同步翻手
- (void)sendTurnHand
{
    [[UserInfoHelper sharedInstance] sendTurnHand: [UserInfoHelper sharedInstance].bltModel.isTurnHand WithBackBlock:^(id object)
     {
     }];
    [self performSelector:@selector(sendSysHeart) withObject:nil afterDelay:0.2];
}

// 同步心率开关
- (void)sendSysHeart
{
    [BLTSendModel sendHeartOpenWith:[UserInfoHelper sharedInstance].userModel.heartOpen
                                      withBlock:^(id object, BLTAcceptModelType type) {
    }];
    [self performSelector:@selector(sendSMS) withObject:nil afterDelay:0.2];
}

// 同步短信开关
- (void)sendSMS
{
    [BLTSendModel sendSMSAlert:[UserInfoHelper sharedInstance].userModel.isSMS
                          withUpdateBlock:^(id object, BLTAcceptModelType type) {
                          }];
    [self performSelector:@selector(sendNotice) withObject:nil afterDelay:0.2];
}

// 同步通知开关
- (void)sendNotice
{
    [BLTSendModel sendNoticeAlert:[UserInfoHelper sharedInstance].userModel.isNotice
                          withUpdateBlock:^(id object, BLTAcceptModelType type) {
                          }];
    [self performSelector:@selector(sendDeviceInfo) withObject:nil afterDelay:0.2];
}

// 同步固件信息
- (void)sendDeviceInfo
{
    [BLTSendModel sendDeviceInfoWithBlock:^(id object, BLTAcceptModelType type) {
    }];
    [self performSelector:@selector(sendSysDeviceInfo5) withObject:nil afterDelay:0.5];
}

// 同步数据
- (void)sendSysDeviceInfo5
{
    [BLTSendModel sendSysDeviceDataWithUpdate:^(id object, BLTAcceptModelType type) {
    }];
}

//同步失败
- (void)endSyncFail
{
    _synState = BLTSimpleSendSynWait;
    // 回调置空.
    [BLTAcceptModel sharedInstance].updateValue = nil;

    if (self.backBlock)
    {
        self.backBlock(nil);
    }
}

// 同步数据结束
- (void)endSyncData:(NSDate *)date
{
    _synState = BLTSimpleSendSynWait;

    if (self.backBlock)
    {
        self.backBlock(date);
    }
}

/**
 *   ---------------------------------   定时器操作中心   --------------------------------------
 */
- (void)startTimer
{
    self.waitTime = 0;
    
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(supervisionSync) userInfo:nil repeats:YES];
    }
}

// 监察同步状态
- (void)supervisionSync
{
    self.waitTime ++;
    
    // 10秒内没有新的数据, 那么表示当次数据同步失败.
    NSInteger waitTime = 10;
    
    if (self.waitTime > waitTime)
    {
        // 停止同步数据因意外情况
        [self stopTimer];
        [self endSyncFail];
        dispatch_async(dispatch_get_main_queue(), ^{
            /*
            UInt8 *val = [BLTPeripheral sharedInstance].lastInfo;
            NSString *error = [NSString stringWithFormat:@"最后指令: %02x%02x%02x%02x", val[0], val[1], val[2], val[3]];
            SHOWMBProgressHUD((@"Data sync failed"), error, nil, NO, 2.0);
             */
            
            if (_synProgressBlock)
            {
                _synProgressBlock(0, BLTSimpleSendSynProgressFail);
            }
        });
    }
}

- (void)stopTimer
{
    if (self.timer)
    {
        if ([self.timer isValid])
        {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (BOOL)isSyning
{
    if (_synState != BLTSimpleSendSynWait)
    {
        return YES;
    }
    
    return NO;
}

@end
