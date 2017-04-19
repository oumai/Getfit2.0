//
//  DeviceMainScrollView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTableView.h"
@interface DeviceMainScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DeviceTableView *deviceTableView;

- (void)sCViewWillAppear;

@end
