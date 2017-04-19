//
//  AlarmRemindViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "AlarmRemindViewController.h"
#import "DeviceInfoClass.h"
#import "UserInfoHelper.h"
#import "BLTManager.h"

@interface AlarmRemindViewController ()

@end

@implementation AlarmRemindViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DEF_WEAKSELF_(AlarmRemindViewController);
    [BLTManager sharedInstance].connectBlock = ^ {
        weakSelf.tableView.alarmArray = [UserInfoHelper sharedInstance].bltModel.alarmArray;
    };
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTManager sharedInstance].connectBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self loadAlarmView];
    [self loadTableView];
    [self loadRefreshView];
}

- (void)loadAlarmView
{
    self.tipTitle.text = KK_Text(@"Alarm List Setting");
    
    _tableView = [[AlarmTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)];
    [self.view addSubview:_tableView];
    _tableView.alarmArray = [UserInfoHelper sharedInstance].bltModel.alarmArray;
    
    self.view.backgroundColor = UIColorHEX(0x272727);
}

- (void)loadRefreshView
{
    _refreshView = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshView.frame = CGRectMake(self.view.width - 44, 0, 44, 44);
    [self.navigationController.navigationBar addSubview:_refreshView];
    _refreshView.backgroundColor = UIColorHEX(0xef5543);

    _alarmUpdateRefresh = [[DeviceRefreshView alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
    _alarmUpdateRefresh.center = CGPointMake(22, 22);
    [_refreshView addSubview:_alarmUpdateRefresh];
    [_refreshView setHidden:YES];
}

- (void)loadTableView
{
    
}

- (void)leftBarButton
{
    if (_tableView.editState == YES)
    {
        [self.view animationWithViewTransition:^(UIView *aView, id object) {
            [_tableView.alarmAppendView setHidden:YES];
            [_tableView.tableView setHidden:NO];
            _tableView.editState = NO;
            [_tableView.tableView reloadData];
        }];
        
    }else
    {
        [_tableView tableViewDismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBarButton
{
    if(_tableView.editState == YES)
    {
        SHOWMBProgressHUD(KK_Text(@"Setting success"), nil, nil, NO, 1.0);
        [_tableView.tableView setHidden:NO];
        [_tableView.alarmAppendView setHidden:YES];
        _tableView.editState = NO;
        [_tableView.tableView reloadData];

    }else
    {
        // 发送闹钟数据到蓝牙
        DEF_WEAKSELF_(AlarmRemindViewController)
        [_refreshView setHidden:NO];
        [_alarmUpdateRefresh Start:1.0 refreshtype:2 startRefreshBlock:^(DeviceRefreshView *refreshView) {
            [weakSelf alarmSet];
            [_refreshView setHidden:NO];
            
        } endRefreshBlock:^(DeviceRefreshView *refreshView)
         {
            [_refreshView setHidden:YES];
        }];
    }
  
}
- (void)alarmSet
{
    [[UserInfoHelper sharedInstance] startSetAlarmClock];
    [self performSelector:@selector(reloadTableViewData) withObject:self afterDelay:2.0];
}
- (void)reloadTableViewData {
    [_tableView.tableView reloadData];
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
