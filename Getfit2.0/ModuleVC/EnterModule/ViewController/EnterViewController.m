//
//  EnterViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "EnterViewController.h"
#import "AppDelegate.h"
#import "EnterPch.h"
#import "HubView.h"
#import "CustomieTableView.h"
#import "Information.h"
#import "SexViewController.h"
#import "BLTManager.h"
#import "BLTSendModel.h"

@interface EnterViewController ()

@property (nonatomic, strong) UIView *searchView;                   //搜索窗口视图(主)
@property (nonatomic, strong) HubView *hubProgressView;             //搜索动画视图
@property (nonatomic, strong) UILabel *searchLabel;                 //搜索状态标签

@property (nonatomic, strong) NSArray *deviceList;                  //设备
@property (nonatomic, strong) UIButton *refreshDeviceButton;        //刷新设备按钮
@property (nonatomic, strong) UIButton *bindingDeviceButton;        //绑定设备按钮
@property (nonatomic, strong) CustomieTableView *tableView;        //设备列表
@property (nonatomic, assign) BOOL refresh;

@end

@implementation EnterViewController
{
    UILabel *alertLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DEF_WEAKSELF_(EnterViewController);
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem.title = @"";
    self.navigationItem.hidesBackButton = YES;
    [BLTManager sharedInstance].updateModelBlock = ^(BLTModel *model) {
        [weakSelf updateTableView];
    };
    NSLog(@"%@",[BLTManager sharedInstance].updateModelBlock);
    [BLTManager sharedInstance].connectBlock = ^ {
        [weakSelf noticeViewIsConnected];
    };
    NSLog(@"%@",[BLTManager sharedInstance].connectBlock);
    [BLTManager sharedInstance].disConnectBlock = ^ {
        [weakSelf noticeViewDisConnected];
    };
    NSLog(@"%@",[BLTManager sharedInstance].disConnectBlock);
    _searchView.hidden = YES;
    [self performSelector:@selector(startSearchDevice) withObject:nil afterDelay:0.01];
//    [self startSearchDevice];
    
//    [self controlAnimation:[BLTManager sharedInstance].allWareArray.count > 0 ? NO : YES];
    
}

- (void)updateTableView
{
    _tableView.array = [BLTManager sharedInstance].allWareArray;
    // NSLog(@"蓝牙更新设备>>>%@",_tableView.array);
}

// 蓝牙断开
- (void)noticeViewDisConnected
{
    if ([BLTManager sharedInstance].allWareArray.count == 0)
    {
        [self searchFail];
    }
    else
    {
//        [_bindingDeviceButton setSelected:NO];
//        _bindingDeviceButton.userInteractionEnabled = NO;
//        _bindingDeviceButton.hidden = YES;
    }
}

// 已经连接上
- (void)noticeViewIsConnected
{
    NSLog(@"选中设备>>>>>>");
    [_bindingDeviceButton setSelected:YES];
    _bindingDeviceButton.userInteractionEnabled = YES;
    _bindingDeviceButton.hidden = NO;
    [_bindingDeviceButton setTitle:KK_Text(@"Bind OK") forState:UIControlStateNormal];
    [_tableView.table reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTManager sharedInstance].updateModelBlock = nil;
    [BLTManager sharedInstance].connectBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = KK_Text(@"Add Device");
//    self.view.backgroundColor = UIColorHEX(0x272727);
    self.view.backgroundColor = UIColorHEX(0xededed);
    
    [self loadFunctionButton];
    
    [self ShowTableView];
    
    [self BindingDevice];
    
//  [Information sharedInstance].infoProgressIndex = 1;
//    SexViewController * SexVc = [[SexViewController alloc]init];
//    [self.navigationController pushViewController:SexVc animated:NO];
    
    if (ISTESTMODEL)
    {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app pushContenVc];
    }
}

- (void)loadFunctionButton
{
    CGRect searchViewI5 =CGRectMake(0, 0, self.view.width, self.view.height);

    _searchView = [[UIView alloc] initWithFrame:FitScreenRect(CGRectMake(0, - 30, self.view.width, 270), searchViewI5, searchViewI5, searchViewI5, searchViewI5)];
    
    _searchView.backgroundColor = UIColorHEX(0xededed);
    [self.view addSubview:_searchView];

    _searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 68, self.view.width, 28)];
    _searchLabel.hidden = YES;
    _searchLabel.textAlignment = NSTextAlignmentLeft;
    _searchLabel.font = DEFAULT_FONT(14);
    _searchLabel.textColor =[UIColor blackColor];
    [_searchView addSubview:_searchLabel];


    UILabel *label = [[UILabel alloc] initWithFrame:FitScreenRect(CGRectMake(20, 150, 185, 56), CGRectMake(20, 200, 185, 56), CGRectMake(20, 200, 185, 56), CGRectMake(20, 200, 185, 56), CGRectMake(20, 200, 185, 56))];
    label.text = KK_Text(@"Please confirm:");
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = DEFAULT_FONT(16);
    label.textColor =[UIColor redColor];
    [_searchView addSubview:label];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:FitScreenRect(CGRectMake(20, 180, self.view.width, 80 + 80), CGRectMake(20, 230, self.view.width, 80 + 80), CGRectMake(20, 230, self.view.width, 80 + 80), CGRectMake(20, 230, self.view.width, 80 + 80), CGRectMake(20, 230, self.view.width, 80 + 80))];
    detailLabel.text = KK_Text(@"1. Wake up the device (Screen on) when searching a device.\n2. Bluetooth on the smartphone is ON.\n3. Device is within 10 meters nearby the smartphone.");
    detailLabel.numberOfLines = 5;
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.textColor =[UIColor blackColor];
    [_searchView addSubview:detailLabel];
    
    alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.width, 20)];
    alertLabel.text = KK_Text(@"Please choose a device...");
    alertLabel.textAlignment = NSTextAlignmentLeft;
    alertLabel.font = [UIFont systemFontOfSize:16];
    alertLabel.textColor =[UIColor blackColor];
    [self.view addSubview:alertLabel];
    
    _refreshDeviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshDeviceButton.frame = FitScreenRect(CGRectMake(self.view.center.x - 40, 308, 80, 80),
                                               CGRectMake(self.view.center.x - 40, 328 + 60,  80, 80),
                                               CGRectMake(self.view.center.x - 40, 328 + 60,  80, 80),
                                               CGRectMake(self.view.center.x - 40, 328 + 60,  80, 80),
                                               CGRectMake(self.view.center.x - 40, self.view.height-152, 80, 80));
    [_refreshDeviceButton setBackgroundImage:[UIImage image:@"RefreshButtonSelect_5s"] forState:UIControlStateNormal];
    [_refreshDeviceButton setBackgroundImage:[UIImage image:@"RefreshButtonNormal_5s"] forState:UIControlStateSelected];
    [_refreshDeviceButton setTitle:KK_Text(@"Refresh") forState:UIControlStateNormal];
    [_refreshDeviceButton addTarget:self action:@selector(RefreshDeviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _refreshDeviceButton.layer.cornerRadius = 40;
    _refreshDeviceButton.clipsToBounds = YES;
    _refreshDeviceButton.fontSize = 12.0;
    [self.view addSubview:_refreshDeviceButton];
    
    //绑定按钮
    _bindingDeviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bindingDeviceButton.frame = FitScreenRect(CGRectMake(self.view.center.x + 60, 328, 80, 40), CGRectMake(self.view.center.x + 60, 328+80, 80, 40), CGRectMake(self.view.center.x + 60, 328 + 80, 80, 40), CGRectMake(self.view.center.x + 60, 328+80, 80, 40), CGRectMake(self.view.center.x + 60, self.view.height-132, 80, 40));
    [_bindingDeviceButton setBackgroundImage:[UIImage image:@"RefreshButtonNormal_5s"] forState:UIControlStateNormal];
    [_bindingDeviceButton setBackgroundImage:[UIImage image:@"RefreshButtonSelect_5s"] forState:UIControlStateSelected];
    [_bindingDeviceButton setTitle:KK_Text(@"Skip") forState:UIControlStateNormal];
    [_bindingDeviceButton addTarget:self action:@selector(BindingDeviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindingDeviceButton];
//    _bindingDeviceButton.hidden = YES;
    _bindingDeviceButton.fontSize = 12.0;
    [_bindingDeviceButton setSelected:YES];
//    _bindingDeviceButton.userInteractionEnabled = NO;
    
    _hubProgressView = [[HubView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    _hubProgressView.center =CGPointMake(self.view.center.x, 125);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
    [_hubProgressView addGestureRecognizer:tap];
    
    [_searchView addSubview:_hubProgressView];
}

// 点击图标继续搜索
- (void)imageClick
{
    if (_refresh == NO)
    {
        [self startSearchDevice];
    }
}

- (void)ShowTableView
{
    _tableView = [[CustomieTableView alloc] initWithFrame:FitScreenRect(CGRectMake(0, 40, self.view.width, 250), CGRectMake(0, 40, self.view.width, 330), CGRectMake(0, 40, self.view.width, 330), CGRectMake(0, 40, self.view.width, 330), CGRectMake(0, 40, self.view.width, 330))];
//    [_tableView setHidden:YES];
    _bindingDeviceButton.hidden = YES;
    [self.view addSubview:_tableView];
    
    DEF_WEAKSELF_(EnterViewController);
    _tableView.animationBlock = ^(UIView *aView, id object) {
        [weakSelf controlAnimation:[object boolValue]];
    };
    _tableView.array = [BLTManager sharedInstance].allWareArray;
    
    __weak EnterViewController *safely = self;
    _tableView.devicedidSelectRowBlock = ^(NSInteger index)
    {
        [safely clickItemCellWithIndex:index];
    };
    
}

- (void)clickItemCellWithIndex:(NSInteger)index
{
    [Information sharedInstance].deviceIndex = index;
    SHOWMBProgressHUD(KK_Text(@"Connecting"), nil, nil, NO, 3.0);
    
}

// 开始搜索设备 5秒后结束
- (void)startSearchDevice
{
    _bindingDeviceButton.hidden = YES;
    _tableView.array = nil;
    _refresh = YES;
    [[BLTManager sharedInstance] startCan];
    
    _searchView.hidden = NO;
    alertLabel.text = @"";
    _searchLabel.text = KK_Text(@"Searching device...");
    _searchLabel.hidden = NO;
    [_tableView setHidden:YES];
    [_hubProgressView start];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchFinish) object:nil];
    [self performSelector:@selector(searchFinish) withObject:nil afterDelay:3.0];
    
    DEF_WEAKSELF_(EnterViewController);
    if ([BLTManager sharedInstance].updateModelBlock == nil) {
        [BLTManager sharedInstance].updateModelBlock = ^(BLTModel *model) {
            [weakSelf updateTableView];
        };
    }
    if ([BLTManager sharedInstance].connectBlock == nil) {
        [BLTManager sharedInstance].connectBlock = ^ {
            [weakSelf noticeViewIsConnected];
        };
    }
    if ([BLTManager sharedInstance].disConnectBlock == nil) {
        [BLTManager sharedInstance].disConnectBlock = ^ {
            [weakSelf noticeViewDisConnected];
        };
    }
}

- (void)searchFinish
{ 
    _refresh = NO;
    [_hubProgressView stopSearch];
    
    if (_tableView.array.count > 0)
    {
        if([BLTManager sharedInstance].model.isConnected) {
            [_bindingDeviceButton setTitle:KK_Text(@"Bind OK") forState:UIControlStateNormal];
        }else {
             [_bindingDeviceButton setTitle:KK_Text(@"Please choose a device...") forState:UIControlStateNormal];
        }
        [_tableView setHidden:NO];
        _searchView.hidden = YES;
        alertLabel.text = KK_Text(@"Please choose a device...");
    }
    else
    {
        _bindingDeviceButton.hidden = NO;
        [_bindingDeviceButton setTitle:KK_Text(@"Skip") forState:UIControlStateNormal];
        [self searchFail];
    }
}


- (void)searchFail
{
    [_hubProgressView stopSearch];
    [_tableView setHidden:YES];
    _searchView.hidden = NO;
    _searchLabel.text = KK_Text(@"Search Failed, click the icon to refresh searching the device");
//    [_bindingDeviceButton setSelected:NO];
    
//    _bindingDeviceButton.hidden = YES;
//    _bindingDeviceButton.userInteractionEnabled = NO;
}


- (void)controlAnimation:(BOOL)animation
{
    
    if (animation)
    {
        if (_searchView.hidden)
        {
            [self startSearchDevice];
        }
    }
    else
    {
        if (!_searchView.hidden)
        {
            _bindingDeviceButton.hidden = NO;
            _searchView.hidden = YES;
        }
    }
}

//确定绑定按钮 跳转个人资料设置
- (void)BindingDevice
{
    DEF_WEAKSELF_(EnterViewController)
    // 发送绑定
    
//    [[UserInfoHelper sharedInstance] sendDeviceFunctionWithBackBlock:^(id object) {
////        [weakSelf boindDevice];
  
//    }];
    
    [self performSelector:@selector(boindDevice) withObject:nil afterDelay:0.05];
}

- (void)boindDevice
{
    if ([BLTManager sharedInstance].model.isConnected)
    {
        NSLog(@" 已经链接>>>>");
            [BLTManager sharedInstance].model.isBinding = YES;
            [BLTManager sharedInstance].model.isRepeatConnect = YES;  /////绑定成功,设定该设备
              SHOWMBProgressHUD(KK_Text(@"Bind Success"), nil, nil, NO, 1.0);
        
            if ([SAVEENTERUSERKEY getBOOLValue])
            {
                [self.navigationController popViewControllerAnimated:NO];
            }
            else
            {
                [Information sharedInstance].infoProgressIndex = 1;
                SexViewController * SexVc = [[SexViewController alloc]init];
                [self.navigationController pushViewController:SexVc animated:NO];
            }
    }
}

- (void)pushDelay
{
    if ([SAVEENTERUSERKEY getBOOLValue])
    {
        [self.navigationController popViewControllerAnimated:NO];
    }else {
        [Information sharedInstance].infoProgressIndex = 1;
        SexViewController * SexVc = [[SexViewController alloc]init];
        [self.navigationController pushViewController:SexVc animated:NO];
    }
}

- (void)SearchDeviceFail
{
    [_hubProgressView stopSearch];
    _searchLabel.text = KK_Text(@"Search Failed, click the icon to refresh searching the device");
    
}

// 刷新
- (void)RefreshDeviceButtonClick:(UIButton*)Sender
{
    NSLog(@"按钮刷新>>>>>>>>");
      [self startSearchDevice];
}

- (void)BindingDeviceButtonClick:(UIButton*)Sender
{
//    [Information sharedInstance].infoProgressIndex = 1;
    if([_bindingDeviceButton.titleLabel.text isEqualToString:KK_Text(@"Skip")]) {
        SexViewController * SexVc = [[SexViewController alloc]init];
        [self.navigationController pushViewController:SexVc animated:NO];
    }
  
    if (_bindingDeviceButton.userInteractionEnabled)
    {
        [self BindingDevice];
    }
}

- (CGPathRef)drawPathWithArcCenter:(CGFloat)radius Center:(CGPoint)Point start:(NSInteger)index
{
    CGFloat StartValue = - M_PI_2 + (index - 1) * 4 * M_PI_2/14;
    CGFloat width = 4 * M_PI_2 / 360/3;
    return [UIBezierPath bezierPathWithArcCenter:Point
                                          radius:radius
                                      startAngle:(- M_PI_2 +StartValue)
                                        endAngle:(- M_PI_2 +StartValue+width)
                                       clockwise:YES].CGPath;
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
