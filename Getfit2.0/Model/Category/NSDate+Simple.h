//
//  NSDate+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)

#import <Foundation/Foundation.h>

@interface NSDate (Simple)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;
@property (nonatomic, readonly) NSString	*showTimeAgo;

// 单例模式, 避免持续消耗内存.
+ (NSDateFormatter *)dateFormatterTemp;

// @"yyyy-MM-dd HH:mm:ss"
- (NSString *)dateToStringFormat:(NSString *)format;

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

// 日期转为字符串 和上一个一样
- (NSString *)dateToString;

// 转为@"yyyy-MM-dd"
- (NSString *)dateToDayString;

// 返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day;

// 字符串转日期.
+ (NSDate *)dateByString:(NSString *)timeString;

// @"yyyy-MM-dd HH:mm:ss" 字符串转日期
+ (NSDate *)dateByStringFormat:(NSString *)timeString;

// 返回距离aDate有多少天
- (NSInteger)dateByDistanceDaysWithDate:(NSDate *)aDate;

// 获得当前的时区
+ (CGFloat)DateByTimeZone;

// 日期比较 同一天返回yes
- (BOOL)compareWithDate:(NSDate *)date;

// 判断当前日期是否是本周.
+ (BOOL)dateIsThisWeek:(NSDate *)date;
// 判断当前日期是否是本月.
+ (BOOL)dateIsThisMonth:(NSDate *)date;

@end
