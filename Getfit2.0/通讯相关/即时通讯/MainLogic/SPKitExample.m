//
//  SPKitExample.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPKitExample.h"

#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOUIModule/YWUIFMWK.h>

#import "SPUtil.h"
#import "ZHObject.h"
#import "CustomTopView.h"
#import "SPInputViewPluginCustomize.h"

#import "SPBaseBubbleChatViewCustomize.h"
#import "SPBubbleViewModelCustomize.h"
#if __has_include("SPTribeConversationViewController.h")
/// Demo中使用了继承方式，实现群聊聊天页面。
#import "SPTribeConversationViewController.h"
#endif
#import <WXOUIModule/YWIndicator.h>
#import <objc/runtime.h>
#import <WXOpenIMSDKFMWK/YWTribeSystemConversation.h>

#import <objc/runtime.h>

#warning IF YOU NEED CUSTOMER SERVICE USER TRACK, REMOVE THE COMMENT '//' TO IMPORT THE FRAMEWORK
/// 如果需要客服跟踪用户操作轨迹的功能，你可以取消以下行的注释，引入YWExtensionForCustomerServiceFMWK.framework
//#import <YWExtensionForCustomerServiceFMWK/YWExtensionForCustomerServiceFMWK.h>

@interface SPKitExample ()

/**
 *  是否已经预登录进入
 */
- (BOOL)exampleIsPreLogined;

@end

@implementation SPKitExample


#pragma mark - properties

- (id<UIApplicationDelegate>)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

- (UIWindow *)rootWindow
{
    UIWindow *result = nil;
    
    do {
        if ([self.appDelegate respondsToSelector:@selector(window)]) {
            result = [self.appDelegate window];
        }
        
        if (result) {
            break;
        }
    } while (NO);
    
    
    NSAssert(result, @"如果在您的App中出现这个断言失败，您需要检查- [SPKitExample rootWindow]中的实现，是否符合您的App结构");
    
    return result;
    
}

- (UINavigationController *)rootNavigationController
{
    UINavigationController *result = [self.rootWindow.rootViewController isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self.rootWindow.rootViewController : nil;
    
    NSAssert(result, @"如果在您的App中出现这个断言失败，您需要检查- [SPKitExample rootNavigationController]中的实现，是否符合您的App结构");
    
    return result;
}

#pragma mark - private methods


#pragma mark - public methods

+ (instancetype)sharedInstance
{
    static SPKitExample *sExample = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sExample = [[SPKitExample alloc] init];
    });
    
    return sExample;
}

#pragma mark - SDK Life Control
/**
 *  程序完成启动，在appdelegate中的 application:didFinishLaunchingWithOptions:一开始的地方调用
 */
- (void)callThisInDidFinishLaunching
{
    if ([self exampleInit]) {
        // 在IMSDK截获到Push通知并需要您处理Push时，IMSDK会自动调用此回调
        [self exampleHandleAPNSPush];
        // 自定义全局导航栏
//        [self exampleCustomGlobleNavigationBar];
        
    } else {
        /// 初始化失败，需要提示用户
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK初始化失败, 请检查网络后重试" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil];
//        [av show];
    }
}

/**
 *  用户在应用的服务器登录成功之后，向云旺服务器登录之前调用
 *  @param ywLoginId, 用来登录云旺IMSDK的id
 *  @param password, 用来登录云旺IMSDK的密码
 *  @param aSuccessBlock, 登陆成功的回调
 *  @param aFailedBlock, 登录失败的回调
 */
- (void)callThisAfterISVAccountLoginSuccessWithYWLoginId:(NSString *)ywLoginId passWord:(NSString *)passWord preloginedBlock:(void(^)())aPreloginedBlock successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock
{
    /// 监听连接状态
    [self exampleListenConnectionStatus];
    
    /// 设置头像和昵称
    [self exampleSetAvatarStyle];
    [self exampleSetProfile];
    
    /// 设置最大气泡宽度
    [self exampleSetMaxBubbleWidth];
    
    /// 监听新消息
    [self exampleListenNewMessage];

    // 设置提示
    [self exampleSetNotificationBlock];
    
    /// 监听群邀请
    [self exampleListenTribeInvitation];

    /// 监听头像点击事件
    [self exampleListenOnClickAvatar];
    
    /// 监听链接点击事件
    [self exampleListenOnClickUrl];
    
    /// 监听预览大图事件
    [self exampleListenOnPreviewImage];
    
    /// 自定义皮肤
    [self exampleCustomUISkin];
    
    /// 开启群@消息功能
    [self exampleEnableTribeAtMessage];
    
    if ([ywLoginId length] > 0 && [passWord length] > 0) {
        /// 预登陆
        [self examplePreLoginWithLoginId:ywLoginId successBlock:aPreloginedBlock];
        
        /// 真正登录
        [self exampleLoginWithUserID:ywLoginId password:passWord successBlock:aSuccessBlock failedBlock:aFailedBlock];
    } else {
        if (aFailedBlock) {
            aFailedBlock([NSError errorWithDomain:YWLoginServiceDomain code:YWLoginErrorCodePasswordError userInfo:nil]);
        }
    }
}

/**
 *  用户即将退出登录时调用
 */
- (void)callThisBeforeISVAccountLogout
{
    [self exampleLogout];
}

#pragma mark - basic

/**
 *  初始化示例代码
 */
- (BOOL)exampleInit;
{
    /// 设置环境
    [[YWAPI sharedInstance] setEnvironment:YWEnvironmentRelease];
    /// 开启日志
    [[YWAPI sharedInstance] setLogEnabled:NO];
    
    NSLog(@"SDKVersion:%@", [YWAPI sharedInstance].YWSDKIdentifier);
    
    NSError *error = nil;
    
    /// 异步初始化IM SDK
#warning TODO: CHANGE TO YOUR AppKey
    /// 更换成你自己的AppKey
    [[YWAPI sharedInstance] syncInitWithOwnAppKey:@"23283000" getError:&error];
    
    if (error.code != 0 && error.code != YWSdkInitErrorCodeAlreadyInited) {
        /// 初始化失败
        return NO;
    } else {
        if (error.code == 0) {
            /// 首次初始化成功
            /// 获取一个IMKit并持有
            self.ywIMKit = [[YWAPI sharedInstance] fetchIMKitForOpenIM];
            [[self.ywIMKit.IMCore getContactService] setEnableContactOnlineStatus:YES];
        } else {
            /// 已经初始化
        }
        return YES;
    }
}

/**
 *  登录的示例代码
 */
- (void)exampleLoginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock
{
    aSuccessBlock = [aSuccessBlock copy];
    aFailedBlock = [aFailedBlock copy];
    
    /// 登录之前，先告诉IM如何获取登录信息。
    /// 当IM向服务器发起登录请求之前，会调用这个block，来获取用户名和密码信息。
    [[self.ywIMKit.IMCore getLoginService] setFetchLoginInfoBlock:^(YWFetchLoginInfoCompletionBlock aCompletionBlock) {
        aCompletionBlock(YES, aUserID, aPassword, nil, nil);
    }];
    
    /// 发起登录
    [[self.ywIMKit.IMCore getLoginService] asyncLoginWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
        if (aError.code == 0 || [[self.ywIMKit.IMCore getLoginService] isCurrentLogined]) {
            /// 登录成功
#ifdef DEBUG
            NSLog(@"登录成功");
//            [[SPUtil sharedInstance] showNotificationInViewController:self.rootWindow.rootViewController title:@"登录成功" subtitle:nil type:SPMessageNotificationTypeSuccess];
#endif
            
            if (aSuccessBlock) {
                aSuccessBlock();
            }
        } else {
            /// 登录失败
            [[SPUtil sharedInstance] showNotificationInViewController:self.rootWindow.rootViewController title:@"登录失败" subtitle:aError.description type:SPMessageNotificationTypeError];
            
            if (aFailedBlock) {
                aFailedBlock(aError);
            }
        }
    }];
}

/**
 *  预登陆
 */
- (void)examplePreLoginWithLoginId:(NSString *)loginId successBlock:(void(^)())aPreloginedBlock
{
    /// 预登录
    if ([[self.ywIMKit.IMCore getLoginService] preLoginWithPerson:[[YWPerson alloc] initWithPersonId:loginId]]) {
        /// 预登录成功，直接进入页面,这里可以打开界面
        if (aPreloginedBlock) {
            aPreloginedBlock();
        }
    }
}

/**
 *  是否已经预登录进入
 */
- (BOOL)exampleIsPreLogined
{
#warning TODO: NEED TO CHANGE TO YOUR JUDGE METHOD
    /// 这个是Demo中判断是否已经进入IM主页面的方法，你需要修改成你自己的方法
    return self.rootNavigationController.viewControllers.count > 0;
}

/**
 *  监听连接状态
 */
- (void)exampleListenConnectionStatus
{
    __weak typeof(self) weakSelf = self;
    [[self.ywIMKit.IMCore getLoginService] addConnectionStatusChangedBlock:^(YWIMConnectionStatus aStatus, NSError *aError) {
        if (aStatus == YWIMConnectionStatusForceLogout || aStatus == YWIMConnectionStatusMannualLogout || aStatus == YWIMConnectionStatusAutoConnectFailed) {
            /// 手动登出、被踢、自动连接失败，都退出到登录页面
            if (aStatus != YWIMConnectionStatusMannualLogout) {
                [YWIndicator showTopToastTitle:@"云旺" content:@"退出登录" userInfo:nil withTimeToDisplay:2 andClickBlock:nil];
            }
            [[weakSelf rootNavigationController] popToRootViewControllerAnimated:YES];
        }
    } forKey:[self description] ofPriority:YWBlockPriorityDeveloper];
}


/**
 *  注销的示例代码
 */
- (void)exampleLogout
{
    [[self.ywIMKit.IMCore getLoginService] asyncLogoutWithCompletionBlock:NULL];
}

#pragma mark - abilities

- (void)exampleSetAvatarStyle
{
    [self.ywIMKit setAvatarImageViewCornerRadius:4.f];
    [self.ywIMKit setAvatarImageViewContentMode:UIViewContentModeScaleAspectFill];
}

- (void)exampleSetProfile
{
#warning TODO: JUST COMMENT OUT THE FOLLOWING CODE IF YOU HAVE IMPORTED USER PROFILE INTO IM SERVER
    /// 如果你已经将所有的用户Profile都导入到了IM服务器，则可以直接注释掉下面setFetchProfileBlockV2:函数。
    /// 如果你使用了客服功能，或者你还没有将用户Profile导入到IM服务器，则需要参考下面setFetchProfileBlockV2:中的实现，并修改成你自己获取用户Profile的方式
    [self.ywIMKit setFetchProfileBlockV2:^(YWPerson *aPerson, YWFetchProfileProgressBlock aProgressBlock, YWFetchProfileCompletionBlock aCompletionBlock) {
        if (!aPerson.personId) {
            return;
        }
        
        /// Demo中模拟了异步获取Profile的过程，你需要根据实际情况，从你的服务器获取用户profile
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:aPerson progress:aProgressBlock completion:aCompletionBlock];
    }];
    
    /// IM会在需要显示群聊profile时，调用这个block，来获取群聊的头像和昵称
    [self.ywIMKit setFetchTribeProfileBlock:^(YWTribe *tribe, YWFetchTribeProfileCompletionBlock aCompletionBlock) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#warning TODO: CHANGE TO YOUR ACTUAL GETTING Tribe Profile METHOD
            /// 用2秒钟的网络延迟，模拟从网络获取群头像
            NSString *name = tribe.tribeName;
            UIImage *avatar = nil;
            if (tribe.tribeType == YWTribeTypeMultipleChat) {
                avatar = [UIImage imageNamed:@"demo_discussion"];
            }
            else {
                avatar = [UIImage imageNamed:@"demo_group_120"];
            }

            aCompletionBlock(YES, tribe, name, avatar);
        });
    }];
    
    /// IM会在显示自定义会话时，调用此block
    [self.ywIMKit setFetchCustomProfileBlock:^(YWConversation *conversation, YWFetchCustomProfileCompletionBlock aCompletionBlock) {
#warning TODO: CHANGE TO YOUR ACTUAL GETTING Custom Conversation Profile METHOD
        if (aCompletionBlock) {

            if ([conversation.conversationId isEqualToString:SPTribeInvitationConversationID]) {
                aCompletionBlock(YES, conversation, @"群系统信息", [UIImage imageNamed:@"demo_group_120"]);
            }
            else {
                aCompletionBlock(YES, conversation, @"自定义会话和置顶功能！", [UIImage imageNamed:@"input_plug_ico_hi_nor"]);
            }
        }
    }];
}


#pragma mark - ui pages

/**
 *  创建会话列表页面
 */
- (YWConversationListViewController *)exampleMakeConversationListControllerWithSelectItemBlock:(YWConversationsListDidSelectItemBlock)aSelectItemBlock
{
    YWConversationListViewController *result = [self.ywIMKit makeConversationListViewController];
    
    [result setDidSelectItemBlock:aSelectItemBlock];
    
    return result;
}

/**
 *  打开某个会话
 */
- (void)exampleOpenConversationViewControllerWithConversation:(YWConversation *)aConversation fromNavigationController:(UINavigationController *)aNavigationController
{
    __block YWConversationViewController *alreadyController = nil;
    [aNavigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[YWConversationViewController class]]) {
            YWConversationViewController *c = obj;
            
            if (aConversation.conversationId && [c.conversation.conversationId isEqualToString:aConversation.conversationId]) {
                alreadyController = c;
                *stop = YES;
            }
        }
    }];

    if (alreadyController) {
        /// 必须判断当前是否已有该会话，如果有，则直接显示已有会话
        /// @note 目前IMSDK不允许同时存在两个相同会话的Controller
        [aNavigationController popToViewController:alreadyController animated:YES];
        [aNavigationController setNavigationBarHidden:NO];
        
        alreadyController.messageInputView.hidden = YES;
        alreadyController.tableView.frame = alreadyController.view.bounds;
        
        
        return;
    } else {
        YWConversationViewController *conversationController = nil;
        
#if __has_include("SPTribeConversationViewController.h")
        /// Demo中使用了继承方式，实现群聊聊天页面。
        if ([aConversation isKindOfClass:[YWTribeConversation class]]) {
            conversationController = [SPTribeConversationViewController makeControllerWithIMKit:self.ywIMKit
                                                                                   conversation:aConversation];
            [self.ywIMKit addDefaultInputViewPluginsToMessagesListController:conversationController];
            
            conversationController.messageInputView.hidden = YES;
            conversationController.tableView.frame = CGRectMake(0, 0, 320, 536);
        }
#endif
        if (conversationController == nil) {
            conversationController = [self.ywIMKit makeConversationViewControllerWithConversationId:aConversation.conversationId];
#warning IF YOU NEED CUSTOMER SERVICE USER TRACK, REMOVE THE COMMENT '//' AND CHANGE THE ywcsTrackTitle OR ywcsUrl PROPERTIES
            /// 如果需要客服跟踪用户操作轨迹的功能，你可以取消以下行的注释，引入YWExtensionForCustomerServiceFMWK.framework，并并且修改相应的属性
            //            conversationController.ywcsTrackTitle = @"聊天页面";
        }
#warning IF YOU NEED CUSTOM NAVIGATION TITLE OF YWCONVERSATIONVIEWCONTROLLER
        //如果需要自定义聊天页面标题，可以取消以下行的注释，注意，这将不再显示在线状态和输入状态
//        if ([aConversation isKindOfClass:[YWP2PConversation class]] && [((YWP2PConversation *)aConversation).person.personId isEqualToString:@"云大旺"]) {
//            conversationController.disableTitleAutoConfig = YES;
//            conversationController.title = @"自定义标题";
//
//        }
        
        
        __weak typeof(conversationController) weakController = conversationController;
        [conversationController setViewDidLoadBlock:^{
            
            CustomTopView *custom = [[NSBundle mainBundle]loadNibNamed:@"CustomTopView" owner:self options:nil].lastObject;
            custom.frame = CGRectMake(0, 0, screenWidth, 64);
            custom.controller = weakController;
            custom.backgroundColor = KK_MainColor;
            custom.topTitleLabel.text = KK_Text(@"Notice");
            custom.infoLabel.titleNormal = KK_Text(@"Detail");
            weakController.customTopView = custom;

            //为1就是群主
            BOOL isManager = [[NSUserDefaults standardUserDefaults] integerForKey:@"is_manager"];
            weakController.messageInputView.hidden = !isManager;
            
            if (!isManager) {
                weakController.messageInputView.hidden = YES;
                CGSize size = [UIScreen mainScreen].bounds.size;
                CGFloat height = size.height;
                weakController.tableView.frame = CGRectMake(0, 0, size.width, height + 40);
            }
        }];
        
        [conversationController setViewWillAppearBlock:^(BOOL aAnimated) {
            [weakController.navigationController setNavigationBarHidden:YES animated:NO];
        }];
        
        [aNavigationController pushViewController:conversationController animated:YES];
    }
}

///**
// *  打开某个会话
// */
//- (void)exampleOpenConversationViewControllerWithConversation:(YWConversation *)aConversation fromNavigationController:(UINavigationController *)aNavigationController
//{
//    __block YWConversationViewController *alreadyController = nil;
//    [aNavigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isKindOfClass:[YWConversationViewController class]]) {
//            YWConversationViewController *c = obj;
//            
//            if (aConversation.conversationId && [c.conversation.conversationId isEqualToString:aConversation.conversationId]) {
//                alreadyController = c;
//                *stop = YES;
//            }
//        }
//    }];
//    
//    if (alreadyController) {
//        /// 必须判断当前是否已有该会话，如果有，则直接显示已有会话
//        /// @note 目前IMSDK不允许同时存在两个相同会话的Controller
//        [aNavigationController popToViewController:alreadyController animated:YES];
//        [aNavigationController setNavigationBarHidden:NO];
//        return;
//    } else {
//        YWConversationViewController *conversationController = nil;
//        
////#if __has_include("SPTribeConversationViewController.h")
////        /// Demo中使用了继承方式，实现群聊聊天页面。
////        if ([aConversation isKindOfClass:[YWTribeConversation class]]) {
////            conversationController = [SPTribeConversationViewController makeControllerWithIMKit:self.ywIMKit
////                                                                                   conversation:aConversation];
////            [self.ywIMKit addDefaultInputViewPluginsToMessagesListController:conversationController];
////        }
////#endif
//        
//        if (conversationController == nil) {
//            conversationController = [self.ywIMKit makeConversationViewControllerWithConversationId:aConversation.conversationId];
//#warning IF YOU NEED CUSTOMER SERVICE USER TRACK, REMOVE THE COMMENT '//' AND CHANGE THE ywcsTrackTitle OR ywcsUrl PROPERTIES
//            /// 如果需要客服跟踪用户操作轨迹的功能，你可以取消以下行的注释，引入YWExtensionForCustomerServiceFMWK.framework，并并且修改相应的属性
//            //            conversationController.ywcsTrackTitle = @"聊天页面";
//        }
//#warning IF YOU NEED CUSTOM NAVIGATION TITLE OF YWCONVERSATIONVIEWCONTROLLER
//        //如果需要自定义聊天页面标题，可以取消以下行的注释，注意，这将不再显示在线状态和输入状态
//        //        if ([aConversation isKindOfClass:[YWP2PConversation class]] && [((YWP2PConversation *)aConversation).person.personId isEqualToString:@"云大旺"]) {
//        //            conversationController.disableTitleAutoConfig = YES;
//        //            conversationController.title = @"自定义标题";
//        //
//        //        }
//        
//        
//        __weak typeof(conversationController) weakController = conversationController;
//        [conversationController setViewDidLoadBlock:^{
//            CustomTopView *custom = [[NSBundle mainBundle]loadNibNamed:@"CustomTopView" owner:self options:nil].lastObject;
//            custom.frame = CGRectMake(0, 0, screenWidth, 64);
//            custom.controller = weakController;
//            weakController.customTopView = custom;
//        }];
//        [conversationController setViewWillAppearBlock:^(BOOL aAnimated) {
//            [weakController.navigationController setNavigationBarHidden:YES animated:NO];
//        }];
//        [aNavigationController pushViewController:conversationController animated:YES];
//        
//        /// 添加自定义插件
//        [self exampleAddInputViewPluginToConversationController:conversationController];
//        
//        /// 添加自定义表情
//        [self exampleShowCustomEmotionWithConversationController:conversationController];
//        
//        /// 设置显示自定义消息
//        [self exampleShowCustomMessageWithConversationController:conversationController];
//        
//        /// 设置消息长按菜单
//        [self exampleSetMessageMenuToConversationController:conversationController];
//    }
//}


/**
 *  打开单聊页面
 */
- (void)exampleOpenConversationViewControllerWithPerson:(YWPerson *)aPerson fromNavigationController:(UINavigationController *)aNavigationController
{
    YWConversation *conversation = [YWP2PConversation fetchConversationByPerson:aPerson creatIfNotExist:YES baseContext:self.ywIMKit.IMCore];

    [self exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:aNavigationController];
}

/**
 *  打开群聊页面
 */
- (void)exampleOpenConversationViewControllerWithTribe:(YWTribe *)aTribe fromNavigationController:(UINavigationController *)aNavigationController
{
    YWConversation *conversation = [YWTribeConversation fetchConversationByTribe:aTribe createIfNotExist:YES baseContext:self.ywIMKit.IMCore];
    
    [self exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:aNavigationController];
}

- (void)exampleOpenEServiceConversationWithPersonId:(NSString *)aPersonId fromNavigationController:(UINavigationController *)aNavigationController
{
    YWPerson *person = [[SPKitExample sharedInstance] exampleFetchEServicePersonWithPersonId:aPersonId groupId:nil];
    [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:aNavigationController];
}

/**
 *  创建某个会话Controller，在这个Demo中仅用于iPad SplitController中显示会话
 */
- (YWConversationViewController *)exampleMakeConversationViewControllerWithConversation:(YWConversation *)aConversation
{
    YWConversationViewController *conversationController = [self.ywIMKit makeConversationViewControllerWithConversationId:aConversation.conversationId];
    
    /// 添加自定义插件
    [self exampleAddInputViewPluginToConversationController:conversationController];
    
    /// 添加自定义表情
    [self exampleShowCustomEmotionWithConversationController:conversationController];
    
    /// 设置显示自定义消息
    [self exampleShowCustomMessageWithConversationController:conversationController];
    
    /// 设置消息长按菜单
    [self exampleSetMessageMenuToConversationController:conversationController];
    
    return conversationController;
}




#pragma mark - Customize

/**
 *  自定义全局导航栏
 */
- (void)exampleCustomGlobleNavigationBar
{
#warning TODO: JUST RETURN IF NO NEED TO CHANGE Global Navigation Bar
    // 自定义导航栏背景
    if ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] == NSOrderedDescending )
    {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0 green:1.f*0xb4/0xff blue:1.f alpha:1.f]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0 green:1.f*0xb4/0xff blue:1.f alpha:1.f]];
    }
    else
    {
        UIImage *originImage = [UIImage imageNamed:@"pub_title_bg"];
        UIImage *backgroundImage = [originImage resizableImageWithCapInsets:UIEdgeInsetsMake(44, 7, 4, 7)];
        [[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];


        [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor],
                                                               UITextAttributeTextShadowColor: [UIColor clearColor],
                                                               UITextAttributeFont: [UIFont boldSystemFontOfSize:18.0]}];

        NSDictionary *barButtonTittleAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                    UITextAttributeTextShadowColor: [UIColor clearColor],
                                                    UITextAttributeFont: [UIFont systemFontOfSize:16.0f]};

        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barButtonTittleAttributes
                                                                                                forState:UIControlStateNormal];

        UIImage *backItemImage = [[UIImage imageNamed:@"pub_title_ico_back_white"] resizableImageWithCapInsets:UIEdgeInsetsMake(33, 24, 0, 24)
                                                                                                  resizingMode:UIImageResizingModeStretch];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:backItemImage
                                                                                                      forState:UIControlStateNormal
                                                                                                    barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage new]
                                                                                            forState:UIControlStateNormal
                                                                                          barMetrics:UIBarMetricsDefault];

        [[UITabBar appearance] setBackgroundImage:backgroundImage];
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    }


    // 自定义导航栏及导航按钮，可参考下面的文章
    // http://www.appcoda.com/customize-navigation-status-bar-ios-7/
}

/**
 *  自定义皮肤
 */
- (void)exampleCustomUISkin
{
    // 使用自定义UI资源和配置
    YWIMKit *imkit = self.ywIMKit;
    
    NSString *bundleName = @"CustomizedUIResources.bundle";
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:bundleName];
    NSBundle *customizedUIResourcesBundle = [NSBundle bundleWithPath:bundlePath];
    [imkit setCustomizedUIResources:customizedUIResourcesBundle];
}

- (void)exampleEnableTribeAtMessage {
    [self.ywIMKit.IMCore getSettingService].disableAtFeatures = NO;
}

/**
 *  添加输入面板插件
 */
- (void)exampleAddInputViewPluginToConversationController:(YWConversationViewController *)aConversationController
{
#warning TODO: CHANGE TO YOUR ACTUAL Input View Plugin
    /// 创建自定义插件
    SPInputViewPluginCustomize *plugin = [[SPInputViewPluginCustomize alloc] init];
    /// 添加插件
    [aConversationController.messageInputView addPlugin:plugin];
}

/**
 *  发送自定义消息
 */
- (void)exampleSendCustomMessageWithConversationController:(YWConversationViewController *)aConversationController
{
    __weak typeof(aConversationController) weakController = aConversationController;
    
    /// 构建一个自定义消息
    YWMessageBodyCustomize *body = [[YWMessageBodyCustomize alloc] initWithMessageCustomizeContent:@"Hi!" summary:@"您收到一个招呼"];
    
    /// 发送该自定义消息
    [aConversationController.conversation asyncSendMessageBody:body progress:^(CGFloat progress, NSString *messageID) {
        NSLog(@"消息发送进度:%lf", progress);
    } completion:^(NSError *error, NSString *messageID) {
#ifdef DEBUG
        if (error.code == 0) {
            [[SPUtil sharedInstance] showNotificationInViewController:weakController title:@"打招呼成功!" subtitle:nil type:SPMessageNotificationTypeSuccess];
        } else {
            [[SPUtil sharedInstance] showNotificationInViewController:weakController title:@"打招呼失败!" subtitle:nil type:SPMessageNotificationTypeError];
        }
#endif
    }];
}

/**
 *  设置如何显示自定义消息
 */
- (void)exampleShowCustomMessageWithConversationController:(YWConversationViewController *)aConversationController
{
#warning TODO: CHANGE TO YOUR ACTUAL METHOD TO SHOW Custom Message
    /// 设置用于显示自定义消息的ViewModel
    /// ViewModel，顾名思义，一般用于解析和存储结构化数据
    [aConversationController setHook4BubbleViewModel:^YWBaseBubbleViewModel *(id<IYWMessage> message) {
        if ([[message messageBody] isKindOfClass:[YWMessageBodyCustomize class]]) {
            SPBubbleViewModelCustomize *viewModel = [[SPBubbleViewModelCustomize alloc] initWithMessage:message];
            return viewModel;
        }
        
        return nil;
    }];
    
    /// 设置用于显示自定义消息的ChatView
    /// ChatView一般从ViewModel中获取已经解析的数据，用于显示
    [aConversationController setHook4BubbleView:^YWBaseBubbleChatView *(YWBaseBubbleViewModel *message) {
        if ([message isKindOfClass:[SPBubbleViewModelCustomize class]]) {
            SPBaseBubbleChatViewCustomize *chatView = [[SPBaseBubbleChatViewCustomize alloc] init];
            return chatView;
        }
        
        return nil;
    }];
}

/**
 *  添加或者更新自定义会话
 */
- (void)exampleAddOrUpdateCustomConversation
{
#warning TODO: JUST RETURN IF NO NEED TO ADD Custom Conversation OR CHANGE TO YOUR ACTUAL METHOD TO ADD Custom Conversation
    NSInteger random = arc4random()%100;
    static NSArray *contentArray = nil;
    if (contentArray == nil) {
        contentArray = @[@"欢迎使用OpenIM", @"新的开始", @"完美的APP", @"请点击我"];
    }
    YWCustomConversation *conversation = [YWCustomConversation fetchConversationByConversationId:@"ywcustom007" creatIfNotExist:YES baseContext:[SPKitExample sharedInstance].ywIMKit.IMCore];
    /// 每一次点击都随机的展示未读数和最后消息
    [conversation modifyUnreadCount:@(random) latestContent:contentArray[random%4] latestTime:[NSDate date]];
    
    /// 将这个会话置顶
    [self exampleMarkConversationOnTop:conversation onTop:YES];
}

/**
 *  将会话置顶
 */
- (void)exampleMarkConversationOnTop:(YWConversation *)aConversation onTop:(BOOL)aOnTop
{
    NSError *error = nil;
    [aConversation markConversationOnTop:aOnTop getError:&error];
    if (error) {
        [[SPUtil sharedInstance] showNotificationInViewController:nil title:@"自定义消息置顶失败" subtitle:nil type:SPMessageNotificationTypeError];
    }
}


/**
 *  设置如何显示自定义表情
 */
- (void)exampleShowCustomEmotionWithConversationController:(YWConversationViewController *)aConversationController
{
#warning TODO: JUST RETURN IF NO NEED TO ADD Custom Emoticon OR CHANGE TO YOUR ACTUAL METHOD TO ADD Custom Emoticon
    for ( id item in aConversationController.messageInputView.allPluginList )
    {
        if ( ![item isKindOfClass:[YWInputViewPluginEmoticonPicker class]] ) continue;
        
        YWInputViewPluginEmoticonPicker *emotionPicker = (YWInputViewPluginEmoticonPicker *)item;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"YW_TGZ_Emoitons" ofType:@"emo"];
        NSArray *groups = [YWEmoticonGroupLoader emoticonGroupsWithEMOFilePath:filePath];
        
        for (YWEmoticonGroup *group in groups)
        {
            [emotionPicker addEmoticonGroup:group];
        }
    }
}

/**
 *  设置气泡最大宽度
 */
- (void)exampleSetMaxBubbleWidth
{
    [YWBaseBubbleChatView setMaxWidthUsedForLayout:280.f];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString* strError = @"保存成功，照片已经保存至相册。";
    if( error != nil )
    {
        strError = error.localizedDescription;
    }
    
    [[SPUtil sharedInstance] showNotificationInViewController:nil title:@"图片保存结果" subtitle:strError type:SPMessageNotificationTypeMessage];
}


/**
 *  设置消息的长按菜单
 *  这个方法展示如何设置图片消息的长按菜单
 */
- (void)exampleSetMessageMenuToConversationController:(YWConversationViewController *)aConversationController
{
#warning TODO: JUST RETURN IF NO NEED TO ADD Custom Menu OR CHANGE TO YOUR ACTUAL METHOD TO ADD Custom Menu
    __weak typeof(self) weakSelf = self;
    [aConversationController setMessageCustomMenuItemsBlock:^NSArray *(id<IYWMessage> aMessage) {
        if ([[aMessage messageBody] isKindOfClass:[YWMessageBodyImage class]]) {
            YWMessageBodyImage *bodyImage = (YWMessageBodyImage *)[aMessage messageBody];
            if (bodyImage.originalImageType == YWMessageBodyImageTypeNormal) {
                /// 对于普通图片，我们增加一个保存按钮
                return @[[[YWMoreActionItem alloc] initWithActionName:@"保存" actionBlock:^(NSDictionary *aUserInfo) {
                    NSString *messageId = aUserInfo[YWConversationMessageCustomMenuItemUserInfoKeyMessageId]; /// 获取长按的MessageId
                    YWConversationViewController *conversationController = aUserInfo[YWConversationMessageCustomMenuItemUserInfoKeyController]; /// 获取会话Controller
                    id<IYWMessage> message = [conversationController.conversation fetchMessageWithMessageId:messageId];
                    message = [message conformsToProtocol:@protocol(IYWMessage)] ? message : nil;
                    if ([[message messageBody] isKindOfClass:[YWMessageBodyImage class]]) {
                        YWMessageBodyImage *bodyImage = (YWMessageBodyImage *)[message messageBody];
                        NSArray *forRetain = @[bodyImage];
                        [bodyImage asyncGetOriginalImageWithProgress:^(CGFloat progress) {
                            ;
                        } completion:^(NSData *imageData, NSError *aError) {
                            /// 下载成功后保存
                            UIImage *img = [UIImage imageWithData:imageData];
                            if (img) {
                                UIImageWriteToSavedPhotosAlbum(img, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                            }
                            [forRetain count]; /// 用于防止bodyImage被释放
                        }];
                    }
                }]];
            }
        }
        return nil;
    }];
}

#pragma mark - events

/**
 *  监听新消息
 */
- (void)exampleListenNewMessage
{
    [[self.ywIMKit.IMCore getConversationService] addOnNewMessageBlockV2:^(NSArray *aMessages, BOOL aIsOffline) {
        /// 你可以在此处根据需要播放提示音
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

- (void)exampleSetNotificationBlock
{
    // 当IMSDK需要弹出提示时，会调用此回调，你需要修改成你App中显示提示的样式
    [self.ywIMKit setShowNotificationBlock:^(UIViewController *aViewController, NSString *aTitle, NSString *aSubtitle, YWMessageNotificationType aType) {
        [[SPUtil sharedInstance] showNotificationInViewController:aViewController title:aTitle subtitle:aSubtitle type:(SPMessageNotificationType)aType];
    }];
}

/**
 *  监听群邀请
 */
- (void)exampleListenTribeInvitation {
    __weak __typeof(self) weakSelf = self;
    [[self.ywIMKit.IMCore getTribeService] addInvitationFromTribeBlock:^(NSDictionary *userInfo) {
        YWTribeSystemConversation *tribeSystemConversation = [[self.ywIMKit.IMCore getTribeService] fetchTribeSystemConversation];

        NSNumber *count = tribeSystemConversation.conversationUnreadMessagesCount;
        if (count.integerValue) {
            NSDate *time = tribeSystemConversation.conversationLatestMessageTime;
            NSString *content = tribeSystemConversation.conversationLatestMessageContent;

            YWCustomConversation *tribeInvitationCustomConversation = [YWCustomConversation fetchConversationByConversationId:SPTribeInvitationConversationID creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];

            [tribeInvitationCustomConversation modifyUnreadCount:count
                                                   latestContent:content
                                                      latestTime:time];
        }

    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

/**
 * 头像点击事件
 */
- (void)exampleListenOnClickAvatar
{
#warning TODO: JUST RETURN IF NO NEED TO PROCESS Avatar Click Event OR CHANGE TO YOUR ACTUAL METHOD
    __weak __typeof(self) weakSelf = self;
    [self.ywIMKit setOpenProfileBlock:^(YWPerson *aPerson, UIViewController *aParentController) {
        BOOL isMe = [aPerson isEqualToPerson:[[weakSelf.ywIMKit.IMCore getLoginService] currentLoginedUser]];

        if (isMe == NO && [aParentController isKindOfClass:[YWConversationViewController class]] && [((YWConversationViewController *)aParentController).conversation isKindOfClass:[YWTribeConversation class]])
        {
            //跳转资料页面
            
            
//            [weakSelf exampleOpenConversationViewControllerWithPerson:aPerson fromNavigationController:aParentController.navigationController];
        }
        else
        {
            /// 您可以打开该用户的profile页面
//            [[SPUtil sharedInstance] showNotificationInViewController:aParentController title:@"打开profile" subtitle:aPerson.description type:SPMessageNotificationTypeMessage];
        }
    }];
}


/**
 *  链接点击事件
 */
- (void)exampleListenOnClickUrl
{
    [self.ywIMKit setOpenURLBlock:^(NSString *aURLString, UIViewController *aParentController) {
        /// 您可以使用您的容器打开该URL
        YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:aURLString];
        [aParentController.navigationController pushViewController:controller animated:YES];
    }];
}

/**
 *  预览大图事件
 */
- (void)exampleListenOnPreviewImage
{
#warning TODO: JUST RETURN IF NO NEED TO ADD Custom Menu When Preview Image OR CHANGE TO YOUR ACTUAL METHOD
    __weak typeof(self) weakSelf = self;
    
    [self.ywIMKit setPreviewImageMessageBlockV2:^(id<IYWMessage> aMessage, YWConversation *aOfConversation, UIViewController *aFromController) {
        
        /// 增加更多按钮，例如转发
//        YWMoreActionItem *transferItem = [[YWMoreActionItem alloc] initWithActionName:@"转发" actionBlock:^(NSDictionary *aUserInfo) {
//            /// 获取会话及消息相关信息
//            NSString *convId = aUserInfo[YWImageBrowserHelperActionKeyConversationId];
//            NSString *msgId = aUserInfo[YWImageBrowserHelperActionKeyMessageId];
//            
//            YWConversation *conv = [[weakSelf.ywIMKit.IMCore getConversationService] fetchConversationByConversationId:convId];
//            if (conv) {
//                id<IYWMessage> msg = [conv fetchMessageWithMessageId:msgId];
//                if (msg) {
//                    YWPerson *person = [[YWPerson alloc] initWithPersonId:@"jiakuipro003"];
//                    YWP2PConversation *targetConv = [YWP2PConversation fetchConversationByPerson:person creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];
//                    [targetConv asyncForwardMessage:msg progress:NULL completion:^(NSError *error, NSString *messageID) {
//                        NSLog(@"转发结果：%@", error.code == 0 ? @"成功" : @"失败");
//                        [[SPUtil sharedInstance] asyncGetProfileWithPerson:person progress:nil completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
//                            [[SPUtil sharedInstance] showNotificationInViewController:nil title:[NSString stringWithFormat:@"已经成功转发给:%@", aDisplayName] subtitle:nil type:SPMessageNotificationTypeMessage];
//                        }];
//                    }];
//                }
//            }
//        }];

        /// 打开IMSDK提供的预览大图界面
        [YWImageBrowserHelper previewImageMessage:aMessage conversation:aOfConversation inNavigationController:aFromController.navigationController additionalActions:nil];
    }];
}


#pragma mark - apns

/**
 *  您需要在-[AppDelegate application:didFinishLaunchingWithOptions:]中第一时间设置此回调
 *  在IMSDK截获到Push通知并需要您处理Push时，IMSDK会自动调用此回调
 */
- (void)exampleHandleAPNSPush
{
    __weak typeof(self) weakSelf = self;

    
    [[[YWAPI sharedInstance] getGlobalPushService] setHandlePushBlockV3:^(BOOL aIsLaunching, UIApplicationState aState, NSDictionary *aAPS, NSString *aConversationId, __unsafe_unretained Class aConversationClass, YWPerson *aToPerson) {
        if (aConversationId.length <= 0) {
            return;
        }
        
        if (aConversationClass == NULL) {
            return;
        }
        
        if (aIsLaunching) {
            /// 用户划开Push导致app启动
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self exampleIsPreLogined]) {
                    /// 说明已经预登录成功
                    YWConversation *conversation = nil;
                    if (aConversationClass == [YWP2PConversation class]) {
                        conversation = [YWP2PConversation fetchConversationByConversationId:aConversationId creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];
                    } else if (aConversationClass == [YWTribeConversation class]) {
                        conversation = [YWTribeConversation fetchConversationByConversationId:aConversationId creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];
                    }
                    if (conversation) {
                        [weakSelf exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:weakSelf.rootNavigationController];
                    }
                }
            });

        } else {
            /// app已经启动时处理Push
            
            if (aState != UIApplicationStateActive) {
                if ([self exampleIsPreLogined]) {
                    /// 说明已经预登录成功
                    YWConversation *conversation = nil;
                    if (aConversationClass == [YWP2PConversation class]) {
                        conversation = [YWP2PConversation fetchConversationByConversationId:aConversationId creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];
                    } else if (aConversationClass == [YWTribeConversation class]) {
                        conversation = [YWTribeConversation fetchConversationByConversationId:aConversationId creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];
                    }
                    if (conversation) {
                        [weakSelf exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:weakSelf.rootNavigationController];
                    }
                }
            } else {
                /// 应用处于前台
                /// 建议不做处理，等待IM连接建立后，收取离线消息。
            }
        }
    }];
}

#pragma mark - EService

/**
 *  获取EService对象
 */
- (YWPerson *)exampleFetchEServicePersonWithPersonId:(NSString *)aPersonId groupId:(NSString *)aGroupId
{
    return [[YWPerson alloc] initWithPersonId:aPersonId EServiceGroupId:aGroupId baseContext:self.ywIMKit.IMCore];
}


@end
