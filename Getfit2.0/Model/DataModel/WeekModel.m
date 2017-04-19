//
//  WeekModel.m
//  AJBracelet
//
//  Created by zorro on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "WeekModel.h"
#import "DateTools.h"
#import "PedometerHelper.h"

@implementation WeekModel

- (instancetype)initWithWeekNumber:(NSInteger)weekNumber
                     andYearNumber:(NSInteger)yearNumber
{
    self = [super init];
    if (self)
    {
        _wareUUID = [UserInfoHelper sharedInstance].bltModel.bltUUID;
        _userName = [UserInfoHelper sharedInstance].userModel.userName;
        _weekNumber = weekNumber;
        _yearNumber = yearNumber;
        
        // 测试
        // _weekTotalSteps = arc4random() % 1000 + 10000;
        // _weekTotalSleep = arc4random() % 100 + 1000;
    }
    
    return self;
}

- (void)updateTotalWithModel:(PedometerModel *)model
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:_weeksDict];
    
    // 二维数组.
    NSInteger yesterDaytime = [self getYesterdaySleepTime];
    NSInteger yesterDaydeeptime = [self getYesTerDayDeepSleepTime];
    NSInteger yesterDayshallow = [self getYesTerDayshallowSleepTime];
    NSInteger yesterDaywaking = [self getYesTerDaywakingTime];
    NSInteger yesterDayStartTime = [self getStartTime];
    [dict setObject:@[@[@(model.totalSteps), @(model.totalCalories), @(model.totalDistance)],
                      @[@(model.sleepTotalTime+yesterDaytime+model.wakingTime), @(model.deepSleepTime+yesterDaydeeptime), @(model.shallowSleepTime+yesterDayshallow),
                        @(model.wakingTime+yesterDaywaking), @(yesterDayStartTime), @(model.sleepEndTime)]]
             forKey:model.dateString];
    
    _weeksDict = dict;
    
    // 这个方法也可以在取出的时候使用, 如果保存太费时间的话.
    [self updateAllDetailInfo];
}

// 更新详细数据.
- (void)updateAllDetailInfo
{
    _weekTotalSteps = 0;
    _weekTotalCalories = 0;
    _weekTotalDistance = 0;
    _weekTotalSleep = 0;
    
    NSInteger sportDay = 0;
    NSInteger sleepDay = 0;
    
    NSInteger totalDeepSleep = 0;
    NSInteger totalShallowSleep = 0;
    NSInteger totalWakingSleep = 0;
    NSInteger totalStartSleep = 0;
    NSInteger totalEndSleep = 0;

    NSArray *values = [_weeksDict allValues];
    
    for (int i = 0; i < values.count; i++)
    {
        NSArray *sport = values[i][0];
        NSArray *sleep = values[i][1];
        
        _weekTotalSteps += [sport[0] integerValue];
        _weekTotalCalories += [sport[1] integerValue];
        _weekTotalDistance += [sport[2] integerValue];

        _weekTotalSleep += [sleep[0] integerValue];
        totalDeepSleep += [sleep[1] integerValue];
        totalShallowSleep += [sleep[2] integerValue];
        totalWakingSleep += [sleep[3] integerValue];
        totalStartSleep += [sleep[4] integerValue];
        totalEndSleep += [sleep[5] integerValue];
        
        if ([sport[0] integerValue] > 0)
        {
            sportDay++;
        }
        
        if ([sleep[0] integerValue] > 0)
        {
            sleepDay++;
        }
    }

    _dailySteps = sportDay > 0 ? (NSInteger)(_weekTotalSteps * 1.0 / sportDay) : 0;
    _dailyCalories = sportDay > 0 ? (NSInteger)(_weekTotalCalories * 1.0 / sportDay) : 0;
    _dailyDistance = sportDay > 0 ? (NSInteger)(_weekTotalDistance * 1.0 / sportDay) : 0;
    
    _dailySleep = sleepDay > 0 ? (NSInteger)(_weekTotalSleep * 1.0 / sleepDay) : 0;
    _dailyDeepSleep = sleepDay > 0 ? (NSInteger)(totalDeepSleep * 1.0 / sleepDay) : 0;
    _dailyShallowSleep = sleepDay > 0 ? (NSInteger)(totalShallowSleep * 1.0 / sleepDay) : 0;
    _dailyWakingSleep = sleepDay > 0 ? (NSInteger)(totalWakingSleep * 1.0 / sleepDay) : 0;
    _dailyStartSleep = sleepDay > 0 ? (NSInteger)(totalStartSleep * 1.0 / sleepDay) : 0;
    _dailyEndSleep = sleepDay > 0 ? (NSInteger)(totalEndSleep * 1.0 / sleepDay) : 0;
}

- (NSString *)showDates
{
    NSDate *sunDate = [self getDateOfSunDayInCurrentWeek];
    NSDate *satDate = [sunDate dateAfterDay:6];
    
    NSString *showString = [NSString stringWithFormat:@"%d/%d-%d/%d", sunDate.month, sunDate.day, satDate.month, satDate.day];
    
    return showString;
}

- (NSArray *)showDaySteps
{
    NSDate *date = [self getDateOfSunDayInCurrentWeek];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDate *tmpDate;
    PedometerModel *model;
    
    if (_isContinue)
    {
        tmpDate = [date dateAfterDay:-1];
        model = [PedometerHelper getModelFromDBWithDate:tmpDate];
        [array addObject:@(model.totalSteps)];
    }
    
    for (int i = 0; i < 7; i++)
    {
        tmpDate = [date dateAfterDay:i];
        NSString *dateString = [tmpDate dateToDayString];
        NSArray *tmpArray = [_weeksDict objectForKey:dateString];
        
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
        tmpDate = [date dateAfterDay:7];
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
    NSDate *date = [self getDateOfSunDayInCurrentWeek];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDate *tmpDate;
    
    if (_isContinue)
    {
        tmpDate = [date dateAfterDay:-1];
        [array addObject:[self getSleepTimeFromDate:tmpDate withIndex:index]];
    }
    
    for (int i = 0; i < 7; i++)
    {
        tmpDate = [date dateAfterDay:i];
        NSString *dateString = [tmpDate dateToDayString];
        NSArray *tmpArray = [_weeksDict objectForKey:dateString];
        
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
        tmpDate = [date dateAfterDay:7];
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

- (NSDate *)getDateOfSunDayInCurrentWeek
{
    NSString *dateString = [NSString stringWithFormat:@"%04d-01-01", (int)_yearNumber];
    NSDate *date = [NSDate dateByString:dateString];
    NSDate *sunDate = [date dateAfterDay:1 - (int)date.weekday]; // 得出上周日
    NSDate *currentMonDate = [sunDate dateByAddingWeeks:_weekNumber - 1];
    
    // NSLog(@"..%d..%d..%d..%d..%d..%@..%d", date.weekday, sunDate.weekday, sunDate.weekOfYear, _weekNumber, currentMonDate.weekOfYear, currentMonDate, currentMonDate.weekday);

    return currentMonDate;
}

+ (WeekModel *)getWeekModelFromDBWithDate:(NSDate *)date isContinue:(BOOL)isContinue
{
    NSString *where = [NSString stringWithFormat:@"userName = '%@' AND wareUUID = '%@' AND yearNumber = %d AND weekNumber = %d",
                       [UserInfoHelper sharedInstance].userModel.userName, [UserInfoHelper sharedInstance].bltModel.bltUUID,
                       (int)date.year, (int)date.weekOfYear];
    WeekModel *weekModel = [WeekModel searchSingleWithWhere:where orderBy:nil];
    
    NSLog(@"week model  where>>>>>%@",where);
    
    
    // NSLog(@"当前周的字典: %@", weekModel.weeksDict);
    if (!weekModel)
    {
        weekModel = [[WeekModel alloc] initWithWeekNumber:date.weekOfYear andYearNumber:date.year];
 
        [weekModel saveToDB];
    }
    
    weekModel.isContinue = isContinue;

    return weekModel;
}

// 表名
+ (NSString *)getTableName
{
    return @"WeekModel";
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"weekNumber", @"yearNumber", @"userName", @"wareUUID"];
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
    
    return index;
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
