//
//  VeryFitMainRainDotView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "VeryFitMainRainDotView.h"
#define SPACEWidth 1.0 * floor(self.width - 10)/3.2/96
#define WIDTH 2.2 * floor(self.width - 10)/3.2/96
#define DOTTIME 0.01
#define RAINDOTTIME 0.001
@implementation VeryFitMainRainDotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)loadrainDotView
{
    if (_rainDotView) {
        [_rainDotView removeFromSuperview];
        _rainDotView = nil;
    }
    _rainDotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview: _rainDotView];
    
    [self loadRainDot];
}


- (void)loadRainDot
{
    _rightCount = 96 / 2 ;
    [self loadRightDot];
    _leftCount = 96 /2 - 1;
    [self loadLeftDot];
}

- (void)loadRightDot
{
    CGFloat offsetY = FitScreenNumber(20, 40, 40, 40, 40);
    if (_rightCount < 96)
    {
        UIView * rainDot = [[UIView alloc ]initWithFrame:CGRectMake(5 + _rightCount * (WIDTH) +_rightCount * SPACEWidth, offsetY + 30, WIDTH, WIDTH)];
        rainDot.backgroundColor = BGCOLOR;
        [_rainDotView addSubview:rainDot];
        rainDot.tag = _rightCount;
        _rightCount ++;
        
        [self performSelector:@selector(loadRightDot) withObject:nil afterDelay:DOTTIME];
        [self performSelector:@selector(viewActive:) withObject:rainDot afterDelay:DOTTIME *50];
    }
}

- (void)viewActive:(UIView *)view
{
    [UIView animateWithDuration:arc4random() % 1000 * RAINDOTTIME animations:^{

        view.frame = CGRectMake(5 + view.tag * (WIDTH) +view.tag * SPACEWidth, self.height - 25, WIDTH, WIDTH);

    } completion:^(BOOL finished) {

    }];
}

- (void)loadLeftDot
{
    CGFloat offsetY = FitScreenNumber(20, 40, 40, 40, 40);
    if (_leftCount >= 0)
    {
        UIView * rainDot = [[UIView alloc ]initWithFrame:CGRectMake(5 + _leftCount * (WIDTH) +_leftCount * SPACEWidth, offsetY + 30, WIDTH, WIDTH)];
        rainDot.backgroundColor = BGCOLOR;
        [_rainDotView addSubview:rainDot];
        rainDot.tag = _leftCount;
        _leftCount --;

        [self performSelector:@selector(loadLeftDot) withObject:nil afterDelay:DOTTIME];
        [self performSelector:@selector(viewActive:) withObject:rainDot afterDelay:DOTTIME *50];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
