//
//  DaysStepModel.m
//  AJBracelet
//
//  Created by zorro on 15/7/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DaysStepModel.h"

@implementation DaysStepModel

// 简单初始化并赋值。
+ (DaysStepModel *)simpleInitWithUUID:(NSString *)uuid
{
    DaysStepModel *model = [[DaysStepModel alloc] init];
    
    model.userName = [UserInfoHelper sharedInstance].userModel.userName;
    model.wareUUID = uuid;
    
    return model;
}

+ (DaysStepModel *)getCurrentDaysStepModelFromDB
{
    NSString *where = [NSString stringWithFormat:@"wareUUID = '%@'", [UserInfoHelper sharedInstance].bltModel.bltUUID];
    DaysStepModel *model = [DaysStepModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [DaysStepModel simpleInitWithUUID:[UserInfoHelper sharedInstance].bltModel.bltUUID];
        
        [model saveToDB];
    }
    
    return model;
}

+ (void)updateDaysStepWithModel:(PedometerModel *)model
{
    DaysStepModel *daysModel = [DaysStepModel getCurrentDaysStepModelFromDB];
    
    [daysModel saveSteps:model.totalSteps
                andSleep:model.sleepTotalTime
                withDateString:model.dateString];
    
    [daysModel updateToDB];
}

- (void)saveSteps:(NSInteger)steps andSleep:(NSInteger)sleep withDateString:(NSString *)dateString
{
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:_daysStepDict];
    
    [mutDict setObject:@[@(steps), @(sleep)] forKey:dateString];
    
    _daysStepDict = mutDict;
}

- (NSArray *)stepsArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDate *date = [SAVEFIRSTUSERDATE getObjectValue];
    NSInteger days = [date dateByDistanceDaysWithDate:[NSDate date]];
    
    for (NSInteger i = 0; i <= days; i++)
    {
        NSArray *data = [_daysStepDict objectForKey:[[date dateAfterDay:(int)i] dateToDayString]];
        
        [array addObject:data ? data[0] : @(0)];
    }
    
    NSLog(@"stepsArray－count ＝ %d", array.count);
    
    return array;
}

- (NSArray *)sleepArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDate *date = [SAVEFIRSTUSERDATE getObjectValue];
    NSInteger days = [date dateByDistanceDaysWithDate:[NSDate date]];
    
    for (NSInteger i = 0; i <= days; i++)
    {
        NSArray *data = [_daysStepDict objectForKey:[[date dateAfterDay:(int)i] dateToDayString]];
        
        [array addObject:data ? data[1] : @(0)];
    }
    
    NSLog(@"sleepArray－count ＝ %d", array.count);
    
    return array;
}

// 表名
+ (NSString *)getTableName
{
    return @"DaysStepModel";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"wareUUID"];
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
    
    [self removePropertyWithColumnName:@"stepsArray"];
    [self removePropertyWithColumnName:@"sleepArray"];
}

@end
