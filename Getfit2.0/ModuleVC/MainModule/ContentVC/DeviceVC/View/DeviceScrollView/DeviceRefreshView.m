//
//  DeviceRefreshView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceRefreshView.h"

@implementation DeviceRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadImageView];
    }
    
    return self;
}

- (void)loadImageView
{
    _refreshView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _refreshView.image = UIImageNamed(@"Device_refresh_1_5s@2x.png");
    [self addSubview:_refreshView];
    [_refreshView setHidden:YES];
}

- (void)Start:(float)time refreshtype:(NSInteger)type
        startRefreshBlock:(RefreshViewBlock)startBlock
        endRefreshBlock:(RefreshViewBlock)endBlock
{
    if (type == 1)
    {
     _refreshView.image = UIImageNamed(@"Device_refresh_1_5s@2x.png");
    }
    else if(type ==2)
    {
    _refreshView.image = UIImageNamed(@"Device_refresh_2_5s@2x.png");
    }
    _angle = 0;
    _totalAngle = time / 0.02 *12.5;
    _time = time / 0.02 ;
    [self startAnimation];
    [_refreshView setHidden:NO];
    
    _StartrefreshBlock = startBlock;
    _endRefreshBlock = endBlock;
    
    if (_StartrefreshBlock)
    {
        _StartrefreshBlock(self);
    }
}

-(void)startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.02];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _refreshView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation
{
    if (_angle < _totalAngle)
    {
        _angle += 12.5;
        [self startAnimation];
    }else
    {
        [_refreshView setHidden:YES];
        
        if (_endRefreshBlock)
        {
            _endRefreshBlock(self);
        }
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
