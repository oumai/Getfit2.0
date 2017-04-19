//
//  PedometerModel.h
//  AJBracelet
//
//  Created by zorro on 15/7/13.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    StateModelSportSteps = 0,
    StateModelSportCalories = 1,
    StateModelSportDistance = 2,
    StateModelSportSleep
} StateModelSportType;

// 运动的激烈程度
typedef enum {
    SportStateQuiet = 0,
    SportStateSlight = 1,
    SportStateActive = 2,
    SportStateStrongly
} SportState;

typedef enum {
    StateModelSport = 0,
    StateModelSleep
} StateModelType;

@interface StateModel : NSObject

@property (nonatomic, strong) NSString *wareUUID;           // 设备uuid
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, assign) NSInteger currentOrder;   // 当前时间序号

@property (nonatomic, assign) StateModelType modelType;
@property (nonatomic, assign) SportState sportState;
@property (nonatomic, assign) NSInteger steps;
@property (nonatomic, assign) NSInteger activeTime;     // 活跃时间.
@property (nonatomic, assign) NSInteger calories;       // 卡路里
@property (nonatomic, assign) CGFloat distance;         // 距离

// 1 醒着 2 浅睡 3 深睡
@property (nonatomic, assign) NSInteger sleepState;     // 睡眠状态
@property (nonatomic, assign) NSInteger sleepDuration;     // 睡眠持续时间.

@end

@interface PedometerModel : NSObject

typedef void(^PedometerModelSyncEnd)(NSDate *date, BOOL success);

@property (nonatomic, strong) NSString *wareUUID;           // 设备uuid
@property (nonatomic, strong) NSString *userName;           // 用户名

@property (nonatomic, strong) NSString *dateString;         // 日期
@property (nonatomic, assign) NSInteger timeOffset;         // 时间偏移量
@property (nonatomic, assign) NSInteger perMinutes;         // 每分钟产生的数据量
@property (nonatomic, assign) NSInteger sportItemCounts;    // 运动item的个数
@property (nonatomic, assign) NSInteger sportTotalBytes;    // 运动数据包

@property (nonatomic, assign) NSInteger totalActiveTime;

@property (nonatomic, assign) NSInteger totalSteps;         // 当天的总步数
@property (nonatomic, assign) NSInteger totalCalories;      // 当天的总卡路里
@property (nonatomic, assign) NSInteger totalDistance ;     // 当天的总路程
@property (nonatomic, assign) NSInteger totalSportTime ;    // 当天的总运动时间

@property (nonatomic, assign) NSInteger sleepStartTime;     // 睡眠开始时间 用总分数表示 比如9点就是 540分.
@property (nonatomic, assign) NSInteger sleepEndTime;       // 睡眠结束时间
@property (nonatomic, assign) NSInteger sleepTotalTime;     // 睡眠时长
@property (nonatomic, assign) NSInteger sleepItemCounts;    // 睡眠item的个数
@property (nonatomic, assign) NSInteger sleepTotalBytes;    // 睡眠数据包

@property (nonatomic, assign) NSInteger shallowSleepCounts; // 浅睡眠时长.
@property (nonatomic, assign) NSInteger deepSleepCounts;    // 深睡眠时长.
@property (nonatomic, assign) NSInteger wakingCounts;       // 醒来次数.

@property (nonatomic, assign) NSInteger targetStep;         // 目标步数
@property (nonatomic, assign) CGFloat targetCalories;       // 目标卡路里
@property (nonatomic, assign) CGFloat targetDistance;       // 目标距离
@property (nonatomic, assign) NSInteger targetSleep;        // 目标睡眠

@property (nonatomic, strong) NSArray *sportsArray;
@property (nonatomic, strong) NSArray *sleepArray;
//前一天18:00-0:00的数据
@property (nonatomic,strong) NSArray *yesterdayArray;
@property (nonatomic, strong) NSArray *heartArray;

// 原始数据 288
@property (nonatomic, strong) NSArray *originalSportsArray;
@property (nonatomic, strong) NSArray *originalSleepArray;

// 主页需要的运动数据用这个 一维数组. item为: @(model.steps)
@property (nonatomic, strong) NSArray *showDetailSports;
// 主页的睡眠用这个. 二维数组, 每个item为: @[@(model.currentOrder), @(model.sleepState), @(model.sleepDuration)];
@property (nonatomic, strong) NSArray *showDetailSleep;

@property (nonatomic, strong) NSArray *showSleepTimeArray;  // 睡眠显示的时间数据.

@property (nonatomic, assign) NSInteger deepSleepTime;      // 深度睡眠时间
@property (nonatomic, assign) NSInteger shallowSleepTime;   // 浅度睡眠时间
@property (nonatomic, assign) NSInteger wakingTime;         // 清醒时长

@property (nonatomic, assign) BOOL isSaveAllDay;            // 是否保存了全天的数据

//心率
@property (nonatomic, strong) NSArray *showHeartArray;

// 目前硬件协议有问题。协商改进。
+ (void)saveDataToModel:(NSArray *)array withEnd:(PedometerModelSyncEnd)endBlock;
+ (PedometerModel *)simpleInitWithDate:(NSDate *)date;

// 将模型保存到周表和月表
- (void)savePedometerModelToWeekModelAndMonthModel;

- (void)showMessage;

// 从用户信息为模型添加各种目标.
- (void)addTargetForModelFromUserInfo;

// 同步手环数据到数据库(新)
+ (void)pedometerModelSaveDataToDB;

// 同步手环昨天的数据
+(void)pedometerModelSaveDataToDBYs;

//更新图标的睡眠时间
+(void)updateSleepTime;
@end
