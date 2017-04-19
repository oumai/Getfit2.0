//
//  HubView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "HubView.h"

@implementation HubView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)start
{
    
    if (_progressView)
    {
        [_progressView removeFromSuperview];
        _progressView = nil;
    }
    _progressIndex = 1;
    
    if (_progressTimer)
    {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
    
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.075 target:self selector:@selector(progressLayerAnimation) userInfo:nil repeats:YES];
}

//选中设备动画
- (void)startAnimation
{
    if (_progressView)
    {
        [_progressView removeFromSuperview];
        _progressView = nil;
    }
    _progressIndex = 1;
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.075 target:self selector:@selector(selectDeviceProgressLayerAnimation) userInfo:nil repeats:YES];
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:1.0];

}

//搜索失败动画
- (void)stopSearch
{
    [_progressTimer invalidate];
    _progressTimer = nil;
    
    if (_progressView)
    {
        [_progressView removeFromSuperview];
        _progressView = nil;
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self addSubview:_progressView];
        
        UIImageView* bgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Fail_5s@2x.png"]];
        bgview.frame = CGRectMake(0, 0, 25, 25);
        bgview.center = CGPointMake(25, 25);
        [_progressView addSubview:bgview];
    }
}

//选中设备加载动画
- (void)selectDeviceProgressLayerAnimation
{
    if (_progressIndex<15)
    {
        if (!_progressView)
        {
            _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [self addSubview:_progressView];
        }
        
        CAShapeLayer * progressLayer = [CAShapeLayer layer];
        progressLayer.path = [self drawPathWithArcCenter:15 Center:CGPointMake(25, 25) start:_progressIndex];
        progressLayer.fillColor = [UIColor whiteColor].CGColor;
        progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        progressLayer.lineJoin =kCALineJoinRound;
        progressLayer.lineWidth =_progressIndex/4 +2;
        progressLayer.lineCap = kCALineCapRound;
        [_progressView.layer addSublayer:progressLayer];
        _progressIndex++;
    }
    else
    {
        if (_progressView)
        {
            [_progressView removeFromSuperview];
            _progressView = nil;
            _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [self addSubview:_progressView];
        }
        _progressIndex = 1;
    }
}

//搜索设备动画
- (void)progressLayerAnimation
{
    if (_progressIndex<15)
    {
        if (!_progressView)
        {
            _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [self addSubview:_progressView];
        }
        CAShapeLayer * progressLayer = [CAShapeLayer layer];
        CGFloat Value = 0.03*_progressIndex +0.58;
        
        progressLayer.path = [self drawPathWithArcCenter:15 Center:CGPointMake(25, 25) start:_progressIndex];
        progressLayer.fillColor = [UIColor colorWithRed:0 green:Value blue:0 alpha:Value].CGColor;
        progressLayer.strokeColor = [UIColor colorWithRed:0 green:Value blue:0 alpha:Value].CGColor;
        progressLayer.lineJoin =kCALineJoinRound;
        progressLayer.lineWidth =_progressIndex/4 +2;
        progressLayer.lineCap = kCALineCapRound;
        [_progressView.layer addSublayer:progressLayer];
        _progressIndex++;
    }
    else
    {
        if (_progressView)
        {
            [_progressView removeFromSuperview];
            _progressView = nil;
            _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [self addSubview:_progressView];
        }
        _progressIndex = 1;
    }
}

//动画路径
- (CGPathRef)drawPathWithArcCenter:(CGFloat)radius Center:(CGPoint)Point start:(NSInteger)index
{
    CGFloat StartValue = - M_PI_2 + (index-1)*4*M_PI_2/14;
    CGFloat width = 4*M_PI_2/360/3;
    return [UIBezierPath bezierPathWithArcCenter:Point
                                          radius:radius
                                      startAngle:(- M_PI_2 +StartValue)
                                        endAngle:(- M_PI_2 +StartValue+width)
                                       clockwise:YES].CGPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
