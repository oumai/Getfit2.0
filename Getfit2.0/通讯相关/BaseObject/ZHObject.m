//
//  ZHObject.m
//  Elevator
//
//  Created by 张浩 on 15/6/17.
//  Copyright (c) 2015年 zhanghao. All rights reserved.
//

#import "ZHObject.h"
#import <CommonCrypto/CommonCryptor.h>
#import "WXLogin.h"
@implementation ZHObject

@end



@implementation GlobleFiles
{
    NSString *_PhoneNum;
}
+(GlobleFiles *)ShareObject
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.userData = [NSMutableDictionary dictionary];
    }
    return self;
}
+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
-(void)callPhone:(NSString *)phoneNum
{
    if (![GlobleFiles isPureInt:phoneNum])
    {
        [OtherTools showAlert:@"电话号码有误"];
        return;
    }
    _PhoneNum = phoneNum;
    UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"是否拨打%@？",phoneNum] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 8521;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_PhoneNum]]];
    }
}
@end





@implementation OtherTools
+(NSString *)formatString:(id)object
{
    if (object == nil)
    {
        return @"";
    }
    else
    {
        return [NSString stringWithFormat:@"%@",object];
    }
}
///保存登录信息
+(void)saveLoginData:(NSString *)json
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:json forKey:@"userLoginData"];
    [user synchronize];
}
///读取登录信息
+(void)readLoginData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *json = [user objectForKey:@"userLoginData"];
    if (json)
    {
        NSDictionary *dic= json.JSONValue;
        G_USERTOKEN = formartStr(dic[@"data"][@"access_token"]);
        [[WXLogin alloc]initWithUserID:formartStr(dic[@"data"][@"id"]) AndUserPSW:formartStr(dic[@"data"][@"im_password"])];
    }
}

+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
+(NSString *)getElevatorStatu:(NSInteger)statu
{
    if (statu == 0)
    {
        return @"正常";
    }
    else if (statu == 1)
    {
        return @"维保";
    }
    else
    {
        return @"停用";
    }
}
+(NSString *)requestMethod:(NSString *)method
{
    return [NSString stringWithFormat:@"%@%@",ServerURL,method];
}
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3],result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]] lowercaseString];
}
+(void)showAlert:(NSString *)string
{
    UIAlertView *laer = [[UIAlertView alloc]initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [laer show];
}
+(void)autoLogin:(BOOL)autoLogin
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:autoLogin forKey:@"autoLogin"];
    if (autoLogin)
    {
        [user setValue:G_USERID forKey:@"userID"];
        [user setValue:G_USERTOKEN forKey:@"userToken"];
    }
    [user synchronize];
}
+(BOOL)readIfAutoLogin
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    BOOL autoLogin = [[user objectForKey:@"autoLogin"]boolValue];
    if (autoLogin)
    {
        G_USERID = [user objectForKey:@"userID"];
        G_USERTOKEN = [user objectForKey:@"userToken"];
    }
    return autoLogin;
}
+ (CGFloat)getStringHeightInWidth:(CGFloat)width AndSystemFontSize:(CGFloat)fontSize forString:(NSString *)string
{
    return [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
}
+ (CGFloat)getWidthInHeight:(CGFloat)height AndSystemFontSize:(CGFloat)fontSize forString:(NSString *)string
{
    return [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, height) lineBreakMode:NSLineBreakByWordWrapping].width;
}
+ (CGFloat)getWidthInLimitedSize:(CGSize)limitedSize AndSystemFontSize:(CGFloat)fontSize forString:(NSString *)string
{
    return  [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:limitedSize lineBreakMode:NSLineBreakByWordWrapping].width;
}
+(NSString *)stringFromImage:(UIImage *)image;
{
    NSData *data = UIImagePNGRepresentation(image);
    if (!data)
    {
        data = UIImageJPEGRepresentation(image, 0.8);
    }
    return [data base64EncodedStringWithOptions:0];
}
    
@end

@implementation ZHDateObject
+(NSString *)stringFromDate:(NSDate *)date WithDateFormater:(NSString *)dateFormatter
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormatter];
    return [formatter stringFromDate:date];
}
+(NSString *)currentDateWithDateFormater:(NSString *)dateFormatter
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormatter];
    return [formatter stringFromDate:[NSDate date]];
}
+(NSDate *)dateFromString:(NSString *)dateString AndFormatter:(NSString *)formatter
{
    NSDateFormatter *form =[[NSDateFormatter alloc]init];
    [form setDateFormat:formatter];
    return [form dateFromString:dateString];
}
+(BOOL)compareTime:(NSString *)time1 withTime:(NSString *)time2
{
    NSInteger hour1 = [time1 substringToIndex:[time1 rangeOfString:@":"].location].integerValue;
    NSInteger hour2 = [time2 substringToIndex:[time2 rangeOfString:@":"].location].integerValue;
    NSInteger minute1= [time2 substringFromIndex:[time2 rangeOfString:@":"].location+1].integerValue;
    NSInteger minute2= [time2 substringFromIndex:[time2 rangeOfString:@":"].location+1].integerValue;
    if ((hour1*60+minute1)>=(hour2*60+minute2))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end



@implementation searchView
{
    SearchBlock _block;
}
-(instancetype)initWithSearchBlock:(SearchBlock)block;
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 64, screenWidth, screenHeight-64);
        self.backgroundColor = [UIColor clearColor];
        UILabel *bg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        bg.backgroundColor = [UIColor blackColor];
        bg.alpha = 0.8;
        [self addSubview:bg];
        
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
        [self addSubview:self.searchBar];
        self.searchBar.delegate = self;
        _block = block;
    }
    return self;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _block(searchBar.text);
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self removeFromSuperview];
    return YES;
}
@end
#pragma mark 首字母排序


@implementation UntillSortData

-(instancetype)initWithKeyWord:(NSString *)key AndData:(NSArray *)data
{
    self = [super init];
    if (self) {
        self.keyWord=key;
        self.dataSource = [data mutableCopy];
    }
    return self;
}

@end


@implementation SortResult

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.titles = [NSMutableArray array];
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

@end


@implementation SortArrayTool
{
    UntillSortData *_sortData;
}
-(SortResult *)sortArray:(UntillSortData *)sortData
{
    _sortData = sortData;
    SortResult *result = [[SortResult alloc]init];
    for(int i = 0;i<_sortData.dataSource.count;i++)
    {
        NSMutableDictionary *dic = [_sortData.dataSource[i] mutableCopy];
        NSString *firstLetter = [self ZHGetFirstLetter:[NSString stringWithFormat:@"%@",dic[_sortData.keyWord]]];
        [dic setValue:firstLetter forKey:@"firstletter"];
        [_sortData.dataSource replaceObjectAtIndex:i withObject:dic];
    }
    for (char title = 'a'; title<='z'; title++)
    {
        NSArray *subArr = [self searchForTitle:title  WithKey:_sortData.keyWord];
        if (subArr&&subArr.count>0)
        {
            [result.dataArray addObject:subArr];
            [result.titles addObject:[[NSString stringWithFormat:@"%c",title] uppercaseString]];
        }
    }
    if (_sortData.dataSource.count>0)
    {
        [result.dataArray addObject:_sortData.dataSource];
        [result.titles addObject:@"#"];
    }
    return result;
}

- (NSString *)ZHGetFirstLetter:(NSString *)string
{
    //去掉空格
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    //深拷贝
    NSMutableString *source = [string mutableCopy];
    //转拼音
    CFStringTransform((CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    //    NSLog(@"source is %@",source);
    //获取首字母
    if (source.length>1)
    {
        if ([@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" rangeOfString:[source substringWithRange:NSMakeRange(0, 1)]].location != NSNotFound)
        {
            return [source substringWithRange:NSMakeRange(0, 1)];
        }
        else
        {
            return [string substringWithRange:NSMakeRange(0, 1)];
        }
    }
    else
    {
        return @"#";
    }
}
-(NSMutableArray *)searchForTitle:(char)title WithKey:(NSString *)key;
{
    NSMutableArray *arr;
    for (int i = 0;i<_sortData.dataSource.count;i++)
    {
        NSDictionary * dic =_sortData.dataSource[i];
        if(title == [dic[@"firstletter"] characterAtIndex:0]||title-32 == [dic[@"firstletter"] characterAtIndex:0])
        {
            if (!arr)
            {
                arr = [NSMutableArray array];
            }
            [arr addObject:dic];
            [_sortData.dataSource removeObjectAtIndex:i];
            i--;
        }
    }
    return arr;
}
@end





@implementation HelpObject
-(UIView *)showHelp:(helpType)type
{
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
    if (type == helpTypeRegion)
    {
        if([usr boolForKey:@"helpTypeRegion"] == 0)
        {
            [usr setBool:1 forKey:@"helpTypeRegion"];
            [usr synchronize];
            return [self showImageWithImageName:@"help0.jpg"];
            
        }
        else
        {
            return nil;
        }
    }
    else if (type == helpTypeRepairTypeSet)
    {
        if([usr boolForKey:@"helpTypeRepairTypeSet"] == 0)
        {
            [usr setBool:1 forKey:@"helpTypeRepairTypeSet"];
            [usr synchronize];
            return [self showImageWithImageName:@"help1.jpg"];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if([usr boolForKey:@"helpTypeMingPian"] == 0)
        {
            [usr setBool:1 forKey:@"helpTypeMingPian"];
            [usr synchronize];
            return [self showImageWithImageName:@"help2.jpg"];
        }
        else
        {
            return nil;
        }
    }
}
-(UIView *)showImageWithImageName:(NSString *)imageName
{
    NSLog(@"image is %@",imageName);
    UIView *helpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [helpView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:imageName];
    return helpView;
}

@end







