//
//  HomeSleepView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/24.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeryFitMainSleepChatView.h"
#import "SleepCircleView.h"
#import "PedometerModel.h"

@interface HomeSleepView : UIView <VeryFitMainSleepViewDelegate>

@property (nonatomic, strong) UILabel *deepSleepLabel;
@property (nonatomic, strong) UILabel *shallowLabel;
@property (nonatomic, strong) UILabel *soberLabel;
@property (nonatomic, strong) UILabel *finishTargetLabel;
@property (nonatomic, strong) VeryFitMainSleepChatView *chatrView;
@property (nonatomic, strong) SleepCircleView *mainView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *sleepMoonImage;

@property (nonatomic, strong) PedometerModel *model;

- (void)dismissView;

- (void)updateViewsWithModel:(PedometerModel *)model;
- (void)mainViewTouch;
@end
