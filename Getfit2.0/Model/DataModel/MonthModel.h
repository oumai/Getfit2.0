//
//  MonthModel.h
//  AJBracelet
//
//  Created by zorro on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PedometerModel.h"

@interface MonthModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *wareUUID;
@property (nonatomic, assign) NSInteger monthNumber;            //第几月
@property (nonatomic, assign) NSInteger yearNumber;             //年，如2014
@property (nonatomic, assign) NSInteger monthTotalSteps;        // 当月的总步数
@property (nonatomic, assign) NSInteger monthTotalCalories;     // 当月的总卡路里
@property (nonatomic, assign) NSInteger monthTotalDistance ;    // 当月的总路程
@property (nonatomic, assign) NSInteger monthTotalSleep ;       // 当月的总睡眠时间

@property (nonatomic, assign) NSInteger totalDeepSleep;         // 累计深睡.
@property (nonatomic, assign) NSInteger totalShallowSleep;      // 累计浅睡.
@property (nonatomic, assign) NSInteger totalWakingSleep;       // 累计清醒.
@property (nonatomic, assign) NSInteger totalStartSleep;        // 累计入睡时间.
@property (nonatomic, assign) NSInteger totalEndSleep;          // 累计醒来时间.

@property (nonatomic, assign) NSInteger dailySteps;             // 日均步数.
@property (nonatomic, assign) NSInteger dailyCalories;          // 日均卡路里.
@property (nonatomic, assign) NSInteger dailyDistance;          // 日均里程.

@property (nonatomic, assign) NSInteger dailySleep;             // 日均睡眠.
@property (nonatomic, assign) NSInteger dailyDeepSleep;         // 日均深睡.
@property (nonatomic, assign) NSInteger dailyShallowSleep;      // 日均浅睡.
@property (nonatomic, assign) NSInteger dailyWakingSleep;       // 日均清醒.
@property (nonatomic, assign) NSInteger dailyStartSleep;        // 日均入睡时间.
@property (nonatomic, assign) NSInteger dailyEndSleep;          // 日均醒来时间.

@property (nonatomic, assign) NSInteger sportActiveDays;        // 每月运动活跃天数.
@property (nonatomic, assign) NSInteger sleepActiveDays;        // 每月睡眠活跃天数.

@property (nonatomic, strong) NSDictionary *monthsDict;         // 用字典保存 提高获取时的速度 也方便更新数据.

@property (nonatomic, assign) BOOL isContinue;                  // 是否需要连续.
@property (nonatomic, assign) NSInteger daysCount;              // 当月有多少天数
@property (nonatomic, strong) NSArray *showDaySteps;            // 本月每天的步数 没有就为0 包含上月最后1天和下月第一天.
@property (nonatomic, strong) NSArray *showDaySleep;            // 本月每天的睡眠时长 没有就为0 包含上月最后1天和下月第一天.
@property (nonatomic, strong) NSArray *showDayDeepSleep;        // 本月每天的深睡眠时长 没有就为0 包含上月最后1天和下月第一天.
@property (nonatomic, strong) NSArray *showDayShallowSleep;     // 本月每天的浅睡眠时长 没有就为0 包含上月最后1天和下月第一天.

- (instancetype)initWithmonthNumber:(NSInteger)monthNumber
                      andYearNumber:(NSInteger)yearNumber;

- (void)updateTotalWithModel:(PedometerModel *)model;
- (NSArray *)getAllMonthModelFromDB;

// 详情趋势图连续的话就YES 否则为NO
+ (MonthModel *)getMonthModelFromDBWithMonthIndex:(NSInteger)monthIndex isContinue:(BOOL)isContinue;
+ (MonthModel *)getMonthModelFromModelWithYear:(NSInteger)year withMonth:(NSInteger)month;

+ (NSInteger)getStepsFromModelWithYear:(NSInteger)year withMonth:(NSInteger)month;
+ (NSInteger)getSleepFromModelWithYear:(NSInteger)year withMonth:(NSInteger)month withIndex:(NSInteger)index;

@end
