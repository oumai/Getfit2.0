//
//  CustomsPickView.m
//  PickUpview
//
//  Created by 黄建华 on 15/7/20.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "CustomsPickView.h"

@implementation CustomsPickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadPickView];
    }
    return self;
}

- (void)loadPickView
{
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    
    UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [cancelButton setTitle:KK_Text(@"Cancel") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 0, 100, 44)];
    [confirmButton setTitle:KK_Text(@"Confirm") forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, 0.5)];
    selectView.backgroundColor = UIColorHEX(0x888b90);
    [self addSubview:selectView];
    
    if (_customPickClickBlock)
    {
        _customPickClickBlock(NO);
    }
    
   self.frame = CGRectMake(0, Maxheight, self.width,260);
}

- (void)showView
{
    
    [UIView animateWithDuration:0.20 animations:^{
        self.frame = CGRectMake(0, Maxheight-260, Maxwidth,260);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenView
{

    [UIView animateWithDuration:0.20 animations:^{
        
       self.frame = CGRectMake(0, Maxheight, Maxwidth,260);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancelButtonClick:(UIButton *)sender
{
    if (_customPickClickBlock)
    {
        _customPickClickBlock(NO);
    }
}

- (void)confirmButtonClick:(UIButton *)sender
{
    if (_customPickClickBlock)
    {
        _customPickClickBlock(YES);
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
