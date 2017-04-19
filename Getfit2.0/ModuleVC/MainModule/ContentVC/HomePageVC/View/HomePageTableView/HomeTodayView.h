//
//  HomeTodayView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/24.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeryFitMainChatView.h"
#import "VeryFitMainRainDotView.h"
#import "Information.h"
#import "MainCircleView.h"
#import "PedometerModel.h"
#import "CustomieTableView.h"

@interface HomeTodayView : UIView <ChartViewDelegate,mainViewDelegate>
{
    //CGFloat height;  //全局的height  先布局 loadLabel  再布局cireView
}

@property (nonatomic, strong) UILabel *kilometreLabel;  //公里数
@property (nonatomic, strong) UILabel *kilometreUnit;   //公里数单位
@property (nonatomic, strong) UILabel *calorieLabel;    //卡路里

@property (nonatomic, strong) UILabel *temperature;      //温度
@property (nonatomic, strong) UILabel *pressure;         //气压
@property (nonatomic, strong) UILabel *altitude;         //海拔

@property (nonatomic, strong) MainCircleView *circleView;
@property (nonatomic, strong) VeryFitMainChatView *Chart;
@property (nonatomic, strong) VeryFitMainRainDotView *rainDotView;
@property (nonatomic, assign) CGFloat mainFrameCount;
@property (nonatomic, assign) CGFloat mainViewCenterCount;
@property (nonatomic, strong) UIImageView *backgroundView;

@property (nonatomic, strong) UIButton  *button;

@property (nonatomic, strong) PedometerModel *model;

-(void)dismissView;
-(void)updateViewsWithModel:(PedometerModel *)model;
-(void)mainViewTouch;

- (void)updateDataHomeToday;
@end
