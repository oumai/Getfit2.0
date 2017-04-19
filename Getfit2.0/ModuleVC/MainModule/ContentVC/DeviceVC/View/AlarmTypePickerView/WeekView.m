//
//  WeekView.m
//  ZKKWaterHeater
//
//  Created by zorro on 15-1-5.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define WeekView_Button_Tag 3333
#import "WeekView.h"

@implementation WeekView
- (instancetype)initWithFrame:(CGRect)frame withWeekBlock:(WeekViewBlock)block
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.backgroundColor = UIColorRGB(108, 108, 108);
        _weekBlock = block;
        _selArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self loadButtons];
    }
    return self;
}

- (void)loadButtons
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, 42, 120, 20)];
    title.text = KK_Text(@"Please remind me during this time");
    title.font = [UIFont systemFontOfSize:11.0];
    title.textColor = [UIColor whiteColor];
    [self addSubview:title];
    
    NSArray *titleArray = @[KK_Text(@"Mon"),
                            KK_Text(@"Tue"),
                            KK_Text(@"Wed"),
                            KK_Text(@"Thu"),
                            KK_Text(@"Fri"),
                            KK_Text(@"Sat"),
                            KK_Text(@"Sun")];
    CGFloat buttonWidth = (self.frame.size.width - 8 * 5) / 7;
    
    for (int i = 1; i < 8; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((i - 1) * (buttonWidth +5) + 5, 65, buttonWidth, buttonWidth)];
        button.tag = 10000 + i;
        button.selected = NO;
        button.tag = WeekView_Button_Tag + i;
        button.backgroundColor = UIColorHEX(0x363636);
        [button setTitle:titleArray[i - 1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        button.layer.cornerRadius = buttonWidth/2;
        button.layer.masksToBounds = YES;
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)clickButton:(UIButton *)button
{
    if (button.selected)
    {
        button.selected = NO;
        button.backgroundColor = UIColorHEX(0x363636);

        [_selArray removeObject:[NSString stringWithFormat:@"%d",(button.tag - WeekView_Button_Tag)]];
    }
    else
    {
        button.selected = YES;
        button.backgroundColor = UIColorHEX(0xef5543);

        [_selArray addObject:[NSString stringWithFormat:@"%d",(button.tag - WeekView_Button_Tag)]];
    }
    
    if (_weekBlock)
    {
        _weekBlock(self);
    }
}

- (void)updateSelButtonForWeekView:(NSArray *)array
{
    [_selArray addObjectsFromArray:array];
    
    for (int i = 1; i < 8; i++)
    {
        UIButton *button = (UIButton *)[self viewWithTag:WeekView_Button_Tag + i];
        
        if ([array containsObject:[NSString stringWithFormat:@"%d",(button.tag - WeekView_Button_Tag)]])
        {
            button.selected = YES;
            button.backgroundColor = UIColorHEX(0xef5543);
        }
    }
}

@end
