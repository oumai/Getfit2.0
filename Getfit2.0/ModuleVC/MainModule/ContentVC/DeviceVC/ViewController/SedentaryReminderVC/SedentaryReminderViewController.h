//
//  SedentaryReminderViewController.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceNavViewController.h"
#import "KUlSlide.h"
#import "WeekView.h"
#import "SedentaryReminderTableView.h"
#import "SelectTimePickUpView.h"
#import "RemindModel.h"
#import "CustomSwitch.h"

@interface SedentaryReminderViewController : DeviceNavViewController <SliderDelegate,SedentaryReminderSelectDelegate>

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) CustomSwitch *switchButton;
@property (nonatomic, strong) KUlSlide *slider;
@property (nonatomic, strong) UILabel *minValueLabel;
@property (nonatomic, strong) UILabel *maxValueLabel;

@property (nonatomic, strong) UILabel *beginTimeLabl;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) SedentaryReminderTableView *tableView;
@property (nonatomic, strong) SelectTimePickUpView *pickUpSelectView;
@property (nonatomic, assign) NSInteger selectTimeIndex;
@property (nonatomic, strong) NSMutableArray *setTimeArray;
@property (nonatomic, strong) WeekView *weekView;

@property (nonatomic, strong) UIButton *button01;
@property (nonatomic, strong) UIButton *button02;
@property (nonatomic, strong) UIButton *button03;
@property (nonatomic, assign) NSInteger settingTime;

@end
