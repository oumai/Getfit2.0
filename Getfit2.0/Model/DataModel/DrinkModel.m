//
//  DrinkModel.m
//  AJBracelet
//
//  Created by zorro on 16/1/11.
//  Copyright © 2016年 zorro. All rights reserved.
//

#import "DrinkModel.h"

@implementation DrinkModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _isOpen = NO;
        _startTime = 6;
        _endTime = 18;
        _drinkWater = 1500;
        _timeInterval = 90;
    }
    
    return self;
}

+ (DrinkModel *)getDrinkFromDBWithUUID:(NSString *)uuid
{
    NSString *where = [NSString stringWithFormat:@"wareUUID = '%@'", uuid];
    DrinkModel *model = [DrinkModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [[DrinkModel alloc] init];
        model.wareUUID = uuid;
        [model saveToDB];
    }
    
    return model;
    
}

// 数据库存储.
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    self.isChanged = YES;
}

- (void)setStartTime:(NSInteger)startTime
{
    _startTime = startTime;
    self.isChanged = YES;
}

- (void)setEndTime:(NSInteger)endTime
{
    _endTime = endTime;
    self.isChanged = YES;
}

- (void)setDrinkWater:(NSInteger)drinkWater
{
    _drinkWater = drinkWater;
    self.isChanged = YES;
}

- (void)setTimeInterval:(NSInteger)timeInterval
{
    _timeInterval = timeInterval;
    self.isChanged = YES;
}

- (void)setIsChanged:(BOOL)isChanged
{
    if ([ShareData sharedInstance].isAllowBLTSave)
    {
        _isChanged = isChanged;
        
        [DrinkModel updateToDB:self where:nil];
    }
}

// 表名
+ (NSString *)getTableName
{
    return @"DrinkModel";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"wareUUID"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end
