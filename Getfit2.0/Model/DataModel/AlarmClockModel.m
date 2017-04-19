//
//  AlarmClockModel.m
//  AJBracelet
//
//  Created by zorro on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "AlarmClockModel.h"
#import "UserInfoHelper.h"

@implementation AlarmClockModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self resetParameters];
    }
    
    return self;
}

// 闹钟信息初始化.
- (void)resetParameters
{
    _isOpen = NO;
    _repeat = 0;
    _hour = 0;
    _minutes = 0;
    _seconds = 0;
    _alarmType = KK_Text(@"Get Up");
    _weekArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7"];
}

+ (NSArray *)getAlarmClockFromDBWithUUID:(NSString *)uuid
{
    NSString *where = [NSString stringWithFormat:@"wareUUID = '%@'", uuid];
    NSArray *array = [AlarmClockModel searchWithWhere:where orderBy:nil offset:0 count:-1];
    
    if (!array || array.count == 0)
    {
        NSMutableArray *alarmArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < 3; i++)
        {
            AlarmClockModel *model = [AlarmClockModel simpleInitWith:i withUUID:uuid];
            
            [model saveToDB];
            [alarmArray addObject:model];
        }
        
        array = alarmArray;
    }
    
    /*
    NSMutableArray *alarmArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 10; i++)
    {
        NSString *where = [NSString stringWithFormat:@"wareUUID = '%@' AND orderIndex = %ld", uuid, i];
        AlarmClockModel *model = [AlarmClockModel searchSingleWithWhere:where orderBy:nil];
        
        if (!model)
        {
            model = [AlarmClockModel simpleInitWith:i withUUID:uuid];
            
            [model saveToDB];
        }
        
        [alarmArray addObject:model];
    }
     */
    
    return array;
}

+ (AlarmClockModel *)simpleInitWith:(NSInteger)index withUUID:(NSString *)uuid
{
    AlarmClockModel *model = [[AlarmClockModel alloc] init];
    
    model.orderIndex = index;
    model.wareUUID = uuid;
    
    return model;
}

- (NSArray *)sortByNumberWithArray:(NSArray *)array withSEC:(BOOL)sec
{
    NSMutableArray *muArray = [NSMutableArray arrayWithArray:array];
    
    [muArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         NSString *string1 = (NSString *)obj1;
         NSString *string2 = (NSString *)obj2;
         
         if (([string1 integerValue] > [string2 integerValue]) == sec)
         {
             return NSOrderedAscending;
         }
         else
         {
             return NSOrderedDescending;
         }
     }];
    
    return muArray;
}

- (NSString *)showStringForWeekDay
{
    NSArray *weekArray = [self sortByNumberWithArray:_weekArray withSEC:NO];
    NSDictionary *dict = @{@"7" : KK_Text(@"Sun"), @"1" : KK_Text(@"Mon"), @"2" : KK_Text(@"Tue"),
                           @"3" : KK_Text(@"Wed"), @"4" : KK_Text(@"Thu"),
                           @"5" : KK_Text(@"Fri"), @"6" : KK_Text(@"Sat")};
    
    NSString *weekString = @""; //weekArray.count > 0 ? LS_Text(@"sign-week") : @"";
    
    if (weekArray.count == 7) {
        weekString = KK_Text(@"Everyday");
    } else {
        for (int i = 0; i < weekArray.count; i++)
        {
            NSString *day = weekArray[i];
            NSString *string = [dict objectForKey:day];
            
            if (i != _weekArray.count - 1)
            {
                weekString = [NSString stringWithFormat:@"%@%@ ", weekString, string];
            }
            else
            {
                weekString = [NSString stringWithFormat:@"%@%@", weekString, string];
            }
        }
    }
    
    return weekString;
}

- (void)convertToBLTNeed
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

- (UIImage *)showIconImage
{
    NSString *loccalAlermType = KK_Text(_alarmType);
    if ([loccalAlermType isEqualToString:KK_Text(@"Exercise")])
    {
        return UIImageNamedNoCache(@"device_alarm_sport_5@2x.png");
    }
    else if ([loccalAlermType isEqualToString:KK_Text(@"Take Medication")])
    {
        return UIImageNamedNoCache(@"device_alarm_pill_5@2x.png");
    }
    else if ([loccalAlermType isEqualToString:KK_Text(@"Get Up")])
    {
        return UIImageNamedNoCache(@"device_alarm_wakeup_5@2x.png");
    }
    else if ([loccalAlermType isEqualToString:KK_Text(@"Go to sleep")])
    {
        return UIImageNamedNoCache(@"device_alarm_sleep_5@2x.png");
    }
    else if ([loccalAlermType isEqualToString:KK_Text(@"Dating")])
    {
        return UIImageNamedNoCache(@"device_alarm_dating_5@2x.png");
    }
    else if ([loccalAlermType isEqualToString:KK_Text(@"Party")])
    {
        return UIImageNamedNoCache(@"device_alarm_together_5@2x.png");
    }
    else if ([loccalAlermType isEqualToString:KK_Text(@"Meeting")])
    {
        return UIImageNamedNoCache(@"device_alarm_meeting_5@2x.png");
    }
    else
    {
        return UIImageNamedNoCache(@"device_alarm_customize_5@2x.png");
    }
}

// 数据库存储
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    self.isChanged = YES;
}

- (void)setWeekArray:(NSArray *)weekArray
{
    _weekArray = weekArray;
    self.isChanged = YES;
}

- (void)setAlarmType:(NSString *)alarmType
{
    _alarmType = alarmType;
    self.isChanged = YES;
}

/*
- (void)setRepeat:(UInt8)repeat
{
    _repeat = repeat;
    self.isChanged = YES;
}
 */
- (void)setDaySplit:(NSInteger)daySplit {
    _daySplit = daySplit;
    self.isChanged = YES;
}

- (void)setHour:(NSInteger)hour
{
    _hour = hour;
    self.isChanged = YES;
}

- (void)setMinutes:(NSInteger)minutes
{
    _minutes = minutes;
    self.isChanged = YES;
}

- (void)setShowHeight:(CGFloat)showHeight
{
    _showHeight = showHeight;
    
    if (_showHeight < 20.0)
    {
        [self resetParameters];
    }
    
    self.isChanged = YES;
}

- (void)setNoteString:(NSString *)noteString
{
    _noteString = noteString;
    self.isChanged = YES;
}

- (void)setIsChanged:(BOOL)isChanged
{
    if ([ShareData sharedInstance].isAllowBLTSave)
    {
        _isChanged = isChanged;

        NSString *where = [NSString stringWithFormat:@"wareUUID = '%@' AND orderIndex = %ld", _wareUUID, (long)_orderIndex];
        [AlarmClockModel updateToDB:self where:where];
    }
}

- (NSString *)showTimeString
{
    if ([AlarmClockModel isHasAMPMTimeSystem])
    {
        if (_daySplit == 0)
        {
            return [NSString stringWithFormat:@"%@ %02ld:%02ld", (@"AM"), (long)_hour, (long)_minutes];
        }
        else
        {
            return [NSString stringWithFormat:@"%@ %02ld:%02ld", (@"PM"), _hour - 12 , (long)_minutes];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)_hour, (long)_minutes];
    }
}

- (NSArray *)alarmTypeArray
{
    return [UserInfoHelper sharedInstance].userModel.alarmTypeArray;
}

/*
- (NSString *)noteString
{
    return [NSString stringWithFormat:@"我的%@提醒", _alarmType];
}
 */

// 表名
+ (NSString *)getTableName
{
    return @"AlarmClockModel";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"wareUUID", @"orderIndex"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

+(void)initialize
{
    [self removePropertyWithColumnName:@"alarmTypeArray"];
    [self removePropertyWithColumnName:@"showTimeString"];
    [self removePropertyWithColumnName:@"showAlarmType"];
}

@end
