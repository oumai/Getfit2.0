//
//  BLTUUID.h
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLTUUID : NSObject

+ (CBUUID *)uartServiceUUID;
+ (CBUUID *)txCharacteristicUUID;
+ (CBUUID *)rxCharacteristicUUID;
+ (CBUUID *)hardwareRevisionStringUUID;
+ (CBUUID *)deviceInformationServiceUUID;

// 大数据写
+ (CBUUID *)bigDataWriteCharacteristicUUID;

// 大数据读
+ (CBUUID *)bigDataReadCharacteristicUUID;

// 升级时的服务.
+ (CBUUID *)updateServiceUUID;
// 控制中心.
+ (CBUUID *)controlPointCharacteristicUUID;
// 数据传输通道.
+ (CBUUID *)packetCharacteristicUUID;
// 固件版本特征
+ (CBUUID *)versionCharacteristicUUID;
// uuid 转字符串.
+ (NSString *)representativeString:(CBUUID *)uuid;

@end
