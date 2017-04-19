//
//  BLTService.h
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTPeripheral.h"
#import "BLTModel.h"
#import "BLTDFUHelper.h"

@interface BLTManager : NSObject

typedef void(^BLTManagerUpdateModel)(BLTModel *model);
// 传入的model为空时为全部刷新.传入具体的model时为单个刷新.
typedef void(^BLTManagerUpdateShowModel)(BLTModel *model);
typedef void(^BLTManagerUpdateValue)(NSData *data);
typedef void(^BLTManagerDidConnect)();
typedef void(^BLTManagerDisConnect)();

@property (nonatomic, strong) BLTModel *model;

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) NSMutableArray *allWareArray;
@property (nonatomic, strong) BLTManagerUpdateModel updateModelBlock;
@property (nonatomic, strong) BLTManagerUpdateShowModel showModelBlock;
@property (nonatomic, strong) BLTManagerUpdateValue updateValueBlock;
@property (nonatomic, strong) BLTManagerDidConnect connectBlock;
@property (nonatomic, strong) BLTManagerDisConnect disConnectBlock;

@property (nonatomic, assign) BOOL isUpdateing;
@property (nonatomic, strong) BLTModel *updateModel;
@property (nonatomic, assign) BOOL isConnectNext;
@property (nonatomic, assign) BOOL isConnected;

@property (nonatomic, assign) BOOL isAutoUpdate;  // 是否开启自动升级.

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) CBPeripheral *bondPeripheral;  ////绑定的外设


AS_SINGLETON(BLTManager)

/*
// 持续的刷新
- (void)startTimer;
// 停止持续的刷新
- (void)stopTimer;
 */
// 停止扫描.
- (void)stopScan;

// 不取消当前设备的情况下扫描
- (void)scan;
// 开始扫描或者是重新扫描
- (void)startCan;
// 如果当前没有设备连接就开始扫描.
- (void)repeatScan;

// 主动断开指定的设备.
- (void)disConnectPeripheralWithModel:(BLTModel *)model;

// 主动断开链接
- (void)dismissLink;
// 连接下一个设备.
- (void)connectNextPeripheral;
// 指定连接某个设备.
- (void)connectPeripheralWithModel:(BLTModel *)model;
// 在扫描到的设备组里面根据外围设备找model.
- (BLTModel *)findModelWithPeripheral:(CBPeripheral *)peripheral;
// 移除某个设备
- (void)removeModelWithPeripheral:(CBPeripheral *)peripheral withArray:(NSMutableArray *)array;

// 从设备列表删除某个cell .下面的方法替代这个.
- (void)deleteModelFromAllWaresWith:(BLTModel *)model;

// 解除绑定并且断开连接
- (void)removeBindingAndDisconnect:(BLTModel *)model withEndBlock:(NSObjectSimpleBlock)endBlock;

// 设备双击令设备尖叫.
- (void)keyEventControlAlertWithPeripheral:(CBPeripheral *)peripheral;

// 达到一定的距离启动
- (void)distanceLostControlAlertWithPeripheral:(CBPeripheral *)peripheral
                                     withStart:(BOOL)isStart;


// 主动断开重连接
- (void)dismissLinkAndRepeatConnect;
- (void)dismissLinkAndRepeatConnect:(CBPeripheral *)peripheral;

/**
 *  准备固件更新.
 */
- (void)checkIsAllownUpdateFirmWare;

@end
