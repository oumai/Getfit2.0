//
//  BLTDFUHelper.h
//  ZKKBLT_OTA
//
//  Created by zorro on 15/2/15.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

// 固件更新

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Utility.h"
#import "Header.h"

typedef enum {
    BLTDFUHelperNoUpdate = 0,                   // 没更新
    BLTDFUHelperUpdateNoUpdateFile = 1,         // 没有更新文件
    BLTDFUHelperUpdateing = 2,                  // 更新中
    BLTDFUHelperUpdateSuccess = 3,              // 更新成功
    BLTDFUHelperUpdateFail = 4,                 // 更新失败
} BLTDFUHelperUpdateState;

typedef void(^BLTDFUHelperPrepareUpdate)();
typedef void(^BLTDFUHelperEnd)(BOOL success);
typedef void(^BLTDFUHelperUpdate)(BLTDFUHelperUpdateState state, NSInteger number);

@interface BLTDFUHelper : NSObject

@property (nonatomic, strong) BLTDFUHelperEnd endBlock;
@property (nonatomic, strong) BLTDFUHelperUpdate updateBlock;

@property (nonatomic, strong) CBPeripheral *updatePeripheral;  //  正在更新的外围设备
@property (nonatomic, strong) CBCharacteristic *controlPointChar;
@property (nonatomic, strong) CBCharacteristic *packetChar;
@property (nonatomic, strong) CBCharacteristic *versionChar;

@property (nonatomic, strong) NSData *binFileData;                //  升级的数据包。

@property (nonatomic, assign) BOOL isAllowUpdate;

@property (nonatomic, assign) NSUInteger binFileSize;

@property (nonatomic, assign) int writingPacketNumber;
@property (nonatomic, assign) int numberOfPackets;
@property (nonatomic, assign) int bytesInLastPacket;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *finishTime;
@property (nonatomic, assign) NSTimeInterval uploadTimeInSeconds;

@property (nonatomic, assign) BOOL isFoundControlPointChar;
@property (nonatomic, assign) BOOL isFoundPacketChar;
@property (nonatomic, assign) BOOL isFoundVersionChar;

@property (nonatomic, strong) NSURL *firmwareFileMetaData;

@property struct DFUResponse dfuResponse;

AS_SINGLETON(BLTDFUHelper)

// 开始升级
- (void)performDFUOnFileWithMetaData;

// 接受来自控制中心的信息.
- (void)processDFUResponse:(uint8_t *)data;

- (void)onReadDfuVersion:(NSInteger)version;

@end
