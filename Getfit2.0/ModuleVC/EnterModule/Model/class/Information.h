//
//  Information.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Information : NSObject

AS_SINGLETON (Information)

@property (nonatomic, assign) BOOL sex;
@property (nonatomic, assign) BOOL unit;
@property (nonatomic, strong) NSArray *deviceList;
@property (nonatomic, assign) NSInteger deviceIndex;
@property (nonatomic, assign) NSInteger infoProgressIndex;
@property (nonatomic, assign) NSInteger selectHeight;
@property (nonatomic, assign) NSInteger selectWeight;
@property (nonatomic, assign) NSInteger selectBirthYear;
@property (nonatomic, assign) NSInteger selectTargetStep;
@property (nonatomic, assign) NSInteger selectTargetSleep;

- (BOOL)getUserInfo;

- (void)saveUserInfo;

@end
