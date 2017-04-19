//
//  YearModel.h
//  AJBracelet
//
//  Created by zorro on 15/7/16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PedometerModel.h"

@interface YearModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *wareUUID;
@property (nonatomic, assign) NSInteger yearNumber;             //年，如2014

@property (nonatomic, assign) NSInteger yearTotalSteps;         // 当年的总步数
@property (nonatomic, assign) NSInteger yearTotalCalories;      // 当年的总卡路里
@property (nonatomic, assign) NSInteger yearTotalDistance ;     // 当年的总路程
@property (nonatomic, assign) NSInteger yearTotalSleep ;        // 当年的总睡眠时间

@property (nonatomic, assign) NSInteger dailySteps;             // 日均步数.
@property (nonatomic, assign) NSInteger dailyCalories;          // 日均卡路里.
@property (nonatomic, assign) NSInteger dailyDistance;          // 日均里程.

@property (nonatomic, assign) NSInteger dailySleep;             // 日均睡眠.
@property (nonatomic, assign) NSInteger dailyDeepSleep;         // 日均深睡.
@property (nonatomic, assign) NSInteger dailyShallowSleep;      // 日均浅睡.
@property (nonatomic, assign) NSInteger dailyWakingSleep;       // 日均清醒.
@property (nonatomic, assign) NSInteger dailyStartSleep;        // 日均入睡时间.
@property (nonatomic, assign) NSInteger dailyEndSleep;          // 日均醒来时间.

@property (nonatomic, strong) NSDictionary *yearsDict;          // 用字典保存 提高获取时的速度 也方便更新数据.

@property (nonatomic, assign) BOOL isContinue;                  // 是否需要连续.
@property (nonatomic, strong) NSArray *showMonthSteps;          // 本年每月的步数
@property (nonatomic, strong) NSArray *showMonthSleep;          // 本年每月的睡眠时长
@property (nonatomic, strong) NSArray *showMonthDeepSleep;        // 本月每天的深睡眠时长
@property (nonatomic, strong) NSArray *showMonthShallowSleep;     // 本月每天的浅睡眠时长

- (instancetype)initWithYearNumber:(NSInteger)yearNumber;
- (void)updateTotalWithModel:(PedometerModel *)model;

// 详情趋势图连续的话就YES 否则为NO YES包含去年最后一月和明年第一月.
+ (YearModel *)getYearModelFromDBWithYearIndex:(NSInteger)yearIndex isContinue:(BOOL)isContinue;

@end
