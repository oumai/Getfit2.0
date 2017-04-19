//
//  SleepMoonView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "SleepMoonView.h"

@implementation SleepMoonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadSleepMoonView];
    }
    
    return self;
}

- (void)loadSleepMoonView
{
    _change = 0;
    [self changeImage];
}

- (void)changeImage
{
    if (_change < 3)
    {
        if (_change == 0)
        {
            self.image = UIImageNamedNoCache(@"home_sleep_1_5s.png");
        }
        else if (_change == 1)
        {
            self.image = UIImageNamedNoCache(@"home_sleep_2_5s.png");
        }
        else if (_change == 2)
        {
            self.image = UIImageNamedNoCache(@"home_sleep_3_5s.png");
        }
        else if (_change == 3)
        {
            self.image = UIImageNamedNoCache(@"home_sleep_4_5s.png");
        }
        _change ++;
    }
    else
    {
        _change = 0;
    }
   [self performSelector:@selector(changeImage) withObject:nil afterDelay:0.5];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
