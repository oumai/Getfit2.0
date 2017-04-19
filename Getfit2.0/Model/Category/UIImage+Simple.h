//
//  UIImage+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Simple)

// 直接加载工程的图片 适配不同的系统因渲染问题导致有时看不到图片 同时也是缓存的方式.
+ (UIImage *)image:(NSString *)resourceName;

// 将图片进行缩放
- (UIImage *)imageScaleToSize:(CGSize)size;

// 将图片拉伸 imageName 将要拉伸的图片名字
+ (UIImage *)imageStretch:(NSString *)imageName;

// 根据工程文件的图片直接加载 非缓存的方式
+ (UIImage *)imageWithFile:(NSString *)fileString;

// 根据完整的路径加载图片 非缓存的方式
+ (UIImage *)imageWithPath:(NSString *)fileString;

// 高斯模糊 radius 模糊的范围
- (UIImage *)imageWithStackBlur:(NSUInteger)radius;

// 根据颜色绘制图片
+ (UIImage *)imageWithColor:(UIColor *)color;


- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

- (UIImage *)rotatedByDegrees:(CGFloat)degrees;

- (UIImage *)croppedImage:(CGRect)bounds;
@end
