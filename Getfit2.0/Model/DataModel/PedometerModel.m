//
//  PedometerModel.m
//  AJBracelet
//
//  Created by zorro on 15/7/13.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PedometerModel.h"
#import "PedometerHelper.h"
#import "UserInfoHelper.h"
#import "BLTAcceptModel.h"

@implementation StateModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _sleepState = 9999;
    }
    return self;
}

@end

@implementation PedometerModel

// 简单初始化并赋值。
+ (PedometerModel *)simpleInitWithDate:(NSDate *)date
{
    PedometerModel *model = [[PedometerModel alloc] init];
    
    model.wareUUID = [AJ_LastWareUUID getObjectValue];
    model.dateString = [[date dateToString] componentsSeparatedByString:@" "][0];
    
    return model;
}


// 返回总卡路里
- (NSInteger)totalCalories
{
    NSInteger calories = [self getCaloriesWith:self.totalSteps];
//    NSLog(@"self.totalSteps>>>%d",self.totalSteps);
//    
//    NSLog(@"totalCalories>>>>>%d",calories);
    
    return calories;
}

// 返回总距离 根据步数换算
- (NSInteger)totalDistance
{
    int height = [UserInfoHelper sharedInstance].userModel.showHeight.intValue;

    return height *0.45*self.totalSteps *0.01/1000;
}

// 睡眠开始时间
- (NSInteger)sleepStartTime
{
    NSInteger index = 0;

    
    for (NSInteger i = 0; i < self.sleepArray.count; i ++)
    {
        int value = [[[self.sleepArray objectAtIndex:i] objectAtIndex:1] intValue];
        
        if (value < 9999)
        {
            index =  i * 5;
            break;
        }
    }
    
//    for (NSInteger i = 0; i < self.yesterdayArray.count; i ++)
//    {
//        int value = [[[self.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];
//        
//        if (value < 9999)
//        {
//            index =  (i+217) * 5;
//            break;
//        }
//    }

    
    return index ;
}

// 睡眠结束时间
- (NSInteger)sleepEndTime
{
    NSInteger index = self.sleepStartTime;
    if (self.sleepArray.count > 0)
    {
        for (NSInteger i = 287; i >= 0; i --)
        {
            int value = [[[self.sleepArray objectAtIndex:i] objectAtIndex:1] intValue];
            
            if (value != 9999)
            {
                index =  (i+1) * 5;
                break;
            }
        }
    }
    
    return index ;
}

// 睡眠总时长
- (NSInteger)sleepTotalTime
{
    return self.shallowSleepTime  + self.deepSleepTime;
    //+ self.wakingTime
}

- (NSInteger)deepSleepTime
{
    NSInteger deepTime = 0;
    
    for (NSInteger i = 0; i < 216; i ++)
    {
        int value = [[[self.sleepArray objectAtIndex:i] objectAtIndex:1] intValue];
        int count = [[[self.sleepArray objectAtIndex:i] objectAtIndex:0] intValue];

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

- (NSInteger)shallowSleepTime
{
    NSInteger deepTime = 0;
    
    for (NSInteger i = 0; i < 216; i ++)
    {
        int value = [[[self.sleepArray objectAtIndex:i] objectAtIndex:1] intValue];
        int count = [[[self.sleepArray objectAtIndex:i] objectAtIndex:0] intValue];
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

- (NSInteger)wakingTime
{
    NSInteger deepTime = 0;
    
    for (NSInteger i = 0; i < 216; i ++)
    {
        int value = [[[self.sleepArray objectAtIndex:i] objectAtIndex:1] intValue];
        
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

// 返回实际卡路里根据步数
- (NSInteger)getCaloriesWith:(NSInteger)step
{
    if (step < 1)
    {
        step = 0;
    }
    
    int height = [UserInfoHelper sharedInstance].userModel.showHeight.intValue;
    int weight = [UserInfoHelper sharedInstance].userModel.showWeight.intValue;
    
    return    (NSInteger)(1.0* weight * 1.036 * height *0.45 * step * 0.00001 );
}


// 读取运动数据包 前面2个包的数据
- (void)saveSportInfoToModel:(UInt8 *)val
{
}

// 读取睡眠数据包 前面2个包的数据
- (void)saveSleepInfoToModel:(UInt8 *)val
{
}

+(void)pedometerModelSaveDataToDBYs
{
}

// 同步手环数据到数据库
+ (void)pedometerModelSaveDataToDB
{
    
}

+ (void)saveModelToDBFinish:(PedometerModel *)model
{
}

// 解析并保存数据。
+ (void)saveDataToModel:(NSArray *)array
                withEnd:(PedometerModelSyncEnd)endBlock
{
}

// 最后步骤
// 保存到数据库.
+ (void)saveModelToDB:(PedometerModel *)model withEndBlock:(PedometerModelSyncEnd)endBlock
{
}

// 从用户信息为模型添加各种目标.
- (void)addTargetForModelFromUserInfo
{
    _targetStep = [UserInfoHelper sharedInstance].userModel.targetSteps;
    _targetCalories = [UserInfoHelper sharedInstance].userModel.targetCalories;
    _targetDistance = [UserInfoHelper sharedInstance].userModel.targetDistance;
    _targetSleep = [UserInfoHelper sharedInstance].userModel.targetSleep;
}

// 详细运动步数显示.
- (NSArray *)showDetailSports
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < _sportsArray.count; i++)
    {
        NSArray *data = _sportsArray[i];
        
        [array addObject:data[2]];
    }
    
    // 补满方便显示
    for (int i = array.count; i < 96; i++)
    {
        [array addObject:@(0)];
    }
    
    return array;
}

// 详细睡眠显示.
- (NSArray *)showDetailSleep
{
    return _sleepArray;
}

- (NSArray *)showSleepTimeArray
{
    if (!_sleepArray || _sleepArray.count == 0)
    {
        return nil;
    }
    
//    CGFloat average = _sleepTotalTime / 3.0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
//    for (int i = 1; i >= 0; i--)
//    {
//        NSInteger time = _sleepEndTime - (NSInteger)(i * average + 0.5);
//        if (time < 0)
//        {
//            time = (24 * 60 + time);
//        }
//        
//        NSString *timeString = [NSString stringWithFormat:@"%02d:%02d", time / 60, time % 60];
//        
//        [array addObject:timeString];
//    }
    NSString *startTimeString = [NSString stringWithFormat:@"%02d:%02d", self.sleepStartTime / 60, self.sleepStartTime % 60];
    NSString *startEndString = [NSString stringWithFormat:@"%02d:%02d", self.sleepEndTime / 60, self.sleepEndTime % 60];
    
    [array addObject:startTimeString];
    [array addObject:startEndString];
    [array addObject:@(self.sleepStartTime)];
    [array addObject:@(self.sleepEndTime)];
    
    return array;
}

- (void)savePedometerModelToWeekModelAndMonthModel
{
    [PedometerHelper updateTrendTableWithModel:self];
}

// 表名
+ (NSString *)getTableName
{
    return @"PedometerTable";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"dateString", @"wareUUID"];
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
    
    [self removePropertyWithColumnName:@"showDetailSports"];
    [self removePropertyWithColumnName:@"showDetailSleep"];
    [self removePropertyWithColumnName:@"showSleepTime"];
}

@end
