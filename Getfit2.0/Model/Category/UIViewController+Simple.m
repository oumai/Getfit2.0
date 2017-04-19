//
//  UIViewController+Simple.m
//  AJBracelet
//
//  Created by zorro on 15/5/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UIViewController+Simple.h"

@implementation UIViewController (Simple)

- (CGFloat)width
{
    return self.view.width;
}

- (CGFloat)height
{
    return self.view.height;
}

- (CGRect)frame
{
    return self.view.frame;
}

- (CGRect)bounds
{
    return self.view.bounds;
}

- (void)addSubview:(UIView *)subView
{
    [self.view addSubview:subView];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}

- (UIColor *)backgroundColor
{
    return self.view.backgroundColor;
}

@end
