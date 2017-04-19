//
//  UIColor+Simple.m
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UIColor+Simple.h"

@implementation UIColor (Simple)

+ (UIColor *)colorFromHex:(int)hex
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)colorFromHex:(int)hex withAlpha:(CGFloat)alpha
{
    return [[UIColor colorFromHex:hex] colorWithAlphaComponent:alpha];
}

@end
