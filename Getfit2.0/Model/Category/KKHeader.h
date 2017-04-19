//
//  KKHeader.h
//  AJBracelet
//
//  Created by zorro on 15/5/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#ifndef AJBracelet_KKHeader_h
#define AJBracelet_KKHeader_h

// 头文件.
#import "Header.h"

#import "UIView+Simple.h"
#import "UIImage+Simple.h"
#import "UIColor+Simple.h"
#import "UIButton+Simple.h"
#import "UILabel+Simple.h"
#import "UIScrollView+Simple.h"
#import "UITextField+Simple.h"

#import "NSDate+Simple.h"
#import "NSObject+Simple.h"
#import "NSString+Simple.h"

#endif

// 宏定义系列.
#define UIImageNamed(string) [UIImage image:string]
#define UIImageNamedNoCache(string) [UIImage imageWithFile:string]
#define UIImageNamedF(string) [UIImage imageNamed:string]

#define UIColorHEX(hexValue) [UIColor colorFromHex:hexValue]
#define UIColorHEXA(hexValue, a) [UIColor colorFromHex:hexValue withAlpha:a]
#define UIColorRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define UIFontSize(size) [UIFont systemFontOfSize:size]
