//
//  ShareSDKHelper.h
//  AJBracelet
//
//  Created by zorro on 16/4/8.
//  Copyright © 2016年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareSDKHelper : NSObject

+ (void)initLoad;
+ (void)shareContentWithIndex:(NSInteger)index view:(UIView *)view image:(NSData *)image;

@end
