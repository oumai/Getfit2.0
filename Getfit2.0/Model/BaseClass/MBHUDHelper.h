//
//  MBHUDHelper.h
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MBHUDHelper : NSObject

/**
 * 显示MBProgressHUD指示器
 * api parameters 说明
 * aTitle 标题
 * aMsg 信息
 * aImg 图片, 为nil时,只显示标题
 * d 延时消失时间, 为0时需要主动隐藏
 * blockE 执行的代码快
 * blockF 结束时的代码块
 * 执行时改变hub需要调用Common_MainFun(aFun)
 */
#define HIDDENMBProgressHUD [MBHUDHelper hiddenMBProgressHUD];
+ (void)hiddenMBProgressHUD;

+ (MBProgressHUD *)MBProgressHUD;

#define SHOWMBProgressHUD(aTitle, aMsg, aImg, aDimBG, aDelay) [MBHUDHelper showMBProgressHUDTitle:aTitle msg:aMsg image:aImg dimBG:aDimBG delay:aDelay];
+ (MBProgressHUD *)showMBProgressHUDTitle:(NSString *)aTitle
                                      msg:(NSString *)aMsg
                                    image:(UIImage *)aImg
                                    dimBG:(BOOL)dimBG
                                    delay:(float)d;

#define SHOWMBProgressHUDIndeterminate(aTitle, aMsg, aDimBG) [MBHUDHelper showMBProgressHUDModeIndeterminateTitle:aTitle msg:aMsg dimBG:aDimBG];
+ (MBProgressHUD *)showMBProgressHUDModeIndeterminateTitle:(NSString *)aTitle
                                                       msg:(NSString *)aMsg
                                                     dimBG:(BOOL)dimBG;

+ (MBProgressHUD *)showMBProgressHUDTitle:(NSString *)aTitle
                                      msg:(NSString *)aMsg
                                    dimBG:(BOOL)dimBG
                             executeBlock:(void(^)(MBProgressHUD *hud))blockE
                              finishBlock:(void(^)(void))blockF;

@end
