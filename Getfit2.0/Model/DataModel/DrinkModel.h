//
//  DrinkModel.h
//  AJBracelet
//
//  Created by zorro on 16/1/11.
//  Copyright © 2016年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrinkModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *wareUUID;

@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger drinkWater;
@property (nonatomic, assign) NSInteger timeInterval;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isChanged;           // 用户是否进行了新的设置.



// 根据设备uuid获取久坐提醒设置.
+ (DrinkModel *)getDrinkFromDBWithUUID:(NSString *)uuid;

@end
