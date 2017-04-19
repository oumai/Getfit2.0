//
//  AppDelegate.m
//  AJBracelet
//
//  Created by zorro on 15/5/25.
//  Copyright (c) 2015年 zorro. All rights reserved.
// test

#import "AppDelegate.h"
#import "EnterViewController.h"
#import "Information.h"
#import "BLTSimpleSend.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "XYSandbox.h"
#import "UseDataShowViewController.h"

#import "SPKitExample.h"
#import "IQKeyboardManager.h"

#import "FamilyViewController.h"
#import "LoginViewController.h"
#import "KKASIHelper.h"
#import "ShareSDKHelper.h"
#import "AudioHelper.h"

@interface AppDelegate ()

//@property (nonatomic, strong) ControlVC *ContenVc;
@property (nonatomic, strong) CTCallCenter *callCenter;
@property (nonatomic, assign) BOOL isDialing;

@property (nonatomic, strong) FamilyViewController *familyVC;
@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    NSDate *date = [NSDate date];
    NSInteger year = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date].year;
    
    NSLog(@"year = %d", year);
    
    // 状态栏文字白色
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 启动页停止2秒
    sleep(1);

    [self createVideoFloders];
    // 检查设备模型
    [[ShareData sharedInstance] checkDeviceModel];
    [IQKeyboardManager sharedManager].enable = NO;
    
    // 分享
    [ShareSDKHelper initLoad];

    // 启动蓝牙.
    [BLTAcceptModel sharedInstance];
    [UserInfoHelper sharedInstance];
    [self addTelephonyEvent];

    if ([SAVEENTERUSERKEY getBOOLValue])
    {
        [self pushContenVc];  // 进入主页
    }
    else
    {
        [self pushEnterVc];   // 进入启动页面
    }
    
    if (![SAVEFIRSTUSERDATE getObjectValue])
    {
        [SAVEFIRSTUSERDATE setObjectValue:[NSDate date]];
        [USERUPDATEDATETIME setObjectValue:[NSDate date]];
    }
        
    [[SPKitExample sharedInstance] callThisInDidFinishLaunching];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [@"chooseDate" setObjectValue:[NSDate date]];
    NSDate *yesdate = [[NSDate date] dateAfterDay:-1];
    [@"lastDate" setObjectValue:yesdate];
    return YES;
}

- (void)pushHeartVc
{
    UseDataShowViewController *hearVc = [[UseDataShowViewController alloc] init];
    
    if (_ContenVc) {
        [_ContenVc.navigationController pushViewController:hearVc animated:YES];
    }
}

- (void)pushEnterVc
{
    EnterViewController *enterVc =[[EnterViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:enterVc];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
}

- (void)pushContenVc
{
    _ContenVc = [ControlVC simpleInit];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_ContenVc];
    nav.navigationBar.barTintColor = KK_MainColor;
    _ContenVc.automaticallyAdjustsScrollViewInsets = NO;
    [nav.navigationBar setHidden:YES];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
}

- (void)pushChatVc
{
    _familyVC = [[FamilyViewController alloc] initWithNibName:@"FamilyViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_familyVC];
    [nav setNavigationBarHidden:YES];
    [self.window makeKeyAndVisible];
    
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        self.window.rootViewController = nav;
                    } completion:nil];
}

- (void)pushChatLoginVc
{
    _loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_loginVC];
    [self.window makeKeyAndVisible];
    
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        self.window.rootViewController = nav;
                    } completion:nil];
}

- (void)createVideoFloders
{
    [XYSandbox createDirectoryAtPath:[[XYSandbox libCachePath] stringByAppendingPathComponent:AJ_FileCache_Firmware]];
    [XYSandbox createDirectoryAtPath:[[XYSandbox libCachePath] stringByAppendingPathComponent:AJ_FileCache_HeadImage]];
    NSLog(@"..%@", [XYSandbox libCachePath]);
    
    [XYSandbox createDirectoryAtPath:[[XYSandbox docPath] stringByAppendingPathComponent:@"/db/"]];
    [XYSandbox createDirectoryAtPath:[[XYSandbox docPath] stringByAppendingPathComponent:@"/dbimg/"]];

    // 通知不用上传备份
    [[[XYSandbox docPath] stringByAppendingPathComponent:@"/db/"] addSkipBackupAttributeToItem];
    [[[XYSandbox docPath] stringByAppendingPathComponent:@"/dbimg/"] addSkipBackupAttributeToItem];
}

- (void)addTelephonyEvent
{
    __weak AppDelegate *safeSelf = self;
    _callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler = ^(CTCall *call) {
        if (call.callState == CTCallStateDialing)
        {
            [BLTManager sharedInstance].connectBlock =  nil;
            NSLog(@"CTCallStateDialing");
        }
        else if (call.callState == CTCallStateDisconnected)
        {
            [BLTManager sharedInstance].connectBlock =  nil;
            NSLog(@"CTCallStateDisconnected");
            safeSelf.isDialing = NO;
            [safeSelf performSelectorInBackground:@selector(CTCallStateDisconnected) withObject:nil];
            
        }
        else if (call.callState == CTCallStateConnected)
        {
            [BLTManager sharedInstance].connectBlock =  nil;
            NSLog(@"CTCallStateDisconnected");
        }
        else if (call.callState == CTCallStateIncoming)
        {
            NSLog(@"CTCallStateIncoming");
            safeSelf.isDialing = [UserInfoHelper sharedInstance].bltModel.isDialingRemind;
            if (![UserInfoHelper sharedInstance].bltModel.isConnected) {
                 [[BLTManager sharedInstance] repeatScan];
                [BLTManager sharedInstance].connectBlock = ^ {
                    [safeSelf performSelectorInBackground:@selector(delaySend) withObject:nil];
                };
            }else {
                [safeSelf performSelectorInBackground:@selector(delaySend) withObject:nil];
            }
        }
    };
}

- (void)delaySend
{
    double delayInSeconds = [UserInfoHelper sharedInstance].bltModel.delayDialing;
    NSLog(@"delayInSeconds = %f", delayInSeconds);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSLog(@"delayInSeconds  calling");

        [self sendDialingInfoToBLTDevice];
    });
}

// 取消来电提醒通知
- (void)CTCallStateDisconnected
{
    /*
    [[UserInfoHelper sharedInstance] sendCallRemind:NO WithBackBlock:^(id object)
     {
         NSLog(@"挂断 object>>>>>%@",object);
     }]; */
}

// 来电提醒通知.
- (void)sendDialingInfoToBLTDevice
{
    if ([UserInfoHelper sharedInstance].bltModel.isDialingRemind)
    {
        NSLog(@"delayInSeconds calling 2");
        
        [[UserInfoHelper sharedInstance] sendCallRemind:YES WithBackBlock:^(id object)
         {
             NSLog(@"接收来电  object>>>>>%@",object);
         }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [ShareData sharedInstance].isBackGround = YES;
    
    self. backgroundTaskIdentifier =[application beginBackgroundTaskWithExpirationHandler:^( void) {
        [self endBackgroundTask];
    }];
}

- (void) endBackgroundTask{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    AppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^(void) {
        AppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil){
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    

    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [ShareData sharedInstance].isBackGround = NO;
    [KK_AudioHelper showAlertView];

    NSLog(@"[AppDelegate isHasAMPMTimeSystem]>>>>>%i",[AppDelegate isHasAMPMTimeSystem]);
    if ([UserInfoHelper sharedInstance].userModel.hasAMPM == [AppDelegate isHasAMPMTimeSystem]) {
        
    } else {
        [UserInfoHelper sharedInstance].userModel.hasAMPM = [AppDelegate isHasAMPMTimeSystem];
    }
    if (![UserInfoHelper sharedInstance].isUpdating) {
        if ([BLTManager sharedInstance].isConnected) {
           [[UserInfoHelper sharedInstance] sendTimeMode];  ///如果还在升级,就不发送时间设置
        } else {
            [[BLTManager sharedInstance] startCan]; /////进入前台,断开情况下扫描重连
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[BLTAcceptModel sharedInstance] exitBeforeSave];
}

@end
