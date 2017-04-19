//
//  HomeSleepView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/24.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "HomeSleepView.h"
@implementation HomeSleepView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    
    if (self)
    {
        [self loadSleepView];
    }
    
    return self;
}

- (void)loadSleepView
{
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _backgroundView.image = UIImageNamedNoCache(@"bg_night_5s.png");
    [self addSubview:_backgroundView];  //不需要设置背景
    
    CGFloat height=  FitScreenNumber(30, 0, 0, 0, 0);
//    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 375, self.width,199)];
    UIView *blackView = [[UIView alloc] initWithFrame:FitScreenRect(CGRectMake(0, 375 - height, self.width,199 - height),
                                                                    CGRectMake(0, 375, self.width,199),
                                                                    CGRectMake(0, self.height - 229, self.width,229),
                                                                    CGRectMake(0, self.height - 229, self.width,229),
                                                                    CGRectMake(0, self.height - 199, self.width,199))];
    blackView.backgroundColor = [UIColor clearColor];
    [self addSubview:blackView];
    
    UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 25)/2, 110 -height * 1.4, 25, 8)];
    dot.image = [UIImage imageNamed:@"home_dot_2_5s"];
//    [blackView addSubview:dot];

    
    [self loadLabel];
    [self loadMainView];
}

- (void)loadMainView
{
    CGFloat height=  FitScreenNumber(175, 230, 250, 290, 310);
    _mainView = [[SleepCircleView alloc] initWithFrame:CGRectMake(0, 0, 468 / 2, 468 / 2)];
    _mainView.layer.cornerRadius = 468 / 4;
    _mainView.layer.masksToBounds = YES;
    _mainView.center = CGPointMake(self.width/2, height);
    [self addSubview:_mainView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTouch)];
    [_mainView addGestureRecognizer:tap];

    CGFloat offsetY=  FitScreenNumber(80, 110, 120, 140, 150);
    _chatrView = [[VeryFitMainSleepChatView alloc]initWithFrame:CGRectMake(16, offsetY, self.frame.size.width-32, 234)];
    [self addSubview:_chatrView];
    [_chatrView setHidden:YES];
}

// 加载睡眠数据 显示
- (void)loadSleepData
{
    CGFloat offsetY = FitScreenNumber(20, 40, 40, 40, 40);
    if (_finishTargetLabel == nil) {
        _finishTargetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _finishTargetLabel.center = CGPointMake(_chatrView.width/2, offsetY);
        _finishTargetLabel.text = KK_Text(@"8小时20分");
        _finishTargetLabel.textColor = [UIColor whiteColor];
        _finishTargetLabel.font = [UIFont systemFontOfSize:16];
        _finishTargetLabel.textAlignment = NSTextAlignmentCenter;
        [_chatrView addSubview:_finishTargetLabel];
    }
  
    if (_sleepMoonImage == nil) {
        _sleepMoonImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _sleepMoonImage.center = CGPointMake(_chatrView.width/2, offsetY - 22);
        _sleepMoonImage.image = [UIImage imageNamed:@"home_sleep_4_5s"];
        [_chatrView addSubview:_sleepMoonImage];
    }

    if (ISTESTMODEL) {
        _chatrView.sleepLabelArray = [[NSArray alloc]initWithObjects:@"00:00", @"03:00", @"06:00", @"09:00", nil];
    } else {
        //睡眠图表的时间刷新
        NSInteger starttime = [self getStartTime];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSString *startTimeString = [NSString stringWithFormat:@"%02ld:%02ld", starttime / 60,starttime % 60];
        NSString *startEndString = [NSString stringWithFormat:@"%02ld:%02ld", _model.sleepEndTime / 60, _model.sleepEndTime % 60];
        
        [array addObject:startTimeString];
        [array addObject:startEndString];
        [array addObject:@(starttime)];
        [array addObject:@(_model.sleepEndTime)];
        _model.showSleepTimeArray = array;
        
        _chatrView.sleepLabelArray = array.mutableCopy;

        NSInteger yestime = [self getYesterdaySleepTime];
        NSInteger hour = (_model.sleepTotalTime+yestime) / 60;
        NSInteger min = (_model.sleepTotalTime+yestime) - 60 * hour;
        
        _finishTargetLabel.text = [NSString stringWithFormat:@"%ld%@%ld%@", hour, KK_Text(@"Hour"), min, KK_Text(@"Min")];
    }
    _chatrView.veryFitMainSleepDelegate = self;
    [_chatrView updateView:_model.showDetailSleep];//改动部分
    [_chatrView setHidden:NO];
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
- (NSInteger)getYesTerDayDeepSleepTime
{
    NSInteger deepTime = 0;
    NSDate *yesdate = [@"lastDate" getObjectValue];
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:yesdate];

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
    NSDate *yesdate = [@"lastDate" getObjectValue];
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:yesdate];
    
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
    NSDate *yesdate = [@"lastDate" getObjectValue];
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:yesdate];
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


- (void)tapTouch
{
    [self mainViewTouch];
    _mainView.userInteractionEnabled = NO;
    NSDictionary *dic = @{@"isTouch":@"yes",@"obj":self};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tap" object:dic];
}

- (void)mainViewTouch
{
    if (ISTESTMODEL)
    {
        [UIView animateWithDuration:0.0 animations:^{
        }
                         completion:^(BOOL finished) {
                             [self showChartView];
                             _mainView.userInteractionEnabled = YES;
                         }];
    }
    else
    {
        BOOL sleep = NO;
        for (int i =0; i <_model.showDetailSleep.count; i++)
        {
            if ([[[_model.showDetailSleep objectAtIndex:i] objectAtIndex:1] integerValue] < 9999)
            {
                sleep = YES;
                break;
            }
        }
        
        if (!sleep)
        {
            [UIView animateWithDuration:0.0 animations:^{
            }
                             completion:^(BOOL finished) {
                                 [self showNoDataChartView];
                                 _mainView.userInteractionEnabled = YES;
                             }];
        }
        else
        {
            [UIView animateWithDuration:0.0 animations:^{
            }
                             completion:^(BOOL finished) {
                                 [self showChartView];
                                 _mainView.userInteractionEnabled = YES;
                             }];
        }
    }
}

- (void)showChartView
{
    [_mainView setHidden:YES];
    
    [self loadSleepData];
}

- (void)showNoDataChartView
{
    SHOWMBProgressHUD(KK_Text(@"No Data"), nil, nil, NO, 1.0);
}

-(void)dismissView
{
    [_mainView setHidden:NO];
    [_chatrView setHidden:YES];
}

- (void)loadLabel
{
    CGFloat height=  FitScreenNumber(70, 0, -99, -168, 0);
    
    _deepSleepLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 400, 100, 30)];
    _deepSleepLabel.font = [UIFont systemFontOfSize:20.];
    _deepSleepLabel.textColor = [UIColor whiteColor];
    _deepSleepLabel.text = @"0";
    _deepSleepLabel.center = CGPointMake(self.width / 4 - 20, 410 - height);
    _deepSleepLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_deepSleepLabel];
    
    UILabel *deepSleepUnit = [[UILabel alloc] initWithFrame:CGRectMake(55, 400, 80, 30)];
    deepSleepUnit.font = [UIFont systemFontOfSize:12.];
    deepSleepUnit.textColor = [UIColor whiteColor];
    deepSleepUnit.text = KK_Text(@"Deep Sleep");
    deepSleepUnit.center = CGPointMake(self.width / 4 - 20, 440 - height);
    deepSleepUnit.textAlignment = NSTextAlignmentCenter;
    [self addSubview:deepSleepUnit];
    
    UIView *deepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    deepView.backgroundColor = UIColorHEX(0x666666);
    deepView.center = CGPointMake(self.width / 4 - 65, 440 - height);
    [self addSubview:deepView];
    
    _shallowLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 400, 100, 30)];
    _shallowLabel.font = [UIFont systemFontOfSize:20.];
    _shallowLabel.textColor = [UIColor whiteColor];
    _shallowLabel.text = @"0";
    _shallowLabel.center = CGPointMake(self.width / 2, 410 - height);
    _shallowLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_shallowLabel];
    
    UILabel *shallowUnit = [[UILabel alloc] initWithFrame:CGRectMake(55, 400, 80, 30)];
    shallowUnit.font = [UIFont systemFontOfSize:12.];
    shallowUnit.textColor = [UIColor whiteColor];
    shallowUnit.text = KK_Text(@"Light Sleep");
    shallowUnit.center = CGPointMake(self.width / 2, 440 - height);
    shallowUnit.textAlignment = NSTextAlignmentCenter;
    [self addSubview:shallowUnit];
    
    UIView *shallowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    shallowView.backgroundColor = UIColorHEX(0x999999);
    shallowView.center = CGPointMake(self.width / 2 - 45, 440 - height);
    [self addSubview:shallowView];
    
    _soberLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 400, 100, 30)];
    _soberLabel.font = [UIFont systemFontOfSize:20.];
    _soberLabel.textColor = [UIColor whiteColor];
    _soberLabel.text = @"0";
    _soberLabel.center = CGPointMake(self.width / 4 * 3 + 20, 410 - height);
    _soberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_soberLabel];
    
    UILabel *soberUnit = [[UILabel alloc] initWithFrame:CGRectMake(55, 400, 80, 30)];
    soberUnit.font = [UIFont systemFontOfSize:12.];
    soberUnit.textColor = [UIColor whiteColor];
    soberUnit.text = KK_Text(@"Awake Sleep");
    soberUnit.center = CGPointMake(self.width / 4 * 3 + 20, 440 - height);
    soberUnit.textAlignment = NSTextAlignmentCenter;
    [self addSubview:soberUnit];
    
    UIView *soberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    soberView.backgroundColor = UIColorHEX(0xffffff);
    soberView.center = CGPointMake(self.width / 3 * 2, 440 - height);
    [self addSubview:soberView];
    
}

- (void)updateDataHomeSleep
{
//    NSLog(@"Sleep>>>>>%@",_model);
    [self dismissView];
    NSInteger yesterdeep = [self getYesTerDayDeepSleepTime];
    NSInteger yestershallow = [self getYesTerDayshallowSleepTime];
    NSInteger yesterwaking = [self getYesTerDaywakingTime];

    _deepSleepLabel.text = [NSString stringWithFormat:@"%02ld : %02ld", (_model.deepSleepTime+yesterdeep)/60, (_model.deepSleepTime+yesterdeep)%60];
    _shallowLabel.text = [NSString stringWithFormat:@"%02ld : %02ld", (_model.shallowSleepTime+yestershallow)/60, (_model.shallowSleepTime+yestershallow)%60];
    _soberLabel.text = [NSString stringWithFormat:@"%02ld : %02ld", (_model.wakingTime+yesterwaking)/60, (_model.wakingTime+yesterwaking)%6];
}

//- (void)loadSleepModelData
//{
//    _deepSleepLabel.text = @"180";
//    _shallowLabel.text = @"257";
//    _soberLabel.text = @"15";
//
//}

#pragma mark ---   Func  ---
- (void)updateViewsWithModel:(PedometerModel *)model
{
    _model = model;
    [self updateDataHomeSleep];
    [_mainView updateViewsWithModel:_model];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
