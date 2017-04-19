//
//  UILabel+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Simple)

+ (UILabel *)simpleWithRect:(CGRect)rect;

+ (UILabel *)simpleWithRect:(CGRect)rect
              withAlignment:(NSTextAlignment)alignment
               withFontSize:(CGFloat)size
                   withText:(NSString *)text
              withTextColor:(UIColor *)textColor;

- (CGSize)estimateUISizeByHeight:(CGFloat)height;

@end
