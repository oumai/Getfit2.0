//
//  BLTSendModel.h
//  PlaneCup
//
//  Created by zorro on 15/3/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define BLT_Binding @"BLT_Binding"
#define BLT_InfoDelayTime 0.2 // 蓝牙通信间隔 避免造成堵塞.

#import <Foundation/Foundation.h>
#import "BLTAcceptModel.h"
#import "AlarmClockModel.h"
#import "RemindModel.h"

typedef enum {
    BLTDeviceBaseInfo = 0,          // 基本信息
    BLTDeviceFunctionList = 1,      // 功能列表
    BLTDeviceTime = 2,              // 设备时间
    BLTDeviceMACAddress = 3,        // mac地址
    BLTDeviceElectricityInfo = 4    // 电池信息.
} BLTDeviceKeyList;

typedef enum {
    BLTRequestDataTypeByHand = 0,   // 手动同步
    BLTRequestDataTypeAuto = 1,     // 自动同步
} BLTRequestDataType;

typedef enum {
    BLTDeviceUnbundling = 0,        // 解绑
    BLTDeviceBinding = 1,           // 绑定
} BLTDeviceBindCMD;

typedef enum {
    BLTDeviceFuncLogOpen = 0,
    BLTDeviceFuncLogClose = 1,
    BLTDeviceFuncDebugOpen = 2,
    BLTDeviceFuncDebugClose = 3,
} BLTDeviceFunc;

@interface BLTSendModel : NSObject

typedef void(^BLTSendDataBackUpdate)(NSDate *date);

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger waitTime;
@property (nonatomic, assign) NSInteger failCount;
@property (nonatomic, assign) BOOL isStopSync;
@property (nonatomic, assign) BOOL isSyncing;              // 是否在同步中

@property (nonatomic, assign) NSInteger lastSyncOrder;      // 最后同步的时序
@property (nonatomic, strong) NSString *lastSyncDate;       // 最后同步的日期

@property (nonatomic, strong) NSDate *startDate;            // 历史数据保存的开始日期
@property (nonatomic, strong) NSDate *endDate;              // 历史数据保存的结束日期

@property (nonatomic, strong) BLTSendDataBackUpdate backBlock;

AS_SINGLETON(BLTSendModel)

// 升级指令
+ (void)sendUpdateFirmwareWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 02

+ (void)sendObtainDeviceInfoWithFunc:(BLTDeviceKeyList)key
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 03

// 时间设置.
+ (void)sendSetDeviceTimeWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 功能表
+ (void)sendSetDeviceFuctionWithBlock:(BLTAcceptModelUpdateValue)block;

// 闹钟提醒设置.
+ (void)sendSetDeviceAlarmClock:(AlarmClockModel *)model
                withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 设置运动目标. 0722改一起设置睡眠
+ (void)sendSetSportTargetWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 设置睡眠目标.
+ (void)sendSetSleepTargetWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 设置用户信息
+ (void)sendSetUserInfoWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 单位设置
+ (void)sendSetUnit:(UInt8 *)info
    withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 单位设置(新的协议)
+ (void)sendSetUnitwithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 久坐提醒设置
+ (void)sendSetDeviceSedentaryRemind:(RemindModel *)model
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 防丢设置
+ (void)sendSetDeviceLossPrevention:(UInt8 *)info
                    withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 左右手佩戴设置.
+ (void)sendSetDeviceWearingWay:(UInt8 *)info
                withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 手机操作系统设置.
+ (void)sendSetOperatingSystem:(UInt8 *)info
               withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 来电通知开关设置
+ (void)sendSetCallToInform:(UInt8 *)info
            withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 信息通知开关设置
+ (void)sendSetNotifications:(UInt8 *)info
             withUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 04

// 设备绑定
+ (void)sendDeviceBindingWithCMDType:(BLTDeviceBindCMD)type
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 05

// 来电提醒
+ (void)sendNoticePhoneCallsReminding:(BOOL)type withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 信息提醒
+ (void)sendNoticeInformationToRemind:(UInt8 *)info
                      withUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 06

// 音乐播放控制
+ (void)sendControlMusicPlay:(UInt8 *)info
             withUpdateBlock:(BLTAcceptModelUpdateValue)block;

//// 拍照控制
//+ (void)sendControlTakePhoto:(UInt8 *)info
//             withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 拍照控制
+ (void)sendControlTakePhotoState:(BOOL)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 设置防丢模式
+ (void)sendLostWithUpdateBlockState:(BOOL)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block;
+ (void)sendTurnHandWithUpdateBlockState:(BOOL)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 单次运动控制
+ (void)sendControlSingleMotion:(UInt8 *)info
                withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 寻找手环
+ (void)sendControlFindBracelet:(UInt8 *)info
                withUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 07

// 回复事件控制
+ (void)sendReplyControlEvents:(UInt8 *)info
               withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 回复寻找手机请求
+ (void)sendReplyFindMobilePhone:(UInt8 *)info
                 withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 回复一键呼救
+ (void)sendReplyAKeyForHelp:(UInt8 *)info
             withUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 08

// 发送同步数据开始请求   0 为手动 1 为后台自动同步.
+ (void)sendStartRequestDataWithType:(BLTRequestDataType)type
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 发送同步数据结束请求
+ (void)sendEndRequestSportData:(UInt8 *)info
                withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 发送同步当天的运动详情请求
+ (void)sendRequestSportDataForToday:(UInt8 *)info
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 发送同步当天的睡眠详情请求
+ (void)sendRequestSleepDataForToday:(UInt8 *)info
                     withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 发送历史运动详情请求
+ (void)sendRequestSportDataForHistory:(UInt8 *)info
                       withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 发送历史睡眠详情请求
+ (void)sendRequestSleepDataForHistory:(UInt8 *)info
                       withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 请求重发 不带block
+ (void)sendRequestRetryData:(UInt8 *)info;

#pragma mark 20

// 蓝牙设备部分功能关闭或者打开
+ (void)sendOpenLogSendingFunction:(UInt8 *)info
                      withFuncType:(BLTDeviceFunc)type
                   withUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 恢复数据指令
+ (void)sendRestoreDataWithUpdate:(BLTAcceptModelUpdateValue)block;

#pragma mark --- 命令转发中心 ---
+ (void)sendDataToWare:(UInt8 *)val
            withLength:(NSInteger)length
            withUpdate:(BLTAcceptModelUpdateValue)block;

// 进入后台启动定时器
- (void)startTimingCommunication;

// 停止定时器
- (void)stopTimingCommunication;

// 连接响应的设备后进行设置
+ (void)setAfterConnectionResponseEquipmentWithPeripheral:(CBPeripheral *)peripheral;

// 重启设备
+ (void)sendSetReloadDevice:(BLTAcceptModelUpdateValue)block;

// 获取日志
+ (void)sendSetReport:(BLTAcceptModelUpdateValue)block;

// 新的同步请求
+ (void)sendSysDeviceDataWithUpdate:(BLTAcceptModelUpdateValue)block;

// 同步系统时间
+ (void)sendsysTime:(BLTAcceptModelUpdateValue)block;

// 同步久坐提醒
+ (void)sendSysRemind:(BLTAcceptModelUpdateValue)block;
// 同步喝水提醒
+ (void)sendDrinkWater:(BLTAcceptModelUpdateValue)block;
// 同步闹钟
+ (void)sendSysAlarm:(BLTAcceptModelUpdateValue)block;

// 同步用户信息
+ (void)sendSysUserInfo:(BLTAcceptModelUpdateValue)block;

// 固件信息
+ (void)sendDeviceInfoWithBlock:(BLTAcceptModelUpdateValue)block;

// 重启
+ (void)sendReSetInfo:(BLTAcceptModelUpdateValue)block;

// 心率开关
+ (void)sendHeartOpenWith:(BOOL)state withBlock:(BLTAcceptModelUpdateValue)block;
//获取温度 气压 海拔
+ (void)sendGetDeviceTemperature:(BLTAcceptModelUpdateValue)block;

// 短信提醒
+ (void)sendSMSAlert:(BOOL)isAlert withUpdateBlock:(BLTAcceptModelUpdateValue)block;
// 通知提醒
+ (void)sendNoticeAlert:(BOOL)isAlert withUpdateBlock:(BLTAcceptModelUpdateValue)block;

@end
