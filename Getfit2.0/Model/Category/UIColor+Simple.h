//
//  UIColor+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Simple)

// 返回一个十六进制表示的颜色: 0xFF0000
+ (UIColor *)colorFromHex:(int)hex;
+ (UIColor *)colorFromHex:(int)hex withAlpha:(CGFloat)alpha;

@end
