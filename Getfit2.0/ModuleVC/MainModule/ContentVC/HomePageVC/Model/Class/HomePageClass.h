//
//  HomePageClass.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/25.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTAcceptModel.h"

@protocol HomePageClassSleepDelegate <NSObject>

- (void)updateDataHomeSleep;

@end

@interface HomePageClass : NSObject

AS_SINGLETON (HomePageClass)

@property (nonatomic, strong) NSString *kilometre;
@property (nonatomic, strong) NSString *calorie;
@property (nonatomic, strong) NSString *deepSleep;
@property (nonatomic, strong) NSString *shallowSleep;
@property (nonatomic, strong) NSString *soberSleep;
@property (nonatomic, strong) NSString *currentStepValue;   // 当前步数
@property (nonatomic, strong) NSString *currentDate;        // 当天日期
@property (nonatomic, strong) NSDate   *currentSysDate; // 开始同步的时间
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger countAdd;


@property (nonatomic, assign) NSInteger sysTotalStep;
@property (nonatomic, assign) NSInteger sysTotalActiveTime;

@property (nonatomic, assign) id<HomePageClassSleepDelegate> UpdateDataSleepDelegate;

typedef void(^sysDeviceUpdateValue) (id object,BLTAcceptModelType type);

typedef void(^sysDeviceUpdateAll) (id object);

typedef void (^sysHeartData) (id object);

typedef void (^sysCurrentHeart) (NSInteger state);

typedef void(^pushHeartVc) ( );

typedef void(^updaetSys)();

typedef void(^updateSysHeart)();

typedef void(^updateDetail)();

typedef void (^updateDeviceLevel) (NSInteger value,NSInteger type);


- (NSMutableArray *)HomePageTodayData;
- (NSMutableArray *)HomePageSleepData;
- (NSArray *)CustomieScrollStep;
- (NSArray *)CustomieScrollSleep;
- (NSString *)currentStep;
- (NSString *)currentTarget;
- (NSString *)backDate:(int)dateIndex;

-(NSString *)totalSleepTime;
-(NSString *)beginSleepTime;
-(NSString *)endSleepTime;

@property (nonatomic, assign) BOOL isysday;


/*新属性 */
@property (nonatomic, assign) BOOL isSysFinish;

@property (nonatomic, assign) BOOL UpdateFinish;

@property (nonatomic, strong) NSMutableArray *stepArray;
@property (nonatomic, strong) NSMutableArray *sleepArray;
@property (nonatomic, strong) NSDate *nowData;
@property (nonatomic, strong) sysDeviceUpdateValue sysDeviceUpdateBlock;
@property (nonatomic, strong) sysDeviceUpdateAll sysDeviceUpdateAllBlock;
@property (nonatomic, strong) pushHeartVc pushHeartVcBlock;
@property (nonatomic, strong) updaetSys updaetSysBlock;
@property (nonatomic, strong) sysHeartData sysHeartDataBlock;
@property (nonatomic, strong) sysCurrentHeart sysCurrentHeartBlock;
@property (nonatomic, strong) NSMutableArray *heartArray;
@property (nonatomic, assign) NSInteger currentHeart;
@property (nonatomic, strong) updateSysHeart updateSysHeartBlock;
@property (nonatomic, strong) updateDetail updateDetailBlock;
@property (nonatomic, strong) updateDeviceLevel updateDeviceLevelBlock;

- (NSString *)backDate:(int)dateIndex;

- (void)updateBraceletData:(CGFloat)withTime backBlock:(NSObjectSimpleBlock)block;

- (void)exitUpdate;

@end
