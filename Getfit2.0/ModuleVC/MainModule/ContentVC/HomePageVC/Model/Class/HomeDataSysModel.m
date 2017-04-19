//
//  HomeDataSysModel.m
//  AJBracelet
//
//  Created by 黄建华 on 15/12/5.
//  Copyright © 2015年 zorro. All rights reserved.
//

#import "HomeDataSysModel.h"

@implementation HomeDataSysModel

+ (void)initialize
{

}

// 主建
+ (NSString *)getPrimaryKey
{
    return @"userName";
}

// 表名
+ (NSString *)getTableName
{
    return @"HomeDataSysModel";
}
// 表版本
+ (int)getTableVersion
{
    return 1;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _userName = AJ_UserName;
    }
    return self;
}

- (void)setStepTotayArray:(NSMutableArray *)stepTotayArray
{
    _stepTotayArray = stepTotayArray;
    [self updateCurrentModelInDB];
}

- (void)setSleepTotayArray:(NSMutableArray *)sleepTotayArray
{
    _sleepTotayArray = sleepTotayArray;
    [self updateCurrentModelInDB];
}

- (void)setStepYdArray:(NSMutableArray *)stepYdArray
{
    _stepYdArray = stepYdArray;
    [self updateCurrentModelInDB];
}

- (void)setSleepYdArray:(NSMutableArray *)sleepYdArray
{
    _sleepYdArray = sleepYdArray;
    [self updateCurrentModelInDB];
}

- (void)updateCurrentModelInDB
{
    if ([ShareData sharedInstance].isAllowHomeDataSave)
    {
        [HomeDataSysModel updateToDB:self where:nil];
    }
}

+ (HomeDataSysModel *)getModelFromDB
{
    // 避免数据库的循环使用.
    [ShareData sharedInstance].isAllowHomeDataSave = NO;
    
    NSString *where = [NSString stringWithFormat:@"userName = '%@'", AJ_UserName];
    HomeDataSysModel *model = [HomeDataSysModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        // 没有就进行完全创建.
        model = [HomeDataManagerHelp pedometerSaveEmptyModelToisSaveAllDay:NO];
    }
    
    [ShareData sharedInstance].isAllowHomeDataSave = YES;
    
    return model;
}

- (NSInteger)totalStep
{
    NSInteger step = 0;
    
    for (NSString *stepValue in _stepTotayArray)
    {
        step += stepValue.integerValue;
    }
    return step;
}

- (void)setHeartArray:(NSMutableArray *)heartArray
{
    _heartArray = heartArray;
    [self updateCurrentModelInDB];
}

// 简单初始化并赋值。
+ (HomeDataSysModel *)simpleInit
{
    HomeDataSysModel *model = [[HomeDataSysModel alloc] init];
    
    NSMutableArray *stepTotayArrayValue = [[NSMutableArray alloc] init];
    for (int i = 0 ; i< 288; i++)
    {
        [stepTotayArrayValue addObject:@(0)];
    }
    model.dateString = [[[NSDate date] dateToString] componentsSeparatedByString:@" "][0];
    model.stepTotayArray = stepTotayArrayValue;
    model.stepYdArray = stepTotayArrayValue;
    
    
    NSMutableArray *sleepTotayArrayValue = [[NSMutableArray alloc] init];
    for (int i = 0 ; i< 288; i++)
    {
        [sleepTotayArrayValue addObject:@(9999)];
    }
    
    model.sleepTotayArray = sleepTotayArrayValue;
    model.sleepYdArray = sleepTotayArrayValue;
    
    
    NSMutableArray *heartArrayValue = [[NSMutableArray alloc] init];

    for (int i = 0; i < 96; i++)
    {
        [heartArrayValue addObject:@(0)];
    }
    model.heartArray = heartArrayValue;
    
    return model;
}

@end
