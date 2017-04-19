//
//  DeviceInfoClass.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/30.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoClass : NSObject

AS_SINGLETON (DeviceInfoClass)

@property (nonatomic, strong) NSString * firmwareLastVersion;

// 获取系统更新时间
- (NSString *)updateDataTime;

// 返回设备界面 功能开启状态
- (NSString *)Callreminder:(NSString *)title;

// 手环设备名字
- (NSString *)bltDeviceName;

// 电量
- (NSString *)batteryLevel;

// 当前版本号
- (NSString *)currentVersion;

// 固件最新版本号
- (NSString *)firmwareVersion;

// 返回当前闹钟图标
- (UIImage *)alarmIconImage:(NSString*)alarmType;

// 获取闹钟类型
- (NSArray *)alarmtTypeArray;

// 返回当前闹钟 index
- (NSInteger)alarmType:(NSString *)alarmType;

@end
