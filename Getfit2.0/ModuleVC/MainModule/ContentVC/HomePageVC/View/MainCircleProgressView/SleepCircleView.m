//
//  SleepCircleView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/9.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "SleepCircleView.h"

@implementation SleepCircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadSleepCircleView];
        
    }
    
    return self;
}

- (void)loadSleepCircleView
{
    self.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];

    // 睡眠总时间
    _sleepTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    _sleepTimeLabel.text = @" 0     00";
    _sleepTimeLabel.textAlignment = NSTextAlignmentCenter;
    _sleepTimeLabel.textColor = [UIColor whiteColor];
    _sleepTimeLabel.center = CGPointMake(self.width/2, self.width/2);
    _sleepTimeLabel.font = DEFAULT_FONTsize(40);
    [self addSubview:_sleepTimeLabel];
    
    // 睡眠单位
    _sleepTimeUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
//    _sleepTimeUnitLabel.text = @"时         分";
    _sleepTimeUnitLabel.textAlignment = NSTextAlignmentCenter;
    _sleepTimeUnitLabel.textColor = [UIColor whiteColor];
    _sleepTimeUnitLabel.center = CGPointMake(self.width/2  + 35, self.width/2 + 5);
    _sleepTimeUnitLabel.font = DEFAULT_FONTsize(27);
    [self addSubview:_sleepTimeUnitLabel];
    
    // 入睡时间
    _sleepBeginTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
    _sleepBeginTime.text = [NSString stringWithFormat:@"%@ : 0", KK_Text(@"Sleep Start Time")];
    _sleepBeginTime.textAlignment = NSTextAlignmentCenter;
    _sleepBeginTime.textColor = [UIColor whiteColor];
    _sleepBeginTime.center = CGPointMake(self.width/2, self.width/2 + 45);
    _sleepBeginTime.font = DEFAULT_FONTsize(12);
//    [self addSubview:_sleepBeginTime];
    
    // 醒来时间
    _sleepEndTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
    _sleepEndTime.text = [NSString stringWithFormat:@"%@ : 0", KK_Text(@"Sleep End Time")];
    _sleepEndTime.textAlignment = NSTextAlignmentCenter;
    _sleepEndTime.textColor = [UIColor whiteColor];
    _sleepEndTime.center = CGPointMake(self.width/2, self.width/2 + 65);
    _sleepEndTime.font = DEFAULT_FONTsize(12);
//    [self addSubview:_sleepEndTime];
    
    _moonView = [[SleepMoonView alloc] initWithFrame:CGRectMake(self.width /2 - 14, 30, 44, 44)];
    [self addSubview:_moonView];
    
}

- (void)updateViewsWithModel:(PedometerModel *)model
{
    _model = model;
    
    [self LoadData];
}

- (void)LoadData
{
//    _sleepTimeLabel.text = [NSString stringWithFormat:@"  %d时%d分 ",13,15];
    NSInteger yesTerdayTime = [self getYesterdaySleepTime];
    _sleepTimeLabel.text = [NSString stringWithFormat:@"  %02ld : %02ld ", (_model.sleepTotalTime+yesTerdayTime)/60, (_model.sleepTotalTime+yesTerdayTime) %60];
    NSInteger startTime = [self getStartTime];
    _sleepBeginTime.text = [NSString stringWithFormat:@"%@ : %ld:%02ld", KK_Text(@"Sleep Start Time"), startTime/60,startTime %60];
    _sleepEndTime.text = [NSString stringWithFormat:@"%@ : %ld:%02ld", KK_Text(@"Sleep End Time"), _model.sleepEndTime/60,_model.sleepEndTime%60];
}

- (NSInteger)getStartTime
{
    
    NSDate *date = [@"chooseDate" getObjectValue];
    NSDate *yesdate = [@"lastDate" getObjectValue];
    PedometerModel *todayModel = [PedometerHelper getModelFromDBWithDate:date];
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:yesdate];
    NSInteger index = 0;
    
    for (NSInteger i = 0; i < todayModel.sleepArray.count; i ++)
    {
        int value = [[[todayModel.sleepArray objectAtIndex:i] objectAtIndex:1] intValue];
        
        if (value < 9999)
        {
            index =  i * 5;
            break;
        }
    }
    
    for (NSInteger i = 0; i < yesModel.yesterdayArray.count; i ++)
    {
        int value = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];
        
        if (value < 9999)
        {
            index =  (i+216) * 5;
            break;
        }
    }
    
    
    return index ;
}
- (NSInteger)getYesterdaySleepTime
{
    NSDate *yesdate = [@"lastDate" getObjectValue];
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:yesdate];
    NSInteger deepTime = 0;
    
    for (NSInteger i = 0; i < yesModel.yesterdayArray.count; i ++)
    {
        int value = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];

        if (value != 9999 )
        {
            if (value<=30) {
                deepTime += 5;
  
            }
        }
    }
    return deepTime;
}
@end
