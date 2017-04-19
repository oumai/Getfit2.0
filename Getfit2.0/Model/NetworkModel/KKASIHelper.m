//
//  KKASIHelper.m
//  PartyLoss
//
//  Created by zorro on 15/11/9.
//  Copyright © 2015年 zhc. All rights reserved.
//

#import "KKASIHelper.h"
#import "ASIFormDataRequest.h"
#import "NSObject+SBJSON.h"
#import "Reachability.h"
#import "ZHObject.h"

@interface KKASIHelper ()

@property (nonatomic, strong) Reachability *reach;

@end

@implementation KKASIHelper

DEF_SINGLETON(KKASIHelper)

- (void)requestWithString:(NSString *)urlString
                  andDict:(NSDictionary *)dict
         withSuccessBlock:(NSObjectSimpleBlock)success
            withFailBlock:(NSObjectSimpleBlock)fail
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request addPostValue:obj forKey:key];
    }];
    
    __weak ASIHTTPRequest *weakRequest = request;
    [weakRequest setCompletionBlock:^{
        NSString *string = weakRequest.responseString;
        if (success)
        {
            success(string);
        }
    }];
    [weakRequest setFailedBlock:^{
        if (fail)
        {
            fail(nil);
        }
    }];
    
    [weakRequest startAsynchronous];
}

// 退出家庭圈
- (void)exitFamily:(NSString *)familyID withBlock:(NSObjectSimpleBlock)block
{
    NSURL *URL = [NSURL URLWithString:KKASI_Exit_URL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    [request addPostValue:G_USERTOKEN forKey:@"access_token"];
    [request addPostValue:familyID forKey:@"family_id"];
    
     __weak ASIHTTPRequest *weakRequest = request;
    [request setCompletionBlock:^{
        NSLog(@"退出群...%@", weakRequest.responseString);
        NSDictionary *dic= weakRequest.responseString.JSONValue;
        
        if (formartStr(dic[@"ret"]).intValue !=0 && formartStr(dic[@"ret"]))
        {
            [self showMessage:formartStr(dic[@"ret"]).intValue];
            return;
        } else {
            SHOWMBProgressHUD(KK_Text(@"Successful exits group"), nil, nil, NO, 2.0);
            
            if (block) {
                block(nil);
            }
        }
    }];
    [request setFailedBlock:^{
        SHOWMBProgressHUD(KK_Text(@"Exit group fails"), nil, nil, NO, 2.0);
    }];
    [request setTimeOutSeconds:TimeOut];
    [request startAsynchronous];
}

// 更新家庭圈信息
- (void)updateFamily:(NSDictionary *)dict withImage:(UIImage *)image
{
    NSURL *URL = [NSURL URLWithString:KKASI_Update_URL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request addPostValue:obj forKey:key];
    }];
    
    if (image)
    {
        UIImage *updateImage = [image imageScaleToSize:CGSizeMake(240, 240)];
        ///将图片转换成2进制文件，以JPG格式转
        NSData *zipFileData = UIImageJPEGRepresentation(image,0.9);
        if (!zipFileData)
        {
            ///如果以JPG格式转换失败，那么强制转换为PNG
            zipFileData = UIImagePNGRepresentation(updateImage);
            [request addData:zipFileData withFileName:@"uploadImage.png" andContentType:@"image/png" forKey:@"image"];
        }
        else
        {
            [request addData:zipFileData withFileName:@"uploadImage.jpg" andContentType:@"image/jpg" forKey:@"image"];
        }
    }
    
    __weak ASIHTTPRequest *weakRequest = request;
    [request setCompletionBlock:^{
        
        NSDictionary *dic= weakRequest.responseString.JSONValue;
        if (formartStr(dic[@"ret"]).intValue !=0 && formartStr(dic[@"ret"]))
        {
            [self showMessage:formartStr(dic[@"ret"]).intValue];
            return;
        } else {
            SHOWMBProgressHUD(KK_Text(@"Updates Success"), nil, nil, NO, 2.0);
        }
    }];
    [request setFailedBlock:^{
        SHOWMBProgressHUD(KK_Text(@"Updates Failed"), nil, nil, NO, 2.0);
    }];
    [request setTimeOutSeconds:TimeOut];
    [request startAsynchronous];
}

- (BOOL)isReachableNetwork
{
    _reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];

    return [_reach isReachable];
}

#define KK_Binddevice @"http://120.25.103.18:8082/app/binddevice"
#define KK_APPID @"2"


- (NSString *)familyID
{
    return _familyID ? _familyID : @"";
}

@end
