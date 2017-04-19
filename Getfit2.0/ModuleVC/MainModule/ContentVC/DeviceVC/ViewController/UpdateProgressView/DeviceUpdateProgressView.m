//
//  DeviceUpdatePoessView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceUpdateProgressView.h"

@implementation DeviceUpdateProgressView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadUpdateProgressView];
    }
    return self;
    
}

-(void)loadUpdateProgressView
{
     self.layer.cornerRadius = 4; 
    
    _progressView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 20, 10)];
    _progressView.backgroundColor = UIColorHEX(0xa5d445);
    _progressView.layer.cornerRadius = 4;
    [self addSubview:_progressView];
}


- (void)setProgress:(CGFloat)Value
{
    float width = self.width/100 * Value;
    _progressView.frame = CGRectMake(0, 0, width, 10);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
