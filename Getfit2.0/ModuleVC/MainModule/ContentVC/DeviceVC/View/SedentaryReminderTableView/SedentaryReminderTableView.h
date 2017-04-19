//
//  SedentaryReminderTableView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SedentaryReminderSelectDelegate <NSObject>

- (void)SedentaryReminderSelect:(NSInteger)indexRow;

@end

@interface SedentaryReminderTableView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) id<SedentaryReminderSelectDelegate> SedentaryReminderSelectDelegate;

@end
