//
//  UIView+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

CGRect FitScreenRect(CGRect ip4, CGRect ip5, CGRect ip6, CGRect ip6p, CGRect ipad);
CGRect FitSimpleRect(CGRect ip, CGRect ipad);

id FitScreenString(id ip4, id ip5, id ip6, id ip6p, id ipad);
id FitSimpleString(id ip, id ipad);

CGFloat FitScreenNumber(CGFloat ip4, CGFloat ip5, CGFloat ip6, CGFloat ip6p, CGFloat ipad);
CGFloat FitSimpleNumber(CGFloat ip, CGFloat ipad);

typedef void(^UIViewSimpleBlock)(UIView *aView, id object);

@interface UIView (Simple)

// 下面的属性既有set也有get方法
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIImage *image;

// 下面的属性只具备get方法
@property (nonatomic, assign, readonly) CGFloat totalWidth;
@property (nonatomic, assign, readonly) CGFloat totalHeight;
@property (nonatomic, assign, readonly) CGFloat halfWidth;
@property (nonatomic, assign, readonly) CGFloat halfHeight;

// 下面的属性只具备set方法
@property (nonatomic, strong) NSString *imageNamed; // 图片名字 工程的
@property (nonatomic, strong) NSString *imagePath;  // 完整路径的

// 移动所有的子视图
- (void)removeAllSubviews;

// 移动所有的手势
- (void)removeAllGestureRecognizers;

// 简单的淡入淡出动画.
- (void)animationWithViewTransition:(UIViewSimpleBlock)animationBlock;

// 通过路径绘制的方式添加圆角 可以给任意角度添加圆角
// rectCorner 为圆角的位置 size为角度的大小, 可以理解为半径
- (void)addRectCorner:(UIRectCorner)rectCorner withSize:(CGSize)size;

// 添加圆角, 是四周的 color 为边框颜色 width 为边框的宽度.
- (void)addCorner:(UIColor *)color withWidth:(CGFloat)width;

@end
