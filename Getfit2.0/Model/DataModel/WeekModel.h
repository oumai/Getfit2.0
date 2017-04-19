//
//  WeekModel.h
//  AJBracelet
//
//  Created by zorro on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PedometerModel.h"

@interface WeekModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *wareUUID;
@property (nonatomic, assign) NSInteger weekNumber;         // 第几周
@property (nonatomic, assign) NSInteger yearNumber;         // 年，如2014

@property (nonatomic, assign) NSInteger weekTotalSteps;     // 本周的总步数
@property (nonatomic, assign) NSInteger weekTotalCalories;  // 本周的总卡路里
@property (nonatomic, assign) NSInteger weekTotalDistance ; // 本周的总路程
@property (nonatomic, assign) NSInteger weekTotalSleep;     // 本周的总睡眠时间.

@property (nonatomic, assign) NSInteger dailySteps;         // 日均步数.
@property (nonatomic, assign) NSInteger dailyCalories;      // 日均卡路里.
@property (nonatomic, assign) NSInteger dailyDistance;      // 日均里程.

@property (nonatomic, assign) NSInteger dailySleep;         // 日均睡眠.
@property (nonatomic, assign) NSInteger dailyDeepSleep;     // 日均深睡.
@property (nonatomic, assign) NSInteger dailyShallowSleep;  // 日均浅睡.
@property (nonatomic, assign) NSInteger dailyWakingSleep;   // 日均清醒.
@property (nonatomic, assign) NSInteger dailyStartSleep;    // 日均入睡时间.
@property (nonatomic, assign) NSInteger dailyEndSleep;      // 日均醒来时间.

// 这个外部一般不使用, 需要使用的已经计算.
@property (nonatomic, strong) NSDictionary *weeksDict;      // 用字典保存 提高获取时的速度 也方便更新数据.

@property (nonatomic, assign) BOOL isContinue;              // 是否需要连续.
@property (nonatomic, strong) NSString *showDates;          // 日期显示
@property (nonatomic, strong) NSArray *showDaySteps;        // 本周每天的步数 没有就为0 包含上周六和下周日.
@property (nonatomic, strong) NSArray *showDaySleep;        // 本周每天的睡眠时长 没有就为0 包含上周六和下周日.
@property (nonatomic, strong) NSArray *showDayDeepSleep;        // 本月每天的深睡眠时长 没有就为0 包含上周六和下周日.
@property (nonatomic, strong) NSArray *showDayShallowSleep;     // 本月每天的浅睡眠时长 没有就为0 包含上周六和下周日.

- (instancetype)initWithWeekNumber:(NSInteger)weekNumber
                     andYearNumber:(NSInteger)yearNumber;
- (void)updateTotalWithModel:(PedometerModel *)model;

// 根据日期取当前周的数据模型
// 详情趋势图连续的话就YES 否则为NO
+ (WeekModel *)getWeekModelFromDBWithDate:(NSDate *)date isContinue:(BOOL)isContinue;

@end
