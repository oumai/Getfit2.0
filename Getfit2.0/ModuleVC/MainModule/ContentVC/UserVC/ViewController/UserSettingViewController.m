//
//  UserSettingViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/20.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserSettingViewController.h"
#import "UserProfileViewTableCell.h"
#import "CustomPickerView.h"
#import "CustomsPickView.h"
#import "AboutusViewController.h"
#import "BLTSimpleSend.h"
#import "TestViewController.h"
#import "AudioHelper.h"

@interface UserSettingViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *userDataArray; 
@property (nonatomic, strong) CustomsPickView *pickViewBg;
@property (nonatomic, strong) CustomPickerView *PickView;
@property (nonatomic, strong) UIView *adorableView;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, assign) BOOL isRestartClick;

@end

@implementation UserSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    _isRestartClick = NO;
    [BLTSimpleSend sharedInstance].synProgressBlock = ^ (int progress, BLTSimpleSendSynProgress type) {
        if (type == BLTSimpleSendSynProgressNormal) {
            NSString *str = [NSString stringWithFormat:@"数据已同步:%d%%",progress];
            _progressLabel.text = str;
        }else if (type == BLTSimpleSendSynProgressFail) {
            
        }else if (type == BLTSimpleSendSynProgressSuccess){
            [self performSelector:@selector(reStart) withObject:nil afterDelay:0.5];
        }
    };
}
- (void)viewWillDisappear:(BOOL)animated {
    [BLTSimpleSend sharedInstance].synProgressBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNaBar];
    [self loadTableView];
    [self loadPickUpView];
    
}
- (void)loadNaBar
{
    self.view.backgroundColor = UIColorHEX(0x262626);
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, 64)];
    topView.backgroundColor = BGCOLOR;
    [self.view addSubview:topView];
    
    UILabel *title = [UILabel simpleWithRect:CGRectMake(Maxwidth/2 - 60, 20 + 12, 120, 20)];
    title.font = DEFAULT_FONTHelvetica(16.0);
    title.text = KK_Text(@"System Setting");
    title.textColor = [UIColor whiteColor];
    [self.view addSubview:title];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    backButton.bgImageNormal = @"Device_back_5s@2x.png";
    backButton.bgImageHighlight = @"Device_back_5s@2x.png";
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)backButton:(UIButton *)sender
{
    NSLog(@"返回>>>>");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadTableView
{
    
    _titleArray = [[NSArray alloc]initWithObjects:KK_Text(@"Unit Set"),
                   KK_Text(@"Temperature"),
                   KK_Text(@"About Us"),
                   KK_Text(@"Restart Device"),
                   KK_Text(@"APP Version"), nil];
    
    _userDataArray = [[NSMutableArray alloc] init];
    if ([UserInfoHelper sharedInstance].userModel.isMetricSystem) {
        [_userDataArray addObject:KK_Text(@"Metric")];
    } else {
        [_userDataArray addObject:KK_Text(@"British")];
    }
    
    if ([UserInfoHelper sharedInstance].userModel.isFahrenheit) {
        [_userDataArray addObject:@"℉"];
    } else {
        [_userDataArray addObject:@"℃"];
    }

    [_userDataArray addObject:@""];
    [_userDataArray addObject:@""];
   
//    [_userDataArray addObject:@"V1.2"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [_userDataArray addObject:version];
    [_userDataArray addObject:@""];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 160) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self setExtraCellLineHidden:_tableView];
}

- (void)loadPickUpView
{
    _adorableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, Maxheight)];
    _adorableView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    _adorableView.hidden = YES;
    [self.view addSubview:_adorableView];
    
    _pickViewBg = [[CustomsPickView alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, 216 + 44)];
    [self.view addSubview:_pickViewBg];
    
    _PickView = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 44, Maxwidth, 216 )];
    [_pickViewBg addSubview:_PickView];
    
    //点击确定  保存的 BOOL值
    DEF_WEAKSELF_(UserSettingViewController)
    _pickViewBg.customPickClickBlock = ^(BOOL value)
    {
        if (value) {
            [weakSelf saveUserInfo];
        }
        weakSelf.adorableView.hidden = YES;
        [weakSelf.pickViewBg hiddenView];
        NSLog(@"ifReadOnly value: %@" ,value?@"YES":@"NO");
    };
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _adorableView.hidden = YES;
    [_pickViewBg hiddenView];
}

- (void)settingButtonClick:(UIButton*)sender
{
    NSLog(@"settingButtonClick>>>%ld",sender.tag);
    
    if (sender.tag == 0) {
        _PickView.dataArray = nil;
        _PickView.dataArray2 = nil;
        _PickView.dataArray3 = nil;
        _PickView.dataArray = [[NSArray alloc] initWithObjects:KK_Text(@"Metric"),
                               KK_Text(@"British"), nil];
        [_pickViewBg showView];
        self.adorableView.hidden = NO;
    } else if (sender.tag == 1) {
        _PickView.dataArray = nil;
        _PickView.dataArray2 = nil;
        _PickView.dataArray3 = nil;
        _PickView.dataArray = [[NSArray alloc]initWithObjects:@"℃",
                               @"℉", nil];
        
        if(![UserInfoHelper sharedInstance].userModel.isFahrenheit){
            [_PickView selectRow:1 inComponent:0 animated:YES];
        }
        [_pickViewBg showView];
        NSLog(@"isFahrenheit = %d", [UserInfoHelper sharedInstance].userModel.isFahrenheit);
        self.adorableView.hidden = NO;
    }
}
//判断是  公制还是英制
- (void)saveUserInfo
{
    NSInteger row1 = [_PickView selectedRowInComponent:0];
    NSString *replaceString = [_PickView.dataArray objectAtIndex:row1];
    
    
    if ([replaceString isEqualToString:KK_Text(@"Metric")]) {
        [UserInfoHelper sharedInstance].userModel.isMetricSystem = YES;
        [_userDataArray replaceObjectAtIndex:0 withObject:replaceString];
    } else if ([replaceString isEqualToString:KK_Text(@"British")]) {
        [UserInfoHelper sharedInstance].userModel.isMetricSystem = NO;
        [_userDataArray replaceObjectAtIndex:0 withObject:replaceString];
    } else if ([replaceString isEqualToString:@"℉"]) {
        [UserInfoHelper sharedInstance].userModel.isFahrenheit  = YES;
        [_userDataArray replaceObjectAtIndex:1 withObject:replaceString];
    } else if ([replaceString isEqualToString:@"℃"]) {
        [UserInfoHelper sharedInstance].userModel.isFahrenheit = NO;
        [_userDataArray replaceObjectAtIndex:1 withObject:replaceString];
    }
    
    // 同步用户信息
    [BLTSendModel sendSysUserInfo:^(id object, BLTAcceptModelType type) {
    }];
    
    [_tableView reloadData];
}

-(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = UIColorHEX(0x272727);
    [tableView setTableFooterView:view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"UserProfileTableViewCell";
    UserProfileViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[UserProfileViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    
    [cell userProfileUpateCellTitle:[_titleArray objectAtIndex:indexPath.row] update:[_userDataArray objectAtIndex:indexPath.row ]index:indexPath.row];
    cell.userData.frame = CGRectMake(self.view.width - 110, (55 - 25)/2, 80, 25);
    cell.userData.textAlignment = NSTextAlignmentRight;
    cell.userData.font = DEFAULT_FONTHelvetica(10.0);
    cell.userData.textColor = UIColorHEX(0x888b90);
    
    cell.textField.hidden = YES;

    if (indexPath.row == 1) {
        cell.userData.hidden = NO;
    } else {
        cell.userData.hidden = NO;
    }
    
    if (indexPath.row == 3) {
        cell.userInteractionEnabled = NO;  ////不能被选择
        cell.settingButton.hidden = YES;
        cell.userData.frame = CGRectMake(self.view.width - 100, (55 - 25)/2, 90, 25);
    } else {
        cell.settingButton.hidden = NO;
        cell.settingButton.tag = indexPath.row;
        // [cell.settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.settingButton.userInteractionEnabled = NO;
    }

    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        if (!ISCHANGEMODEL) {
            cell.settingButton.userInteractionEnabled = NO;
        }
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    switch (indexPath.row) {
        case 0: {
            _PickView.dataArray = nil;
            _PickView.dataArray2 = nil;
            _PickView.dataArray3 = nil;
            //Metric(公制)   British(英制)
            _PickView.dataArray = [[NSArray alloc]initWithObjects:KK_Text(@"Metric"),
                                   KK_Text(@"British"), nil];
            
            [_PickView selectRow:![UserInfoHelper sharedInstance].userModel.isMetricSystem inComponent:0 animated:YES];
            [_pickViewBg showView];
            NSLog(@"isMetricSystem = %d", [UserInfoHelper sharedInstance].userModel.isMetricSystem);
            self.adorableView.hidden = NO;
        }
            break;
        case 1: {
            _PickView.dataArray = nil;
            _PickView.dataArray2 = nil;
            _PickView.dataArray3 = nil;
            _PickView.dataArray = [[NSArray alloc]initWithObjects:@"℃",
                                   @"℉", nil];
            
            [_PickView selectRow:[UserInfoHelper sharedInstance].userModel.isFahrenheit inComponent:0 animated:YES];
            [_pickViewBg showView];
            NSLog(@"isFahrenheit = %d", [UserInfoHelper sharedInstance].userModel.isFahrenheit);
            self.adorableView.hidden = NO;
        }
            break;
        case 2: {
            AboutusViewController *aboutUsView = [[AboutusViewController alloc]init];
            [self.navigationController pushViewController:aboutUsView animated:YES];
        }
            break;
        case 3: {
            [self showSelectView];
        }
            break;
        case 4: {
            // 测试一下音乐播放器
            // [KK_AudioHelper playAudio];
        }
            break;
        case 5: {
            [self showTestView];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSelectView
{
    if (!_selectView) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, 320, 180)];
        
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = [UIColor whiteColor];
        [_selectView addSubview:_progressLabel];
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, _selectView.height - 52, self.view.width - 20, 44)];
        cancelButton.layer.cornerRadius = 5;
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:KK_Text(@"Cancel") forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelbuttonClick) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:cancelButton];
        
        UIButton *takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(10, _selectView.height - 104, self.view.width - 20, 44)];
        takePhotoButton.layer.cornerRadius = 3;
        takePhotoButton.backgroundColor = [UIColor whiteColor];
        [takePhotoButton setTitle:KK_Text(@"Confirm Reboot") forState:UIControlStateNormal];
        [takePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [takePhotoButton addTarget:self action:@selector(restartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:takePhotoButton];

        UIButton *settingImageButton = [[UIButton alloc] initWithFrame:CGRectMake(10, _selectView.height - 149, self.view.width - 20, 44)];
        settingImageButton.layer.cornerRadius = 3;
        settingImageButton.backgroundColor = [UIColor whiteColor];
        [settingImageButton setTitle:KK_Text(@"Reboot the device? Data will be synced before reboot") forState:UIControlStateNormal];
        [settingImageButton setTitleColor:UIColorHEX(0x888b90) forState:UIControlStateNormal];
        [settingImageButton setFontSize:11.0];
        [settingImageButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:settingImageButton];
    }
    
    [_selectView popupWithtype:PopupViewOption_colorLump succeedBlock:^(UIView *View) {
         View.center = CGPointMake(self.view.center.x, self.view.height - 90);
         _progressLabel.text = @"";
         
     } dismissBlock:^(UIView *View) {
         
     }];
}

- (void)showTestView
{
    if (!_testDataBackGroundView) {
        _testDataBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 200)];
        _testDataBackGroundView.backgroundColor = [UIColor whiteColor];
//        [_testDataBackGroundView addSubview:[TestViewController shareInstance].bleDetailTextView2];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10,  10, self.view.width - 20, 44)];
        btn.backgroundColor = BGCOLOR;
        [btn setTitle:NSLocalizedString(@"获取日志", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(getLogData) forControlEvents:UIControlEventTouchUpInside];
        [_testDataBackGroundView addSubview:btn];
    }
    
    [_testDataBackGroundView popupWithtype:PopupViewOption_colorLump succeedBlock:^(UIView *View) {
         View.center = CGPointMake(self.view.width/2, self.view.height - (self.view.height - 200)/2);
     } dismissBlock:^(UIView *View) {
     }];
}

- (void)getLogData
{
    [[UserInfoHelper sharedInstance] sendDeviceReportWithBackBlock:^(id object) {
        NSData *data = object;
       
        NSLog(@"%@",data);
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"str--%@",str);
//        [[TestViewController shareInstance] updateLog2:[NSString stringWithFormat:@"read<<<<%@",str]];
        [self performSelector:@selector(getLogData) withObject:nil afterDelay:0.3];
    } WithFinishBlcok:^(id object) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getLogData) object:nil];
//        [[TestViewController shareInstance] updateLog2:[NSString stringWithFormat:@"-----------ReadLogFinish-----------"]];
    }];
}

- (void)restartButtonClick:(UIButton *)sender {
    _isRestartClick = YES;
//    [[TestViewController shareInstance] updateLog:@"重启设备同步请求"];
//    [[BLTSimpleSend sharedInstance] startSynHistoryAndTodayData:NO];
    
    [BLTSendModel sendReSetInfo:^(id object, BLTAcceptModelType type) {
        
    }];
}

- (void)reStart
{
    if(_isRestartClick) {
        [[UserInfoHelper sharedInstance] senddeviceRoloadWithBackBlock:^(id object) {
            SHOWMBProgressHUD(KK_Text(@"Reboot Done"), nil, nil, NO, 1.0);
            [_selectView dismissPopup];
            _isRestartClick = NO;
        }];
    }
}

- (void)cancelbuttonClick
{
    [_selectView dismissPopup];
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
