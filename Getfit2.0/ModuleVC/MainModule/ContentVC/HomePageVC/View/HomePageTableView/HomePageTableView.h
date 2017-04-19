//
//  HomePageTableView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/25.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomieScrollView.h"
#import "HomeSleepView.h"
#import "HomeTodayView.h"
#import "MJRefresh.h"
#import "PedometerModel.h"
#import "CustomieTableView.h"
#import "DaysStepModel.h"
#import "CATransform3DPerspect.h"
#import "MainCircleView.h"


///定义宏，动态获取屏幕的高度和宽度
#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width
#define VIEWSTEP 3.141592
#define VIEWSTEP_2 1.570796

@protocol HomePageTableDateDelegate <NSObject>

- (void)HomePageTableDateUpdate:(NSDate *)date;

@end

@interface HomePageTableView : UIView <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CustomieScrollViewDelegate,mainViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView  *refreshView;
@property (nonatomic, strong) UILabel *refreshDownLabel;
@property (nonatomic, strong) UIImageView * todayDot;
@property (nonatomic, strong) CustomieScrollView *trendChartViewStep;
@property (nonatomic, strong) CustomieScrollView *trendChartViewSleep;
@property (nonatomic, strong) HomeTodayView *homeView;
@property (nonatomic, strong) HomeSleepView *sleepView;
@property (nonatomic, strong) HomeTodayView *backHomeView;
@property (nonatomic, strong) HomeSleepView *backSleepView;
@property (nonatomic, assign) BOOL refreshDown;
@property (nonatomic, assign) BOOL todayOrSleep;
@property (nonatomic, assign) NSInteger chatScrollIndex;
@property (nonatomic, assign) BOOL scrollViewDidScroll;
@property (nonatomic, strong) UIButton *todayButton;        // 查看今天
@property (nonatomic, strong) UIButton *backTodayButton;    // 返回今天
@property (nonatomic, strong) UIButton *shareButton;        // 分享按钮
@property (nonatomic, strong) UIButton *blueToothButton;    // 蓝牙按钮
@property (nonatomic, strong) CustomieTableView *deviceTableView; // 设备列表
@property (nonatomic, strong) UIView *deviceViewBackGround;
@property (nonatomic, strong) UIView *shareViewBackGround;



@property (nonatomic, strong) UIImageView * dayBgImageView; //背景imageView
@property (nonatomic, strong) UIImageView * nightBgImageView; //背景imageView

@property (nonatomic, strong) PedometerModel *model;
@property (nonatomic, strong) id<HomePageTableDateDelegate> homePageTableDelegate;
@property (nonatomic, strong) DaysStepModel *daysModel;
@property (nonatomic, assign) BOOL firstLoadData;

@property (nonatomic,strong) MainCircleView *mainView2;

@property (nonatomic, strong) UIPageControl *currentPage;

@property (nonatomic,strong)  UIView        *ShareImageView;
@property (nonatomic,strong) UIImageView    *backgroundView;

- (void)updateTodayViewAndSleepView:(PedometerModel *)model;
- (void)MainUpdteProgressFinish;
- (void)backToday;

@end
