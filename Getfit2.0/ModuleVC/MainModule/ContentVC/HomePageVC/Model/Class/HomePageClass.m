//
//  HomePageClass.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/25.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "HomePageClass.h"
#import "PedometerModel.h"
#import "TestViewController.h"

@implementation HomePageClass

DEF_SINGLETON (HomePageClass)

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self loadData];
        [self loadNewData];
        
        _countAdd = 0;
        _isysday = NO;
        _UpdateFinish = YES;
    }
    
    return self;
}

- (NSDate *)currentSysDate
{
    return [NSDate date];
}

- (void)updaetSys
{
    _countAdd ++;
    
    if (_countAdd < 6000) {
        
    } else {
        _countAdd = 0;
    }
    
    if (_countAdd %60 == 0) {
        
        if (_updateSysHeartBlock) {
            _updateSysHeartBlock();
        }
    }
    
    if (_countAdd % 5 ==0) {
        if (_updaetSysBlock) {
            _updaetSysBlock();
        }
    }
}

- (void)exitUpdate
{
    if (_isysday) {
        [PedometerModel pedometerModelSaveDataToDBYs];
    }
    
    [PedometerModel pedometerModelSaveDataToDB];
}

// 新手环
- (void)loadNewData
{
    _isSysFinish = NO;
}

- (NSString *)currentTarget;
{
    return @"10000";
}

- (NSString *)currentStep
{
    int target =arc4random()%10000;
    _currentStepValue = [NSString stringWithFormat:@"%d",target];
    
    return _currentStepValue;
}

- (void)loadData
{
    [self backDate:0];
}

- (void)refreshDate2
{
    _shallowSleep = @"190";
    _deepSleep = @"287";
    _soberSleep = @"53";
    [self.UpdateDataSleepDelegate updateDataHomeSleep];
}

- (NSMutableArray *)HomePageTodayData;
{
    NSMutableArray *arrary = [[NSMutableArray alloc]init];
    for (int i = 0; i < 96; i++) {
        int randomValue = arc4random() % 500 ;
        [arrary addObject:[NSString stringWithFormat:@"%d",randomValue]];
    }
    return arrary;
}

- (NSMutableArray *)HomePageSleepData
{
    NSMutableArray *sleepState = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 40; i++) {
        [sleepState addObject:[NSString stringWithFormat:@"%d",arc4random()%3+1]];
    }
    return sleepState;
}

- (NSArray *)CustomieScrollStep
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 30; i++) {
        int value = arc4random() % 100 ;
        [array addObject:[NSString stringWithFormat:@"%d",value]];
    }
    
    return array;
}

- (NSArray *)CustomieScrollSleep
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 30; i++) {
        int value = arc4random() % 720 + 1 ;
        [array addObject:[NSString stringWithFormat:@"%d",value]];
    }
    
    return array;
}

// 返回当前多少天日期
- (NSString *)backDate:(int)dateIndex
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[NSDate dateFormatterTemp];
    [dateformatter setDateFormat:@"YYYY/MM/dd"];
    NSTimeInterval time = - 24 * 3600 * dateIndex;
    NSDate *beforeData =[senddate initWithTimeIntervalSinceNow:time];
    NSString *  before=[dateformatter stringFromDate:beforeData];
    
    _currentDate = before;
    return before;
}

-(NSString *)totalSleepTime
{
    return @" 0     00";
}
-(NSString *)beginSleepTime
{
    return  @"22:30";
}
-(NSString *)endSleepTime
{
    return @"07:20";
}


// 发送 $s 同步手环数据
- (void)updateBraceletData:(CGFloat)withTime backBlock:(NSObjectSimpleBlock)block
{
    if (_isSysFinish == NO)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sysDataFinish:) object:block];
        [self performSelector:@selector(sysDataFinish:) withObject:block afterDelay:withTime];
        _isSysFinish = YES;
    }
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}


- (void)sysDataFinish:(NSObjectSimpleBlock)block
{
    _isSysFinish = NO;
    
    _stepArray = [[NSMutableArray alloc] init];
    _sleepArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *sportArray = [[NSMutableArray alloc] init];
    
    for (int i =0; i < 288; i ++)
    {
        [sportArray addObject:@"10"];
    }
    
    NSDate *nowdata = [NSDate date];
    //    NSLog(@"nowdata>>>>%@",nowdata);
    
    NSInteger index = (nowdata.hour *60 + nowdata.minute) /5 ;
    
    //    NSLog(@"minIndex>>>%d",index);
    
    //    NSDate *date = [dateFormatter dateFromString:dateString];
    //
    //    NSLog(@"nowDate>>>>%@",date);
    //    NSInteger min = date.minute;
    //    NSLog(@"min>>>>%d",min);
    
    for (int i = 0 ; i < 96; i ++)
    {
        int value = arc4random() %100;
        
        [_stepArray addObject:@(value)];
        
    }
    
    // 构造睡眠状态
    
    for (int i = 0; i< 288; i++)
    {
        if (i < 2)
        {
            [_sleepArray addObject:@"9999"];
        }
        else if (i <= 1 *4*3 +2)
        {
            [_sleepArray addObject:@"5"];
        }
        else if (i <= 4 *4*3 +2)
        {
            [_sleepArray addObject:@"15"];
        }
        else if (i <= 5 *4*3 +2)
        {
            [_sleepArray addObject:@"40"];
        }
        else if (i <= 8 *4*3 +2)
        {
            [_sleepArray addObject:@"5" ];
        }
        
        else
        {
            [_sleepArray addObject:@"9999"];
        }
    }
    
    //    NSLog(@"_stepArray.count:>%d %@",_stepArray.count,_stepArray);
    
    //    [PedometerModel ]
    //      [PedometerModel pedometerModelSaveDataToDB];
    
    if (block)
    {
        block(@"yes");
    }
}

- (NSDate *)nowData
{
    NSDate *nowdata = [self getNowDateFromatAnDate:[NSDate date]];
    return nowdata;
}

@end
