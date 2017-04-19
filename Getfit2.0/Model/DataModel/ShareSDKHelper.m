//
//  ShareSDKHelper.m
//  AJBracelet
//
//  Created by zorro on 16/4/8.
//  Copyright © 2016年 zorro. All rights reserved.
//

#import "ShareSDKHelper.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

// 116d136ba1519 com.bdk.fitapp
// APPID 1105239815 APPKEY JyNATO21tLZOIUUi
// AppID：wx18ca3a8ae1a1da0f AppSecret：d3c9cb3dc7c6fe5f132c2e0fae54a94e

@implementation ShareSDKHelper

+ (void)initLoad
{
    [ShareSDK registerApp:@"116d136ba1519"
          activePlatforms:@[
                            @(SSDKPlatformTypeFacebook),
                            @(SSDKPlatformTypeTwitter),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformSubTypeQZone)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeFacebook:
                      //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupFacebookByApiKey:@"222165008150321"
                                               appSecret:@"68c29ded67f8b7640732a5c92a3ea8ce"
                                                authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeTwitter:
                      [appInfo SSDKSetupTwitterByConsumerKey:@"Uj4SDhn4nA4xXWhmIaGzCM4ow"
                                              consumerSecret:@"t4hA0DdSi2Eyz4FFBwmrF3HctSI2KKKO1ceuy5knXgtPxKRP3v"
                                                 redirectUri:@"http://mob.com"];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx18ca3a8ae1a1da0f"
                                            appSecret:@"d3c9cb3dc7c6fe5f132c2e0fae54a94e"];
                      break;
                  case SSDKPlatformTypeQQ:
                  case SSDKPlatformSubTypeQZone:
                      [appInfo SSDKSetupQQByAppId:@"1105239815"
                                           appKey:@"JyNATO21tLZOIUUi"
                                         authType:SSDKAuthTypeBoth];
                      break;
                      
                  default:
                      break;
              }
          }];
}

+ (void)shareContentWithIndex:(NSInteger)index view:(UIView *)view image:(NSData *)image
{
    //发送内容给微信
    SSDKContentType contentType = SSDKContentTypeImage;
    SSDKPlatformType sharetype;
    switch (index) {
        case 9000: //facebook
            sharetype = SSDKPlatformTypeFacebook;
            break;
        case 9001: //微信
            sharetype = SSDKPlatformSubTypeWechatSession;
            break;
        case 9002: //朋友圈
            sharetype = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 9003: //qq
            sharetype = SSDKPlatformSubTypeQQFriend;
            break;
        case 9004: //twitter
            sharetype = SSDKPlatformTypeTwitter;
            break;
        case 9005: //qq空间
            sharetype = SSDKPlatformSubTypeQZone;
            contentType = SSDKContentTypeAuto;
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageWithData:image]];
    
    [shareParams SSDKSetupShareParamsByText:@"GetFit2.0"
                                     images:imageArray
                                        url:[NSURL URLWithString:@"https://www.pgyer.com/getfit20"]
                                      title:@"GetFit2.0"
                                       type:contentType];
    
    [ShareSDK share:sharetype
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 // SHOWMBProgressHUD([error localizedFailureReason], nil, nil, NO, 2.0);
                 [view dismissPopup];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 NSDictionary *dict = error.userInfo;
                 NSString *errorText = dict[@"error_message"];
                 if (errorText.length > 0) {
                     SHOWMBProgressHUD(dict[@"error_message"], nil, nil, NO, 2.0);
                 } else {
                 }
                 
                 NSLog(@"error = %@ %@", error, [error localizedDescription]);
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];
}


@end
