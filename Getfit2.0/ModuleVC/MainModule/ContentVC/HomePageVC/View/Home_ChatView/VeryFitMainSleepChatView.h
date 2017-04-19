//
//  VeryFitMainSleepChatView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PedometerHelper.h"
#import "PedometerModel.h"

@protocol VeryFitMainSleepViewDelegate <NSObject>

- (void)dismissView;

@end

@interface VeryFitMainSleepChatView : UIView

@property (nonatomic, assign) id <VeryFitMainSleepViewDelegate> veryFitMainSleepDelegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *sleepDataArray;
@property (nonatomic, strong) NSMutableArray *sleepDataArray2;
@property (nonatomic, strong) NSArray *sleepLabelArray;
@property (nonatomic, strong) UITapGestureRecognizer *tapGest;
@property (nonatomic, strong) UIView *mainView;
- (void)updateView:(NSArray *)dateArray;

@end
