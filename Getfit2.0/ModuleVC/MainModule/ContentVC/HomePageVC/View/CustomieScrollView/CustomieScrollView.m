//
//  V_Active_ProgressView.m
//  VeryFit_Active_ProgressView
//
//  Created by 黄建华 on 15/6/9.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "CustomieScrollView.h"
#define WIDTHSPACE 50
#import "PedometerHelper.h"
#import "PedometerModel.h"
#import "DateTools.h"

@implementation CustomieScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadView];
    }
    return self;
}

- (void)loadView
{
    UIImageView *backGround = [[UIImageView alloc] initWithFrame:self.frame];
    backGround.image = [UIImage imageNamed:@"home_bg_5s"];
    [self addSubview:backGround];
    
    _stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _stepLabel.textAlignment = NSTextAlignmentCenter;
    _stepLabel.font = [UIFont systemFontOfSize:16.0];
    _stepLabel.textColor = BGCOLOR;
    _stepLabel.center = CGPointMake(self.center.x, 20);
    [self addSubview:_stepLabel];
    
    UIView *redLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.width, 1)];
    redLine.backgroundColor = BGCOLOR;
    [self addSubview:redLine];
    
    UIView *redLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 219, self.width, 1)];
    redLine2.backgroundColor = BGCOLOR;
    [self addSubview:redLine2];
    
    UIButton * todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    todayButton.frame = CGRectMake(0, 219, self.width, 42);
    [todayButton setTitle:KK_Text(@"go to The Day") forState:UIControlStateNormal];
    [todayButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [todayButton addTarget:self action:@selector(todayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:todayButton];

}


- (NSInteger)userDays
{
    NSDate *date = [SAVEFIRSTUSERDATE getObjectValue];
    NSInteger beforeIndex = date.dayOfYear;
    NSInteger nowIndex = [NSDate date].dayOfYear;
    NSInteger longTime = nowIndex - beforeIndex + 1;
    return longTime;
}

// 获取使用过的时间
- (NSMutableArray*)getUserDateArray
{
    NSInteger maxCount = [self userDays];
    
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <maxCount; i ++)
    {
        [dateArray addObject:[self backDate:(maxCount - i -1)]];
    }
    
    return dateArray;
}

- (NSString *)backDate:(NSInteger)dateIndex
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[NSDate dateFormatterTemp];
    [dateformatter setDateFormat:@"YYYY/MM/dd"];
    NSTimeInterval time = - 24 * 3600 * dateIndex;
    NSDate *beforeData =[senddate initWithTimeIntervalSinceNow:time];
    NSString *  before=[dateformatter stringFromDate:beforeData];
    return before;
}

// 字符串转换为相应的日期
- (NSDate *)dateWithString:(NSString *)dateString
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate* inputDate = [inputFormatter dateFromString:dateString];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: inputDate];
    NSDate *localeDate = [inputDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

// 创建数据
- (void)CustomieScrollViewUpdate:(NSInteger)type dataArray:(NSArray *)Array
{
    NSMutableArray *dateStringArray = [self getUserDateArray];
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    NSLog(@"获取使用过的时间>>>>%@",dateStringArray);

    _type = type;

    if (_type == 1)
    {
        for (int i = 0; i < dateStringArray.count - 1;i ++)
        {
        NSDate *date = [self dateWithString:[dateStringArray objectAtIndex:i]];
        PedometerModel *model = [PedometerHelper getModelFromDBWithDate:date];
        [dateArray addObject:@(model.totalSteps)];
        }
        PedometerModel *model = [PedometerHelper getModelFromDBWithToday];
        [dateArray addObject:@(model.totalSteps)];

         NSLog(@"记数》》》》%@",dateArray);
        
        _dataArray = dateArray;
        _stepOrSleep = YES;
        
    }
    else if (_type == 2)
    {
        for (int i = 0; i < dateStringArray.count;i ++)
        {
            NSDate *date = [self dateWithString:[dateStringArray objectAtIndex:i]];
            PedometerModel *model = [PedometerHelper getModelFromDBWithDate:date];
            NSInteger yesterdaysleepTime = 0;
            if (i>0) {
                NSDate *date = [self dateWithString:[dateStringArray objectAtIndex:i-1]];
                PedometerModel *model = [PedometerHelper getModelFromDBWithDate:date];
                yesterdaysleepTime = [self getYesterdaySleepTime:model];
            }
            if (model)
            {
                NSInteger sleepTime = model.deepSleepTime + model.shallowSleepTime+yesterdaysleepTime;
                [dateArray addObject:@(sleepTime)];
            }
            else
            {
                [dateArray addObject:@(0)];
            }

        }
//        PedometerModel *model = [PedometerHelper getModelFromDBWithToday];
//        [dateArray addObject:@(model.totalSteps)];
//        NSLog(@"睡眠》》》》%@",dateArray);
        
        _dataArray = dateArray;
        _stepOrSleep = NO;
    }
    
    
    // 获取最大 最小值
    _max = [self max:_dataArray];
    _min = [self min:_dataArray];
    
    // 创建滚动时图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 44, self.frame.size.width ,175);
    _scrollView.backgroundColor = UIColorHEX(0x00000);
    _scrollView.alpha = 0.8;
    _scrollView.contentSize = CGSizeMake((_dataArray.count) * WIDTHSPACE + self.frame.size.width - WIDTHSPACE + 20, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    UIView *ClearView = [[UIView alloc] initWithFrame:CGRectMake(self.center.x-10, 44, 20, 175)];
    [self addSubview:ClearView];
    
    UIView *Redview = [[UIView alloc] initWithFrame:CGRectMake(self.center.x-10, 44, 20, 175)];
    Redview.backgroundColor = BGCOLOR;
    Redview.alpha = 0.3;
    [self addSubview:Redview];
    
    _redDot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _redDot.image =[UIImage imageNamed:@"home_dop_5s"];
    [ClearView addSubview:_redDot];
    
    // 转换为高度
    [self heightList];
    
    // 绘折线图
    [self addPath];
}
- (NSInteger)getYesterdaySleepTime:(PedometerModel*)model
{

    NSInteger deepTime = 0;
    
    for (NSInteger i = 0; i < model.yesterdayArray.count; i ++)
    {
        int value = [[[model.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];
        
        if (value != 9999 )
        {
            if (value<=30) {
                deepTime += 5;
            }
        }
    }
    return deepTime;
}
- (void)heightList
{
    _heightPointArray = [[NSMutableArray alloc]init];
    
    for (NSString *value in _dataArray)
    {
        NSInteger i = value.integerValue;
        int height = (int)(1.0 * (_max - i) / _max *150)+10;
      [_heightPointArray addObject:[NSString stringWithFormat:@"%d",height]];
       
    }
}

- (void)resetOffSet:(NSInteger)index
{
    NSLog(@" resetOffSet index>>>>>>>%ld",index);
    _scrollView.contentOffset = CGPointMake((index)*WIDTHSPACE -WIDTHSPACE, 0);
}

- (void)addPath
{
      [self addLineLast];
//    if (_dataArray.count > 200)
//    {
//        [self addLineFirst];
//    }
//    else
//    {
//        [self addLineLast];
//    }
    _scrollView.contentOffset = CGPointMake((_dataArray.count ) * WIDTHSPACE -WIDTHSPACE, 0);
    
    if (_stepOrSleep)
    {
        _stepLabel.text = [NSString stringWithFormat:@"%d %@", [[_dataArray lastObject] intValue], KK_Text(@"Step")];
    }
    else
    {
        if ([[_dataArray lastObject]intValue]>60)
        {
            NSString *hourStr = KK_Text(@"H");
            NSString *minus = KK_Text(@"Min");
            _stepLabel.text = [NSString stringWithFormat:@"%d%@%d%@", [[_dataArray lastObject]intValue]/60,hourStr,[[_dataArray lastObject]intValue]%60,minus];
        }
        else
        {
            _stepLabel.text = [NSString stringWithFormat:@"%d %@", [[_dataArray lastObject] intValue]%60, KK_Text(@"Min")];
        }

    }

//    [self performSelector:@selector(delayUpdate) withObject:nil afterDelay:1.0];
}

- (void)delayUpdate
{
    [self addLineDelay:0];
}

- (void)addLineDelay:(int)index
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for(int i = 0;i < _dataArray.count - 200;i++)
    {
        float heightV = [[_heightPointArray objectAtIndex:i]floatValue];
        CGPoint p1 = CGPointMake((i)*WIDTHSPACE +self.frame.size.width/2, heightV);
        
        if (i == 0)
        {
            [path moveToPoint:p1];
        }
        else
        {
            [path addLineToPoint:p1];
        }
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = [self drawPathWithArcCenter:p1 Radius:7.5];
        layer.fillColor = BGCOLOR.CGColor;
        layer.strokeColor = BGCOLOR.CGColor;
        layer.lineWidth = 1;
        [_scrollView.layer addSublayer:layer];
    }
    
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.bounds = self.bounds;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [BGCOLOR CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = 1;
        pathLayer.lineJoin = kCALineJoinRound;
        [_scrollView.layer addSublayer:pathLayer];
}

- (void)addLineFirst
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for(int i = _dataArray.count-200;i < _dataArray.count;i++)
    {
        float heightV = [[_heightPointArray objectAtIndex:i]floatValue];
        CGPoint p1 = CGPointMake((i)*WIDTHSPACE +self.frame.size.width/2, heightV);
        
        if (i == _dataArray.count-200)
        {
            [path moveToPoint:p1];
        }
        else
        {
            [path addLineToPoint:p1];
            
        }
        
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        layer.path = [self drawPathWithArcCenter:p1 Radius:7.5];
        layer.fillColor = BGCOLOR.CGColor;
        layer.strokeColor = BGCOLOR.CGColor;
        layer.lineWidth = 1;
        [_scrollView.layer addSublayer:layer];
    }
    
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.bounds = self.bounds;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [BGCOLOR CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = 1;
        pathLayer.lineJoin = kCALineJoinRound;
        [_scrollView.layer addSublayer:pathLayer];
}

- (void)addLineLast
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
 
    
    for(int i = 0;i < _dataArray.count;i++)
    {
        float heightV = [[_heightPointArray objectAtIndex:i]floatValue];
        CGPoint p1 = CGPointMake((i)*WIDTHSPACE +self.frame.size.width/2, heightV);

        if (i == 0)
        {
            [path moveToPoint:p1];
            if (_dataArray.count == 1)
            {
                _redDot.center = CGPointMake(10, p1.y);
            }
        }
        else
        {
            
            [path addLineToPoint:p1];
        }
        
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        layer.path = [self drawPathWithArcCenter:p1 Radius:7.5];
        layer.fillColor = BGCOLOR.CGColor;
        layer.strokeColor = BGCOLOR.CGColor;
        layer.lineWidth = 1;
        [_scrollView.layer addSublayer:layer];
    }
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.bounds;
    pathLayer.bounds = self.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [BGCOLOR CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1;
    pathLayer.lineJoin = kCALineJoinRound;
    [_scrollView.layer addSublayer:pathLayer];
    
    for(int i = 0;i < _dataArray.count;i++)
    {
        float heightV = [[_heightPointArray objectAtIndex:i]floatValue];
        CGPoint p1 = CGPointMake((i)*WIDTHSPACE +self.frame.size.width/2, heightV);
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        layer.path = [self drawPathWithArcCenter:p1 Radius:6.5];
        layer.fillColor = UIColorHEX(0x0A0A0A).CGColor;
        layer.strokeColor = BGCOLOR.CGColor;
        layer.lineWidth = 1;
        [_scrollView.layer addSublayer:layer];
    }

}

- (CGPathRef)drawPathWithArcCenter:(CGPoint)Point Radius:(CGFloat)radius{
    
    return [UIBezierPath bezierPathWithArcCenter:Point
                                          radius:radius
                                      startAngle:(- M_PI_2)
                                        endAngle:(3 * M_PI_2)
                                       clockwise:YES].CGPath;
}
- (void)showValueLabel:(CGFloat)value
{
    if (_type == 1)
    {
        _stepLabel.text = [NSString stringWithFormat:@"%d %@", (int)value, KK_Text(@"Step")];
    }
    else if(_type == 2)
    {
        NSString *hourStr = KK_Text(@"H");
        NSString *minus = KK_Text(@"Min");
        
        _stepLabel.text = [NSString stringWithFormat:@"%d%@%d%@",(int)(value/60),hourStr,(int)value % 60,minus];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = _scrollView.contentOffset.x / WIDTHSPACE;

    CGFloat more = ((int)(_scrollView.contentOffset.x))%WIDTHSPACE;
    if (_dataArray.count == 0)
    {
        
        return;
    }
    
    if (_scrollView.contentOffset.x >= 0 && _scrollView.contentOffset.x <= (_dataArray.count-1) * WIDTHSPACE)
    {
        if (index < _dataArray.count - 1)
        {
            float value2 = [_dataArray[index + 1]floatValue];
            float Value1 = [_dataArray[index]floatValue];
            CGFloat value = (more/WIDTHSPACE) * (value2 - Value1) + Value1;
            CGFloat height = 1.0 * (_max -value) / _max * 150 + 10;
            
            [self showValueLabel:value];
    
            CGPoint point = CGPointMake(10, height);
            _redDot.center = point;
            [_redDot setHidden:NO];
        }
    }
    
    if ((int)_scrollView.contentOffset.x == (_dataArray.count-1) * WIDTHSPACE)
    {
        [_redDot setHidden:NO];
        [self LastPointLayer];
    }
    else if(_scrollView.contentOffset.x > (_dataArray.count - 1) * WIDTHSPACE || _scrollView.contentOffset.x < 0)
    {
        [_redDot setHidden:YES];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayOffSet) object:nil];
    [self performSelector:@selector(delayOffSet) withObject:nil afterDelay:0.20];
}

- (void)delayOffSet
{
    int index = _scrollView.contentOffset.x/WIDTHSPACE;
    CGFloat more = ((int)(_scrollView.contentOffset.x))%WIDTHSPACE;
    
    if (_scrollView.contentOffset.x >= 0 && _scrollView.contentOffset.x <= (_dataArray.count )*WIDTHSPACE)
    {
        if (more > WIDTHSPACE / 2)
        {
            [_scrollView setContentOffset:CGPointMake((index+1) *WIDTHSPACE, 0) animated:YES];
        }
        else
        {
            [_scrollView setContentOffset:CGPointMake(index*WIDTHSPACE, 0) animated:YES];
        }
    }
    
    if (_CustomieScrollViewSelectBlock)
    {
        _CustomieScrollViewSelectBlock (index + 1);
    }
    _currentIndex = index + 1;
}

- (void)LastPointLayer
{
    if (_dataArray.count == 0)
    {
        return;
    }
    
    CGFloat value = [[_dataArray lastObject] floatValue];
    [self showValueLabel:value];

    CGFloat height= (_max -value)/_max *150+10;
    
    CGPoint point = CGPointMake(10, height);
    _redDot.center = point;
}

- (void)todayButtonClick
{
    [self.CustomieScrollViewDelegate CustomieScrollViewCheekDate:_currentIndex];
    [self dismissPopup];
}

- (int)max:(NSArray *)Array
{
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
        max = 110;
    }
    
    return max;
}

- (int)min:(NSArray *)Array
{
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


- (CGPathRef)drawPathWithArcCenterWith:(NSInteger)Total Index:(NSInteger)Index
{
    CGFloat theHalf = self.frame.size.width/2;
    CGFloat centerX = theHalf;
    CGFloat centerY = self.frame.size.height/2;
    
    float start = M_PI_2 *4 / Total * (Index-1);
    float  end  = M_PI_2 *4 / Total * Index;

    CGFloat raius = 100;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY)
                                          radius:raius
                                      startAngle:(- M_PI_2 +start)
                                        endAngle:(- M_PI_2 + end)
                                       clockwise:YES].CGPath;
}


@end
