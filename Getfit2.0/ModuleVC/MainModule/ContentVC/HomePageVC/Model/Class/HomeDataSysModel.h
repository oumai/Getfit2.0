//
//  HomeDataSysModel.h
//  AJBracelet
//
//  Created by 黄建华 on 15/12/5.
//  Copyright © 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDataSysModel : NSObject

@property (nonatomic, strong) NSString *userName;               // 用户名
@property (nonatomic, strong) NSString *dateString;

@property (nonatomic, strong) NSMutableArray *stepTotayArray;   //
@property (nonatomic, strong) NSMutableArray *sleepTotayArray;  //

@property (nonatomic, strong) NSMutableArray *stepYdArray;
@property (nonatomic, strong) NSMutableArray *sleepYdArray;

@property (nonatomic, strong) NSMutableArray *heartArray;

@property (nonatomic, assign) NSInteger totalStep;

+ (HomeDataSysModel *)getModelFromDB;

// 简单初始化并赋值。
+ (HomeDataSysModel *)simpleInit;

@end
