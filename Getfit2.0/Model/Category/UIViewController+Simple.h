//
//  UIViewController+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Simple)

// 只能读取
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign, readonly) CGRect frame;
@property (nonatomic, assign, readonly) CGRect bounds;

// 设置背景色
@property (nonatomic, strong) UIColor *backgroundColor;

// 简略的直接添加视图
- (void)addSubview:(UIView *)subView;

@end
