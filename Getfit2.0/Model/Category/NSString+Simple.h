//
//  NSString+Simple.h
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Simple)

// 注明文件不需要备份
- (BOOL)addSkipBackupAttributeToItem;

// 获取字符串的区域大小
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

// 字符串是否包含 piece
- (BOOL)contains:(NSString *)piece;


// 删除字符串开头与结尾的空白符与换行
- (NSString *)trim;

// 判断字符串是否为真并且不为@""
- (BOOL)isValid;
- (BOOL)isUserName;
- (BOOL)isPassword;
- (BOOL)isEmail;

/**
 *  方便的存储关系
 *
 *  @return
 */
- (id)getObjectValue;
- (NSInteger)getIntValue;
- (BOOL)getBOOLValue;
- (void)setObjectValue:(id)value;
- (void)setIntValue:(NSInteger)value;
- (void)setBOOLValue:(BOOL)value;


@end
