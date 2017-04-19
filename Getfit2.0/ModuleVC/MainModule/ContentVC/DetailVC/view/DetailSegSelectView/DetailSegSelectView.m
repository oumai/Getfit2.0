//
//  segMentScrollView.m
//  Logistics
//
//  Created by zhou on 15/7/4.
//  Copyright (c) 2015年 Shawsan. All rights reserved.
//

#import "DetailSegSelectView.h"

@implementation DetailSegSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadSegView];
        
        [self loadButton];
        
        [self loadSliderView];
    }
    
    return self;
}

- (void)loadSegView
{
    UIView *segmentBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    segmentBackGroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:segmentBackGroundView];
}

- (void)loadButton
{
    _weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_weekButton setTitle:KK_Text(@"Week") forState:UIControlStateNormal];
    _weekButton.frame =CGRectMake(Maxwidth/2-100-10, 0 , 70, 40);
    [_weekButton setTitleColor:UIColorHEX(0xffffff) forState:UIControlStateSelected];
    [_weekButton setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.3] forState:UIControlStateNormal];
    [_weekButton setFontSize:16.0];
    [self addSubview:_weekButton];
    _weekButton.tag = 1;
    _weekButton.selected = YES;
    [_weekButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _selectIndex = 1;

    _monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_monthButton setTitle:KK_Text(@"Month") forState:UIControlStateNormal];
    _monthButton.frame =CGRectMake(Maxwidth/2-25-10, 0 , 70, 40);
    [_monthButton setTitleColor:UIColorHEX(0xffffff) forState:UIControlStateSelected];
    [_monthButton setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.3] forState:UIControlStateNormal];
    [_monthButton setFontSize:16.0];
    _monthButton.selected = NO;
    _monthButton.tag = 2;
    [self addSubview:_monthButton];
    [_monthButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _yearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_yearButton setTitle:KK_Text(@"Year") forState:UIControlStateNormal];
    _yearButton.frame =CGRectMake(Maxwidth/2+50-10, 0 , 70, 40);
    [_yearButton setTitleColor:UIColorHEX(0xffffff) forState:UIControlStateSelected];
    [_yearButton setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.3] forState:UIControlStateNormal];
    [_yearButton setFontSize:16.0];
    _yearButton.selected = NO;
    _yearButton.tag = 3;
    [self addSubview:_yearButton];
    [_yearButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonClick:(UIButton *)Sender
{
    NSLog(@"%ld",Sender.tag);
    _weekButton.selected = NO;
    _monthButton.selected = NO;
    _yearButton.selected = NO;
    _selectIndex = Sender.tag;
    
    if (Sender.tag == 1)
    {
        _weekButton.selected = YES;
    }
    else if (Sender.tag == 2)
    {
        _monthButton.selected = YES;
    }
    else if (Sender.tag == 3)
    {
        _yearButton.selected = YES;
    }
    
    if (_segmentSelectBlock)
    {
        _segmentSelectBlock(Sender.tag);
    }
    
    [self loadSliderPosition];
}


- (void)loadSliderView
{
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(Maxwidth/2-85, 33, 20, 2)];
    _sliderView.backgroundColor = UIColorHEX(0xffffff);
    [self addSubview:_sliderView];
}

- (void)loadSliderPosition
{
    CGFloat position = Maxwidth/2-85;
    
    if (_selectIndex ==1)
    {
        position = Maxwidth/2-85;
    }
    else if (_selectIndex ==2)
    {
        position = Maxwidth/2-10;
    }
    else
    {
        position = Maxwidth/2+65;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _sliderView.frame = CGRectMake(position, 33, 20, 2);
        
    } completion:^(BOOL finished) {
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
