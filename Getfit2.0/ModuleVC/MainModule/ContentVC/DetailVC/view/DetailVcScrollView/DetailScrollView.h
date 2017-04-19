//
//  DetailScrollView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailStepView.h"

@interface DetailScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *viewArray;               // 视图数组
@property (nonatomic, assign) NSInteger currentIndex;           // 当前下标
@property (nonatomic, strong) NSDate *beforeDate;               // 最早时间

@property (nonatomic, strong) DetailStepView *middleView;
@property (nonatomic, strong) DetailStepView *beforeView;
@property (nonatomic, strong) DetailStepView *nextView;
@property (nonatomic, assign) NSInteger dataCount;              // 计算开始到今天相隔数  1 周 2 日 3 月
@property (nonatomic, assign) NSInteger typeValue;              // 日期类型
@property (nonatomic, assign) NSInteger interval;               // 间隔
@property (nonatomic, assign) NSInteger monthIndex;
@property (nonatomic, assign) NSInteger yearIndex;
@property (nonatomic, assign) BOOL changeValue;
@property (nonatomic, strong) NSMutableArray *historyData;
@property (nonatomic, assign) NSInteger historyIndex;

- (void)detailScrollUpdate:(NSInteger)Type;

// 步数跟睡眠切换
- (void)showStepOrSleepView:(BOOL)value;

- (void)updateViewIndex;

@end
