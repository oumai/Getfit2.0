//
//  NSString+Simple.m
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "NSString+Simple.h"

@implementation NSString (Simple)

// 注明文件不需要备份
- (BOOL)addSkipBackupAttributeToItem
{
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:self];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success)
    {
        NSLogD(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}

// 获取字符串的区域大小
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - Contains

// 字符串是否包含 piece
- (BOOL)contains:(NSString *)piece
{
    return ([self rangeOfString:piece].location != NSNotFound);
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isValid
{
    if (self && ![self isEqualToString:@""])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isUserName
{
    NSString *regex = @"(^[A-Za-z0-9]{4,18}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isNickName
{
    NSString *regex = @"(^[A-Za-z0-9-_]{1,10}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPassword
{
    NSString *		regex = @"(^[A-Za-z0-9]{6,14}$)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}+[\\.[A-Za-z]{2,4}]?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

/**
 *  通过key设置value或者取value
 *
 *  @param key
 *
 *  @return
 */
- (id)getObjectValue
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    return [UD objectForKey:self];
}

- (NSInteger)getIntValue
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    return [UD integerForKey:self];
}

- (BOOL)getBOOLValue
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    return [UD boolForKey:self];
}

- (void)setObjectValue:(id)value
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    [UD setObject:value forKey:self];
    [UD synchronize];
}

- (void)setIntValue:(NSInteger)value
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    [UD setInteger:value forKey:self];
    [UD synchronize];
}

- (void)setBOOLValue:(BOOL)value
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    [UD setBool:value forKey:self];
    [UD synchronize];
}

@end
