//
//  CallReminderViewController.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceNavViewController.h"
#import "KUlSlide.h"
#import "BLTModel.h"
#import "CustomSwitch.h"

@interface CallReminderViewController : DeviceNavViewController <SliderDelegate>

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) CustomSwitch *switchButton;
@property (nonatomic, strong) KUlSlide *slider;
@property (nonatomic, strong) UILabel *minValueLabel;
@property (nonatomic, strong) UILabel *maxValueLabel;

@end
