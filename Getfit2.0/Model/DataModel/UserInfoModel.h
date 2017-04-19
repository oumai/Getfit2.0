//
//  UserInfoModel.h
//  AJBracelet
//
//  Created by zorro on 15/7/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

// 所有的东西在set前都必须转成公制.
// 添加了2个,其它有些就暂未存储,如地区,签名等

@property (nonatomic, assign) BOOL isMetricSystem;      // 是否是公制 公制为yes
@property (nonatomic, assign) BOOL isFahrenheit;        // 温度是否按照华氏显示

@property (nonatomic, strong) NSString *avatar;         // 头像
@property (nonatomic, strong) UIImage *headImage;      // 头像 目前为本地的

@property (nonatomic, strong) NSString *userName;       // 用户名
@property (nonatomic, strong) NSString *nickName;       // 昵称

@property (nonatomic, strong) NSString *password;       // 密码
@property (nonatomic, strong) NSString *birthDay;       // 生日   格式为1990-05-01

@property (nonatomic, assign) NSInteger age;            // 年龄
@property (nonatomic, assign) NSInteger genderSex;      // 性别 1为女 0为男 get用下面的show方法
@property (nonatomic, assign) NSInteger height;         // 身高 get的话用下面的show方法
@property (nonatomic, assign) NSInteger weight;         // 体重 get的话用下面的show方法
@property (nonatomic, assign) CGFloat step;             // 步距

@property (nonatomic, strong) NSString *interest;       // 兴趣
@property (nonatomic, strong) NSString *manifesto;      // 宣言

@property (nonatomic, strong) NSArray *alarmTypeArray;

@property (nonatomic, assign) NSInteger targetSteps;     // 目标步数
@property (nonatomic, assign) CGFloat targetCalories;    // 目标卡路里
@property (nonatomic, assign) CGFloat targetDistance;    // 目标距离
@property (nonatomic, assign) NSInteger targetSleep;     // 目标睡眠

@property (nonatomic, strong) NSString *showGenderSex;   // 性别显示
@property (nonatomic, strong) NSString *showHeight;
@property (nonatomic, strong) NSString *showWeight;

@property (nonatomic, strong) NSString *loginUserName;      // 登录用户名
@property (nonatomic, strong) NSString *loginUserPassWord;  // 登录密码
@property (nonatomic, strong) NSString *loginUserPassWordAgain; // 登录密码
@property (nonatomic, strong) NSString *loginEmail; // 邮箱
@property (nonatomic, strong) NSString *loginPhone; // 手机
@property (nonatomic, strong) NSString *loginToken; // 设备token
@property (nonatomic, strong) NSString *loginId;    // ID
@property (nonatomic, strong) NSString *userDevice; // 使用的设备
@property (nonatomic, assign) BOOL heartOpen;
@property (nonatomic, assign) BOOL isFindPhone;

@property (nonatomic, assign) BOOL isSMS;
@property (nonatomic, assign) BOOL isNotice;

@property (nonatomic, assign) BOOL hasAMPM;
@property (nonatomic, strong) NSMutableArray *functionList;

// 从数据库获取用户信息
+ (UserInfoModel *)getUserInfoFromDB;
- (BOOL)addAlarmClockType:(NSString *)string;

@end
