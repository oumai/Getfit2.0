//
//  AlarmTableView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmAppendView.h"

@interface AlarmTableView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *alarmArray;
@property (nonatomic, strong) AlarmAppendView * alarmAppendView;
@property (nonatomic, assign) BOOL editState;

- (void)tableViewDismiss;

@end
