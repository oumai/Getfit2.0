//
//  RemindModel.m
//  AJBracelet
//
//  Created by zorro on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "RemindModel.h"

@implementation RemindModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _isOpen = NO;
        _interval = 30;
        _startHour = 9;
        _startMin = 0;
        _endHour = 12;
        _endMin = 0;
        
        _weekArray = @[@"1", @"2", @"3", @"4", @"5"];
    }
    
    return self;
}

+ (NSArray *)getRemindFromDBWithUUID:(NSString *)uuid
{
    
    NSString *where = [NSString stringWithFormat:@"wareUUID = '%@'", uuid];
    RemindModel *model = [RemindModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [[RemindModel alloc] init];
        model.wareUUID = uuid;
        [model saveToDB];
    }
    
    return @[model];

}

// 数据库存储.
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    self.isChanged = YES;
}

- (void)setInterval:(NSInteger)interval
{
    _interval = interval;
    self.isChanged = YES;
}

- (void)setStartHour:(NSInteger)startHour
{
    _startHour = startHour;
    self.isChanged = YES;
}

- (void)setStartMin:(NSInteger)startMin
{
    _startMin = startMin;
    self.isChanged = YES;
}

- (void)setEndHour:(NSInteger)endHour
{
    _endHour = endHour;
    self.isChanged = YES;
}

- (void)setEndMin:(NSInteger)endMin
{
    _endMin = endMin;
    self.isChanged = YES;
}

- (void)setWeekArray:(NSArray *)weekArray
{
    _weekArray = weekArray;
    self.isChanged = YES;
}

- (UInt8)repeat
{
    UInt8 val = 0;
    for (int i = 1; i < 8; i++)
    {
        if ( _weekArray && [_weekArray containsObject:[NSString stringWithFormat:@"%d", i]])
        {
            val = val | (1 << i);
        }
        else
        {
            val = val | (0 << i);
        }
    }
    
    _repeat = val | (_isOpen << 0);
    
    return _repeat;
}

- (void)setIsChanged:(BOOL)isChanged
{
    
    if ([ShareData sharedInstance].isAllowBLTSave)
    {
        NSLog(@"..%d..%d", _startHour, _startMin);
        
        _isChanged = isChanged;

        [RemindModel updateToDB:self where:nil];
    }
}

- (NSString *)showStartTimeString
{
    /*
    if ([RemindModel isHasAMPMTimeSystem])
    {
        NSArray *array = [_startTime componentsSeparatedByString:@":"];
        NSInteger hour = [array[0] integerValue];
        NSInteger minutes = [array[1] integerValue];
        
        if (hour <= 12)
        {
            return [NSString stringWithFormat:@"%@ %@", @"AM", _startTime];
        }
        else
        {
            return [NSString stringWithFormat:@"%@ %02d:%02d", @"PM", hour - 12, minutes];
        }
    }
    else
    {
        return _startTime;
    }
     */
    
    return [NSString stringWithFormat:@"%02d:%02d", _startHour, _startMin];
}

- (NSString *)showEndTimeString
{
    /*
    if ([RemindModel isHasAMPMTimeSystem])
    {
        NSArray *array = [_endTime componentsSeparatedByString:@":"];
        NSInteger hour = [array[0] integerValue];
        NSInteger minutes = [array[1] integerValue];
        
        if (hour <= 12)
        {
            return [NSString stringWithFormat:@"%@ %@", @"AM", _endTime];
        }
        else
        {
            return [NSString stringWithFormat:@"%@ %02d:%02d", @"PM", hour - 12, minutes];
        }
    }
    else
    {
        return _endTime;
    }
     */
    
    return [NSString stringWithFormat:@"%02d:%02d", _endHour, _endMin];
}

// 表名
+ (NSString *)getTableName
{
    return @"RemindModel";
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
