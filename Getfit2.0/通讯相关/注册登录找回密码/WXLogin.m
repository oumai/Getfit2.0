//
//  WXLogin.m
//  StoryPlayer
//
//  Created by zhanghao on 15/12/10.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "WXLogin.h"
#import "SPKitExample.h"
@implementation WXLogin

-(instancetype)initWithUserID:(NSString *)userID AndUserPSW:(NSString *)userPSW
{
    self = [super init];
    if (self) {
        [self loginWithUserID:userID AndUserPSW:userPSW];
    }
    return self;
}
-(void)loginWithUserID:(NSString *)userID AndUserPSW:(NSString *)userPSW
{
    [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:userID passWord:userPSW preloginedBlock:^{
        NSLog(@"可以显示回话列表");
    } successBlock:^{
        NSLog(@"旺信登录成功");
    } failedBlock:^(NSError *error) {
        NSLog(@"登录旺信失败");
        [self loginWithUserID:userID AndUserPSW:userPSW];
    }];
}
@end
