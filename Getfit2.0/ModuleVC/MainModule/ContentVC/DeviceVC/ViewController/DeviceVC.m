//
//  DeviceVC.m
//  AJBracelet
//
//  Created by zorro on 15/6/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceVC.h"
#import "DeviceMainScrollView.h"
#import "DeviceUpdateViewController.h"
#import "AlarmRemindViewController.h"
#import "CallReminderViewController.h"
#import "SedentaryReminderViewController.h"
#import "PedometerHelper.h"
#import "BLTSimpleSend.h"
#import "CameraController.h"
#import "EnterViewController.h"
#import "AppDelegate.h"
#import "DrinkVC.h"
#import "DeviceNameVC.h"

@interface DeviceVC ()

@property (nonatomic, strong) DeviceMainScrollView *scMainView;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) PedometerModel *model;
@property (nonatomic, strong) NSTimer *stepUpdateTimer;

@end

@implementation DeviceVC

- (void)updateContentForTableView:(NSData *)object
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KK_BgColor;
    
    _scMainView = [[DeviceMainScrollView alloc] initWithFrame:CGRectMake(0, 20, Maxwidth, self.view.height - 84)];
    [self.view addSubview:_scMainView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceDidselectRow:) name:@"deviceDidselectRow" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak DeviceVC *weakSelf = self;
    _scMainView.deviceTableView.bondingBlock = ^() {
        EnterViewController *enterView = [[EnterViewController alloc] init];
        [weakSelf.navigationController pushViewController:enterView animated:NO];
    };
    
    [BLTManager sharedInstance].connectBlock = ^ {
        [weakSelf updateContentForTableView];
    };
    [BLTManager sharedInstance].disConnectBlock = ^{
        [weakSelf updateContentForTableView];
    };
    [BLTManager sharedInstance].updateModelBlock = ^(BLTModel *model) {
        [weakSelf updateContentForTableView];
    };
    
    [BLTSendModel sendObtainDeviceInfoWithFunc:BLTDeviceBaseInfo withUpdateBlock:^(id object, BLTAcceptModelType type) {
        if (type == BLTAcceptModelTypeDevideInfo) {
            [weakSelf updateContentForTableView:object];
        }
    }];
    [BLTAcceptModel sharedInstance].baseInfoBlock = ^ (id object, BLTAcceptModelType type) {
        [weakSelf updateContentForTableView];
    };
    
    [self updateContentForTableView];
}

- (void)updateContentForTableView
{
    [_scMainView.deviceTableView updateContentForSubViews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [BLTManager sharedInstance].connectBlock = nil;
    [BLTManager sharedInstance].disConnectBlock = nil;
    [BLTManager sharedInstance].updateModelBlock = nil;

    [BLTManager sharedInstance].updateModelBlock = nil;
    [BLTAcceptModel sharedInstance].baseInfoBlock = nil;
}

- (void)deviceDidselectRow:(NSNotification*)Info
{
    NSString *title = [Info object];
    
    if ( [title isEqualToString:KK_Text(@"Call Alert")] )
    {
        CallReminderViewController *CallReminderVc = [[CallReminderViewController alloc]init];
        [self.navigationController pushViewController:CallReminderVc animated:YES];
    }
    else if ([title isEqualToString:KK_Text(@"Sedentary Alert")])
    {
        SedentaryReminderViewController *sedentaryVc = [[SedentaryReminderViewController alloc]init];
        [self.navigationController pushViewController:sedentaryVc animated:YES];
    }
    else if ([title isEqualToString:KK_Text(@"Alarm Alert")])
    {
        AlarmRemindViewController *alarmVc = [[AlarmRemindViewController alloc]init];
        [self.navigationController pushViewController:alarmVc animated:YES];
    }
    else if ([title isEqualToString:KK_Text(@"Photograph")])
    {
        CameraController *camera = [[CameraController alloc] init];
        camera.ifSaveImageToLocal = YES;
        [self.navigationController pushViewController:camera animated:YES];
    }
    else if ([title isEqualToString:KK_Text(@"Anti-lost Alert")])
    {
        
    }
    else if ([title isEqualToString:KK_Text(@"device upgrade")])
    {
        if ([UserInfoHelper sharedInstance].bltModel.isBinding)
        {
            DeviceUpdateViewController *updateVc = [[DeviceUpdateViewController alloc]init];
            [self.navigationController pushViewController:updateVc animated:YES];
        }
        else
        {
            SHOWMBProgressHUD(KK_Text(@"Pair Device"), nil, nil, NO, 2.0);
        }
    } else if ([title isEqualToString:KK_Text(@"Remind drink")]) {
        DrinkVC *vc = [[DrinkVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:KK_Text(@"Device Name")]) {
        DeviceNameVC *nameVC = [[DeviceNameVC alloc]init];
        [self.navigationController pushViewController:nameVC animated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deviceDidselectRow" object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
