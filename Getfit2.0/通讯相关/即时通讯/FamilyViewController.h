//
//  FamilyViewController.h
//  StoryPlayer
//
//  Created by zhanghao on 15/12/4.
//  Copyright © 2015年 zxc. All rights reserved.
//
/*
 1,在APPDelegate的didfinishLauch里面加上[[SPKitExample sharedInstance] callThisInDidFinishLaunching];
 2，包含的库文件：
    UIKit.framework
    AddressBook.framework
    SystemConfiguration.framework
    CoreLocation.framework
    CoreTelephony.framework
    CoreData.framework
    libz.tbd
    libstdc++.6.0.9.tbd
    MobileCoreServices.framework
    ImageIO.framework
    AudioToolbox.framework
    AVFoundation.framework
    AssetsLibrary.framework
 3，登录在loginViewController
 4,聊天UI在即时通讯/MainLogic/SPKitExample.m
 - (void)exampleOpenConversationViewControllerWithConversation:(YWConversation *)aConversation fromNavigationController:(UINavigationController *)aNavigationController
 {
    //在这里更改UI，主界面.m不提供但是UI控件全部暴露、提供接口
 }
 */





#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ZHObject.h"
@interface FamilyViewController : UIViewController

@end
