//
//  BLTAcceptModel.h
//  PlaneCup
//
//  Created by zorro on 15/3/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTManager.h"

@protocol BLTControlTypeDelegate <NSObject>

- (void)bltControlTakePhoto;

@end

typedef enum {                                   // 详细的看接口参数。

    BLTAcceptModelTypeUnKnown = 0,               // 无状态
    BLTAcceptModelTypeBindingSuccess,            // 绑定成功
    BLTAcceptModelTypeBindingTimeout,            // 绑定超时
    BLTAcceptModelTypeBindingError,              // 绑定错误
    BLTAcceptModelTypeUnBindingSuccess,          // 解绑成功
    BLTAcceptModelTypeUnBindingFail,             // 解绑失败

    BLTAcceptModelTypeDevideInfo,                // 设备信息
    BLTAcceptModelTypeSetDateInfo,               // 时间信息
    BLTAcceptModelTypeFunction,                  // 获取设备支持功能
    BLTAcceptModelTypeUnitSuccess,               // 单位设置(包含时间)
    BLTAcceptModelTypeUnitFail,
    BLTAcceptModelTypeSetUserInfo,               // 用户信息
    BLTAcceptModelTypeSetAlarmClock,             // 设置闹钟
    BLTAcceptModelTypeSetRemind,                 // 设置久坐提醒

    BLTAcceptModelTypeSetSportTarget,            // 设置运动目标
    BLTAcceptModelTypeSetSleepTarget,            // 设置睡眠目标

    BLTAcceptModelTypeDataRequestSuccess,        // 数据请求成功
    BLTAcceptModelTypeDataTodaySport,            // 今天运动数据
    BLTAcceptModelTypeDataTodaySleep,            // 今天睡眠数据
    BLTAcceptModelTypeDataHistorySport,          // 历史运动数据
    BLTAcceptModelTypeDataHistorySleep,          // 历史睡眠数据.
    
    BLTAcceptModelTypeDataRequestEnd,               // 数据请求结束
    BLTAcceptModelTypeDataTodaySportEnd,            // 今天运动数据请求结束
    BLTAcceptModelTypeDataTodaySleepEnd,            // 今天睡眠数据请求结束
    BLTAcceptModelTypeDataHistorySportEnd,          // 历史运动数据请求结束
    BLTAcceptModelTypeDataHistorySleepEnd,          // 历史睡眠数据请求结束.
    
    BLTAcceptModelTypeRestoreData,                  // 恢复数据

    BLTAcceptModelTypeSetLostModel,              // 丢失报警方式
    BLTAcceptModelTypeSetAlertModel,             // 寻找报警方式
    BLTAcceptModelTypeFindDevice,                // 寻找设备
    BLTAcceptModelTypeLostEvent,                 // 防丢事件
    BLTAcceptModelTypeKeyEvent,                  // 按键事件
    BLTAcceptModelTypeNoMuchElec,                // 没有足够的电量
    BLTAcceptModelTypeNoSupport,                 // 不支持
    BLTAcceptModelTypeSuccess,                   // 通讯成功
    BLTAcceptModelTypeError,                     // 通讯错误
    
    /*手环控制*/
    BLTAcceptModelPhotoControl,
    /*事件控制类型*/
    BLTAcceptModelPhotoControlType,
    /*防丢模式*/
    BLTAcceptModelLostMode,
    // 日志输出报告未完成
    BLTAcceptModelReport,
    // 日志输出报告完成
    BLTAcceptModelReportFinish,
    // 重启
    BLTAcceptModelReLoad,
    
    //接听
    BLTAcceptModelReceive,
    
    BLTAcceptModelHangUp,
    
    BLTAcceptModelSysData


} BLTAcceptModelType;

typedef enum {
    BLTAcceptModelDataTypeUnKnown = 0,
    BLTAcceptModelDataTypeTodaySport = 1,
    BLTAcceptModelDataTypeTodaySleep = 2,
    BLTAcceptModelDataTypeHistorySport = 3,
    BLTAcceptModelDataTypeHistorySleep = 4,
} BLTAcceptModelDataType;

typedef void(^BLTAcceptModelUpdateValue)(id object, BLTAcceptModelType type);
typedef void(^BLTAcceptModelKeyEvent)(id object1, id object2);
// 设备, 开始或结束, 远中近
typedef void(^BLTAcceptModelDistanceAlert)(id object1, id object2, id object3);

@protocol BLTAcceptModelDeleagte;

@interface BLTAcceptModel : NSObject

@property (nonatomic, assign) BLTAcceptModelType type;
@property (nonatomic, assign) BLTAcceptModelDataType dataType;

@property (nonatomic, strong) BLTAcceptModelUpdateValue updateValue;
@property (nonatomic, strong) BLTAcceptModelKeyEvent keyEvent;
@property (nonatomic, strong) BLTAcceptModelDistanceAlert distanceAlert;

// 实时
@property (nonatomic, strong) BLTAcceptModelUpdateValue realTimeBlock;
@property (nonatomic, strong) BLTAcceptModelUpdateValue heartBlock;
@property (nonatomic, strong) BLTAcceptModelUpdateValue realTimeHeartBlock;

@property (nonatomic, strong) BLTAcceptModelUpdateValue baseInfoBlock;
@property (nonatomic, strong) BLTAcceptModelUpdateValue detailDataBlock;

@property (nonatomic, strong) BLTAcceptModelUpdateValue pushToHeartVC;
@property (nonatomic, strong) BLTAcceptModelUpdateValue heartStatusBlock;

// 最大 平均 最小心率
@property (nonatomic, assign) NSInteger maxHeart;
@property (nonatomic, assign) NSInteger averageHeart;
@property (nonatomic, assign) NSInteger minHeart;
@property (nonatomic, assign) BOOL isOpenHeart;

// 这3个无用.
@property (nonatomic, strong) NSMutableArray *shakeArray;
@property (nonatomic, assign) NSInteger lastCount;
@property (nonatomic, assign) NSInteger lastSerial;

@property (nonatomic, strong) NSMutableArray *heartArray;

@property (nonatomic, strong) NSMutableData *syncData;          // 同步的数据.
@property (nonatomic, strong) NSMutableArray *indexArray;       // 已经传过来的index 没有的就是漏发的.
@property (nonatomic, assign) NSInteger packagesCount;          // 当前一轮数据包de个数.
@property (nonatomic, assign) NSInteger acceptCount;            // 当前一轮数据接收到的包de个数.

// @property (nonatomic, assign) BOOL isLeakData;               // 是否存在漏掉数据
@property (nonatomic, assign) BOOL isAcceptEnd;                 // 一轮数据是否接受结束
@property (nonatomic, assign) NSInteger checkCount;             // 一轮数据被检测漏包的次数.
@property (nonatomic, assign) int lastMissIndex;                // 一轮数据被检测漏包的次数.

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) NSInteger dataLength;

@property (nonatomic, assign) id <BLTAcceptModelDeleagte> delegate;
@property (nonatomic, strong) id <BLTControlTypeDelegate> BLTControlTDelegate;
@property (nonatomic, strong) NSTimer *sysTimer;

AS_SINGLETON(BLTAcceptModel)

/**
 *  清空数据。
 */
- (void)cleanMutableData;
- (void)exitBeforeSave;

@end

// 该协议在此项目无用.
@protocol BLTAcceptModelDeleagte <NSObject>

// play_status 为yes是动作。 为no时停止。
- (void)acceptModelControlVideoStatusPlay:(BOOL)play_status;
- (void)acceptModelStopGetShakeData;
- (void)acceptModelStartGetShakeData;
- (void)acceptModelControlPlayVideoContent:(BOOL)previous;



@end
