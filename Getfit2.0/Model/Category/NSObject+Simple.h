//
//  NSObject+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NSObjectSimpleBlock)(id object);

@interface NSObject (Simple)

// 属性列表.
@property (nonatomic, readonly) NSArray *attributeList;

// 获取系统时制信息.
+ (BOOL)isHasAMPMTimeSystem;

// 获取根视图.
+ (UIViewController *)topMostController;

// 延迟调用.
- (void)delayPerformBlock:(NSObjectSimpleBlock)block WithTime:(CGFloat)time;

// 判断文件是否存在.
- (BOOL)completePathDetermineIsThere:(NSString *)path;

+ (NSString *)KKLocalizedString:(NSString *)translation_key;

// 服务器提示错误信息.
- (void)showMessage:(NSInteger)ret;

@end
