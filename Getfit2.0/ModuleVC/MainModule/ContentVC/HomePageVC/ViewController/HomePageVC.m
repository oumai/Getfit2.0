//
//  HomePageVC.m
//  AJBracelet
//
//  Created by zorro on 15/6/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageTableView.h"

#import "BLTSimpleSend.h"
#import "PedometerHelper.h"
#import "TestViewController.h"
#import "AppDelegate.h"
#import "BackGroundTaskView.h"
#import "UseDataShowViewController.h"
#import "WeekModel.h"

@interface HomePageVC () <HomePageTableDateDelegate>

@property (nonatomic, strong) HomePageTableView *homePageTableView;

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) PedometerModel *model;
@property (nonatomic, strong) NSTimer *stepUpdateTimer;

@property (nonatomic, strong) NSDate *currentSysDate;
@property (nonatomic, assign) NSInteger lastSteps;

@end

@implementation HomePageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _currentDate = [NSDate date];
    [self loadTableView];
    
    _homePageTableView.homePageTableDelegate = self;
    [BackGroundTaskView sharedInstance];
    
//    [BLTSendModel sendGetDeviceTemperature:^(id object, BLTAcceptModelType type) {
//        
//    }];
    self.view.userInteractionEnabled = YES;

}

- (NSDate *)getDate:(NSInteger)index;
{
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[NSDate dateFormatterTemp];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval time = - 24 * 3600 * index * 7;
    NSDate *beforeData =[senddate initWithTimeIntervalSinceNow:time];
    return beforeData;
}
- (void)beacomActive
{
    [_homePageTableView backToday];
    [WeekModel getWeekModelFromDBWithDate:[self getDate:0] isContinue:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTAcceptModel sharedInstance].realTimeBlock = nil;
    [BLTAcceptModel sharedInstance].detailDataBlock = nil;
    
    [BLTSimpleSend sharedInstance].backBlock = nil;
    [BLTManager sharedInstance].connectBlock = nil;
    
    [BackGroundTaskView sharedInstance].BackGroundTaskBlock = nil;

    if (_stepUpdateTimer) {
        [_stepUpdateTimer invalidate];
        _stepUpdateTimer = nil;
    }
    
    [_homePageTableView.homeView.circleView updateTarget];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DEF_WEAKSELF_(HomePageVC)
    [BLTSimpleSend sharedInstance].backBlock = ^(NSDate *date) {
        [weakSelf updateViewsForCurrentVC:weakSelf.currentDate];
    };
    
    [BLTManager sharedInstance].connectBlock = ^ {
        [weakSelf updateViewsForCurrentVC:weakSelf.currentDate];
        [weakSelf didConnect];
    };
    
    [BLTManager sharedInstance].disConnectBlock = ^{
        [weakSelf disConnecct];
    };
    
    // 接收到8个字节数据, 实时数据
    [BLTAcceptModel sharedInstance].realTimeBlock = ^ (id object, BLTAcceptModelType type) {
        [weakSelf updateRealTimeData:object];
    };
    
    // 数据同步完成
    [BLTAcceptModel sharedInstance].detailDataBlock = ^ (id object, BLTAcceptModelType type) {
        [weakSelf updateRealTimeData:object];
    };
    
    if (_homePageTableView.todayOrSleep)
    {
        [_homePageTableView.homeView dismissView];   // 更新今天详情数据
    }
    
    [self updateViewsForCurrentVC:_currentDate];
    
    if ([BLTManager sharedInstance].model!=nil)
    {
        if ([BLTManager sharedInstance].model.isConnected)
        {
           _homePageTableView.blueToothButton.bgImageNormal = @"home_btn_link_5s@2x.png";
        }
    }
    
    if (_stepUpdateTimer) {
        [_stepUpdateTimer invalidate];
        _stepUpdateTimer = nil;
    }
    
    [BLTSimpleSend sharedInstance].synProgressBlock = ^ (int progress, BLTSimpleSendSynProgress type) {
        if (type == BLTSimpleSendSynProgressNormal) {
            weakSelf.homePageTableView.tableView.header.titleLabel.text = [NSString stringWithFormat:@"%@%d%%", KK_Text(@"Synced"), progress];
            if(progress == 100) {
                _homePageTableView.tableView.header.titleLabel.text = KK_Text(@"Sync Done");
                [weakSelf.homePageTableView performSelector:@selector(endRefresh) withObject:nil afterDelay:1];
            }
        }else if (type == BLTSimpleSendSynProgressFail) {
            
            [weakSelf.homePageTableView.tableView.legendHeader.activityView stopAnimating];
            weakSelf.homePageTableView.tableView.legendHeader.stateImageV.image = [UIImage image:@"syn_fail_5@2x"];
            weakSelf.homePageTableView.tableView.header.titleLabel.text = KK_Text(@"Sync Failed");
            [weakSelf.homePageTableView performSelector:@selector(endRefresh) withObject:nil afterDelay:1];
        }else if (type == BLTSimpleSendSynProgressSuccess){
            
        }
    };
    
    [BackGroundTaskView sharedInstance].BackGroundTaskBlock = ^(BOOL type)
    {
        if (!type) {
            [weakSelf beacomActive];
        }
    };
    
    if ( [UserInfoHelper sharedInstance].bltModel.isConnected) {
        _homePageTableView.blueToothButton.bgImageNormal = @"home_btn_link_5s@2x.png";
    } else {
        _homePageTableView.blueToothButton.bgImageNormal = @"home_btn_unlink_5s@2x.png";
    }
}

- (void)updateTableView
{
    _homePageTableView.deviceTableView.array = [BLTManager sharedInstance].allWareArray;
}

- (void)sysAgain
{
    [[BLTSimpleSend sharedInstance]sendSysDeviceInfo5];
}

// 蓝牙连接
- (void)didConnect
{
     _homePageTableView.blueToothButton.bgImageNormal = @"home_btn_link_5s@2x.png";
}

//  更新实时的数据.
- (void)updateRealTimeData:(id)object
{
    NSString *nowDateString = [[[NSDate date] dateToString] componentsSeparatedByString:@" "][0];
    if ([nowDateString isEqualToString:_model.dateString])
    {
        [self updateSysData];
    }
}

// 解析数据到数据库 更新界面
- (void)updateSysData
{
    [self updateViewsForCurrentVC:_currentDate];
}

// 蓝牙断开
- (void)disConnecct
{
    _homePageTableView.blueToothButton.bgImageNormal = @"home_btn_unlink_5s@2x.png";
    // [_homePageTableView.deviceTableView.table reloadData];
}

- (void)updateViewsForCurrentVC:(NSDate *)date
{
    if (date) {
        self.model = [PedometerHelper getModelFromDBWithDate:date];
        [self.homePageTableView updateTodayViewAndSleepView:self.model];
        [_homePageTableView.homeView.circleView updateTarget];
        [_homePageTableView.homeView.circleView LoadData];
        
        _lastSteps = _model.totalSteps;
    }
}

- (void)HomePageTableDateUpdate:(NSDate *)date
{
    [self setCurrentDate:date];
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    [self updateViewsForCurrentVC:_currentDate];
}

- (void)loadTableView
{
    _homePageTableView = [[HomePageTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    //_homePageTableView.backgroundColor = [UIColor lightGrayColor];
//    UIImageView *iamge = [[UIImageView alloc]initWithImage:[UIImage image:@"bg_day_5s.png"]];
//    iamge.frame = _homePageTableView.frame;
//    _homePageTableView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:iamge];
    [self.view addSubview:_homePageTableView];
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

- (void)endRefresh
{
    
}


@end
