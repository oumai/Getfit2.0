//
//  RemindModel.h
//  AJBracelet
//
//  Created by zorro on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *wareUUID;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) NSInteger interval;       // 久坐提醒时间间隔.
@property (nonatomic, assign) NSInteger startHour;
@property (nonatomic, assign) NSInteger startMin;
@property (nonatomic, assign) NSInteger endHour;
@property (nonatomic, assign) NSInteger endMin;

@property (nonatomic, strong) NSArray *weekArray;       // 选中的星期.
@property (nonatomic, assign) UInt8 repeat;

@property (nonatomic, assign) BOOL isChanged;           // 用户是否进行了新的设置.

@property (nonatomic, assign) NSInteger orderIndex;

@property (nonatomic, strong) NSString *showStartTimeString;
@property (nonatomic, strong) NSString *showEndTimeString;

// 根据设备uuid获取久坐提醒设置.
+ (NSArray *)getRemindFromDBWithUUID:(NSString *)uuid;

@end
