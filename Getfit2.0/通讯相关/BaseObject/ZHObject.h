//
//  ZHObject.h
//  Elevator
//
//  Created by 张浩 on 15/6/17.
//  Copyright (c) 2015年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewAdditions.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+SBJSON.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"



#define ServerURL @"http://120.25.103.18:8086"





///blocks
typedef void (^ZHVoidBlock)(void);
typedef void (^ZHStringBlock)(NSString *string);
typedef void (^ZHArrayBlock)(NSArray *array);
typedef void (^ZHDictionaryBlock)(NSDictionary *dictionary);
typedef void (^ZHIntegerBlock)(NSInteger numbers);
//用户数据

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define ZHRED 0xff0000
#define ZHGREEN 0x1c8f3b
//#define ZHBLUE 0x29a4de
#define ZHORANGE 0xde642b
#define ZHBLUE 0x89c522


#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define defaultScreen CGRectMake(0, 64, screenWidth, screenHeight-64)



#define TabBar_Height 49



//用户数据
#define G_USERDATA [GlobleFiles ShareObject].userData
#define G_USERID [GlobleFiles ShareObject].userID
#define G_GROUPID [GlobleFiles ShareObject].groupID
#define G_USERTOKEN [GlobleFiles ShareObject].usertoken
#define MyTabBar [GlobleFiles ShareObject].myTabBar
#define REQMethod(method) [OtherTools requestMethod:method]

#define TimeOut 30
#define BadNetWork @"亲，网络貌似有点不通畅哦~"


///格式化数据成字符串
#define formartStr(object) [OtherTools formatString:object]

#define CLASSNAME(object)  [NSString stringWithUTF8String:object_getClassName(object)]

#define ZHDEBUG(msg) NSLog(@"调试信息：%s\n内容：\n%@",__FUNCTION__,msg);


@interface ZHObject : NSObject

@end

#pragma mark 全局变量~~~~~~~~
@interface GlobleFiles : NSObject<UIAlertViewDelegate>

//在appdelegate里面调用shareObject此对象线程安全，APP生命周期只会实例化一次的单例
+(GlobleFiles *)ShareObject;
///以下是用户数据
@property(nonatomic,strong)NSMutableDictionary *userData;
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *usertoken;
@property(nonatomic,copy)NSString *groupID;
///引用APP的tabBar用来调用tabBar的对象或方法


///其他对象：
///拨打电话
-(void)callPhone:(NSString *)phoneNum;
+ (BOOL)isPureInt:(NSString*)string;

@end


#pragma mark 其他工具
@interface OtherTools :NSObject
///格式化字符串
+(NSString *)formatString:(id)object;
///保存登录信息
+(void)saveLoginData:(NSString *)json;
///读取登录信息
+(void)readLoginData;
//转换json
+(NSString*)DataTOjsonString:(id)object;
//枚举获取电梯目前运行状态
+(NSString *)getElevatorStatu:(NSInteger)statu;
//MD5加密
+(NSString *)md5:(NSString *)str;
//网络请求、匹配陈尧服务器接口
+(NSString *)requestMethod:(NSString *)method;
///弹窗精简代码（无代理回调的alertView）
+(void)showAlert:(NSString *)string;
///储存自动登录的数据
+(void)autoLogin:(BOOL)autoLogin;
///读取是否自动登录
+(BOOL)readIfAutoLogin;
///字符串高度（高度不限）
+ (CGFloat)getStringHeightInWidth:(CGFloat)width AndSystemFontSize:(CGFloat)fontSize forString:(NSString *)string;
///字符串高度（限高，超出部分用...代替）
+ (CGFloat)getWidthInHeight:(CGFloat)height AndSystemFontSize:(CGFloat)fontSize forString:(NSString *)string;
///在指定范围内获取字符串宽度
+ (CGFloat)getWidthInLimitedSize:(CGSize)limitedSize AndSystemFontSize:(CGFloat)fontSize forString:(NSString *)string;
+(NSString *)stringFromImage:(UIImage *)image;
@end

#pragma mark 时间处理
@interface ZHDateObject : NSObject
//获取指定时间指定格式的字符串，如果获取当前时间就传[NSDate date]
+(NSString *)stringFromDate:(NSDate *)date WithDateFormater:(NSString *)dateFormatter;
///根据字符串和它的格式获取时间
+(NSDate *)dateFromString:(NSString *)dateString AndFormatter:(NSString *)formatter;
/*
 yyyyMMddHHmmss
 eeee(en_us)
 EEEE(zh_cn)
 
 */
///避免24：00的时间比较出问题自己写一个，00:00和24:00系统是比较不出来的
+(BOOL)compareTime:(NSString *)time1 withTime:(NSString *)time2;
@end

#pragma mark 一个搜索的View
typedef void (^SearchBlock)(NSString *searchText);
@interface searchView : UIView<UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar *searchBar;
///实例化反回一个全屏的搜索view，顶部会有一个搜索框，下面的Block会在点击搜索按钮时候调用并且此view被销毁掉
-(instancetype)initWithSearchBlock:(SearchBlock)block;

@end

#pragma mark 首字母排序
@interface UntillSortData : NSObject
///排序的数组内字典的关键字
@property(nonatomic,copy)NSString *keyWord;
///需要排序的数组
@property(nonatomic,retain)NSMutableArray *dataSource;
-(instancetype)initWithKeyWord:(NSString *)key AndData:(NSArray *)data;
@end




@interface SortResult : NSObject
///排序后返回的结果
@property(nonatomic,retain,getter=title)NSMutableArray *titles;
///排序后返回的二维数组
@property(nonatomic,retain,getter=array)NSMutableArray *dataArray;
-(instancetype)init;

@end





@interface SortArrayTool : NSObject
-(SortResult *)sortArray:(UntillSortData *)sortData;
@end

#pragma mark 帮助页面
typedef enum {
    helpTypeRegion = 0,
    helpTypeRepairTypeSet,
    helpTypeMingPian
}helpType;

@interface HelpObject : NSObject
-(UIView *)showHelp:(helpType)type;
@end


