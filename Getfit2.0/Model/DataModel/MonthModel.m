//
//  MonthModel.m
//  AJBracelet
//
//  Created by zorro on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "MonthModel.h"
#import "PedometerHelper.h"
#import "UserInfoHelper.h"

@implementation MonthModel

- (instancetype)initWithmonthNumber:(NSInteger)monthNumber
                      andYearNumber:(NSInteger)yearNumber
{
    self = [super init];
    if (self)
    {
        _wareUUID = [UserInfoHelper sharedInstance].bltModel.bltUUID;
        _userName = [UserInfoHelper sharedInstance].userModel.userName;
        _monthNumber = monthNumber;
        _yearNumber = yearNumber;
    }
    
    return self;
}

- (void)updateTotalWithModel:(PedometerModel *)model
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:_monthsDict];
    
    // 二维数组.
    NSInteger yesterDaytime = [self getYesterdaySleepTime];
    NSInteger yesterDaydeeptime = [self getYesTerDayDeepSleepTime];
    NSInteger yesterDayshallow = [self getYesTerDayshallowSleepTime];
    NSInteger yesterDaywaking = [self getYesTerDaywakingTime];
    NSInteger yesterDayStartTime = [self getStartTime];
    [dict setObject:@[@[@(model.totalSteps), @(model.totalCalories), @(model.totalDistance)],
                      @[@(model.sleepTotalTime+yesterDaytime), @(model.deepSleepTime+yesterDaydeeptime), @(model.shallowSleepTime+yesterDayshallow),
                        @(model.wakingTime+yesterDaywaking), @(yesterDayStartTime), @(model.sleepEndTime)]]
             forKey:model.dateString];
    
    _monthsDict = dict;
    
    [self updateAllDetailInfo];
}

- (void)updateAllDetailInfo
{
    _monthTotalSteps = 0;
    _monthTotalCalories = 0;
    _monthTotalDistance = 0;
    _monthTotalSleep = 0;
    
    _totalDeepSleep = 0;
    _totalShallowSleep = 0;
    _totalWakingSleep = 0;
    _totalStartSleep = 0;
    _totalEndSleep = 0;
    
    _sportActiveDays = 0;
    _sleepActiveDays = 0;
    
    NSArray *values = [_monthsDict allValues];
    
    for (int i = 0; i < values.count; i++)
    {
        NSArray *sport = values[i][0];
        NSArray *sleep = values[i][1];
        
        _monthTotalSteps += [sport[0] integerValue];
        _monthTotalCalories += [sport[1] integerValue];
        _monthTotalDistance += [sport[2] integerValue];
        
        _monthTotalSleep += [sleep[0] integerValue];
        _totalDeepSleep += [sleep[1] integerValue];
        _totalShallowSleep += [sleep[2] integerValue];
        _totalWakingSleep += [sleep[3] integerValue];
        _totalStartSleep += [sleep[4] integerValue];
        _totalEndSleep += [sleep[5] integerValue];
        
        if ([sport[0] integerValue] > 0)
        {
            _sportActiveDays++;
        }
        
        if ([sleep[0] integerValue] > 0)
        {
            _sleepActiveDays++;
        }
    }
    
    _dailySteps = _sportActiveDays > 0 ? (NSInteger)(_monthTotalSteps * 1.0 / _sportActiveDays) : 0;
    _dailyCalories = _sportActiveDays > 0 ? (NSInteger)(_monthTotalCalories * 1.0 / _sportActiveDays) : 0;
    _dailyDistance = _sportActiveDays > 0 ? (NSInteger)(_monthTotalDistance * 1.0 / _sportActiveDays) : 0;
    
    _dailySleep = _sleepActiveDays > 0 ? (NSInteger)(_monthTotalSleep * 1.0 / _sleepActiveDays) : 0;
    _dailyDeepSleep = _sleepActiveDays > 0 ? (NSInteger)(_totalDeepSleep * 1.0 / _sleepActiveDays) : 0;
    _dailyShallowSleep = _sleepActiveDays > 0 ? (NSInteger)(_totalShallowSleep * 1.0 / _sleepActiveDays) : 0;
    _dailyWakingSleep = _sleepActiveDays > 0 ? (NSInteger)(_totalWakingSleep * 1.0 / _sleepActiveDays) : 0;
    _dailyStartSleep = _sleepActiveDays > 0 ? (NSInteger)(_totalStartSleep * 1.0 / _sleepActiveDays) : 0;
    _dailyEndSleep = _sleepActiveDays > 0 ? (NSInteger)(_totalEndSleep * 1.0 / _sleepActiveDays) : 0;
}

- (NSInteger)daysCount
{
    NSString *dateString = [NSString stringWithFormat:@"%04d-%02d-01", (int)_yearNumber, (int)_monthNumber % 12 + 1];
    NSDate *date = [[NSDate dateByString:dateString] dateAfterDay:-1];

    // NSLog(@"..date === %d", date.day);
    return date.day;
}

- (NSArray *)showDaySteps
{
    NSString *dateString = [NSString stringWithFormat:@"%04d-%02d-01", (int)_yearNumber, (int)_monthNumber];
    NSDate *date = [NSDate dateByString:dateString];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDate *tmpDate;
    PedometerModel *model;
    
    if (_isContinue)
    {
        tmpDate = [date dateAfterDay:-1];
        model = [PedometerHelper getModelFromDBWithDate:tmpDate];
        [array addObject:@(model.totalSteps)];
    }
   
    for (int i = 0; i < self.daysCount; i++)
    {
        tmpDate = [date dateAfterDay:i];
        NSString *dateString = [tmpDate dateToDayString];
        NSArray *tmpArray = [_monthsDict objectForKey:dateString];
        
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
        tmpDate = [date dateAfterDay:(int)self.daysCount];
        model = [PedometerHelper getModelFromDBWithDate:tmpDate];
        [array addObject:@(model.totalSteps)];
    }
    
    return array;
}

- (NSArray *)showDaySleep
{
    return [self getSleepDurationForIndex:0];
}

- (NSArray *)showDayDeepSleep
{
    return [self getSleepDurationForIndex:1];
}

- (NSArray *)showDayShallowSleep
{
    return [self getSleepDurationForIndex:2];
}

- (NSArray *)getSleepDurationForIndex:(NSInteger)index
{
    NSString *dateString = [NSString stringWithFormat:@"%04d-%02d-01", (int)_yearNumber, (int)_monthNumber];
    NSDate *date = [NSDate dateByString:dateString];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDate *tmpDate;
    
    if (_isContinue)
    {
        tmpDate = [date dateAfterDay:-1];
        [array addObject:[self getSleepTimeFromDate:tmpDate withIndex:index]];
    }
    
    for (int i = 0; i < self.daysCount; i++)
    {
        tmpDate = [date dateAfterDay:i];
        NSString *dateString = [tmpDate dateToDayString];
        NSArray *tmpArray = [_monthsDict objectForKey:dateString];
        
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
        tmpDate = [date dateAfterDay:(int)self.daysCount];
        [array addObject:[self getSleepTimeFromDate:tmpDate withIndex:index]];
    }
    
    return array;
}

- (NSNumber *)getSleepTimeFromDate:(NSDate *)date withIndex:(NSInteger)index
{
    PedometerModel *model = [PedometerHelper getModelFromDBWithDate:date];
    
    if (index == 0)
    {
        return @(model.sleepTotalTime);
    }
    else if (index == 1)
    {
        return @(model.deepSleepTime);
    }
    else
    {
        return @(model.shallowSleepTime);
    }
}

- (NSArray *)getAllMonthModelFromDB
{
    NSString *where = [NSString stringWithFormat:@"userName = '%@' AND wareUUID = '%@'",
                       [UserInfoHelper sharedInstance].userModel.userName, [UserInfoHelper sharedInstance].bltModel.bltUUID];
    NSArray *array = [MonthModel searchSingleWithWhere:where orderBy:@"yearNumber DESC, monthNumber ASC"];
    
    return array;
}

+ (NSInteger)getStepsFromModelWithYear:(NSInteger)year withMonth:(NSInteger)month
{
    NSString *where = [NSString stringWithFormat:@"userName = '%@' AND wareUUID = '%@' AND yearNumber = %d AND monthNumber = %d",
                       [UserInfoHelper sharedInstance].userModel.userName, [UserInfoHelper sharedInstance].bltModel.bltUUID,
                       (int)year, (int)month];
    MonthModel *model = [MonthModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        return 0;
    }

    return model.monthTotalSteps;
}

+ (NSInteger)getSleepFromModelWithYear:(NSInteger)year withMonth:(NSInteger)month withIndex:(NSInteger)index
{
    NSString *where = [NSString stringWithFormat:@"userName = '%@' AND wareUUID = '%@' AND yearNumber = %d AND monthNumber = %d",
                       [UserInfoHelper sharedInstance].userModel.userName, [UserInfoHelper sharedInstance].bltModel.bltUUID,
                       (int)year, (int)month];
    MonthModel *model = [MonthModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        return 0;
    }
    
    if (index == 2)
    {
        return model.totalShallowSleep;
    }
    else if (index == 1)
    {
        return model.totalDeepSleep;
    }
    
    return model.monthTotalSleep ;
}

+ (MonthModel *)getMonthModelFromModelWithYear:(NSInteger)year withMonth:(NSInteger)month
{
    NSString *where = [NSString stringWithFormat:@"userName = '%@' AND wareUUID = '%@' AND yearNumber = %d AND monthNumber = %d",
             [UserInfoHelper sharedInstance].userModel.userName, [UserInfoHelper sharedInstance].bltModel.bltUUID,
             (int)year, (int)month];
    MonthModel *monthModel = [MonthModel searchSingleWithWhere:where orderBy:nil];
    
    if (!monthModel)
    {
        monthModel = [[MonthModel alloc] initWithmonthNumber:month andYearNumber:year];
        
        [monthModel saveToDB];
    }

    return monthModel ;
}

+ (MonthModel *)getMonthModelFromDBWithMonthIndex:(NSInteger)monthIndex isContinue:(BOOL)isContinue
{
    NSInteger currentYear = [self getYearWithMonthIndex:monthIndex];
    NSInteger month = monthIndex - (currentYear - [NSDate date].year) * 12;
    NSString *where = [NSString stringWithFormat:@"yearNumber = %ld AND monthNumber = %ld AND userName = '%@' AND wareUUID = '%@'", (long)currentYear, (long)month, [UserInfoHelper sharedInstance].userModel.userName, [UserInfoHelper sharedInstance].bltModel.bltUUID];
    MonthModel *monthModel = [MonthModel searchSingleWithWhere:where orderBy:nil];
    
    if (!monthModel)
    {
        monthModel = [[MonthModel alloc] initWithmonthNumber:month andYearNumber:currentYear];
        
        [monthModel saveToDB];
    }
    
    monthModel.isContinue = isContinue;
    
    return monthModel;
}

+ (NSInteger)getYearWithMonthIndex:(NSInteger)index
{
    NSInteger currentYear = [NSDate date].year;
    if (index > 0)
    {
        currentYear = currentYear + (index - 1) / 12;
    }
    else
    {
        currentYear = currentYear + index / 12 - 1;
    }
    
    return currentYear;
}

// 表名
+ (NSString *)getTableName
{
    return @"MonthModel";
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"monthNumber", @"yearNumber", @"userName", @"wareUUID"];
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
    [self removePropertyWithColumnName:@"showDates"];
    [self removePropertyWithColumnName:@"showDaySteps"];
    [self removePropertyWithColumnName:@"showDaySleep"];
    [self removePropertyWithColumnName:@"showDayDeepSleep"];
    [self removePropertyWithColumnName:@"showDayShallowSleep"];
}
- (NSInteger)getStartTime
{
    PedometerModel *todayModel = [PedometerHelper getModelFromDBWithDate:[NSDate date]];
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:[[NSDate date] dateAfterDay :-1]];
    NSInteger index = 0;
    
    for (NSInteger i = 0; i < yesModel.yesterdayArray.count && i < 72; i ++)
    {
        int value = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];
        
        if (value < 9999)
        {
            index =  (i+216) * 5;
            return index ;
        }
    }
    
    
    for (NSInteger i = 0; i < todayModel.sleepArray.count && i < 216; i ++)
    {
        int value = [[[todayModel.sleepArray objectAtIndex:i] objectAtIndex:1] intValue];
        
        if (value < 9999)
        {
            index =  i * 5;
            return index ;
        }
    }
   
    return index ;
}
- (NSInteger)getYesterdaySleepTime
{
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:[[NSDate date] dateAfterDay :-1]];
    NSInteger deepTime = 0;
    
    for (NSInteger i = 0; i < yesModel.yesterdayArray.count; i ++)
    {
        int value = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];
        
        if (value != 9999 )
        {
            if (value) {
                deepTime += 5;
            }
        }
    }
    return deepTime;
}
- (NSInteger)getYesTerDayDeepSleepTime
{
    NSInteger deepTime = 0;
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:[[NSDate date] dateAfterDay :-1]];
    
    
    for (NSInteger i = 0; i < yesModel.yesterdayArray.count; i ++)
    {
        int value = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];
        int count = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:0] intValue];
        
        if (value != 9999)
        {
            if (value < 10)
            {
                if (count>=0)//&&count<216
                {
                    deepTime += 5;
                }
            }
        }
    }
    
    
    return deepTime;
}
- (NSInteger)getYesTerDayshallowSleepTime
{
    NSInteger deepTime = 0;
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:[[NSDate date] dateAfterDay :-1]];
    
    
    for (NSInteger i = 0; i < yesModel.yesterdayArray.count; i ++)
    {
        int value = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];
        int count = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:0] intValue];
        if (value != 9999)
        {
            if (value >=10 && value <= 30)
            {
                if (count>=0)//&&count<216
                {
                    deepTime += 5;
                }
            }
        }
    }
    
    return deepTime;
}

- (NSInteger)getYesTerDaywakingTime
{
    NSInteger deepTime = 0;
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:[[NSDate date] dateAfterDay :-1]];
    
    for (NSInteger i = 0; i < yesModel.yesterdayArray.count; i ++)
    {
        int value = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];
        
        if (value != 9999 )
        {
            if (value > 30)
            {
                deepTime += 5;
            }
        }
    }
    
    return deepTime;
}
@end
