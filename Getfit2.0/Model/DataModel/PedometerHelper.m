//
//  PedometerHelper.m
//  LoveSports
//
//  Created by zorro on 15/2/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PedometerHelper.h"
#import "DateTools.h"
#import "WeekModel.h"
#import "MonthModel.h"
#import "YearModel.h"
#import "DaysStepModel.h"

@implementation PedometerHelper

DEF_SINGLETON(PedometerHelper)

// 根据日期取出模型。
+ (PedometerModel *)getModelFromDBWithDate:(NSDate *)date
{
    NSString *dateString = [date dateToString];
    NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                       [dateString componentsSeparatedByString:@" "][0], [AJ_LastWareUUID getObjectValue]];
    PedometerModel *model = [PedometerModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        // 没有就进行完全创建.
        model = [PedometerHelper pedometerSaveEmptyModelToDBWithDate:date isSaveAllDay:NO];
    }
    
    return model;
}

// 取出今天的数据模型
+ (PedometerModel *)getModelFromDBWithToday
{
    PedometerModel *model = [PedometerHelper getModelFromDBWithDate:[NSDate date]];
    
    if (model)
    {
        return model;
    }
    else
    {
        model = [[PedometerModel alloc] init];
        
        return model;
    }
}

+ (void)saverealTimeDataToModel:(NSData *)data withEnd:(PedometerModelSyncEnd)endBlock
{
    PedometerModel *model = [PedometerHelper getModelFromDBWithDate:[NSDate date]];
    
    UInt8 val[20] = {0};//初始化20个0
    [data getBytes:&val length:data.length];
    
    NSInteger time = val[0] * 256 * 256 * 256 + val[1] * 256 * 256+ val[2] * 256 + val[3];
    NSInteger step = val[7] + val[6] * 256 + val[5] * 256 * 256 + val[4] * 256 * 256 * 256;
    
    model.totalSteps = step;
    model.totalActiveTime = time;
    [model updateToDB];
    // 更新到趋势表
    [PedometerHelper updateTrendTableWithModel:model];
    
    if (endBlock) {
        endBlock([NSDate date], YES);
    }
}

// 取出趋势图所需要的每天的模型.
+ (NSArray *)getEveryDayTrendDataWithDate:(NSDate *)date
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++)
    {
        NSDate *curDate = [date dateAfterDay:i];
        PedometerModel *model = [PedometerHelper getModelFromDBWithDate:curDate];
        if (model)
        {
            [array addObject:model];
        }
        else
        {
            [array addObject:[PedometerModel simpleInitWithDate:curDate]];
        }
    }
    
    return array;
}

+ (BOOL)queryWhetherCurrentDateDataSaveAllDay:(NSDate *)date
{
    NSString *dateString = [date dateToString];
    NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                       [dateString componentsSeparatedByString:@" "][0], [AJ_LastWareUUID getObjectValue]];
    PedometerModel *model = [PedometerModel searchSingleWithWhere:where orderBy:nil];
    
    if (model && model.isSaveAllDay)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 为模型创建空值的对象
+ (void)creatEmptyDataArrayWithModel:(PedometerModel *)model
{
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    NSMutableArray *sleeps = [[NSMutableArray alloc] init];
    NSMutableArray *sleepItems = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 288; i++)
    {
        StateModel *state = [[StateModel alloc] init];
        
        state.currentOrder  = i + 1;
        state.sleepState    = 9999;
        state.sleepDuration = 5;
        NSArray *stateData = @[@(state.currentOrder), @(state.sleepState), @(state.sleepDuration)];
        [sleepItems addObject:stateData];
        
        [steps addObject:@(0)];
        [sleeps addObject:@(9999)];
    }
    model.originalSportsArray = steps;
    model.originalSleepArray = sleeps;
    model.sleepArray = sleepItems;
    
    NSMutableArray *yesterdaysleepItems = [NSMutableArray array];
    for (int i = 0 ; i < 72 ; i++) {
        StateModel *state = [[StateModel alloc] init];
        
        state.currentOrder  = i + 1;
        state.sleepState    = 9999;
        state.sleepDuration = 5;
        NSArray *stateData = @[@(state.currentOrder), @(state.sleepState), @(state.sleepDuration)];
        [yesterdaysleepItems addObject:stateData];
    }
    model.yesterdayArray = yesterdaysleepItems;
    
    NSMutableArray *sportItems = [[NSMutableArray alloc] init];
    NSMutableArray *heartItems = [[NSMutableArray alloc] init];
    
    // 运动
    for (int i = 0; i < 96; i++)
    {
        StateModel *state = [[StateModel alloc] init];
        
        state.currentOrder  = i + 1;
        state.sportState    = SportStateActive;
        state.activeTime = 5;
        NSArray *stateData = @[@(state.currentOrder), @(state.sportState), @(state.steps),
                               @(state.activeTime), @(state.calories), @(state.distance)];
        [sportItems addObject:stateData];
        [heartItems addObject:@(0)];
    }
    model.sportsArray = sportItems;
    model.heartArray = heartItems;
}

// 保存空模型到数据库.
+ (PedometerModel *)pedometerSaveEmptyModelToDBWithDate:(NSDate *)date isSaveAllDay:(BOOL)save
{
    PedometerModel *model = [PedometerModel simpleInitWithDate:date];
    
    [model addTargetForModelFromUserInfo];
    [PedometerHelper creatEmptyDataArrayWithModel:model];
    
    if (![date compareWithDate:[NSDate date]] &&
        [date timeIntervalSince1970] < [[NSDate date] timeIntervalSince1970])
    {
        // NSLog(@"model.isSaveAllDay = ..%@", date);
        if (save)
        {
            model.isSaveAllDay = YES;
        }
    }
    
    [model saveToDB];
    
    return model;
}

+ (void)updateTrendTableWithModel:(PedometerModel *)model
{
    NSDate *date = [NSDate dateByString:model.dateString];
    
    // 保存到周的模型.
    WeekModel *weekModel = [WeekModel getWeekModelFromDBWithDate:date isContinue:NO];
    [weekModel updateTotalWithModel:model];
    [weekModel updateToDB];
    
    //取到这一月的模型，没有就创建，更新至年模型中
    MonthModel *monthModel = [MonthModel getMonthModelFromModelWithYear:date.year withMonth:date.month];
    [monthModel updateTotalWithModel:model];
    [monthModel updateToDB];
    
    //取到这一年的模型，没有就创建，更新至年模型中
    YearModel *yearModel = [YearModel getYearModelFromDBWithYearIndex:date.year isContinue:NO];
    [yearModel updateTotalWithModel:model];
    [yearModel updateToDB];
    
    // 更新的每天的步数和睡眠到DaysStepModel
    [DaysStepModel updateDaysStepWithModel:model];
}

// 保存数据。
+ (void)saveDataToModel:(NSData *)data
                withEnd:(PedometerModelSyncEnd)endBlock
{
    if (data.length == 0) {
        return;
    }
    
    // NSLog(@"运动数据 = %@", data);
    
    UInt8 val[288 * 4 * 2] = {0};
    [data getBytes:&val length:data.length];
    
    PedometerModel *todayModel = [PedometerHelper getModelFromDBWithDate:[NSDate date]];
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:[[NSDate date] dateAfterDay:-1]];
    BOOL isHaveYes = NO;
    
    NSDate *nowTime = [NSDate date];
    for (int i = 0; i < data.length; i += 4) {
        NSInteger value = val[i] * 256 + val[i + 1];
        NSInteger time = val[i + 2] * 256 + val[i + 3];
        NSInteger currenttime = nowTime.hour * 60 + nowTime.minute / 5 * 5;
        
        if (val[i + 2] & 0x80) {
            // 如果是睡眠
            time = time - 0x80 * 256;
        }
        
        NSInteger sysTime = currenttime - time ;
        
        if (sysTime > 0) {
            // 今天
            if (val[i + 2] & 0x80) {
                // 如果是睡眠
                [self updateDetailData:sysTime / 5 - 1 sleep:value model:todayModel];
            } else {
                [self updateDetailData:sysTime / 5 - 1 step:value model:todayModel];
            }
        } else {
            isHaveYes = YES;
            // 昨天
            if (val[i + 2] & 0x80) {
                // 如果是睡眠
                [self updateDetailData:288+sysTime / 5 - 1 sleep:value model:yesModel];
            } else {
                [self updateDetailData:288+sysTime / 5 - 1 step:value model:yesModel];
            }
        }
    }
    
    // 更新数据库
    [PedometerHelper updateSyncDataToDB:todayModel isYesTerday:NO];
    if (isHaveYes) {
        [PedometerHelper updateSyncDataToDB:yesModel isYesTerday:YES];
//        NSLog(@"yesmodel = %@",yesModel.originalSleepArray);
    }
    
    if (endBlock) {
        endBlock([NSDate date], YES);
    }
}

+ (void)updateSyncDataToDB:(PedometerModel *)model isYesTerday:(BOOL)yesterday
{
    NSMutableArray *stepArray = [[NSMutableArray alloc] init];
    NSInteger totalSteps = 0;
    for (int i = 0; i < model.originalSportsArray.count; i += 3)
    {
        NSInteger stepValue = [model.originalSportsArray[i] integerValue] +
        [model.originalSportsArray[i + 1] integerValue] +
        [model.originalSportsArray[i + 2] integerValue];
        
        [stepArray addObject:@(stepValue)];
        
        totalSteps += stepValue;
    }
    
    if (totalSteps > model.totalSteps) {
        model.totalSteps = totalSteps;
    }
    
    int height = [UserInfoHelper sharedInstance].userModel.showHeight.intValue;
    int weight = [UserInfoHelper sharedInstance].userModel.showWeight.intValue;
    
    NSMutableArray *stepItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < stepArray.count; i++)
    {
        StateModel *state = [[StateModel alloc] init];
        state.currentOrder  = i + 1;
        state.sportState    = SportStateActive;
        state.steps         = [stepArray[i] integerValue];
        state.activeTime    = arc4random()%5 +1;
        state.calories =  (NSInteger)(1.0* weight * 1.036 * height *0.45 * state.steps * 0.00001);
        state.distance = 1.0 * [stepArray[i] integerValue] * height*0.45*0.01;
        
        NSArray *modelData = @[@(state.currentOrder), @(state.sportState), @(state.steps),
                               @(state.activeTime), @(state.calories), @(state.distance)];
        [stepItems addObject:modelData];
    }
    
    model.sportsArray = stepItems;
    
    NSMutableArray *sleepItems = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < model.originalSleepArray.count; i++)
    {
        StateModel *state = [[StateModel alloc] init];
        
        state.currentOrder  = i + 1;
        state.sleepState    = [[model.originalSleepArray objectAtIndex:i] integerValue];
        state.sleepDuration = 5;
        
        NSArray *modelData = @[@(state.currentOrder), @(state.sleepState), @(state.sleepDuration)];
        [sleepItems addObject:modelData];
    }
    
    model.sleepArray = sleepItems;
    
    NSMutableArray *yesArr = model.sleepArray.mutableCopy;
    //    先将今天睡眠数据18:00之后的数据和昨天18:00的数据替换,然后保存今天18:00的数据
//    
//    //替换数据
//    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:[[NSDate date] dateAfterDay:-1]];
//    NSMutableArray *yesterarr = yesModel.yesterdayArray.mutableCopy;
//        NSMutableArray *newsleepArray = model.sleepArray.mutableCopy;
//    NSMutableArray *arrrr = [NSMutableArray array];
//    for (int i = 0; i<55; i++) {
//        NSArray *modelData = @[@(i), @(0), @(5)];
//
//        [arrrr addObject:modelData];
//    }
//    for (int i = 216 ; i< arrrr.count; i++) {
////        int j = i-216;
//        [newsleepArray replaceObjectAtIndex:i withObject:arrrr[i]];
//    }
//    model.sleepArray = newsleepArray;

    //18:00到0:00的数据，保存起来
//    if (yesterday) {
        NSMutableArray *myyesArr = [NSMutableArray array];
        for (int i = 216 ; i < 288 ; i++) {
            [myyesArr addObject:yesArr[i]];
        }
        model.yesterdayArray = myyesArr.mutableCopy;
//        NSLog(@"浅睡%ld 深睡%ld",(long)model.shallowSleepTime,(long)model.deepSleepTime);
//    }
 

    
    [model savePedometerModelToWeekModelAndMonthModel];
    [PedometerModel updateToDB:model where:nil];
}

+ (void)updateDetailData:(NSInteger)index step:(NSInteger)step model:(PedometerModel *)model
{
    if (index < 0) {
        return;
    }
    
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:model.originalSportsArray];
    
    NSInteger indexValue = index;
    
    if (indexValue > newArray.count - 1) {
        indexValue = newArray.count - 1;
    }
    
    [newArray replaceObjectAtIndex:indexValue withObject:@(step)];
    model.originalSportsArray = newArray;
}

+ (void)updateDetailData:(NSInteger)index sleep:(NSInteger)sleep model:(PedometerModel *)model
{
    if (index < 0) {
        return;
    }
    
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:model.originalSleepArray];
    NSInteger indexValue = index;
    
    if (indexValue > newArray.count - 1) {
        indexValue = newArray.count - 1;
    }
    
    NSLog(@"1睡眠数据 = %ld %ld", (long)index, (long)sleep);
    
    if (sleep > 200) {
        sleep = arc4random() % 30;
    }
    
    NSLog(@"2睡眠数据 = %ld %ld", (long)index, (long)sleep);
    
    [newArray replaceObjectAtIndex:indexValue withObject:@(sleep)];
    model.originalSleepArray = newArray;
}

// 保存心率数据。
+ (void)saveHeartDataToModel:(NSData *)data
                     withEnd:(PedometerModelSyncEnd)endBlock
{
    UInt8 val[20] = {0};
    [data getBytes:&val length:data.length];
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    PedometerModel *todayModel = [PedometerHelper getModelFromDBWithDate:[NSDate date]];
    
    [newArray addObjectsFromArray:todayModel.heartArray];
    
    [newArray replaceObjectAtIndex:(val[0]) * 4 withObject:@(val[1])];
    [newArray replaceObjectAtIndex:(val[0]) * 4 + 1 withObject:@(val[2])];
    [newArray replaceObjectAtIndex:(val[0]) * 4 + 2 withObject:@(val[3])];
    [newArray replaceObjectAtIndex:(val[0]) * 4 + 3 withObject:@(val[4])];
    
    todayModel.heartArray = newArray;
    [todayModel updateToDB];
}

@end











