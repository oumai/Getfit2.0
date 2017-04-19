//
//  DetailStepView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DetailStepView.h"
#import "DateTools.h"
#import "DetailShowLabel.h"

@interface DetailStepView ()

@property (nonatomic, strong) CAShapeLayer *fillLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer1;
@property (nonatomic, strong) CAShapeLayer *pathLayer;

@property (nonatomic, strong) CAShapeLayer *sleepFillLayer;
@property (nonatomic, strong) CAGradientLayer *sleepGradientLayer1;
@property (nonatomic, strong) CAShapeLayer *sleepPathLayer;

@property (nonatomic, strong) CAShapeLayer *sleepdDeepPathLayer;

@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation DetailStepView

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
        _offsetY = FitScreenNumber(20, 50, 75, 75, 75);
        [self loadShowView];            //  步数 或者 睡眠
        [self loadPublic];              // 图表控件
        [self loadSleepMark];
    }
    return  self;
}

// 步数或者睡眠显示区域
- (void)loadShowView
{
    _stepView = [[UIView alloc] initWithFrame:CGRectMake(0, _offsetY + 45, Maxwidth, 165)];
//    _stepView.backgroundColor = [UIColor blackColor];
    [self addSubview:_stepView];
    
    _sleepView = [[UIView alloc] initWithFrame:CGRectMake(0, _offsetY + 45, Maxwidth, 165)];
//    _sleepView.backgroundColor = [UIColor blackColor];
    [self addSubview:_sleepView];
    _sleepView.hidden = YES;

}

// 步数跟睡眠切换
- (void)showView:(BOOL)value
{
    _stepOrSleep = value;
    
    if (value)
    {
        _stepView.hidden = NO;
        _sleepView.hidden = YES;
    }
    else
    {
        _stepView.hidden = YES;
        _sleepView.hidden = NO;
    }
    
    if (_chatType == 1)
    {
          [self detailScrollUpdateWeek:_weekForData];
    }
    else if (_chatType == 2)
    {
         [self detailScrollUpdateMonth:_monthForIndex];
    }
    else if(_chatType == 3)
    {
        [self detailScrollUpdateYear:_yearForIndex];
    }
}

- (void)updateLeft
{
    
}

- (void)updateRight
{
    
}

// 根据周表
- (void)detailScrollUpdateWeek:(NSDate *)date
{
    _chatType = 1;
    _weekForData = date;
    _weekModel = [WeekModel getWeekModelFromDBWithDate:date isContinue:NO]; // 获取周数据
    
    BOOL other = NO;
    if (date.month == 12 && date.weekOfYear ==1)
    {
        other = YES;
    }
        NSInteger weekIndex = date.weekOfYear;
    
           if ([[DATAVALUECOUNT getObjectValue]intValue] !=2)
           {
               if (self.tag == 2)
               {
            #warning 崩溃
                   
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updatDetailViewLabel" object:[NSString stringWithFormat:@"%ld",weekIndex]];
                   
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDetailViewDate" object:_weekModel];
            }
           }

    
    if (_stepOrSleep)
    {
        _dataArray = [[NSMutableArray alloc] init];
        if (ISTESTMODEL)
        {
            for ( int i = 0; i < 7; i++)
            {
                [_dataArray addObject: [NSString stringWithFormat:@"%d",arc4random()%10000]];
            }
        }
        else
        {
            
            if (other)
            {
                MonthModel *monthModelValue =[MonthModel getMonthModelFromDBWithMonthIndex:12 isContinue:NO];
                // 27 28 29 30 31

                [_dataArray addObject:[monthModelValue.showDaySteps objectAtIndex:26]];
                [_dataArray addObject:[monthModelValue.showDaySteps objectAtIndex:27]];
                [_dataArray addObject:[monthModelValue.showDaySteps objectAtIndex:28]];
                [_dataArray addObject:[monthModelValue.showDaySteps objectAtIndex:29]];
                [_dataArray addObject:[monthModelValue.showDaySteps objectAtIndex:30]];
                [_dataArray addObject:@(0)];
                [_dataArray addObject:@(0)];
            }
            else
            {
                for (NSString *stepValue in _weekModel.showDaySteps)
                {
                    [_dataArray addObject:stepValue];
                }
            }
            

        }
        _maxValue = [self max:_dataArray];
        _minValue = [self min:_dataArray];
        [self stepHeightList];
    }
    else
    {
        _dataArray = [[NSMutableArray alloc] init];
        _sleepDeepDataArray = [[NSMutableArray alloc] init];
        _sleepShallowDataArray = [[NSMutableArray alloc] init];
        
        if (ISTESTMODEL)
        {
            for ( int i = 0; i < 7; i++)
            {
                [_dataArray addObject: [NSString stringWithFormat:@"%d",arc4random()%720]];
            }
            
            for (NSString * deepValue in _dataArray)
            {
                int value1 = 1.0 *deepValue.intValue / 3;
                int value2 = 1.0 *deepValue.intValue / 5;
                [_sleepDeepDataArray addObject:@(value1)];
                [_sleepShallowDataArray addObject:@(value2)];
            }
        }
        else
        {
            for (NSString *stepValue in _weekModel.showDaySleep)
            {
                [_dataArray addObject:stepValue];
            }
            
            for (NSString *stepValue in _weekModel.showDayDeepSleep)
            {
                [_sleepDeepDataArray addObject:stepValue];
            }
            for (NSString *stepValue in _weekModel.showDayShallowSleep)
            {
                [_sleepShallowDataArray addObject:stepValue];
            }
        }
        
        _maxValue = [self max:_dataArray];
        _minValue = [self min:_dataArray];
        [self sleepDeepHeight];
        [self sleepHeightList];
    }
    
    [self updateTarSize];
}

- (void)updateTarSize
{
    _showStepImageView.hidden = YES;
    NSInteger targetStep = 0;
    int height = 0;
    
    if (_stepOrSleep)
    {
        targetStep = [UserInfoHelper sharedInstance].userModel.targetSteps;
         _targetLabel.text = [NSString stringWithFormat:@"%d",targetStep];
    }
    else
    {
         targetStep = [UserInfoHelper sharedInstance].userModel.targetSleep + 120;
        NSString *hourStr = KK_Text(@"H");
        NSString *minus = KK_Text(@"Min");

         _targetLabel.text = [NSString stringWithFormat:@"%02d%@%02d%@",targetStep/60,hourStr,targetStep%60,minus];
    }
    
    if (_maxValue < targetStep)
    {
        height = 60;
        _maxValue = targetStep * 1.2;
        
    }else
    {
        height = (int)(1.0 * (_maxValue - targetStep) / _maxValue * 150) + 45 ;
    }
    _targetLineView.frame = CGRectMake(0, height + _offsetY, Maxwidth, 1);
    _tagrgetImage.frame  = CGRectMake(2, height - 18 + _offsetY, 17, 17);
    _targetLabel.frame  = CGRectMake(25, height - 18 + _offsetY, 200, 17);
    
    if (_chatType == 3) {
        _targetLabel.text = @"";
        _targetLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage image:@""]];
    }
}

// 更新月表
- (void)detailScrollUpdateMonth:(NSInteger)monthIndex
{
    _monthForIndex = monthIndex;
    _chatType = 2;

    _monthModel = [MonthModel getMonthModelFromDBWithMonthIndex:monthIndex isContinue:NO];
    NSLog(@"%d",[[DATAVALUECOUNT getObjectValue] intValue]);
    if ([[DATAVALUECOUNT getObjectValue] intValue] != 2)
    {
        
        if (self.tag == 2)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updatDetailViewLabel" object:[NSString stringWithFormat:@"%ld",monthIndex]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateDetailViewDate" object:_monthModel];
        }
    }

    if (_stepOrSleep)
    {
        _dataArray = [[NSMutableArray alloc] init];
        
        if (ISTESTMODEL)
        {
            for ( int i = 0; i < 30; i++)
            {
                [_dataArray addObject: [NSString stringWithFormat:@"%d",arc4random()%10000]];
            }
        }
        else
        {
            for (NSString *stepValue in _monthModel.showDaySteps)
            {
                [_dataArray addObject:stepValue];
            }
        }

        
        _maxValue = [self max:_dataArray];
        _minValue = [self min:_dataArray];
        [self stepHeightList];
    }
    else
    {
        _dataArray = [[NSMutableArray alloc] init];
        _sleepDeepDataArray = [[NSMutableArray alloc] init];
        _sleepShallowDataArray = [[NSMutableArray alloc] init];
        
        if (ISTESTMODEL)
        {
            for ( int i = 0; i < 30; i++)
            {
                [_dataArray addObject: [NSString stringWithFormat:@"%d",arc4random()%720]];
            }
            
            for (NSString * deepValue in _dataArray)
            {
                int value1 = 1.0 *deepValue.intValue / 3;
                int value2 = 1.0 *deepValue.intValue / 5;
                [_sleepDeepDataArray addObject:@(value1)];
                [_sleepShallowDataArray addObject:@(value2)];
            }
        }
        else
        {
            for (NSString *stepValue in _monthModel.showDaySleep)
            {
                [_dataArray addObject:stepValue];
            }
            for (NSString *stepValue in _monthModel.showDayDeepSleep)
            {
                [_sleepDeepDataArray addObject:stepValue];
            }
            for (NSString *stepValue in _monthModel.showDayShallowSleep)
            {
                [_sleepShallowDataArray addObject:stepValue];
            }
        }
        
        _maxValue = [self max:_dataArray];
        _minValue = [self min:_dataArray];
        [self sleepDeepHeight];
        [self sleepHeightList];
    }
    
    [self updateTarSize];
}

// 更新年表
- (void)detailScrollUpdateYear:(NSInteger) yearIndex
{
    _chatType = 3;
    _yearForIndex = yearIndex;
    _yearModel = [YearModel getYearModelFromDBWithYearIndex:yearIndex isContinue:NO];

    if ([[DATAVALUECOUNT getObjectValue]intValue] != 2)
    {
        if (self.tag == 2)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updatDetailViewLabel" object:[NSString stringWithFormat:@"%d",yearIndex]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateDetailViewDate" object:_yearModel];

        }
    }
    
    if (_stepOrSleep)
    {
        _dataArray = [[NSMutableArray alloc] init];
        
        if (ISTESTMODEL)
        {
            for ( int i = 0; i < 12; i++)
            {
                [_dataArray addObject: [NSString stringWithFormat:@"%d",arc4random()%10000]];
            }
        }
        else
        {
            for (NSString *stepValue in _yearModel.showMonthSteps)
            {
                [_dataArray addObject:stepValue];
            }
        }
        _maxValue = [self max:_dataArray];
        _minValue = [self min:_dataArray];
        
        [self stepHeightList];
    }
    else
    {
        _dataArray = [[NSMutableArray alloc] init];
        _sleepDeepDataArray = [[NSMutableArray alloc] init];
        _sleepShallowDataArray = [[NSMutableArray alloc] init];
        
        if (ISTESTMODEL)
        {
            for ( int i = 0; i < 7; i++)
            {
                [_dataArray addObject: [NSString stringWithFormat:@"%d",arc4random()%720]];
            }
            
            for (NSString * deepValue in _dataArray)
            {
                int value1 = 1.0 *deepValue.intValue / 3;
                int value2 = 1.0 *deepValue.intValue / 5;
                [_sleepDeepDataArray addObject:@(value1)];
                [_sleepShallowDataArray addObject:@(value2)];
            }
        }
        else
        {
            for (NSString *stepValue in _yearModel.showMonthSleep)
            {
                [_dataArray addObject:stepValue];
            }
            for (NSString *stepValue in _yearModel.showMonthDeepSleep)
            {
                [_sleepDeepDataArray addObject:stepValue];
            }
            for (NSString *stepValue in _yearModel.showMonthShallowSleep)
            {
                [_sleepShallowDataArray addObject:stepValue];
            }
        }
        _maxValue = [self max:_dataArray];
        _minValue = [self min:_dataArray];
        [self sleepDeepHeight];
        [self sleepHeightList];
    }

    [self updateTarSize];
}

- (NSString *)getTimeLabel:(NSDate *)date;
{
    NSDateFormatter  *dateformatter=[NSDate dateFormatterTemp];
    [dateformatter setDateFormat:@"dd-MM-yyyy"];
    NSString *  before=[dateformatter stringFromDate:date];
    return before;
}

- (void)loadPublic
{
    if (!_showStepImageView)
    {
        _showStepImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, + _offsetY, 36, 27)];
        [self addSubview:_showStepImageView];
    }
    
    
    if (!_showStepImageView)
    {
        _showStepImageView.image = UIImageNamed(@"details_capacity_5s@2x.png");
        _showStepImageView.center = CGPointMake(100,100);
        [self addSubview:_showStepImageView];
    }
    
    if (!_showStepLabel)
    {
        _showStepLabel = [[UILabel alloc] initWithFrame:CGRectMake( -5, 0, 50, 20)];
        [_showStepImageView addSubview:_showStepLabel];
        _showStepLabel.numberOfLines = 3;
        _showStepLabel.textAlignment = NSTextAlignmentCenter;
        _showStepLabel.textColor = [UIColor whiteColor];
        _showStepLabel.font =DEFAULT_FONTsize(10);
        _showStepLabel.text = @"";
    }
    
    if (!_targetLineView)
    {
        _targetLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _offsetY + 45, Maxwidth, 1)];
        _targetLineView.backgroundColor = [UIColor colorWithPatternImage:UIImageNamed(@"details_targetline_5@2x.png")];
        [self addSubview:_targetLineView];
    }
    
    // 目标图像
    if (!_tagrgetImage)
    {
        _tagrgetImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0 - 18 + _offsetY + 45, 17, 17)];
        _tagrgetImage.image = UIImageNamed(@"details_cup_5s@2x.png");
        [self addSubview:_tagrgetImage];
    }
    
    if (!_targetLabel)
    {
        _targetLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0 - 18 + _offsetY + 45, 200, 17)];
        _targetLabel.textAlignment = NSTextAlignmentLeft;
        _targetLabel.textColor = [UIColor whiteColor];
        _targetLabel.font =DEFAULT_FONTsize(12);
        [self addSubview:_targetLabel];
    }

        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 195 + _offsetY + 3, Maxwidth, 1)];
        line2.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        [self addSubview:line2];
}

- (void)loadSleepMark {
    _deepsleepMark = [[UIImageView alloc] initWithFrame:CGRectMake(Maxwidth - 200, 100, 10, 10)];
    _sleepMark =[[UIImageView alloc] initWithFrame:CGRectMake(Maxwidth - 300, 100, 10, 10)];
    _deepsleepLabel = [[UILabel alloc] initWithFrame:CGRectMake(Maxwidth - 180, 100, 80, 20)];
    _sleepLabel = [[UILabel alloc] initWithFrame:CGRectMake(Maxwidth - 280, 100, 80, 20)];
}

// 返回对应点高度
- (void)stepHeightList
{
    _heightArray = [[NSMutableArray alloc]init];
    
    for (NSString *value in _dataArray)
    {
        NSInteger i = value.integerValue;
        int height = (int)(1.0 * (_maxValue - i) / _maxValue * 150) ;
//        NSLog(@"%d",height);
        if (height > _maxValue) {
            height = _maxValue;
        }
        [_heightArray addObject:[NSString stringWithFormat:@"%d",height]];
    }
   
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath* fill = [UIBezierPath bezierPath];
    CGFloat scale = 150.0 / _maxValue;
    
    for(int i = 1;i < _dataArray.count;i++)//mark,有多少数据多少个点
    {
        NSNumber *last = _dataArray[i - 1];
        NSNumber *number = _dataArray[i];
        CGPoint p1 = CGPointMake(10 + (i - 1) * ((Maxwidth - 20)/ (_dataArray.count - 1)), 150  - [last floatValue] * scale);
        CGPoint p2 = CGPointMake(10 + i * ((Maxwidth - 20) / (_dataArray.count - 1)), 150   - [number floatValue] * scale);
        [fill moveToPoint:p1];
        [fill addLineToPoint:p2];
        [fill addLineToPoint:CGPointMake(p2.x, 150 )];
        [fill addLineToPoint:CGPointMake(p1.x, 150 )];
    }
    if (!_lineArray)
    {
        _lineArray = [[NSMutableArray alloc] init];
    }
    for (UIView *view in _lineArray)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    for(int i = 0 ;i< _dataArray.count;i++)
    {
        UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake(10 + (i) * ((Maxwidth - 20) / (_dataArray.count - 1)), -5, 0.5, 158)];
        whiteLine.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        [_lineArray addObject:whiteLine];
        [_stepView addSubview:whiteLine];
    }
    
    // 填充区域
    if (!_fillLayer)
    {
        _fillLayer = [CAShapeLayer layer];
        _fillLayer.lineJoin = kCALineJoinRound;
        _fillLayer.strokeColor = nil;
        _fillLayer.fillColor = UIColorHEX(0xef5543).CGColor;
        _fillLayer.lineWidth = 0;
        [_stepView.layer addSublayer:_fillLayer];
    }
        _fillLayer.frame = self.bounds;
        _fillLayer.bounds = self.bounds;
        _fillLayer.path = fill.CGPath;
    
    // 渐变
    if (!_gradientLayer1)
    {
        _gradientLayer1 =  [CAGradientLayer layer];
        [_stepView.layer addSublayer:_gradientLayer1];
    }
        _gradientLayer1.frame = self.bounds;
        [_gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColorHEX(0xef5543)colorWithAlphaComponent:0.4] CGColor], nil]];
        [_gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
        [_gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
        _gradientLayer1.mask = _fillLayer;

    if (!_buttonArray)
    {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    
    for (UIButton *button in _buttonArray)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            [button removeFromSuperview];
        }
    }
    
    for (int i = 0;i < _heightArray.count;i++)
    {
        float heightV = [[_heightArray objectAtIndex:i]floatValue];
        CGPoint px = CGPointMake((i) * ((Maxwidth - 20) / (_dataArray.count - 1)) + 10, heightV);
        if (i == 0)
        {
            [path moveToPoint:px];
        }else
        {
            [path addLineToPoint:px];
        }
        
        UIButton *button = [[UIButton alloc]init];
        
        if (_chatType == 1)
        {
            button.frame = CGRectMake(0, 0, 40, 40);
            button.bgImageNormal = @"details_round_week2_5@2x.png";
            button.bgImageSelecte = @"details_round_week1_5@2x.png";
        }
        else if (_chatType == 2)
        {
            button.frame = CGRectMake(0, 0, 15, 15);
            button.bgImageNormal = @"details_round_month2_5@2x.png";
            button.bgImageSelecte = @"details_round_month1_5@2x.png";
        }
        else if (_chatType == 3)
        {
            button.frame = CGRectMake(0, 0, 30, 30);
            button.bgImageNormal = @"details_round_year2_5@2x.png";
            button.bgImageSelecte = @"details_round_year1_5@2x.png";
        }

        button.center = px;
        button.tag = i;
        button.selected = NO;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_stepView addSubview:button];
        [_buttonArray addObject:button];
    }
    
    if (!_pathLayer)
    {
        _pathLayer = [CAShapeLayer layer];
        _pathLayer.strokeColor = UIColorHEX(0xef5543).CGColor;
        _pathLayer.fillColor = nil;
        _pathLayer.lineWidth = 1;
        _pathLayer.lineJoin = kCALineJoinRound;
        [_stepView.layer addSublayer:_pathLayer];//图表的红色轨迹线
    }
        _pathLayer.frame = self.bounds;
        _pathLayer.bounds = self.bounds;
        _pathLayer.path = path.CGPath;
}

- (void)sleepDeepHeight
{
    _heightArray = [[NSMutableArray alloc]init];

    for (NSString *value in _sleepDeepDataArray)
    {
        NSInteger i = value.integerValue;
        int height = (int)(1.0 * (_maxValue - i) / _maxValue * 150) ;
        [_heightArray addObject:[NSString stringWithFormat:@"%d",height]];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (!_sleepButtonArray)
    {
        _sleepButtonArray = [[NSMutableArray alloc] init];
    }
    
    for (UIButton *button in _sleepButtonArray)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            [button removeFromSuperview];
        }
    }
    
    for (int i = 0;i < _heightArray.count;i++)
    {
        float heightV = [[_heightArray objectAtIndex:i]floatValue];
        CGPoint px = CGPointMake((i) * ((Maxwidth - 20) / (_sleepDeepDataArray.count - 1)) + 10, heightV);
        /////////睡眠线视图
        if (px.y <= 0) {
            px.y = 0;
        }
        if (i == 0)
        {
            [path moveToPoint:px];
        }else
        {
            [path addLineToPoint:px];
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        button.center = px;
        button.tag = i;
        button.bgImageNormal = @"details_round_week2_violet5@2x.png";
        [_sleepView addSubview:button];
        [_sleepButtonArray addObject:button];
    }
    NSLog(@"_heightArray>>>>%@",_heightArray);
    
    if (!_sleepdDeepPathLayer)
    {
        _sleepdDeepPathLayer = [CAShapeLayer layer];
        _sleepdDeepPathLayer.strokeColor = UIColorHEX(0x943bf9).CGColor;
        _sleepdDeepPathLayer.fillColor = nil;
        _sleepdDeepPathLayer.lineWidth = 1;
        _sleepdDeepPathLayer.lineJoin = kCALineJoinRound;
        [_sleepView.layer addSublayer:_sleepdDeepPathLayer];
    }
    _sleepdDeepPathLayer.frame = self.bounds;
    _sleepdDeepPathLayer.bounds = self.bounds;
    _sleepdDeepPathLayer.path = path.CGPath;
}

// 睡眠视图
- (void)sleepHeightList
{
    _heightArray = [[NSMutableArray alloc]init];
    
    for (NSString *value in _dataArray)
    {
        NSInteger i = value.integerValue;
        int height = (int)(1.0 * (_maxValue - i) / _maxValue * 150) ;
        [_heightArray addObject:[NSString stringWithFormat:@"%d",height]];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath* fill = [UIBezierPath bezierPath];
    CGFloat scale = 150.0 / _maxValue;
    
    for(int i = 1;i < _dataArray.count;i++)
    {
        NSNumber *last = _dataArray[i - 1];
        NSNumber *number = _dataArray[i];
        CGPoint p1 = CGPointMake(10 + (i - 1) * ((Maxwidth - 20) / (_dataArray.count - 1)), 150  - [last floatValue] * scale);
        CGPoint p2 = CGPointMake(10 + i * ((Maxwidth - 20) / (_dataArray.count - 1)), 150   - [number floatValue] * scale);
        [fill moveToPoint:p1];
        [fill addLineToPoint:p2];
        [fill addLineToPoint:CGPointMake(p2.x, 150 )];
        [fill addLineToPoint:CGPointMake(p1.x, 150 )];
    }
    if (!_sleepLineArray)
    {
        _sleepLineArray = [[NSMutableArray alloc] init];
    }
    for (UIView *view in _sleepLineArray)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    for(int i = 0 ;i<_dataArray.count;i++)
    {
        UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake((i) * ((Maxwidth - 20) / (_dataArray.count - 1)) + 10, -5, 0.5, 158)];
        whiteLine.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        [_sleepLineArray addObject:whiteLine];
        [_sleepView addSubview:whiteLine];
    }
    
    // 填充区域
    if (!_sleepFillLayer)
    {
        _sleepFillLayer = [CAShapeLayer layer];
        _sleepFillLayer.lineJoin = kCALineJoinRound;
        _sleepFillLayer.strokeColor = nil;
        _sleepFillLayer.fillColor = [UIColor whiteColor].CGColor;
        _sleepFillLayer.lineWidth = 0;
        [_sleepView.layer addSublayer:_sleepFillLayer];
    }
    _sleepFillLayer.frame = self.bounds;
    _sleepFillLayer.bounds = self.bounds;
    _sleepFillLayer.path = fill.CGPath;
    
    // 渐变
    if (!_sleepGradientLayer1)
    {
        _sleepGradientLayer1 =  [CAGradientLayer layer];
        [_sleepView.layer addSublayer:_sleepGradientLayer1];
    }
    _sleepGradientLayer1.frame = self.bounds;
    [_sleepGradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[[UIColor whiteColor]colorWithAlphaComponent:0.2] CGColor], nil]];
    [_sleepGradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [_sleepGradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    _sleepGradientLayer1.mask = _sleepFillLayer;
    
    if (!_sleepButtonClickArray)
    {
        _sleepButtonClickArray = [[NSMutableArray alloc] init];
    }
    
    for (UIButton *button in _sleepButtonClickArray)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            [button removeFromSuperview];
        }
    }
    
    for (int i = 0;i < _heightArray.count;i++)
    {
        float heightV = [[_heightArray objectAtIndex:i]floatValue];
        CGPoint px = CGPointMake((i) * ((Maxwidth - 20) / (_dataArray.count - 1)) + 10, heightV);
        ////睡眠线视图
        if(px.y <= 0) {
            px.y = 0;
        }
        if (i == 0)
        {
            [path moveToPoint:px];
        }else
        {
            [path addLineToPoint:px];
        }
        
        UIButton *button = [[UIButton alloc] init];
        if (_chatType == 1)
        {
            button.frame =CGRectMake(0, 0, 40, 40);
            button.bgImageNormal = @"details_round_week2_night5@2x.png";
            button.bgImageSelecte = @"details_round_week1_night5@2x.png";
        }
        else if (_chatType == 2)
        {
            button.frame =CGRectMake(0, 0, 15, 15);
            button.bgImageNormal = @"details_round_month2_night5@2x.png";
            button.bgImageSelecte = @"details_round_month1_night5@2x.png";
        }
        else
        {
            button.frame =CGRectMake(0, 0, 40, 40);
            button.bgImageNormal = @"details_round_week2_night5@2x.png";
            button.bgImageSelecte = @"details_round_week1_night5@2x.png";
        }
        button.center = px;
        button.tag = i;
        button.selected = NO;
        [button addTarget:self action:@selector(sleepbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sleepView addSubview:button];
        [_sleepButtonClickArray addObject:button];
    }
    
    if (!_sleepPathLayer)
    {
        _sleepPathLayer = [CAShapeLayer layer];
        _sleepPathLayer.strokeColor = [UIColor whiteColor].CGColor;
        _sleepPathLayer.fillColor = nil;
        _sleepPathLayer.lineWidth = 1;
        _sleepPathLayer.lineJoin = kCALineJoinRound;
        [_sleepView.layer addSublayer:_sleepPathLayer];
    }
        _sleepPathLayer.frame = self.bounds;
        _sleepPathLayer.bounds = self.bounds;
        _sleepPathLayer.path = path.CGPath;
}

// 步数 按钮
- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 3)
    {
//        NSLog(@"%f",sender.origin.y);
        if (sender.origin.y < 110)
        {

        }
    }
    for (UIButton *button in _buttonArray)
    {
        button.selected = NO;
    }
    sender.selected = YES;
    
    CGPoint pointCenter = sender.center;
    _showStepImageView.frame = CGRectMake(0, + _offsetY, 36, 27);
    
    _showStepLabel.frame =  CGRectMake( -5, 0, 55, 20);
    _showStepLabel.textAlignment = NSTextAlignmentCenter;

        if (sender.origin.x < 30)
        {
            _showStepImageView.image = UIImageNamed(@"details_popup2_5@2x.png");
            _showStepImageView.center = CGPointMake(pointCenter.x + 20, pointCenter.y - 20 + 120);
        }
        else if (sender.origin.x > 280)
        {
            _showStepImageView.image = UIImageNamed(@"details_popup3_5@2x.png");
            _showStepImageView.center = CGPointMake(pointCenter.x - 20, pointCenter.y - 20 + 120);
        }else
        {
            _showStepImageView.image = UIImageNamed(@"details_capacity_5s@2x.png");
            _showStepImageView.center = CGPointMake(pointCenter.x , pointCenter.y - 20 + 120);
        }

    _showStepImageView.hidden = NO;
    _showStepLabel.text = [NSString stringWithFormat:@"%@",[_dataArray objectAtIndex:sender.tag]];
}

- (void)sleepbuttonClick:(UIButton *)sender
{
        if (sender.tag == 3)
        {
//            NSLog(@"%f",sender.origin.y);
            if (sender.origin.y < 110)
            {

            }
        }
        for (UIButton *button in _sleepButtonClickArray)
        {
            button.selected = NO;
        }
        sender.selected = YES;
        
        CGPoint pointCenter = sender.center;
    
        _showStepLabel.frame =  CGRectMake( 5, 0, 100, 50);
        _showStepLabel.numberOfLines = 3;
        _showStepLabel.textAlignment = NSTextAlignmentLeft;

        _showStepImageView.frame = CGRectMake(0, + _offsetY, 90, 60);
    
        if (sender.origin.x < 55.0)
        {
            _showStepImageView.image = UIImageNamed(@"details_popup2_5@2x.png");
            _showStepImageView.center = CGPointMake(pointCenter.x + 45, pointCenter.y - 30 + 120);
        }else if (sender.origin.x > 260.0)
        {
            _showStepImageView.image = UIImageNamed(@"details_popup3_5@2x.png");
            _showStepImageView.center = CGPointMake(pointCenter.x - 45, pointCenter.y - 30 + 120);
        }else
        {
            _showStepImageView.image = UIImageNamed(@"details_popup1_5@2x.png");
            _showStepImageView.center = CGPointMake(pointCenter.x , pointCenter.y - 30 + 120);
        }

        _showStepImageView.hidden = NO;
    
        NSMutableString *string = [[NSMutableString alloc]init];
        
        int value = [[_dataArray objectAtIndex:sender.tag]intValue];
        NSString *totalTime = [NSString stringWithFormat:@"%@:%dh%dm", KK_Text(@"Total"), value/60,value%60];
        [string appendString:totalTime];
        [string appendString:@"\n"];
    
        int deepValue = [[ _sleepDeepDataArray objectAtIndex:sender.tag]intValue];
        int shallowValue = [[ _sleepShallowDataArray objectAtIndex:sender.tag]intValue];
        [string appendString:[NSString stringWithFormat:@"%@:%dh%dm\n", KK_Text(@"Light"),shallowValue/60,shallowValue%60]]; // _sleepDeepDataArray
        [string appendString:[NSString stringWithFormat:@"%@:%dh%dm.", KK_Text(@"Deep"),deepValue/60,deepValue%60]];// _sleepShallowDataArray
        _showStepLabel.text = string;
}

- (int)max:(NSArray *)Array
{
    if (Array.count == 0)
    {
        return 0;
    }
    
    int max = [[Array objectAtIndex:0]intValue];
    
    for (int i =0; i<Array.count; i++)
    {
        if ([[Array objectAtIndex:i]intValue] > max)
        {
            max = [[Array objectAtIndex:i]intValue];
        }
    }
    
    if (max == 0)
    {
        max = 150;
    }
    NSInteger target = 0;
    if (_stepOrSleep)
    {
    target = [UserInfoHelper sharedInstance].userModel.targetSteps;
    }
    else
    {
    target = [UserInfoHelper sharedInstance].userModel.targetSleep + 120;
    }
    
    if (max < target)
    {
        max = target *1.2;
    }
    
    return max;
}

- (int)min:(NSArray *)Array
{
    if (Array.count == 0)
    {
        return 0;
    }
    
    int min = [[Array objectAtIndex:0]intValue];
    
    for (int i =0; i<Array.count; i++)
    {
        if ([[Array objectAtIndex:i]intValue] < min)
        {
            min = [[Array objectAtIndex:i]intValue];
        }
    }
    
    return min;
}


@end
