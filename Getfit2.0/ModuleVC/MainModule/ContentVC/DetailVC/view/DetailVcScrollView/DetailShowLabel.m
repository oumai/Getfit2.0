//
//  DetailShowLabel.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DetailShowLabel.h"

@implementation DetailShowLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:10];
        self.textColor = UIColorHEX(0x888b90);
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
