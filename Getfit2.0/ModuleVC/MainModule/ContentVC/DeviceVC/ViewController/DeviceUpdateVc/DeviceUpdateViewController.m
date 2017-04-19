//
//  ViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceUpdateViewController.h"
#import "DeviceInfoClass.h"
#import "BLTManager.h"
#import "BLTSimpleSend.h"
#import "AppDelegate.h"
#import "HubView.h"

@interface DeviceUpdateViewController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *currentVersionLabel;
@property (nonatomic, strong) UILabel *firmeareVersionLabel;
@property (nonatomic, strong) UILabel *updateInfo01;
@property (nonatomic, strong) UILabel *updateInfo02;
@property (nonatomic, strong) UILabel *updateInfo03;
@property (nonatomic, strong) UILabel *updateInfo04;
@property (nonatomic, strong) NSArray *updateInfoArray;
@property (nonatomic, strong) UIButton *autoUpdateButton;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) DeviceUpdateProgressView *updateProgessView;
@property (nonatomic, strong) UILabel *updateStateLabel;
@property (nonatomic, assign) NSInteger updateCount;
@property (nonatomic, strong) UILabel *updateLabel;
@property (nonatomic, assign) NSInteger updateTimes;
@property (nonatomic, assign) BOOL devieUpdateState;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) HubView *hubProgressView;
@property (nonatomic, strong) UILabel *showLabel;

@end

@implementation DeviceUpdateViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DEF_WEAKSELF_(DeviceUpdateViewController);
    [BLTManager sharedInstance].connectBlock = ^() {
        [weakSelf checkIsUpdateDevice];
    };
    [BLTSimpleSend sharedInstance].synProgressBlock = ^ (int progress, BLTSimpleSendSynProgress type) {
        if (!_updateButton.selected) {
            return;
        }
        if (type == BLTSimpleSendSynProgressNormal) {
            _backButton.enabled = NO;
            _updateButton.enabled = NO;
             [_updateButton setTitle:[NSString stringWithFormat:@"%@:%d %%", KK_Text(@"Synced"), progress] forState:UIControlStateNormal];
        }else if (type == BLTSimpleSendSynProgressFail) {
            _backButton.enabled = YES;
            _updateButton.enabled = YES;
            [_updateButton setTitle:KK_Text(@"Sync Failed") forState:UIControlStateNormal];
            [self performSelector:@selector(backButtonClick) withObject:nil afterDelay:2.0];
        }else if (type == BLTSimpleSendSynProgressSuccess){
            _backButton.enabled = NO;
            _updateButton.enabled = NO;
            [_updateButton setTitle:KK_Text(@"Prepare for update") forState:UIControlStateNormal];
            [weakSelf performSelector:@selector(checkIsAllownUpdateFirmWare) withObject:nil afterDelay:1.0];
        }
    };
    [BLTSimpleSend sharedInstance].getFunctionsuccess = ^(id obj) {
        _showLabel.text = KK_Text(@"配置成功,马上转到主页");
        [weakSelf performSelector:@selector(updateSuccessBack) withObject:nil afterDelay:2.0];
    };
    [self updateVersionLabel];

}

- (void)checkIsAllownUpdateFirmWare {
     [[BLTManager sharedInstance] checkIsAllownUpdateFirmWare]; ///同步成功之后开始升级
}

- (void)checkIsUpdateDevice
{
    if ([BLTManager sharedInstance].isAutoUpdate)
    {
        // 点击按钮事件
        [self update];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

//    [BLTSimpleSend sharedInstance].synProgressBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        self.tipTitle.text = KK_Text(@"Device Update");
    
        [self loadBackgroundView];  // 加载UI
    
        [self loadUpdateInfo];      // 更新内容
}

- (void)loadBackgroundView
{
    self.view.backgroundColor = UIColorHEX(0x262626);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 219)];
    bgView.backgroundColor = UIColorHEX(0x333333);
    [self.view addSubview:bgView];

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, 1)];
    line1.backgroundColor = UIColorHEX(0x888b90);
    [self.view addSubview:line1];

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 88, self.view.width, 1)];
    line2.backgroundColor = UIColorHEX(0x888b90);
    [self.view addSubview:line2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 219, self.view.width, 1)];
    line3.backgroundColor = UIColorHEX(0x888b90);
    [self.view addSubview:line3];
    
    _currentVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 10, 200, 25)];
    _currentVersionLabel.textColor = [UIColor whiteColor];
    _currentVersionLabel.font = DEFAULT_FONTHelvetica(14);
    [self.view addSubview:_currentVersionLabel];
    
    _firmeareVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 10 + 44, 200, 25)];
    _firmeareVersionLabel.textColor = [UIColor whiteColor];
    _firmeareVersionLabel.font = DEFAULT_FONTHelvetica(14);
    [self.view addSubview:_firmeareVersionLabel];
    
    _updateInfoArray = [[NSArray alloc ]initWithObjects:KK_Text(@"Update details"),@"1.",@"2.",@"3.",@"4.", nil];
    
    UILabel * updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 10 + 90, 280, 20)];
    updateLabel.text = [_updateInfoArray firstObject];
    updateLabel.textColor = [UIColor whiteColor];
    updateLabel.font = DEFAULT_FONTHelvetica(14);
    [self.view addSubview:updateLabel];
    
    _updateInfo01= [[UILabel alloc] initWithFrame:CGRectMake(18, 10 + 90 + 20, 280, 20)];
    _updateInfo01.textColor = [UIColor whiteColor];
    _updateInfo01.font = DEFAULT_FONTHelvetica(12);
    _updateInfo01.text = [_updateInfoArray objectAtIndex:1];
    [self.view addSubview:_updateInfo01];
    
    _updateInfo02= [[UILabel alloc] initWithFrame:CGRectMake(18, 10 + 90 + 40, 280, 20)];
    _updateInfo02.textColor = [UIColor whiteColor];
    _updateInfo02.font = DEFAULT_FONTHelvetica(12);
    _updateInfo02.text = [_updateInfoArray objectAtIndex:2];
    [self.view addSubview:_updateInfo02];
    
    _updateInfo03= [[UILabel alloc] initWithFrame:CGRectMake(18, 10 + 90 + 60, 280, 20)];
    _updateInfo03.textColor = [UIColor whiteColor];
    _updateInfo03.font = DEFAULT_FONTHelvetica(12);
    _updateInfo03.text = [_updateInfoArray objectAtIndex:3];
    [self.view addSubview:_updateInfo03];
    
    _updateInfo04= [[UILabel alloc] initWithFrame:CGRectMake(18, 10 + 90 + 80, 280, 20)];
    _updateInfo04.textColor = [UIColor whiteColor];
    _updateInfo04.font = DEFAULT_FONTHelvetica(12);
    _updateInfo04.text = [_updateInfoArray objectAtIndex:4];
    [self.view addSubview:_updateInfo04];

    CGFloat height = FitScreenNumber(100, 0, 0, 0, 0);
    
    _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _updateButton.frame = FitScreenRect(CGRectMake(20, 495 - 64 - height, self.view.width - 40, 40), CGRectMake(20, 415 - 64 - height, self.view.width - 40, 40), CGRectMake(20, 415 - 64 - height, self.view.width - 40, 40), CGRectMake(20, 415 - 64 - height, self.view.width - 40, 40), CGRectMake(20, 415 - 64 - height, self.view.width - 40, 40));
    _updateButton.backgroundColor = UIColorHEX(0x333333);
    _updateButton.bgImageNormal = @"Device_big_btn_1_5s@2x.png";
    _updateButton.bgImageSelecte = @"Device_big_btn_2_5s@2x.png";
    [_updateButton setTitle:KK_Text(@"Update Now") forState:UIControlStateNormal];
    [_updateButton addTarget:self action:@selector(updateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _updateButton];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.bgImageNormal = @"Device_back_5s@2x.png";
    _backButton.frame = CGRectMake(0, 0, 44, 44);
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_backButton];
    
    _autoUpdateButton = [[UIButton alloc] initWithFrame:FitScreenRect(CGRectMake(20, 415 - 64 - height, self.view.width - 40, 40), CGRectMake(20, 415 - 64 - height - 80, self.view.width - 40, 40), CGRectMake(20, 415 - 64 - height - 80, self.view.width - 40, 40), CGRectMake(20, 415 - 64 - height - 80, self.view.width - 40, 40), CGRectMake(20, 415 - 64 - height - 80, self.view.width - 40, 40))];
    _autoUpdateButton.bgImageNormal = @"Device_big_btn_1_5s@2x.png";
    [_autoUpdateButton setTitle:KK_Text(@"自动升级") forState:UIControlStateNormal];
    [_autoUpdateButton setTitle:KK_Text(@"取消自动") forState:UIControlStateSelected];
    _autoUpdateButton.selected = NO;
    [_autoUpdateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_autoUpdateButton addTarget:self action:@selector(autoUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_autoUpdateButton];
    
    [self updateVersionLabel];

    _updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(160,10, 110, 20)];
    _updateLabel.textColor = [UIColor whiteColor];
    _updateLabel.font = [UIFont systemFontOfSize:14.0];
    _updateLabel.text = KK_Text(@"当前:0 次");
    _updateLabel.hidden = YES;
    [_autoUpdateButton addSubview:_updateLabel];
    _updateLabel.textAlignment = NSTextAlignmentRight;

}

- (void)autoUpdateButton:(UIButton *)sender
{
    _updateLabel.hidden = sender.selected;
    if (sender.selected)
    {
        sender.selected = NO;
        [BLTManager sharedInstance].isAutoUpdate = NO;
    }
    else
    {
        sender.selected = YES;
        [BLTManager sharedInstance].isAutoUpdate = YES;
        
        [self update];
    }
    
    
}
- (void)backButtonClick
{
    
    _backButton.hidden = YES;
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)updateSuccessBack{
    [UserInfoHelper sharedInstance].isUpdating = NO;
    [_progressView dismissPopup];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.ContenVc setSelectedIndex:0];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController popViewControllerAnimated:NO];
}



- (UILabel *)UIlabelSetSpace:(NSString *)Text UILabel:(UILabel*)label
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:Text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, Text.length)];
    label.attributedText = attributedString;
    [label sizeToFit];

    return label;
}

- (void)updateButtonClick:(UIButton *)Sender
{
    [self update];
}

- (void)update
{
    
    if (![UserInfoHelper sharedInstance].bltModel.isConnected)
    {
        SHOWMBProgressHUD(KK_Text(@"Please connect to the device"), nil,nil,NO, 1.0);
        return;
    }
    
    if(_updateButton.selected == NO)
    {
        _devieUpdateState = NO;
        _updateCount = 0;
        _updateButton.selected = YES;
        [_updateProgessView setHidden:NO];
        [_updateStateLabel setHidden:NO];
//        [_updateButton setTitle:NSLocalizedString(@"正在下载固件...", nil) forState:UIControlStateNormal];
        [_updateProgessView setProgress:_updateCount];
//        _updateStateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"已完成:%ld %%", nil),_updateCount ];
        //        [self performSelector:@selector(updateFirmware) withObject:nil afterDelay:0.025];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateFirmwareTimeOut) object:nil];
        [self performSelector:@selector(updateFirmwareTimeOut) withObject:nil afterDelay:90.0];
        _updateButton.userInteractionEnabled = NO;
        
        DEF_WEAKSELF_(DeviceUpdateViewController);
   
        /*
        [[DownloadEntity sharedInstance] startDownloadUpdateFileWithUpdateBlcok:^(BLTDFUHelperUpdateState state, NSInteger number) {
            if (state == BLTDFUHelperUpdateing)
            {
                [_updateButton setTitle:NSLocalizedString(@"正在升级...", nil) forState:UIControlStateNormal];
                _backButton.enabled = NO;
                [UserInfoHelper sharedInstance].isUpdating = YES; ////正在升级
                [weakSelf.updateProgessView setProgress:number];
                weakSelf.updateStateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"已完成:%ld %%", nil),number ];
                
            }
            else if(state == BLTDFUHelperUpdateSuccess)
            {
                _backButton.enabled = YES;
                _devieUpdateState = YES;
                [_updateProgessView setHidden:NO];
                [_updateStateLabel setHidden:NO];
                _updateTimes ++;
                weakSelf.updateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"当前:%d次", nil),_updateTimes];
                weakSelf.updateStateLabel.text = NSLocalizedString(@"恭喜您升级成功", nil);
                [weakSelf.updateButton setTitle:NSLocalizedString(@"马上升级", nil) forState:UIControlStateNormal];
                weakSelf.updateButton.selected = NO;
                weakSelf.updateButton.userInteractionEnabled = YES;
                [weakSelf.updateProgessView setProgress:100];
                weakSelf.updateStateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"已完成:%d %%", nil),100 ];
                
//                NSString *uuidString = [AJ_LastWareUUID getObjectValue];
//                NSLog(@"[DeviceInfoClass sharedInstance].firmwareLastVersion]>>>>%@",[DeviceInfoClass sharedInstance].firmwareLastVersion);
//                [uuidString setObjectValue:[DeviceInfoClass sharedInstance].firmwareLastVersion];
                
                [self updateVersionLabel];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateFirmwareTimeOut) object:nil];
                [UserInfoHelper sharedInstance].isUpdateSuccess = YES;
                [self performSelector:@selector(showProgressView) withObject:nil afterDelay:1.0];
                
            }
            else if(state == BLTDFUHelperUpdateFail)
            {
                _backButton.enabled = YES;
                [weakSelf updateFirmwareTimeOut];
                _devieUpdateState = NO;
                _updateButton.selected = NO;
                _updateButton.userInteractionEnabled = YES;
                
                [UserInfoHelper sharedInstance].isUpdating = NO;
                [_updateButton setTitle:NSLocalizedString(@"升级失败,请重新升级", nil) forState:UIControlStateNormal];
                [self performSelector:@selector(backButtonClick) withObject:nil afterDelay:2.0];
            }
        }];*/
    }
}

- (void) showProgressView {
    if(_progressView == nil) {
        _progressView = [[UIView alloc] initWithFrame:self.view.bounds];
        _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 132)];
        _showLabel.numberOfLines = 3;
        _showLabel.center = _progressView.center;
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.textColor = [UIColor whiteColor];
        _showLabel.text = KK_Text(@"已升级完成\n APP和固件正在配置信息\n请稍后....");
        [_progressView addSubview:_showLabel];
        
        _hubProgressView = [[HubView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _hubProgressView.center =CGPointMake(self.view.center.x, self.view.center.y + 50);
        
        [_progressView addSubview:_hubProgressView];
    }
    [_progressView popupWithtype:PopupViewOption_colorLump succeedBlock:^(UIView *View)
     {
         View.center = self.view.center;
         [_hubProgressView start];
     } dismissBlock:^(UIView *View) {
         
     }];
}


- (void)updateVersionLabel
{
    _currentVersionLabel.text = [NSString stringWithFormat:@"%@: %@", KK_Text(@"Current Version"), [[DeviceInfoClass sharedInstance] currentVersion]];
    _firmeareVersionLabel.text = [NSString stringWithFormat:@"%@: %@", KK_Text(@"Latest Version"), [[DeviceInfoClass sharedInstance] firmwareVersion]];
}

- (void)updateFirmware
{
    if (_updateCount < 200)
    {
        _updateCount ++;
        [_updateProgessView setProgress:_updateCount];
        [_updateButton setTitle:KK_Text(@"Updating") forState:UIControlStateNormal];
        _updateStateLabel.text = [NSString stringWithFormat:@"%@:%ld %%", KK_Text(@"Update Done"), _updateCount ];
        [self performSelector:@selector(updateFirmware) withObject:nil afterDelay:0.025];
    }
    else
    {
         _updateStateLabel.text = KK_Text(@"Update Complete");
        
        [_updateButton setTitle:KK_Text(@"Device Update") forState:UIControlStateNormal];
        _updateButton.selected = NO;
        _updateButton.userInteractionEnabled = YES;
        _firmeareVersionLabel.text = [NSString stringWithFormat:@"%@: %@",KK_Text(@"Latest Version"), [[DeviceInfoClass sharedInstance]firmwareVersion]];
        
        
   
    }
}

- (void)updateFirmwareTimeOut
{
    if (!_devieUpdateState)
    {
        SHOWMBProgressHUD(KK_Text(@"Update Failed"), nil, nil, NO, 2.0);
        [_updateButton setTitle:KK_Text(@"Update Now") forState:UIControlStateNormal];
        _updateButton.selected = NO;
        [_updateProgessView setHidden:YES];
        [_updateStateLabel setHidden:YES];
        _updateButton.userInteractionEnabled = YES;
    }
}

// 加载进度条
- (void)loadUpdateInfo
{
    CGFloat height = FitScreenNumber(30, 0, 0, 0, 0);
    _updateProgessView = [[DeviceUpdateProgressView alloc] initWithFrame:CGRectMake(20, 415 - 64 +60 - height, self.view.width - 40, 10)];
    _updateProgessView.backgroundColor = UIColorHEX(0x888b90);
    [self.view addSubview:_updateProgessView];
    
    _updateStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
    _updateStateLabel.center = CGPointMake( self.view.center.x,440 - height);
    _updateStateLabel.textAlignment = NSTextAlignmentCenter;
    _updateStateLabel.text = [NSString stringWithFormat:@"%@ 0%%", KK_Text(@"Update Done")];
    _updateStateLabel.textColor = [UIColor whiteColor];
    _updateStateLabel.font = DEFAULT_FONTHelvetica(11);
    [_updateProgessView setHidden:YES];
    [_updateStateLabel setHidden:YES];
    [self.view addSubview:_updateStateLabel];
    
    _updateTimes = 0;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateFirmwareTimeOut) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateFirmware) object:nil];               
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
