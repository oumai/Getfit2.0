//
//  DaysStepModel.h
//  AJBracelet
//
//  Created by zorro on 15/7/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PedometerModel.h"

@interface DaysStepModel : NSObject

@property (nonatomic, strong) NSString *wareUUID;           // 设备uuid
@property (nonatomic, strong) NSString *userName;           // 用户名

// 每天步数的数据 日期为key value有为数组 下图所示

/*
        /   steps
 date -
        \   sleep
*/

@property (nonatomic, strong) NSDictionary *daysStepDict;   // 用字典保存 提高获取时的速度 也方便更新数据.

@property (nonatomic, strong) NSArray *stepsArray;          // 每天的总步数信息
@property (nonatomic, strong) NSArray *sleepArray;          // 每天的总睡眠时长信息

// 改模型保存了每天的运动总步数和总睡眠时间. 调用该方法会直接获取当前设备的相关信息.
+ (DaysStepModel *)getCurrentDaysStepModelFromDB;

// 更新当天的数据.
+ (void)updateDaysStepWithModel:(PedometerModel *)model;

@end
