//
//  DeviceTableView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomieTableView.h"

typedef void(^BONDINGBTNBLOCK)();

@interface DeviceTableView : UIView <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>;

typedef void(^TableViewSelect) (NSInteger indexRow);

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *redHeaderView;
@property (nonatomic, strong) UILabel *deviceNameLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, strong) UILabel *firmwareVersion;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *macLabel;
@property (nonatomic, strong) UILabel *softWareVersion;
@property (nonatomic, strong) NSArray *deviceFunctionList;
@property (nonatomic, strong) UIButton *boindButton;
@property (nonatomic, strong) CustomieTableView *deviceTableView; // 设备列表
@property (nonatomic, strong) UIView *deviceViewBackGround;
@property (nonatomic, strong) TableViewSelect selectIndexRowBlock;
@property (nonatomic, copy) BONDINGBTNBLOCK bondingBlock;


- (void)updateTableView;
- (void)updateContentForSubViews;

@end
