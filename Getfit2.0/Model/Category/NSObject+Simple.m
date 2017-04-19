//
//  NSObject+Simple.m
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "NSObject+Simple.h"
#import <objc/runtime.h>
#import "ShareData.h"

@implementation NSObject (Simple)

@dynamic attributeList;

- (NSArray *)attributeList
{
    NSUInteger propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], (unsigned int *)&propertyCount);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < propertyCount; i++)
    {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        // const char *attr = property_getAttributes(properties[i]);
        // NSLogD(@"%@, %s", propertyName, attr);
        [array addObject:propertyName];
    }
    
    free( properties );
    return array;
}

+ (BOOL)isHasAMPMTimeSystem
{
    // 获取系统是24小时制或者12小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = (containsA.location != NSNotFound);
    
    // hasAMPM == TURE为12小时制，否则为24小时制
    
    return hasAMPM;
}

+ (UIViewController *)topMostController
{
    //Getting rootViewController
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //Getting topMost ViewController
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    //Returning topMost ViewController
    return topController;
}

- (void)delayPerformBlock:(NSObjectSimpleBlock)block WithTime:(CGFloat)time
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // code to be executed on the main queue after delay
        
        if (block)
        {
            block(nil);
        }
        
    });
}

// 对完整的文件路径进行判断,isDirectory 如果是文件夹返回YES, 如果不是返回NO.
- (BOOL)completePathDetermineIsThere:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path];
    
    return existed;
}

+ (NSString *)KKLocalizedString:(NSString *)translation_key
{
    NSString *KK_Language = [ShareData sharedInstance].language;
    NSString *s = NSLocalizedString(translation_key, nil);
    // NSString * s = NSLocalizedStringFromTable(@"trainTitle",@"文件名",@"");
    NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];

    if ([KK_Language isEqualToString:@"zh-Hans-CN"] ||
        [KK_Language isEqualToString:@"zh-Hans"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
    } else if ([KK_Language isEqualToString:@"zh-Hant-CN"] ||
               [KK_Language isEqualToString:@"zh-HK"] ||
               [KK_Language isEqualToString:@"zh-Hant"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"zh-Hant" ofType:@"lproj"];
    } else if ([KK_Language hasPrefix:@"ja"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"ja" ofType:@"lproj"];
    } else if ([KK_Language hasPrefix:@"de"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"de" ofType:@"lproj"];
    } else if ([KK_Language hasPrefix:@"fr"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"fr" ofType:@"lproj"];
    } else if ([KK_Language hasPrefix:@"ko"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"ko" ofType:@"lproj"];
    } else if ([KK_Language hasPrefix:@"ru"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"ru" ofType:@"lproj"];
    } else if ([KK_Language hasPrefix:@"pt"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"pt-PT" ofType:@"lproj"];
    } else if ([KK_Language hasPrefix:@"es"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"es" ofType:@"lproj"];
    } else if ([KK_Language hasPrefix:@"it"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"it" ofType:@"lproj"];
    } else if ([KK_Language hasPrefix:@"uk"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"uk" ofType:@"lproj"];
    }
    else if ([KK_Language hasPrefix:@"pl"]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"pl" ofType:@"lproj"];
    }
    
    NSBundle *languageBundle = [NSBundle bundleWithPath:path];
    s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    
    return s;
}

- (void)showMessage:(NSInteger)ret
{
    NSDictionary *dict = @{@"400" : KK_Text(@"Bad Request"),
                           @"401" : KK_Text(@"Unauthorized"),
                           @"403" : KK_Text(@"Forbidden"),
                           @"500" : KK_Text(@"Internal Server Error"),
                           @"504" : KK_Text(@"Gateway Time-out"),
                           @"10101" : KK_Text(@"User exists"),
                           @"10102" : KK_Text(@"Phone exists"),
                           @"10103" : KK_Text(@"Email exists"),
                           @"10104" : KK_Text(@"User or password error"),
                           @"10105" : KK_Text(@"User device changed"),
                           @"10106" : KK_Text(@"Captcha has been invalid"),
                           @"10107" : KK_Text(@"Captcha is wrong"),
                           @"10108" : KK_Text(@"User not register"),
                           @"10109" : KK_Text(@"Image is illegal"),
                           @"10201" : KK_Text(@"Group not exists"),
                           @"10202" : KK_Text(@"User already join Group"),
                           @"10203" : KK_Text(@"User not member of Group")};
    
    NSString *string = [dict objectForKey:[NSString stringWithFormat:@"%ld", (long)ret]];
    if (!string) {
        string = KK_Text(@"Unknown error");
    }
    
    SHOWMBProgressHUD(string, nil, nil, NO, 2.0);
}

@end
