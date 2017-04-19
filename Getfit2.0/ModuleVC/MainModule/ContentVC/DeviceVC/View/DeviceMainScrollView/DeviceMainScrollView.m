//
//  DeviceMainScrollView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceMainScrollView.h"
#import "DeviceUpdateViewController.h"

@implementation DeviceMainScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadScView];
        [self loadLeftView];
    }
    
    return self;
}

- (void)loadScView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, self.width ,self.height);
    _scrollView.contentSize = CGSizeMake(self.width*2, 0);
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = NO;
   // [self addSubview:_scrollView];
}

- (void)loadLeftView
{
    _deviceTableView = [[DeviceTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:_deviceTableView];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    arr = [UserInfoHelper sharedInstance].userModel.functionList;
    _deviceTableView.deviceFunctionList = [[NSArray alloc] initWithObjects:KK_Text(@"Call Alert"),
                                           KK_Text(@"Sedentary Alert"),
                                           KK_Text(@"Alarm Alert"),
                                           KK_Text(@"Photograph"),
                                           KK_Text(@"Anti-lost Alert"),
                                           KK_Text(@"Remind drink"),
                                           KK_Text(@"Turn the hand"),
                                           KK_Text(@"SMS Notification"),
                                           nil];

    //  寻找手机和通知提醒去掉
    // KK_Text(@"Find phone"), KK_Text(@"Notice reminder")

    // KK_Text(@"Device Name"),

    [_deviceTableView updateTableView];
}

- (void)sCViewWillAppear
{
   // [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
