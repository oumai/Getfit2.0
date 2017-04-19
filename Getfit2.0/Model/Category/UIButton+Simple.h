//
//  UIButton+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Simple)

// 以下有set方法 没有get方法. 即时返回也是无意义的... 当然也可以用运行时方法添加 暂时无需要, 需要的时候也可以进行动态添加.
// 完整路径设置背景图片
@property (nonatomic, strong) NSString *imagePath;

// 设置背景图片
@property (nonatomic, strong) NSString *imageNormal;
@property (nonatomic, strong) NSString *imageHighlight;
@property (nonatomic, strong) NSString *imageSelecte;
@property (nonatomic, strong) NSString *imageDisable;

@property (nonatomic, strong) NSString *bgImageNormal;
@property (nonatomic, strong) NSString *bgImageHighlight;
@property (nonatomic, strong) NSString *bgImageSelecte;
@property (nonatomic, strong) NSString *bgImageDisable;

@property (nonatomic, assign) CGFloat fontSize;

// 既有set 也有get方法
// 设置标题
@property (nonatomic, strong) NSString *titleNormal;
@property (nonatomic, strong) NSString *titleHighlight;
@property (nonatomic, strong) NSString *titleSelecte;

// 设置标题颜色
@property (nonatomic, strong) UIColor *titleColorNormal;
@property (nonatomic, strong) UIColor *titleColorHighlight;
@property (nonatomic, strong) UIColor *titleColorSelecte;

// 默认添加 UIControlEventTouchUpInside
- (void)addTouchUpTarget:(id)object action:(SEL)aSelector;

+ (UIButton *)simpleWithRect:(CGRect)rect
                   withImage:(NSString *)image
             withSelectImage:(NSString *)selImage;

+ (UIButton *)simpleWithRect:(CGRect)rect
                   withTitle:(NSString *)title
             withSelectTitle:(NSString *)selTitle
         withBackgroundColor:(UIColor *)backgroundColor;

@end
