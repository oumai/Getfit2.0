//
//  SleepCircleView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/9.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SleepMoonView.h"
#import "PedometerModel.h"
#import "PedometerHelper.h"
@interface SleepCircleView : UIView

@property (nonatomic, strong) UILabel *sleepTimeLabel;
@property (nonatomic, strong) UILabel *sleepTimeUnitLabel;
@property (nonatomic, strong) UILabel *sleepBeginTime;
@property (nonatomic, strong) UILabel *sleepEndTime;
@property (nonatomic, strong) SleepMoonView *moonView;
@property (nonatomic, strong) PedometerModel *model;

- (void)updateViewsWithModel:(PedometerModel *)model;

@end
