//
//  MainCircleView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/3.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PedometerModel.h"

@protocol mainViewDelegate <NSObject>

- (void)MainUpdteProgressFinish;

@end

@interface MainCircleView : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *mainView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *peopleImage;
@property (nonatomic, strong) UILabel *currentStepLabel; // 当天步数
@property (nonatomic, strong) UILabel *targetStepLabel;  // 目标步数
@property (nonatomic, strong) UILabel *progressLabel;    // 进度
@property (nonatomic, strong) UILabel *stepUnit;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) int currentProgress;

@property (nonatomic, strong) PedometerModel *model;

@property (nonatomic, strong) id<mainViewDelegate> mainViewUpdteDelegate;

- (void)StartupdateProgress;

- (void)updateProgress;
- (void)updateViewsWithModel:(PedometerModel *)model;

- (void)updateTarget;
- (void)LoadData;

@end
