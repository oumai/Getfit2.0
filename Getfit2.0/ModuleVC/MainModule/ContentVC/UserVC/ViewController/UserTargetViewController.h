//
//  TargetViewController.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceNavViewController.h"

@interface UserTargetViewController : DeviceNavViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *stepTargetLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UIScrollView *stepScrollView;
@property (nonatomic, strong) UIScrollView *sleepScrollView;

@end
