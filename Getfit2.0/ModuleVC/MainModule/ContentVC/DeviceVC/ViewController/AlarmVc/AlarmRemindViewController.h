//
//  AlarmRemindViewController.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceNavViewController.h"
#import "AlarmTableView.h"
#import "DeviceRefreshView.h"

@interface AlarmRemindViewController : DeviceNavViewController

@property (nonatomic, strong) AlarmTableView *tableView;
@property (nonatomic, strong) DeviceRefreshView *alarmUpdateRefresh;
@property (nonatomic, strong) UIButton *refreshView;

@end
