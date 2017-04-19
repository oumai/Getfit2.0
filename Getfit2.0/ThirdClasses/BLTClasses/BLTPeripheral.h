//
//  BLTPeripheral.h
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLTPeripheral : NSObject <CBPeripheralDelegate>

typedef CBPeripheral *(^BLTPeripheralPeripheral)();
typedef void(^BLTPeripheralUpdate)(NSData *data, CBPeripheral *peripheral);
typedef void(^BLTPeripheralDidConnect)();
typedef void(^BLTPeripheralGetDeviceInfo)();
typedef void(^BLTPeripheralUpdateBigData)(NSData *data);
typedef void(^BLTPeripheralRSSI)(NSInteger RSSI);
typedef void(^BLTPeripheralFail)();

@property (nonatomic, strong) BLTPeripheralUpdate updateBlock;
@property (nonatomic, strong) BLTPeripheralUpdateBigData updateBigDataBlock;
@property (nonatomic, strong) BLTPeripheralGetDeviceInfo deviceInfoBlock;
@property (nonatomic, strong) BLTPeripheralDidConnect connectBlock;
@property (nonatomic, strong) BLTPeripheralRSSI RSSIBlock;
@property (nonatomic, strong) BLTPeripheralFail failBlock;

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, assign) UInt8 *lastInfo;

AS_SINGLETON(BLTPeripheral)

- (void)errorMessage;
- (void)startUpdateRSSI;
- (void)stopUpdateRSSI;

// 只连接一个设备时发数据.
- (void)senderDataToPeripheral:(NSData *)data;
// 多设备时指定外围设备发数据.
- (void)senderDataToPeripheral:(NSData *)data withPeripheral:(CBPeripheral *)peripheral;

@end
