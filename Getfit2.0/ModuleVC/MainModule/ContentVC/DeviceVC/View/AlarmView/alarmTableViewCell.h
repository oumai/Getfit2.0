//
//  alarmTableViewCell.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmClockModel.h"
#import "CustomSwitch.h"

@interface alarmTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * alarmIcon;
@property (nonatomic, strong) UILabel *alarmTimeLabel;
@property (nonatomic, strong) UILabel *alarmWeeksLabel;
@property (nonatomic, strong) UILabel *alarmTypeLabel;
@property (nonatomic, strong) UILabel *isSysLable;
@property (nonatomic, strong) CustomSwitch *alarmSwitchButton;

@property (nonatomic, strong) UIView *whiteLine;
@property (nonatomic, strong) UIView *addAlarm;
@property (nonatomic, strong) UILabel *addAlarmLabel;
@property (nonatomic, strong) UIButton *addAlarmButton;

@property (nonatomic, strong) AlarmClockModel *model;


- (void)alarmTableViewUpdateCell:(AlarmClockModel *)model withHeight:(CGFloat)height;


@end
