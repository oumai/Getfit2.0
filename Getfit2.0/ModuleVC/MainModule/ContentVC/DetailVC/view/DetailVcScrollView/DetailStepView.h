//
//  DetailStepView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekModel.h"
#import "MonthModel.h"
#import "YearModel.h"

@interface DetailStepView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;            // 数据集合
@property (nonatomic, strong) NSMutableArray *sleepDeepDataArray;   // 睡眠深睡数据集合
@property (nonatomic, strong) NSMutableArray *sleepShallowDataArray;;  // 睡眠浅睡数据集合

@property (nonatomic, strong) NSMutableArray *heightArray;      // 转换为表的高度集合
@property (nonatomic, assign) int maxValue;                     // 最大值
@property (nonatomic, assign) int minValue;                     // 最小值
@property (nonatomic, strong) UIImageView *showStepImageView;   // 显示点中按钮背景框
@property (nonatomic, strong) UILabel *showStepLabel;           // 显示点中步数
@property (nonatomic, strong) NSMutableArray *buttonArray;      // 所有点按钮集合
@property (nonatomic, strong) NSMutableArray *lineArray;        // 所有线集合
@property (nonatomic, strong) UIView *targetLineView;           // 目标线
@property (nonatomic, strong) UILabel *targetLabel;             // 目标
@property (nonatomic, strong) UIImageView *tagrgetImage;        // 目标奖杯
@property (nonatomic, assign) NSInteger chatType;               // 表类型

//  /* ----备注----*/
@property (nonatomic, strong) UIView *stepView;
@property (nonatomic, strong) UIView *sleepView;
@property (nonatomic, strong) NSMutableArray *sleepLineArray;
@property (nonatomic, strong) NSMutableArray *sleepButtonClickArray;
@property (nonatomic, strong) NSMutableArray *sleepButtonArray;
@property (nonatomic, assign) BOOL stepOrSleep;

@property (nonatomic, strong) UIImageView *deepsleepMark;
@property (nonatomic, strong) UIImageView *sleepMark;
@property (nonatomic, strong) UILabel *deepsleepLabel;
@property (nonatomic, strong) UILabel *sleepLabel;

// /*-----保存属性------ */
@property (nonatomic, strong) NSDate *weekForData;
@property (nonatomic, assign) NSInteger monthForIndex;
@property (nonatomic, assign) NSInteger yearForIndex;
@property (nonatomic, strong) WeekModel *weekModel;
@property (nonatomic, strong) MonthModel *monthModel;
@property (nonatomic, strong) YearModel *yearModel;

- (void)detailScrollUpdateWeek:(NSDate *)date;                  // 更新周
- (void)detailScrollUpdateMonth:(NSInteger) monthIndex;         // 更新月
- (void)detailScrollUpdateYear:(NSInteger) yearIndex;           // 更新年

- (void)showView:(BOOL)value;

@end
