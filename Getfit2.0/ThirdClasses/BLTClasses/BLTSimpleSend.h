//
//  BLTSimpleSend.h
//  BopLost
//
//  Created by zorro on 15/4/9.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

// 同步数据的状态
typedef enum {
    BLTSimpleSendSynWait = 0,       // 正在等待同步 或者是没有同步
    BLTSimpleSendSynAuto = 1,       // 正在自动同步数据.
    BLTSimpleSendSynByHand = 2,     // 正在手动同步数据.
} BLTSimpleSendSynState;

typedef enum {
    BLTSimpleSendSynProgressNormal = 0,     // 情况正常
    BLTSimpleSendSynProgressSuccess = 1,    // 同步完成
    BLTSimpleSendSynProgressFail = 2,       // 失败
} BLTSimpleSendSynProgress;

#import "BLTSendModel.h"
typedef void(^BLTSendDataSynProgress)(int progress, BLTSimpleSendSynProgress type);
typedef void(^GetFunctionSuccess)(id obj);

@interface BLTSimpleSend : BLTSendModel

@property (nonatomic, assign) NSInteger todaySports;
@property (nonatomic, assign) NSInteger todaySleep;
@property (nonatomic, assign) NSInteger historySportDays;
@property (nonatomic, assign) NSInteger historySleepDays;

@property (nonatomic, assign) NSInteger historyAllDays;

@property (nonatomic, assign) BLTSimpleSendSynState synState;
@property (nonatomic, assign) BOOL isSyning;        // 是否正在同步中

@property (nonatomic, strong) BLTSendDataSynProgress synProgressBlock;
@property (nonatomic, copy) GetFunctionSuccess getFunctionsuccess;

AS_SINGLETON(BLTSimpleSend)

/**
 *  连接手环后发送连续的指令
 */
- (void)sendContinuousInstruction;

// 发送绑定指令.
- (void)sendBindInstruction;

// 设置用户信息
- (void)sendUserInfo;

// 开始同步今天的数据. 该方法已经弃用.
- (void)startSynTodayData __deprecated_msg("Method deprecated. Use `[Model startSynHistoryAndTodayData]`");

// 现在只用这个接口拉数据, 不用上面的.
// 同步所有的数据, 包含今天的和历史的, 先获取历史然后是今天的. isAuto 自动同步还是手动同步.
- (void)startSynHistoryAndTodayData:(BOOL)isAuto;

// 需要同步的数据天数. 也是还剩余的天数.
- (NSInteger)totalDataOfDays;

// 停止定时器
- (void)stopTimer;

- (void)sendSysDeviceInfo5;

@end
