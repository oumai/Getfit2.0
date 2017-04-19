//
//  showRemarkView.m
//  Warm
//
//  Created by 黄建华 on 15/8/6.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "showRemarkView.h"

@implementation showRemarkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadViewSetup];
    }
    return self;
}

- (void)loadViewSetup
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, self.width ,200);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate =self;
    _scrollView.contentSize = CGSizeMake(self.width, 0);
    [self addSubview:_scrollView];
    
    _pathBuilderView = [[NeedDrawView alloc] initWithFrame:CGRectMake(31, 30, self.width - 30, 160)];
//    _pathBuilderView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_pathBuilderView];
    [self handleRefreashEvent];
    
    for (int i = 0; i < 7; i++)
    {
        CGFloat width = (self.width )/7.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5 +i *width, 180, width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10.0];
        label.text = [NSString stringWithFormat:@"%d",i * 4];
       // [self addSubview:label];
    }
    
    _endTime = [[NavLabel alloc] initWithFrame:CGRectMake(0, 15, 30, 180)];
    _endTime.textAlignment = NSTextAlignmentRight;
    _endTime.numberOfLines = 30;
    _endTime.text = @"120\n\n\n\n90\n\n\n\n60\n\n\n\n30";
    // [self addSubview:_endTime];
    
    UILabel *titeLabelUnit = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 20)];
    titeLabelUnit.textAlignment = NSTextAlignmentLeft;
    titeLabelUnit.text = KK_Text(@"Times / min");
    titeLabelUnit.textColor = [UIColor whiteColor];
    titeLabelUnit.font =  [UIFont systemFontOfSize:10.0];
    [self addSubview:titeLabelUnit];
    
    for (int i = 0; i < 4; i++)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, i *50 +30, self.width - 30, 0.5)];
        line.backgroundColor = UIColorHEXA(0xffffff, 0.8);
        [self addSubview:line];
        
        _endTime = [[NavLabel alloc] initWithFrame:CGRectMake(line.x - 30, 15, 30, 20)];
        _endTime.textAlignment = NSTextAlignmentRight;
        _endTime.center = CGPointMake(line.x - 30 + 14, line.center.y);
        _endTime.text = [NSString stringWithFormat:@"%d", (4-i) * 30];
        [self addSubview:_endTime];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 20, 0.5, 160)];
    line.backgroundColor = UIColorHEXA(0xffffff, 0.8);
    [self addSubview:line];
    
//    UILabel *timeUnit = [[UILabel alloc] initWithFrame:CGRectMake(0, 200,self.width, 20)];
//    timeUnit.textAlignment = NSTextAlignmentCenter;
//    timeUnit.text = @"Time Duration";
//    timeUnit.textColor = [UIColor whiteColor];
//    timeUnit.font =  [UIFont systemFontOfSize:10.0];
//    [self addSubview:timeUnit];
}

- (void)updateShowView:(NSArray *)array isAnimation:(BOOL)isAnimation
{
    [self handleRefreashEvent];
    [_pathBuilderView UpdateData:array isAnimation:isAnimation];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _pathBuilderView;
}

- (void)handleRefreashEvent
{
    for (UIView *view in [self.pathBuilderView subviews])
    {
        if ([view isKindOfClass:[ShapeView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    [self.pathBuilderView UpdateData:nil isAnimation:NO];
}

@end
