//
//  VeryFit_Main_ChatView.h
//  Customize
//
//  Created by 黄建华 on 15/6/11.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PedometerModel.h"

@protocol ChartViewDelegate <NSObject>

- (void)dismissView;

@end

@interface VeryFitMainChatView : UIView
{
    NSInteger maxValue;
    NSInteger minValue;
}

@property (nonatomic, strong) UILabel *finishTargetLabel;
@property (nonatomic, strong) NSArray *dateArray;
@property (nonatomic, assign) id <ChartViewDelegate> customieChartViewDelegate;
@property (nonatomic, strong) CALayer *backGroundLayer;
@property (nonatomic, strong) UILabel *midLable;
@property (nonatomic, strong) UILabel *maxLable;
@property (nonatomic, strong) UIView *maxLine;
@property (nonatomic, strong) UIView *midLine;

- (void)updateView:(PedometerModel *)model;

@end
