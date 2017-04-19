//
//  UIView+Simple.m
//  AJBracelet
//
//  Created by zorro on 15/5/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UIView+Simple.h"

@implementation UIView (Simple)

CGRect FitScreenRect(CGRect ip4, CGRect ip5, CGRect ip6, CGRect ip6p, CGRect ipad)
{
    if (KK_PadDevice)
    {
        return ipad;
    }
    else if (KK_IpFourDevice)
    {
        return ip4;
    }
    else if (KK_IpFiveDevice)
    {
        return ip5;
    }
    else if (KK_IpSixDevice)
    {
        return ip6;
    }
    else if (KK_IpSixPDevice)
    {
        return ip6p;
    }
    else
    {
        return ipad;
    }
}

CGRect FitSimpleRect(CGRect ip, CGRect ipad)
{
    if (KK_PadDevice)
    {
        return ipad;
    }
    else
    {
        return ip;
    }
}

id FitScreenString(id ip4, id ip5, id ip6, id ip6p, id ipad)
{
    if (KK_PadDevice)
    {
        return ipad;
    }
    else if (KK_IpFourDevice)
    {
        return ip4;
    }
    else if (KK_IpFiveDevice)
    {
        return ip5;
    }
    else if (KK_IpSixDevice)
    {
        return ip6;
    }
    else if (KK_IpSixPDevice)
    {
        return ip6p;
    }
    else
    {
        return ipad;
    }
}

id FitSimpleString(id ip, id ipad)
{
    if (KK_PadDevice)
    {
        return ipad;
    }
    else
    {
        return ip;
    }
}

CGFloat FitScreenNumber(CGFloat ip4, CGFloat ip5, CGFloat ip6, CGFloat ip6p, CGFloat ipad)
{
    if (KK_PadDevice)
    {
        return ipad;
    }
    else if (KK_IpFourDevice)
    {
        return ip4;
    }
    else if (KK_IpFiveDevice)
    {
        return ip5;
    }
    else if (KK_IpSixDevice)
    {
        return ip6;
    }
    else if (KK_IpSixPDevice)
    {
        return ip6p;
    }
    else
    {
        return ipad;
    }
    
}

CGFloat FitSimpleNumber(CGFloat ip, CGFloat ipad)
{
    if (KK_PadDevice)
    {
        return ipad;
    }
    else
    {
        return ip;
    }
}

// set and get
- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

// 只有get
- (CGFloat)totalWidth
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTotalWidth:(CGFloat)totalWidth
{
    
}

- (CGFloat)totalHeight
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTotalHeight:(CGFloat)totalHeight
{
    
}

- (CGFloat)halfWidth
{
    return self.width / 2.0;
}

- (void)setHalfWidth:(CGFloat)width
{
    
}

- (CGFloat)halfHeight
{
    return self.height / 2.0;
}

- (void)setHalfHeight:(CGFloat)height
{
    
}

// 只有set
- (void)setImage:(UIImage *)image
{
    self.layer.contents = (id)image.CGImage;
}

- (UIImage *)image
{
    return [UIImage imageWithCGImage:(__bridge CGImageRef)(self.layer.contents)];
}

- (void)setImageNamed:(NSString *)imageNamed
{
    self.layer.contents = (id)UIImageNamedNoCache(imageNamed).CGImage;
}

- (void)setImageNamedFile:(NSString *)imagePath
{
    self.layer.contents = (id)[UIImage imageWithPath:imagePath].CGImage;
}

- (NSString *)imageNamed
{
    return @"";
}

- (NSString *)imagePath
{
    return @"";
}

// 移动所有的子视图
- (void)removeAllSubviews
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

// 移动所有的手势
- (void)removeAllGestureRecognizers
{
    for (UIGestureRecognizer *ges in self.gestureRecognizers)
    {
        [self removeGestureRecognizer:ges];
    }
}

- (void)addRectCorner:(UIRectCorner)rectCorner withSize:(CGSize)size
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:rectCorner
                                                         cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addCorner:(UIColor *)color withWidth:(CGFloat)width
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.width / 2;
    UIColor *currentColor = color ? color : self.backgroundColor;
    self.layer.borderColor = currentColor.CGColor;
    self.layer.borderWidth = width;
}

// view的切换
- (void)animationWithViewTransition:(UIViewSimpleBlock)animationBlock
{
    [UIView transitionWithView:self
                      duration:0.35
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                    animations:^{
                        if (animationBlock)
                        {
                            animationBlock(self, nil);
                        }
                    } completion:nil];
}

@end
