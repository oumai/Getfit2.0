//
//  UIScrollView+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Simple)

+ (UIScrollView *)simpleWithRect:(CGRect)rect
                        withShow:(BOOL)show
                      withBounce:(BOOL)bounce;

@end


@interface UITableView (Simple)

+ (UITableView *)simpleWithRect:(CGRect)rect
                   withDelegate:(id)object;

@end