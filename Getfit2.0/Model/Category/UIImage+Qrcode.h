//
//  UIImage+Qrcode.h
//  AJBracelet
//
//  Created by 黎峰麟 on 15/12/12.
//  Copyright © 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Qrcode)


/**
 *  生成二维码
 *
 *  @param str  字符串生成二维码
 *  @param size 生成图片大小
 *
 */
+ (UIImage *)createQRForString:(NSString *)str withSize:(CGFloat) size;


/**
 *  将生成的二维码染色  RGB 值
 *
 */
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

@end
