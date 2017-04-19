//
//  DetailStepView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/23.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailScrollView.h"
#import "DetailShowLabel.h"
#import "WeekModel.h"
#import "MonthModel.h"
#import "YearModel.h"

@interface DetailStepShowView : UIView

@property (nonatomic,strong) DetailScrollView *detailScrollView;
@property (nonatomic, strong) UIImageView *backGroundImageView; // 底部控件
@property (nonatomic, strong) UIButton *stepButton;
@property (nonatomic, strong) UIButton *sleepButton;
@property (nonatomic, assign) BOOL stepOrSleep;                 // 切换模式

@property (nonatomic, strong) UILabel *showDateLabel;
@property (nonatomic, strong) UILabel *showButtonDateLabel;
@property (nonatomic, assign) NSInteger selectType;

@property (nonatomic, strong) DetailShowLabel *label1;
@property (nonatomic, strong) DetailShowLabel *label2;
@property (nonatomic, strong) DetailShowLabel *label3;
@property (nonatomic, strong) DetailShowLabel *label4;
@property (nonatomic, strong) DetailShowLabel *label5;
@property (nonatomic, strong) DetailShowLabel *label6;

@property (nonatomic, strong) UILabel *showLabel1;
@property (nonatomic, strong) UILabel *showLabel2;
@property (nonatomic, strong) UILabel *showLabel3;
@property (nonatomic, strong) UILabel *showLabel4;
@property (nonatomic, strong) UILabel *showLabel5;
@property (nonatomic, strong) UILabel *showLabel6;

@property (nonatomic, strong) UILabel *firstDayLabel;
@property (nonatomic, strong) UILabel *seventDayLabel;
@property (nonatomic, strong) UILabel *midDayLabel;
@property (nonatomic, strong) UILabel *twentyTDayLabel;
@property (nonatomic, strong) UILabel *lastDayLabel;

@property (nonatomic, strong) UIImageView *deepsleepMark;
@property (nonatomic, strong) UIImageView *sleepMark;
@property (nonatomic, strong) UILabel *deepsleepLabel;
@property (nonatomic, strong) UILabel *sleepLabel;

@property (nonatomic, strong) UILabel *showButtonDateLabel1;
@property (nonatomic, strong) UILabel *showButtonDateLabel2;
@property (nonatomic, strong) UILabel *showButtonDateLabel3;
@property (nonatomic, strong) UILabel *showButtonDateLabel4;
@property (nonatomic, strong) UILabel *showButtonDateLabel5;
@property (nonatomic, strong) UILabel *showButtonDateLabel6;
@property (nonatomic, strong) UILabel *showButtonDateLabel7;
@property (nonatomic, strong) UILabel *showButtonDateLabel8;
@property (nonatomic, strong) UILabel *showButtonDateLabel9;
@property (nonatomic, strong) UILabel *showButtonDateLabel10;
@property (nonatomic, strong) UILabel *showButtonDateLabel11;
@property (nonatomic, strong) UILabel *showButtonDateLabel12;
@property (nonatomic, strong) NSMutableArray *labelArray;



@end
