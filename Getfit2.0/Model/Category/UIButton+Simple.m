//
//  UIButton+Simple.m
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UIButton+Simple.h"

@implementation UIButton (Simple)

- (void)setImagePath:(NSString *)imagePath
{
    [self setImage:[UIImage imageWithPath:imagePath] forState:UIControlStateNormal];
}

- (NSString *)imagePath
{
    return @"";
}

- (void)setImageNormal:(NSString *)imageNormal
{
    [self setImage:[UIImage image:imageNormal] forState:UIControlStateNormal];
}

- (NSString *)imageNormal
{
    return @"";
}

- (void)setImageHighlight:(NSString *)imageHighlight
{
    [self setImage:[UIImage image:imageHighlight] forState:UIControlStateHighlighted];
}

- (NSString *)imageHighlight
{
    return @"";
}

- (void)setImageSelecte:(NSString *)imageSelecte
{
    [self setImage:[UIImage image:imageSelecte] forState:UIControlStateSelected];
}

- (NSString *)imageSelecte
{
    return @"";
}

- (void)setImageDisable:(NSString *)imageDisable
{
    [self setImage:[UIImage image:imageDisable] forState:UIControlStateDisabled];
}

- (NSString *)imageDisable
{
    return @"";
}

- (void)setBgImageNormal:(NSString *)bgImageNormal
{
    [self setBackgroundImage:[UIImage image:bgImageNormal] forState:UIControlStateNormal];
}


- (NSString *)bgImageNormal
{
    return @"";
}

- (void)setBgImageHighlight:(NSString *)bgImageHighlight
{
    [self setBackgroundImage:[UIImage image:bgImageHighlight] forState:UIControlStateHighlighted];
}


- (NSString *)bgImageHighlight
{
    return @"";
}

- (void)setBgImageSelecte:(NSString *)bgImageSelecte
{
    [self setBackgroundImage:[UIImage image:bgImageSelecte] forState:UIControlStateSelected];
}

- (NSString *)bgImageSelecte
{
    return @"";
}

- (void)setBgImageDisable:(NSString *)bgImageDisable
{
    [self setBackgroundImage:[UIImage image:bgImageDisable] forState:UIControlStateDisabled];
}

- (NSString *)bgImageDisable
{
    return @"";
}

// 设置字体大小.
- (void)setFontSize:(CGFloat)size
{
    self.titleLabel.font = [UIFont systemFontOfSize:size];
}

- (CGFloat)fontSize
{
    return 0.0;
}

// 设置标题.
- (void)setTitleNormal:(NSString *)titleNormal
{
    [self setTitle:titleNormal forState:UIControlStateNormal];
}

- (NSString *)titleNormal
{
    return [self titleForState:UIControlStateNormal];
}

- (void)setTitleHighlight:(NSString *)titleHighlight
{
    [self setTitle:titleHighlight forState:UIControlStateHighlighted];
}

- (NSString *)titleHighlight
{
    return [self titleForState:UIControlStateHighlighted];
}

- (void)setTitleSelecte:(NSString *)titleSelecte
{
    [self setTitle:titleSelecte forState:UIControlStateSelected];
}

- (NSString *)titleSelecte
{
    return [self titleForState:UIControlStateSelected];
}

// 设置标题颜色
- (void)setTitleColorNormal:(UIColor *)titleColorNormal
{
    [self setTitleColor:titleColorNormal forState:UIControlStateNormal];
}

- (UIColor *)titleColorNormal
{
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setTitleColorHighlight:(UIColor *)titleColorHighlight
{
    [self setTitleColor:titleColorHighlight forState:UIControlStateHighlighted];
}

- (UIColor *)titleColorHighlight
{
    return [self titleColorForState:UIControlStateHighlighted];
}

- (void)setTitleColorSelecte:(UIColor *)titleColorSelecte
{
    [self setTitleColor:titleColorSelecte forState:UIControlStateSelected];
}

- (UIColor *)titleColorSelecte
{
    return [self titleColorForState:UIControlStateSelected];
}

// 添加方法.
- (void)addTouchUpTarget:(id)object action:(SEL)aSelector
{
    [self addTarget:object action:aSelector forControlEvents:UIControlEventTouchUpInside];
}

+ (UIButton *)simpleWithRect:(CGRect)rect
                   withImage:(NSString *)image
             withSelectImage:(NSString *)selImage
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:UIImageNamedNoCache(image) forState:UIControlStateNormal];
    if (selImage)
    {
        [button setImage:UIImageNamedNoCache(selImage) forState:UIControlStateSelected];
    }
    else
    {
        [button setImage:UIImageNamedNoCache(image) forState:UIControlStateSelected];
    }
    
    return button;
}

+ (UIButton *)simpleWithRect:(CGRect)rect
                   withTitle:(NSString *)title
             withSelectTitle:(NSString *)selTitle
         withBackgroundColor:(UIColor *)backgroundColor

{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = backgroundColor;
    [button setTitle:title forState:UIControlStateNormal];
    if (selTitle)
    {
        [button setTitle:selTitle forState:UIControlStateSelected];
    }
    else
    {
        [button setTitle:title forState:UIControlStateSelected];
    }
    [button setFontSize:14.0];
    
    return button;
}

@end
