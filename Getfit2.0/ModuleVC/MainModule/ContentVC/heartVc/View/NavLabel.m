//
//  NavLabel.m
//  Warm
//
//  Created by 黄建华 on 15/8/4.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "NavLabel.h"

@implementation NavLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:12.0];
        self.textColor = [UIColor whiteColor];
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
