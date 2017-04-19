//
//  DeviceNavViewController.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceNavViewController : UIViewController

@property (nonatomic, strong) UIView *navBarView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel *tipTitle;

- (void)leftBarButton;

@end
