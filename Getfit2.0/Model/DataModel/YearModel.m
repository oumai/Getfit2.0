//
//  YearModel.m
//  AJBracelet
//
//  Created by zorro on 15/7/16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "YearModel.h"
#import "MonthModel.h"

@implementation YearModel

- (instancetype)initWithYearNumber:(NSInteger)yearNumber
{
    self = [super init];
    if (self)
    {
        _wareUUID = [UserInfoHelper sharedInstance].bltModel.bltUUID;
        _userName = [UserInfoHelper sharedInstance].userModel.userName;
        _yearNumber = yearNumber;
    }
    
    return self;
}

- (void)updateTotalWithModel:(PedometerModel *)model
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:_yearsDict];
    
    NSDate *date = [NSDate dateByString:model.dateString];
    NSString *key = [NSString stringWithFormat:@"%04d-%02d", (int)date.year, (int)date.month];
    MonthModel *monthModel = [MonthModel getMonthModelFromModelWithYear:date.year withMonth:date.month];
    
    // 按月的总量存储
    [dict setObject:@[@[@(monthModel.monthTotalSteps), @(monthModel.monthTotalCalories),
                        @(monthModel.monthTotalDistance), @(monthModel.sportActiveDays)],
                      @[@(monthModel.monthTotalSleep), @(monthModel.totalDeepSleep),
                        @(monthModel.totalShallowSleep), @(monthModel.totalWakingSleep),
                        @(monthModel.totalStartSleep), @(monthModel.totalEndSleep),
                        @(monthModel.sleepActiveDays)]]
             forKey:key];
    
    _yearsDict = dict;
    
    [self updateAllDetailInfo];
}

- (void)updateAllDetailInfo
{
    _yearTotalSteps = 0;
    _yearTotalCalories = 0;
    _yearTotalDistance = 0;
    _yearTotalSleep = 0;
    
    NSInteger sportDay = 0;
    NSInteger sleepDay = 0;
    
    NSInteger totalDeepSleep = 0;
    NSInteger totalShallowSleep = 0;
    NSInteger totalWakingSleep = 0;
    NSInteger totalStartSleep = 0;
    NSInteger totalEndSleep = 0;
    
    NSArray *values = [_yearsDict allValues];
    
    for (int i = 0; i < values.count; i++)
    {
        NSArray *sport = values[i][0];
        NSArray *sleep = values[i][1];
        
        _yearTotalSteps += [sport[0] integerValue];
        _yearTotalCalories += [sport[1] integerValue];
        _yearTotalDistance += [sport[2] integerValue];
        sportDay += [sport[3] integerValue];

        _yearTotalSleep += [sleep[0] integerValue];
        totalDeepSleep += [sleep[1] integerValue];
        totalShallowSleep += [sleep[2] integerValue];
        totalWakingSleep += [sleep[3] integerValue];
        totalStartSleep += [sleep[4] integerValue];
        totalEndSleep += [sleep[5] integerValue];
        sleepDay += [sleep[6] integerValue];
    }
    
    _dailySteps = sportDay > 0 ? (NSInteger)(_yearTotalSteps * 1.0 / sportDay) : 0;
    _dailyCalories = sportDay > 0 ? (NSInteger)(_yearTotalCalories * 1.0 / sportDay) : 0;
    _dailyDistance = sportDay > 0 ? (NSInteger)(_yearTotalDistance * 1.0 / sportDay) : 0;
    
    _dailySleep = sleepDay > 0 ? (NSInteger)(_yearTotalSleep * 1.0 / sleepDay) : 0;
    _dailyDeepSleep = sleepDay > 0 ? (NSInteger)(totalDeepSleep * 1.0 / sleepDay) : 0;
    _dailyShallowSleep = sleepDay > 0 ? (NSInteger)(totalShallowSleep * 1.0 / sleepDay) : 0;
    _dailyWakingSleep = sleepDay > 0 ? (NSInteger)(totalWakingSleep * 1.0 / sleepDay) : 0;
    _dailyStartSleep = sleepDay > 0 ? (NSInteger)(totalStartSleep * 1.0 / sleepDay) : 0;
    _dailyEndSleep = sleepDay > 0 ? (NSInteger)(totalEndSleep * 1.0 / sleepDay) : 0;
}

- (NSArray *)showMonthSteps
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (_isContinue)
    {
        NSInteger steps = [MonthModel getStepsFromModelWithYear:_yearNumber - 1 withMonth:12];
        [array addObject:@(steps)];
    }
    
    for (int i = 1; i <= 12; i++)
    {
        NSString *key = [NSString stringWithFormat:@"%04d-%02d", (int)_yearNumber, i];
        NSArray *tmpArray = [_yearsDict objectForKey:key];
        
        if (tmpArray)
        {
            [array addObject:tmpArray[0][0]];
        }
        else
        {
            [array addObject:@(0)];
        }
    }
    
    if (_isContinue)
    {
        NSInteger steps = [MonthModel getStepsFromModelWithYear:_yearNumber + 1 withMonth:1];
        [array addObject:@(steps)];
    }
    
    return array;
}

- (NSArray *)showMonthSleep
{
    return [self getSleepDurationForIndex:0];
}

- (NSArray *)showMonthDeepSleep
{
    return [self getSleepDurationForIndex:1];
}

- (NSArray *)showMonthShallowSleep
{
    return [self getSleepDurationForIndex:2];
}

- (NSArray *)getSleepDurationForIndex:(NSInteger)index
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (_isContinue)
    {
        NSInteger sleep = [MonthModel getSleepFromModelWithYear:_yearNumber - 1 withMonth:12 withIndex:index];
        [array addObject:@(sleep)];
    }
    
    for (int i = 1; i <= 12; i++)
    {
        NSString *key = [NSString stringWithFormat:@"%04d-%02d", (int)_yearNumber, i];
        NSArray *tmpArray = [_yearsDict objectForKey:key];
        
        if (tmpArray)
        {
            [array addObject:tmpArray[1][index]];
        }
        else
        {
            [array addObject:@(0)];
        }
    }
    
    if (_isContinue)
    {
        NSInteger sleep = [MonthModel getSleepFromModelWithYear:_yearNumber + 1 withMonth:1 withIndex:index];
        [array addObject:@(sleep)];
    }
    
    return array;
}

+ (YearModel *)getYearModelFromDBWithYearIndex:(NSInteger)yearIndex isContinue:(BOOL)isContinue
{
    NSString *where = [NSString stringWithFormat:@"yearNumber = %ld AND userName = '%@' AND wareUUID = '%@'", (long)yearIndex, [UserInfoHelper sharedInstance].userModel.userName, [UserInfoHelper sharedInstance].bltModel.bltUUID];
    YearModel *yearModel = [YearModel searchSingleWithWhere:where orderBy:nil];
    
    if (!yearModel)
    {
        yearModel = [[YearModel alloc] initWithYearNumber:yearIndex];
        
        [yearModel saveToDB];
    }
    
    yearModel.isContinue = isContinue;
    
    return yearModel;
}

// 表名
+ (NSString *)getTableName
{
    return @"YearModel";
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"yearNumber", @"userName", @"wareUUID"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

+ (void)initialize
{
    //remove unwant property
    //比如 getTableMapping 返回nil 的时候   会取全部属性  这时候 就可以 用这个方法  移除掉 不要的属性
    
    [self removePropertyWithColumnName:@"isContinue"];
    [self removePropertyWithColumnName:@"showMonthSteps"];
    [self removePropertyWithColumnName:@"showMonthSleep"];
    [self removePropertyWithColumnName:@"showMonthDeepSleep"];
    [self removePropertyWithColumnName:@"showMonthShallowSleep"];
}

@end
