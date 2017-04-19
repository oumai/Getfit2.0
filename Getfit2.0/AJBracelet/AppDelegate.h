//
//  AppDelegate.h
//  AJBracelet
//
//  Created by zorro on 15/5/25.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlVC.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ControlVC *ContenVc;


- (void)pushEnterVc;
- (void)pushContenVc;
- (void)pushChatVc;
- (void)pushChatLoginVc;
- (void)pushHeartVc;

@end

