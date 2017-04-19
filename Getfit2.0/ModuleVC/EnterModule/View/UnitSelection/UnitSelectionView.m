//
//  UnitSelectionView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UnitSelectionView.h"
#import "Information.h"

@implementation UnitSelectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4.0;
    
    UILabel *metric = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 70, 25)];
     metric.textColor = UIColorHEX(0x4a4a4a);
     metric.font = [UIFont systemFontOfSize:14];
     metric.text = KK_Text(@"Metric");
     metric.textAlignment = NSTextAlignmentLeft;
    [self addSubview:metric];
    _isMetricSystem = YES;

    UILabel *inch = [[UILabel alloc] initWithFrame:CGRectMake(40, 57, 70, 25)];
     inch.textColor = UIColorHEX(0x4a4a4a);
     inch.font = [UIFont systemFontOfSize:14];
     inch.text = KK_Text(@"British");
     inch.textAlignment = NSTextAlignmentLeft;
    [self addSubview:inch];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0,44, self.width, 1)];
    line.backgroundColor = UIColorHEX(0x363636);
    [self addSubview:line];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0,88, self.width, 1)];
    line2.backgroundColor = UIColorHEX(0x363636);
    [self addSubview:line2];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
     confirmButton.frame = CGRectMake(0,88,self.width,44);
    [confirmButton setTitle:KK_Text(@"Confirm") forState:UIControlStateNormal];
    [confirmButton setTitleColor:UIColorHEX(0x363636) forState:UIControlStateNormal];
     confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:confirmButton];
     [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
     _metricButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_metricButton setBackgroundImage:[UIImage imageNamed:@"login_unselect_5s" ] forState:UIControlStateNormal];
    [_metricButton setBackgroundImage:[UIImage imageNamed:@"login_select_5s" ] forState:UIControlStateSelected];
    [_metricButton setSelected:YES];
     _metricButton.frame = CGRectMake(self.width - 18 - 35, 2, 44, 44);
    [self addSubview:_metricButton];
     _metricButton.tag = 1;
    [_metricButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [Information sharedInstance].unit = YES;
    
     _inchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inchButton setBackgroundImage:[UIImage imageNamed:@"login_unselect_5s" ] forState:UIControlStateNormal];
    [_inchButton setBackgroundImage:[UIImage imageNamed:@"login_select_5s" ] forState:UIControlStateSelected];
    _inchButton.frame = CGRectMake(self.width - 18 -35, 46, 44, 44);
    [self addSubview:_inchButton];
     _inchButton.tag = 2;
    [_inchButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirmButtonClick:(UIButton *)Sender
{

    [UserInfoHelper sharedInstance].userModel.isMetricSystem = _isMetricSystem;

    [self dismissPopup];
}

- (void)buttonClick:(UIButton *)Sender
{
    if (Sender.tag == 1)
    {
        _metricButton.selected = YES;
        _inchButton.selected = NO;
        _isMetricSystem = YES;
    }
    else if(Sender.tag == 2)
    {
        _metricButton.selected = NO;
        _inchButton.selected = YES;
        _isMetricSystem = NO;
    }
       [UserInfoHelper sharedInstance].userModel.isMetricSystem = _isMetricSystem;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
