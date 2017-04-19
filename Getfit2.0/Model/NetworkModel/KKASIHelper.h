//
//  KKASIHelper.h
//  PartyLoss
//
//  Created by zorro on 15/11/9.
//  Copyright © 2015年 zhc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KKASI_Exit_URL @"http://120.25.103.18:8086/family/member/delete"
#define KKASI_Join_URL @"http://120.25.103.18:8086/family/member/create"
#define KKASI_Update_URL @"http://120.25.103.18:8086/family/manager/update"
#define KKASI_SetUserInfo_URL @"http://120.25.107.145:9527?service=user.setinfo"
#define KKASI_Getalarmtrack_URL @"http://120.25.107.145:9527?service=retrieve.getalarmtrack"

@interface KKASIHelper : NSObject

@property (nonatomic, strong) NSString *familyID;
@property (nonatomic, strong) NSString *tribeLogo;

AS_SINGLETON(KKASIHelper)

- (void)requestWithString:(NSString *)urlString
                  andDict:(NSDictionary *)dict
         withSuccessBlock:(NSObjectSimpleBlock)success
            withFailBlock:(NSObjectSimpleBlock)fail;

// 退出家庭圈
- (void)exitFamily:(NSString *)familyID withBlock:(NSObjectSimpleBlock)block;
// 更新家庭圈信息
- (void)updateFamily:(NSDictionary *)dict withImage:(UIImage *)image;

@end
