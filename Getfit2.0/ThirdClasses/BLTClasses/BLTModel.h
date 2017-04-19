//
//  BLTModel.h
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "DrinkModel.h"

typedef enum {
    BLTModelDisConnect = 0,             // 未连接
    BLTModelDidConnect = 1,             // 已连接
    BLTModelConnecting,                 // 连接中
    BLTModelRepeatConnecting,           // 重连中
    BLTModelConnectFindDevice,          // 寻找设备
    BLTModelConnectAlarming,            // 连接报警, 设备寻找手机
    BLTModelDistanceAlarming,           // 距离报警
    BLTModelDisConnectAlarming,         // 丢失报警
    BLTModelConnectFail                 // 连接失败
} BLTModelConnectState;

typedef enum {
    BLTModelAlertTypeBuzzing = 0,       // 蜂鸣
    BLTModelAlertTypeLEDLight = 1,      // LED灯
    BLTModelAlertTypeALL,               // 蜂鸣和灯
} BLTModelAlertType;

typedef enum {
    BLTModelLostDistancenNear = 0,          // 近
    BLTModelLostDistanceMiddle = 1,         // 中
    BLTModelLostDistanceFar = 2,            // 远
} BLTModelLostDistance;

typedef enum {
    BLTModelAlarmTypeFindMe = 0,            // 寻找
    BLTModelAlarmTypeAntiLost = 1,          // 防丢
} BLTModelAlarmType;

@interface BLTModel : NSObject

// 蓝牙硬件所涉及的数据
@property (nonatomic, strong) NSString *bltName;                    // 设备名字
@property (nonatomic, strong) NSString *bltNickName;                // 设备昵称
@property (nonatomic, strong) NSString *bltUUID;                      // 设备UUID
@property (nonatomic, strong) NSString *macAddress;                 // 设备UUID

// @property (nonatomic, strong) NSString *bltElec;                    // 电量 取消这个属性.
@property (nonatomic, strong) NSString *bltRSSI;                    // RSSI
@property (nonatomic, assign) NSInteger bltVersion;                 // 固件版本
@property (nonatomic, assign) NSInteger bltOnlineVersion;           // 固件在线版本

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, assign) BOOL isConnected;                     // 是否连接中
@property (nonatomic, assign) NSInteger deviceID;                   // 设备ID，硬件版本
@property (nonatomic, assign) NSInteger runMode;                    // 运行模式 0为运动 1为睡眠
@property (nonatomic, assign) NSInteger batteryStatus;              // 电池状态 0为正常 1为正在充电 2为低电量.
@property (nonatomic, assign) NSInteger batteryQuantity;            // 电池电量

/*
@property (nonatomic, assign) NSInteger bltElecState;               // 充电状态
@property (nonatomic, strong) NSString *imageFileName;              // 图片缓存里面的文件名字.

@property (nonatomic, assign) BOOL isCustomAudio;                   // 是否播放自己录制的声音
@property (nonatomic, assign) BOOL isHidden;                        // 是否隐藏
@property (nonatomic, assign) BLTModelConnectState connectState;    // 连接状态

@property (nonatomic, assign) BLTModelAlertType alertType;          // 报警方式

@property (nonatomic, assign) NSInteger delayLost;                  // 防丢延时

@property (nonatomic, assign) BOOL isPrepareAlert;                  // 因距离原因产生的是否警报

@property (nonatomic, assign) BOOL isOpenLost;                      // 是否开启防丢.   针对设备.
@property (nonatomic, assign) CGFloat lostVolume;                   // 丢失音量 手机
@property (nonatomic, assign) CGFloat findVolume;                   // 寻找音量 手机
@property (nonatomic, assign) BOOL isOpenLostLED;                   // 是否丢失闪光.
@property (nonatomic, assign) BOOL isOpenFindLED;                   // 是否寻找闪光.

@property (nonatomic, strong) NSString *lostmName;                  // 防丢声音.
@property (nonatomic, strong) NSString *findName;                   // 报警声音.
@property (nonatomic, assign) BOOL isRemove;                        // 是否移除出设备数组.

@property (nonatomic, assign) BLTModelLostDistance distanceType;    // 寻找报警距离
 */

@property (nonatomic, assign) BOOL isDialingRemind;                 // 是否允许来电提醒
@property (nonatomic, assign) NSInteger delayDialing;               // 延迟多少秒来电提醒

@property (nonatomic, assign) BOOL isInitiative;                    // 是否主动断开的.
@property (nonatomic, assign) BOOL isBinding;                       // 是否绑定了
@property (nonatomic, assign) BOOL isRepeatConnect;                 // 是否重链接
@property (nonatomic, strong) NSArray *alarmArray;                  // 闹钟
@property (nonatomic, strong) NSArray *remindArray;                 // 久坐提醒.

@property (nonatomic, strong) DrinkModel *drinkModel;                 // 喝水提醒.

@property (nonatomic, assign) BOOL isLostModel;                     // 是否防丢
@property (nonatomic, assign) BOOL isTurnHand;                     // 翻手亮屏

+ (instancetype)initWithUUID:(NSString *)uuid;
// 从数据库获取模型.
+ (BLTModel *)getModelFromDBWtihUUID:(NSString *)uuid;
// 根据当前信号获取对应的图片名字.
- (NSString *)imageForsignalStrength;
// 添加闹钟.
- (BOOL)addAlarmClock:(CGFloat)height;

@end
