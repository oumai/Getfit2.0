//
//  AlarmClockModel.h
//  AJBracelet
//
//  Created by zorro on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AlarmClockModelTypeAdd = 0,         // 增加
    AlarmClockModelTypeRemove = 1,      // 删除
    AlarmClockModelTypeEdit             // 修改
} AlarmClockModelType;

@interface AlarmClockModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *wareUUID;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isRepeat;
@property (nonatomic, assign) BOOL isSys;
@property (nonatomic, strong) NSArray *weekArray;       // 选中的星期.

//
@property (nonatomic, assign) NSInteger modelType;      // 闹钟状态
@property (nonatomic, strong) NSString *alarmType;      // 闹钟类型
@property (nonatomic, strong) NSArray *alarmTypeArray;
@property (nonatomic, strong) NSString *noteString;

// 闹钟时间.
@property (nonatomic, assign) NSInteger daySplit; ///上下午
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) UInt8 repeat;
@property (nonatomic, assign) NSInteger sleepDuration;  // 贪睡时长.
@property (nonatomic, assign) BOOL isChanged;           // 用户是否进行了新的设置.

@property (nonatomic, assign) CGFloat daysStringheight;             // 如果选了7天可能需要2行。
@property (nonatomic, assign) CGFloat showHeight;                   // cell显示的高度. 0 的时候为删除. 其他的为增加存在.
@property (nonatomic, assign) NSInteger orderIndex;

@property (nonatomic, strong) NSString *showTimeString;
@property (nonatomic, strong) NSString *showAlarmType;

- (void)convertToBLTNeed __deprecated_msg();
// 根据设备uuid获取闹钟
+ (NSArray *)getAlarmClockFromDBWithUUID:(NSString *)uuid;
// 闹钟在列表显示进行排序 根据用户设定的时间早晚进行排序
- (NSArray *)sortByNumberWithArray:(NSArray *)array withSEC:(BOOL)sec;
// 选中的日期用字符串显示.
- (NSString *)showStringForWeekDay;
// 闹钟的图标 每个闹钟类型对应一个图标  比如起床 或者 锻炼.
- (UIImage *)showIconImage;
// 重置所有参数.
- (void)resetParameters;

@end
