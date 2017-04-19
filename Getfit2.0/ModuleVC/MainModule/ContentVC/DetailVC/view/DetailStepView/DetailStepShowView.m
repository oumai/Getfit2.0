//
//  DetailStepView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/23.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DetailStepShowView.h"

@implementation DetailStepShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadBackGroundImageView]; // 背景
        [self loadLabel];
        
        _stepOrSleep = YES;
        _selectType = 1;
        
        [self loadBottomControl];       // 底部数据显示控件
        [self loadMainView];
        [self loadSwitchButton];        // 中间 步数/睡眠切换
        
        
    }
    return self;
}

- (void)loadBackGroundImageView
{
    _backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _backGroundImageView.image = UIImageNamedF(@"bg_day_5s");
    [self addSubview:_backGroundImageView];
}

- (void)loadMainView
{
    CGFloat  height = FitScreenNumber(0, 0, 0, 0, 0);
    _detailScrollView = [[DetailScrollView alloc] initWithFrame:CGRectMake(0, 0 - height, self.width, self.height)];
    [self addSubview: _detailScrollView];
}

// 步数睡眠切换
- (void)loadSwitchButton
{
    CGFloat offsetY = FitScreenNumber(242, 250 + 50, 250 + 75, 250 + 75, 250 + 75);

    _stepButton = [[UIButton alloc ] initWithFrame:CGRectMake(Maxwidth/2-70, offsetY, 44, 44)];
    _stepButton.bgImageNormal = @"details_btn_sport_2_5s@2x.png";
    _stepButton.bgImageSelecte = @"details_btn_sport_5s@2x.png";
    _stepButton.selected = YES;
    [_stepButton addTarget:self action:@selector(stepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_stepButton];
    
    _sleepButton = [[UIButton alloc ] initWithFrame:CGRectMake(Maxwidth/2+23, offsetY, 44, 44)];
    _sleepButton.bgImageNormal = @"details_btn_sleep_5s@2x.png";
    _sleepButton.bgImageSelecte = @"details_btn_sleep_2_5s@2x.png";
    [_sleepButton addTarget:self action:@selector(sleepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sleepButton];
    _stepOrSleep = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatDetailViewLabel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDetailViewDate" object:nil];
}

- (void)loadLabel
{
    CGFloat offsetY = FitScreenNumber(0 + 30, 0 + 40, 0 + 40, 0 + 40, 0 + 40);

    _showDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(Maxwidth/2-60, offsetY, 120, 35)];
    _showDateLabel.textColor = [UIColor whiteColor];
    _showDateLabel.textAlignment = NSTextAlignmentCenter;
    _showDateLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview: _showDateLabel];
    _showDateLabel.text  =@"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatViewLabel:)
                                                 name:@"updatDetailViewLabel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDetailViewDateLabel:)
                                                 name:@"updateDetailViewDate" object:nil];
    
    offsetY = FitScreenNumber(210 + 10, 210 + 50, 210 + 75, 210 + 75, 210 + 75);
    _labelArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 12; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5 + i * ((Maxwidth - 20)/11) , offsetY , Maxwidth, 35)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"";
        [_labelArray addObject:label];
        [self addSubview:label];
    }
    
////  _showButtonDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 195 + 75 , Maxwidth, 35)];
//    _showButtonDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 195 + 75 + height , Maxwidth, 35)];
//    _showButtonDateLabel.adjustsFontSizeToFitWidth = YES;
//    _showButtonDateLabel.textColor = [UIColor whiteColor];
//    _showButtonDateLabel.textAlignment = NSTextAlignmentLeft;
//    _showButtonDateLabel.font = [UIFont systemFontOfSize:12];
//    _showButtonDateLabel.text = @"";
//    [self addSubview: _showButtonDateLabel];
    
 
    ///////日期label   4个
    _firstDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, offsetY, 15, 35)];
    _firstDayLabel.textColor = [UIColor whiteColor];
    _firstDayLabel.textAlignment = NSTextAlignmentLeft;
    _firstDayLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_firstDayLabel];
    
    _seventDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(Maxwidth, offsetY, 15, 35)];
    _seventDayLabel.textColor = [UIColor whiteColor];
    _seventDayLabel.textAlignment = NSTextAlignmentLeft;
    _seventDayLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_seventDayLabel];
    
    _midDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, offsetY, 15, 35)];
    _midDayLabel.textColor = [UIColor whiteColor];
    _midDayLabel.textAlignment = NSTextAlignmentLeft;
    _midDayLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_midDayLabel];
    
    _twentyTDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(Maxwidth, offsetY, 15, 35)];
    _twentyTDayLabel.textColor = [UIColor whiteColor];
    _twentyTDayLabel.textAlignment = NSTextAlignmentLeft;
    _twentyTDayLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_twentyTDayLabel];
    
    _lastDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(Maxwidth, offsetY, 15, 35)];
    _lastDayLabel.textColor = [UIColor whiteColor];
    _lastDayLabel.textAlignment = NSTextAlignmentCenter;
    _lastDayLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_lastDayLabel];
    
    offsetY = FitScreenNumber(5 + 35, 5 + 50, 5 + 75, 5 + 75, 5 + 75);

    _deepsleepMark = [[UIImageView alloc] initWithFrame:CGRectMake(Maxwidth - 60, offsetY, 40, 40)];
    [self addSubview:_deepsleepMark];
    _sleepMark =[[UIImageView alloc] initWithFrame:CGRectMake(Maxwidth - 120, offsetY, 40, 40)];
    [self addSubview:_sleepMark];
    _deepsleepLabel = [[UILabel alloc] initWithFrame:CGRectMake(Maxwidth - 40, offsetY, 60, 40)];
    _deepsleepLabel.textColor = [UIColor whiteColor];
    _deepsleepLabel.textAlignment = NSTextAlignmentCenter;
    _deepsleepLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_deepsleepLabel];
    _sleepLabel = [[UILabel alloc] initWithFrame:CGRectMake(Maxwidth - 100, offsetY , 60, 40)];
    _sleepLabel.textColor = [UIColor whiteColor];
    _sleepLabel.textAlignment = NSTextAlignmentCenter;
    _sleepLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_sleepLabel];
}

- (void)updatViewLabel:(NSNotification *)info
{
    NSLog(@"date>>>>>%@",[info object]); 
//    _showDateLabel.text = [NSString stringWithFormat:@"%@",[info object]];
}

- (void)updatViewLabel2:(NSNotification *)info
{
    NSLog(@"date2>>>>>%@",[info object]);
    _showButtonDateLabel.text = [NSString stringWithFormat:@"%@",[info object]];
}

- (void)stepButtonClick:(UIButton*)sender
{
    _stepOrSleep = YES;
    [_detailScrollView updateViewIndex];
    _stepButton.selected = YES;
    _sleepButton.selected = NO;
    [_detailScrollView showStepOrSleepView:YES];
    _backGroundImageView.image = UIImageNamedF(@"bg_day_5s");
    [self detailUpdateShowLabel];
}

- (void)sleepButtonClick:(UIButton *)sender
{
    _stepOrSleep = NO;
    [_detailScrollView updateViewIndex];
    _stepButton.selected = NO;
    _sleepButton.selected = YES;
    [_detailScrollView showStepOrSleepView:NO];
    _backGroundImageView.image = UIImageNamedF(@"bg_night_5s");
    [self detailUpdateShowLabel];
}

// 底部控件
- (void)loadBottomControl
{
    // FitScreenNumber(40, 0, -99, -168, 0);
    CGFloat height=  FitScreenNumber(30, 0, 0, 0, 0);
    UIView *backgroundView = [[UIView alloc] initWithFrame:FitScreenRect(CGRectMake(0, self.height - 199, self.width, 199),
                                                                         CGRectMake(0, 375, self.width, 199),
                                                                         CGRectMake(0, self.height - 229, self.width, 229),
                                                                         CGRectMake(0, self.height - 229, self.width, 229),
                                                                         CGRectMake(0, self.height - 199, self.width, 199))];
    backgroundView.backgroundColor = UIColorHEX(0x262626);
    [self addSubview:backgroundView];
    
    // UIView *blackView = [[UIView alloc] initWithFrame:FitScreenRect(CGRectMake(0, 375 - height, self.width,199 - height), CGRectMake(0, 375, self.width,199), CGRectMake(0, self.height - 229, self.width,229), CGRectMake(0, self.height - 229, self.width,229), CGRectMake(0, self.height - 199, self.width,199))];
    
    _label1 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(0, 18, Maxwidth/3, 20)];
    [backgroundView addSubview:_label1];
    
    _label2 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(Maxwidth/3, 18, Maxwidth/3, 20)];
    [backgroundView addSubview:_label2];
    
    _label3 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(Maxwidth*2/3, 18, Maxwidth/3, 20)];
    [backgroundView addSubview:_label3];
    
    _label4 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(0 , 70, Maxwidth/3, 20)];
    [backgroundView addSubview:_label4];
    
    _label5 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(Maxwidth/3 , 70, Maxwidth/3, 20)];
    [backgroundView addSubview:_label5];
    
    _label6 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(Maxwidth*2/3 , 70, Maxwidth/3, 20)];
    [backgroundView addSubview:_label6];
    
    _showLabel1 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(0, 18 + 27, Maxwidth/3, 20)];
    _showLabel1.textColor = BGCOLOR;
    [backgroundView addSubview:_showLabel1];
    
    _showLabel2 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(Maxwidth/3, 18 + 27, Maxwidth/3, 20)];
    _showLabel2.textColor = BGCOLOR;
    [backgroundView addSubview:_showLabel2];
    
    _showLabel3 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(Maxwidth*2/3, 18 + 27, Maxwidth/3, 20)];
    _showLabel3.textColor = BGCOLOR;
    [backgroundView addSubview:_showLabel3];
    
    _showLabel4 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(0, 70 + 27, Maxwidth/3, 20)];
    _showLabel4.textColor = BGCOLOR;
    [backgroundView addSubview:_showLabel4];
    
    _showLabel5 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(Maxwidth/3, 70 + 27, Maxwidth/3, 20)];
    _showLabel5.textColor = BGCOLOR;
    [backgroundView addSubview:_showLabel5];
    
    _showLabel6 = [[DetailShowLabel alloc] initWithFrame:CGRectMake(Maxwidth*2/3, 70 + 27, Maxwidth/3, 20)];
    _showLabel6.textColor = BGCOLOR;
    [backgroundView addSubview:_showLabel6];
    
    
    [self detailUpdateShowLabel];
}

- (void)updateDetailViewDateLabel:(NSNotification *)info
{
    CGFloat  height = FitScreenNumber(0, 20, 30, 40, 0);
    CGFloat offsetY = FitScreenNumber(210 + 10, 210 + 50, 210 + 75, 210 + 75, 210 + 75);
    NSLog(@"_stepOrSleep>>>>%i",_stepOrSleep);
    _showButtonDateLabel.text = @"";
    _showDateLabel.text = @"";
    
    int userheight = [UserInfoHelper sharedInstance].userModel.showHeight.intValue;
    
    if (_selectType == 1)
    {
        WeekModel *weekModel = [info object];
//        NSLog(@"weeksDict>>>>>%@",weekModel.weeksDict);
        
        _showDateLabel.text = [NSString stringWithFormat:@"%@",weekModel.showDates];
        _showButtonDateLabel.adjustsFontSizeToFitWidth = YES;
        NSArray *arr = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
        int i = 0;
        for (UILabel *label in _labelArray) {
            
            label.frame = CGRectMake(5 + i * ((Maxwidth - 30)/6) , offsetY , Maxwidth, 35);
            if (i<=6) {
                label.text = KK_Text(arr[i]);
            }else if (i > 6) {
                label.text = @"";
            }
            
            i++;
        }
        _lastDayLabel.text = @"";
        _firstDayLabel.text = @"";
        _seventDayLabel.text = @"";
        _midDayLabel.text = @"";
        _twentyTDayLabel.text = @"";
        
        if (_stepOrSleep) {
            _showLabel1.text = [NSString stringWithFormat:@"%.2f%@", 1.0*userheight *0.45 *weekModel.weekTotalSteps *0.01 /1000,
                                KK_Text(@"KM")];
            _showLabel2.text = [NSString stringWithFormat:@"%ld%@",weekModel.weekTotalSteps, KK_Text(@"Step")];
            _showLabel3.text = [NSString stringWithFormat:@"%.3f%@",1.0 *weekModel.weekTotalCalories/1000, KK_Text(@"kCal")];
            _showLabel4.text = [NSString stringWithFormat:@"%.2f%@",1.0*userheight *0.45 *weekModel.dailySteps*0.01/1000, KK_Text(@"KM")];
            _showLabel5.text = [NSString stringWithFormat:@"%ld%@",weekModel.dailySteps, KK_Text(@"Step")];
            _showLabel6.text = [NSString stringWithFormat:@"%.3f%@",1.0*weekModel.dailyCalories/1000, KK_Text(@"kCal")];
            
            if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
                

                //英里
                _showLabel1.text = [NSString stringWithFormat:@"%.2f%@", 0.6214*1.0*userheight *0.45 *weekModel.weekTotalSteps *0.01 /1000,
                                    KK_Text(@"MI")];
                _showLabel4.text = [NSString stringWithFormat:@"%.2f%@",0.6214*1.0*userheight *0.45 *weekModel.dailySteps*0.01/1000, KK_Text(@"MI")];
                
            } else {
                //公里
                _showLabel1.text = [NSString stringWithFormat:@"%.2f%@", 1.0*userheight *0.45 *weekModel.weekTotalSteps *0.01 /1000,
                                    KK_Text(@"KM")];
                _showLabel4.text = [NSString stringWithFormat:@"%.2f%@",1.0*userheight *0.45 *weekModel.dailySteps*0.01/1000, KK_Text(@"KM")];
                
            }

            

        } else {
            _showLabel1.text = [self ShowSleepTime:weekModel.dailySleep showType:YES];
            _showLabel2.text = [self ShowSleepTime:weekModel.dailyDeepSleep showType:YES];
            _showLabel3.text = [self ShowSleepTime:weekModel.dailyShallowSleep showType:YES];
            _showLabel4.text = [self ShowSleepTime:weekModel.dailyStartSleep showType:NO];
            _showLabel5.text = [self ShowSleepTime:weekModel.dailyEndSleep showType:NO];
            _showLabel6.text = [self ShowSleepTime:weekModel.dailyWakingSleep showType:YES];
        }
    }
    else if (_selectType == 2)
    {
        MonthModel *monthModel = [info object];
        _showDateLabel.text = [NSString stringWithFormat:@"%ld/1-%ld/%ld",monthModel.monthNumber,monthModel.monthNumber,monthModel.daysCount];
        _showButtonDateLabel.text = [NSString stringWithFormat:@""];
        _firstDayLabel.text = @"1";
        for (UILabel *label in _labelArray) {
            label.text = @"";
        }

        ////4个日期label frame 更新
        CGFloat step = ([UIScreen mainScreen].bounds.size.width)/(monthModel.daysCount + 2);
        CGRect tempRect = _firstDayLabel.frame;
        tempRect.origin.x = step;
        _firstDayLabel.frame = tempRect;
        _firstDayLabel.text = @"1";
       
        tempRect.origin.x = 7 * step;
        _seventDayLabel.frame = tempRect;
        _seventDayLabel.text = [NSString stringWithFormat:@"%d",7];
    
        
        tempRect.origin.x = 15 * step;
        _midDayLabel.frame = tempRect;
        _midDayLabel.text = [NSString stringWithFormat:@"%d",15];
   
        tempRect.origin.x = 22 * step;
        _twentyTDayLabel.frame = tempRect;
        _twentyTDayLabel.text = [NSString stringWithFormat:@"%d",22];
        
        
        tempRect.origin.x = monthModel.daysCount * step;
        _lastDayLabel.frame = tempRect;
        _lastDayLabel.text = [NSString stringWithFormat:@"%ld",monthModel.daysCount];
        
        if (_stepOrSleep)
        {
            _showLabel1.text = [NSString stringWithFormat:@"%.2f%@", 1.0*userheight *0.45 *monthModel.monthTotalSteps *0.01 /1000,
                                KK_Text(@"KM")];
            _showLabel2.text = [NSString stringWithFormat:@"%ld%@",monthModel.monthTotalSteps, KK_Text(@"Step")];
            _showLabel3.text = [NSString stringWithFormat:@"%.3f%@",1.0 *monthModel.monthTotalCalories/1000, KK_Text(@"kCal")];
            _showLabel4.text = [NSString stringWithFormat:@"%.2f%@",1.0*userheight *0.45 *monthModel.dailySteps*0.01/1000, KK_Text(@"KM")];
            _showLabel5.text = [NSString stringWithFormat:@"%ld%@",monthModel.dailySteps, KK_Text(@"Step")];
            _showLabel6.text = [NSString stringWithFormat:@"%.3f%@",1.0*monthModel.dailyCalories/1000, KK_Text(@"kCal")];
            
            if(![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
                _showLabel1.text = [NSString stringWithFormat:@"%.2f%@",0.6213712 * 1.0 *monthModel.monthTotalDistance / 1000, KK_Text(@"MI")];
                _showLabel4.text = [NSString stringWithFormat:@"%.2f%@",0.6213712 * 1.0 *monthModel.dailyDistance / 1000, KK_Text(@"MI")];
            }
        }
        else
        {
            _showLabel1.text = [self ShowSleepTime:monthModel.dailySleep showType:YES];
            _showLabel2.text = [self ShowSleepTime:monthModel.dailyDeepSleep showType:YES];
            _showLabel3.text = [self ShowSleepTime:monthModel.dailyShallowSleep showType:YES];
            _showLabel4.text = [self ShowSleepTime:monthModel.dailyStartSleep showType:NO];
            _showLabel5.text = [self ShowSleepTime:monthModel.dailyEndSleep showType:NO];
            _showLabel6.text = [self ShowSleepTime:monthModel.dailyWakingSleep showType:YES];
        }
    }
    else
    {
        YearModel *yearModel = [info object];
        _showDateLabel.text = [NSString stringWithFormat:@"%ld",yearModel.yearNumber];
        int i = 0;
        for (UILabel *label in _labelArray) {
            label.frame = CGRectMake(5 + i * ((Maxwidth - 20)/11), offsetY, Maxwidth, 35);
            label.text = [NSString stringWithFormat:@"%d",i+1];
            i++;
        }
        _lastDayLabel.text = @"";
        _firstDayLabel.text = @"";
        
        _seventDayLabel.text = @"";
        _midDayLabel.text = @"";
        _twentyTDayLabel.text = @"";
        if (_stepOrSleep)
        {
            _showLabel1.text = [NSString stringWithFormat:@"%.2f%@", 1.0*userheight *0.45 *yearModel.yearTotalSteps *0.01 /1000,KK_Text(@"KM")];
            _showLabel2.text = [NSString stringWithFormat:@"%ld%@",yearModel.yearTotalSteps, KK_Text(@"Step")];
            _showLabel3.text = [NSString stringWithFormat:@"%.3f%@",1.0 *yearModel.yearTotalCalories/1000, KK_Text(@"kCal")];
            _showLabel4.text = [NSString stringWithFormat:@"%.2f%@",1.0*userheight *0.45 *yearModel.dailySteps*0.01/1000, KK_Text(@"KM")];
            _showLabel5.text = [NSString stringWithFormat:@"%ld%@",yearModel.dailySteps, KK_Text(@"Step")];
            _showLabel6.text = [NSString stringWithFormat:@"%.3f%@",1.0*yearModel.dailyCalories/1000, KK_Text(@"kCal")];
            
            if(![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
                _showLabel1.text = [NSString stringWithFormat:@"%.2f%@",0.6213712 * 1.0 *yearModel.yearTotalDistance / 1000, KK_Text(@"MI")];
                _showLabel4.text = [NSString stringWithFormat:@"%.2f%@",0.6213712 * 1.0 *yearModel.dailyDistance / 1000, KK_Text(@"MI")];
            }
        }
        else
        {
            _showLabel1.text = [self ShowSleepTime:yearModel.dailySleep showType:YES];
            _showLabel2.text = [self ShowSleepTime:yearModel.dailyDeepSleep showType:YES];
            _showLabel3.text = [self ShowSleepTime:yearModel.dailyShallowSleep showType:YES];
            _showLabel4.text = [self ShowSleepTime:yearModel.dailyStartSleep showType:NO];
            _showLabel5.text = [self ShowSleepTime:yearModel.dailyEndSleep showType:NO];
            _showLabel6.text = [self ShowSleepTime:yearModel.dailyWakingSleep showType:YES];
        }
    }
    
    [self detailUpdateShowLabel];
}

- (NSString *)ShowSleepTime:(NSInteger)SleepValue showType:(BOOL)type
{
    if (type)
    {
        if (SleepValue >=60)
        {
            NSString *hourStr = KK_Text(@"H");
            NSString *minus = KK_Text(@"Min");
            return  [NSString stringWithFormat:@"%ld%@%ld%@",SleepValue/60,hourStr,SleepValue % 60,minus];
        }
        else
            return [NSString stringWithFormat:@"%ld%@", SleepValue % 60, KK_Text(@"Min")];
    }else
    {
        if (SleepValue >=60)
        {
            return  [NSString stringWithFormat:@"%02ld:%02ld",SleepValue/60,SleepValue % 60];
        }
        else
            return [NSString stringWithFormat:@"%ld%@",SleepValue % 60, KK_Text(@"Min")];
    }
}


- (void)setSelectType:(NSInteger)selectType
{
    _selectType = selectType;  //切换模式
}

//刷新底部控件 单位
- (void)detailUpdateShowLabel
{
    if (_stepOrSleep)
    {
        _deepsleepMark.image = [UIImage image:@""];
        _sleepMark.image = [UIImage image:@""];
        _deepsleepLabel.text = @"";
        _sleepLabel.text = @"";
        if (_selectType == 1)
        {
            _label1.text = KK_Text(@"Week Distance");
            _label2.text = KK_Text(@"Week Steps");
            _label3.text = KK_Text(@"Week Calories");
            
            _label4.text = KK_Text(@"Average Distance");
            _label5.text = KK_Text(@"Average Steps");
            _label6.text = KK_Text(@"Average Calories") ;
        }
        else if(_selectType ==2)
        {
            _label1.text = KK_Text(@"Month Distance");
            _label2.text = KK_Text(@"Month Steps");
            _label3.text = KK_Text(@"Month Calories");
            
            _label4.text = KK_Text(@"Average Distance");
            _label5.text = KK_Text(@"Average Steps");
            _label6.text = KK_Text(@"Average Calories") ;
        }
        else
        {
            _label1.text = KK_Text(@"Year Distance");
            _label2.text = KK_Text(@"Year Steps");
            _label3.text = KK_Text(@"Year Calories");
            
            _label4.text = KK_Text(@"Average Distance");
            _label5.text = KK_Text(@"Average Steps");
            _label6.text = KK_Text(@"Average Calories") ;
        }

    }
    else
    {
        _deepsleepMark.image = [UIImage image:@"details_round_week2_violet5@2x"];
        _sleepMark.image = [UIImage image:@"details_round_week2_night5@2x"];
        _deepsleepLabel.text = KK_Text(@"Deep");
        _sleepLabel.text = KK_Text(@"Total");
        _label1.text = KK_Text(@"Average Sleep");
        _label2.text = KK_Text(@"Average Deep");
        _label3.text = KK_Text(@"Average Light");
        
        _label4.text = KK_Text(@"Start Time");
        _label5.text = KK_Text(@"End Time");
        _label6.text = KK_Text(@"Awake Time");
    }
}

@end
