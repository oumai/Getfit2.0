//
//  VeryFit_Main_ChatView.m
//  Customize
//
//  Created by 黄建华 on 15/6/11.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "VeryFitMainChatView.h"
//#define SPACEWidth 1.0
//#define WIDTH 2.2

#define SPACEWidth 1.0 * floor(self.width - 10)/3.2/96
#define WIDTH 2.2 * floor(self.width - 10)/3.2/96


@implementation VeryFitMainChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadView];
    }
    
    return self;
}

// 更新今天详情数据
- (void)updateView:(PedometerModel *)model
{
   _dateArray = model.showDetailSports;
//    NSLog(@"_dateArray>>>>%@",_dateArray);
    
    
   maxValue =  [self max:_dateArray];
   minValue =  [self min:_dateArray];
   _maxLable.text = [NSString stringWithFormat:@"%ld",maxValue];
   _midLable.text = [NSString stringWithFormat:@"%ld",maxValue/2];
    if (maxValue == 0)
    {
        _maxLable.text = [NSString stringWithFormat:@""];
        _midLable.text = [NSString stringWithFormat:@""];
        maxValue = 200;
    }
    
    [self LoadChartView];
    _finishTargetLabel.text = [NSString stringWithFormat:@"%ld / %ld",model.totalSteps, [UserInfoHelper sharedInstance].userModel.targetSteps];
}

- (NSInteger)getTotalStep
{
    NSInteger totalStep = 0;
    for (NSString *value in _dateArray)
    {
        totalStep += value.integerValue;
    }
    return totalStep;
}

- (void)loadView
{
    CGFloat offsetY = FitScreenNumber(20, 40, 40, 40, 40);
    _finishTargetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    _finishTargetLabel.text = @"0 / 10000";
    _finishTargetLabel.textColor = [UIColor whiteColor];
    _finishTargetLabel.center = CGPointMake(self.center.x , offsetY);
    _finishTargetLabel.font = [UIFont systemFontOfSize:16];
    _finishTargetLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_finishTargetLabel];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 18)];
    image.center = CGPointMake(self.center.x, offsetY - 20);
    image.image = [UIImage imageNamed:@"home_people_5s"];
    [self addSubview:image];
    
    _midLable = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height+40)/2, 20, 15)];
    _midLable.font = [UIFont systemFontOfSize:8.0];
    _midLable.textColor = [UIColor whiteColor];
    [self addSubview:_midLable];
    _midLine = [[UIView alloc] initWithFrame:CGRectMake(5, (self.frame.size.height+40)/2,Maxwidth - 10, 0.5)];
    _midLine.backgroundColor = [UIColor greenColor];
    [self addSubview:_midLine];
    
    _maxLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 20, 15)];
    _maxLable.font = [UIFont systemFontOfSize:8.0];
    _maxLable.textColor = [UIColor whiteColor];
    [self addSubview:_maxLable];
    
    _maxLine = [[UIView alloc] initWithFrame:CGRectMake(5, 65,Maxwidth - 10, 0.5)];
    _maxLine.backgroundColor = [UIColor greenColor];
    [self addSubview:_maxLine];
    for (NSInteger i = 0; i<= 24; i+=4) {
        UILabel * Label = [[UILabel alloc]initWithFrame:CGRectMake( 5 + (i/4) * (self.width - 20)/6, self.height-20, 20, 20)];
        Label.text = [NSString stringWithFormat:@"%ld",i];
        Label.font = [UIFont systemFontOfSize:10.0];
        Label.textColor = [UIColor whiteColor];
        Label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:Label];
    }
    [self loadBackgroundLayer];
}

- (void)loadBackgroundLayer
{
    if (_backGroundLayer)
    {
        [_backGroundLayer removeFromSuperlayer];
        _backGroundLayer = nil;
    }
    _backGroundLayer = [CALayer layer];
    _backGroundLayer.backgroundColor = [UIColor clearColor].CGColor;
    _backGroundLayer.bounds = CGRectMake(0, 0, self.width, 200) ;
    _backGroundLayer.position = CGPointMake(self.center.x, 100);
    [self.layer addSublayer:_backGroundLayer];

}

- (NSInteger)max:(NSArray *)Array
{
    if (Array.count ==0)
    {
        return 0;
    }
    
    NSInteger max = [[_dateArray objectAtIndex:0] integerValue] ;
    
    for (int i = 0; i <_dateArray.count; i++)
    {
        if ([[_dateArray objectAtIndex:i] integerValue] > max) {
            max = [[_dateArray objectAtIndex:i] integerValue];
        }
    }
    
    return max;
}

- (NSInteger)min:(NSArray *)Array
{
    if (Array.count ==0)
    {
        return 0;
    }
    
    NSInteger min = [[_dateArray objectAtIndex:0] integerValue] ;
    
    for (int i =0; i <_dateArray.count; i++)
    {
        
        if ([[_dateArray objectAtIndex:i] integerValue] < min) {
            min = [[_dateArray objectAtIndex:i] integerValue];
        }
    }
    return min;
}

- (void)LoadChartView
{
    float Origin_x = 5;
    CGFloat Origin_height = self.height - 25;
    
    [self loadBackgroundLayer];
    
    CGFloat offsetY = FitScreenNumber(20, 40, 40, 40, 40);

    float max = 0;
    _maxLine.frame = CGRectMake(5, 65 - 55 / maxValue, Maxwidth - 10, 0.5);
    for (int i = 0; i < _dateArray.count; i ++)
    {
        CGFloat value = [[_dateArray objectAtIndex:i] floatValue] + 0.5;
        if (value > maxValue) {
            value = maxValue;
        }
        
        CGFloat height = (self.height - (25 + 30 + offsetY)) * (value / maxValue);
       
        static int total = 0;
        total = total + value;
        
        self.backgroundColor= [UIColor clearColor];
        
        if (i % 2 == 0)
        {
            max = 3;
        }
        CGPoint point01 = CGPointMake(i * (WIDTH) +i * SPACEWidth + Origin_x, Origin_height - height - max);
        CGPoint point02 = CGPointMake((i + 1) * (WIDTH) + i * SPACEWidth +Origin_x, Origin_height - height - max);
      
        UIBezierPath* fill = [UIBezierPath bezierPath];
        [fill moveToPoint:point01];
        [fill addLineToPoint:point02];
        [fill addLineToPoint:CGPointMake(point02.x,Origin_height)];
        [fill addLineToPoint:CGPointMake(point01.x, Origin_height)];
        
        // 填充区域
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.frame = self.bounds;
        fillLayer.bounds = self.bounds;
        fillLayer.path = fill.CGPath;
        fillLayer.strokeColor = BGCOLOR.CGColor;
        fillLayer.fillColor = BGCOLOR.CGColor;
        fillLayer.lineWidth = 0.0;
        fillLayer.lineJoin = kCALineJoinRound;
        [_backGroundLayer addSublayer:fillLayer];
        
        UIBezierPath* noFill = [UIBezierPath bezierPath];
        [noFill moveToPoint:CGPointMake(point01.x, Origin_height)];
        [noFill addLineToPoint:CGPointMake(point02.x,Origin_height)];
        [noFill addLineToPoint:CGPointMake(point02.x, Origin_height)];
        [noFill addLineToPoint:CGPointMake(point01.x, Origin_height)];
        
        // 填充区域过渡动画
        CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        fillAnimation.duration = 0.3;
        fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        fillAnimation.fillMode = kCAFillModeForwards;
        fillAnimation.fromValue = (id)noFill.CGPath;
        fillAnimation.toValue = (id)fill.CGPath;
        [fillLayer addAnimation:fillAnimation forKey:@"path"];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSDictionary *dic = @{@"isTouch":@"yes",@"obj":self.customieChartViewDelegate};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chattap" object:dic];
    [self setHidden:YES];
    [self.customieChartViewDelegate dismissView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
