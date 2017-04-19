//
//  UITextField+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Simple)

// 简单的创建方法.
+ (UITextField *)simpleWithRect:(CGRect)rect
                withPlaceholder:(NSString *)placeholder;

+ (UITextField *)simpleWithRect:(CGRect)rect
                      withImage:(NSString *)imageString
                withPlaceholder:(NSString *)placeholder
                       withFont:(CGFloat)size;

// 修改提示文本的款式.
- (void)changePlaceholder:(NSString *)placeholder
                withColor:(UIColor *)color
                 withFont:(CGFloat)size;

@end
