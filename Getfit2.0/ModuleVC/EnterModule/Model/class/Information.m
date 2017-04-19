//
//  Information.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "Information.h"

@implementation Information

DEF_SINGLETON (Information)

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
     
    }
    
    return self;
}

- (void)setDeviceIndex:(NSInteger)DeviceIndex
{
    
}

- (BOOL)getUserInfo
{
    NSUserDefaults *saveInfo = [NSUserDefaults standardUserDefaults];
    
    if ([saveInfo objectForKey:@"saveuserinfo"]) {
        return YES;
    }
    else
        return NO;
}

- (void)saveUserInfo
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    [userInfo setObject:[NSNumber numberWithBool:_sex] forKey:@"sex"];
    
    [userInfo setObject:[NSNumber numberWithBool:_sex] forKey:@"sex"];
    [userInfo setObject:[NSNumber numberWithBool:_unit] forKey:@"unit"];
    [userInfo setObject:[NSNumber numberWithInteger:_selectHeight] forKey:@"selectHeight"];
    [userInfo setObject:[NSNumber numberWithInteger:_selectWeight] forKey:@"selectWeight"];
    [userInfo setObject:[NSNumber numberWithInteger:_selectBirthYear] forKey:@"selectBirthYear"];
    [userInfo setObject:[NSNumber numberWithInteger:_selectTargetStep] forKey:@"selectTargetStep"];
    [userInfo setObject:[NSNumber numberWithInteger:_selectTargetSleep] forKey:@"selectTargetSleep"];
    
    NSUserDefaults *saveInfo = [NSUserDefaults standardUserDefaults];
    [saveInfo setObject:userInfo forKey:@"saveuserinfo"];
    [saveInfo synchronize];
    
// NSLog(@"用户信息>>>>>%@",userInfo);
// NSLog(@"deviceList>>>>>%@",_deviceList);
// NSLog(@"selectTargetSleep>>>>>%ld",_selectHeight);
// NSLog(@"selectTargetSleep>>>>>%ld",_selectWeight);
// NSLog(@"selectTargetSleep>>>>>%ld",_selectBirthYear);
// NSLog(@"selectTargetSleep>>>>>%ld",_selectTargetStep);
// NSLog(@"selectTargetSleep>>>>>%ld",_selectTargetSleep);
}
@end
