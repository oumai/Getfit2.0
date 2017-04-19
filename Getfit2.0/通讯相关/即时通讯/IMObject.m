//
//  IMObject.m
//  StoryPlayer
//
//  Created by zhanghao on 15/12/10.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "IMObject.h"

@implementation IMObject
{
    ZHArrayBlock _block;
    NSMutableArray *tribeList;
}
- (YWIMCore *)ywIMCore
{
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}
- (id<IYWTribeService>)ywTribeService
{
    return [[self ywIMCore] getTribeService];
}
+(IMObject *)shareObject
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
-(void)openTribe:(NSString *)tribeID
{
    
    
}
-(NSString *)unreadMessageCount
{
    return 0;
}
-(void)getTribeListWhileCompelete:(ZHArrayBlock)block
{
    _block = block;
    if (!tribeList)
    {
        [self updataTribe:YES];
    }
    else
    {
        _block(tribeList);
    }
}
/**
 *  获取群列表
 */
-(void)updataTribe:(BOOL)isRunBlock
{
    [self.ywTribeService requestAllTribesFromServer:^(NSArray *tribes, NSError *error) {
        if( error == nil ) {
            if (!tribeList)
            {
                tribeList = [NSMutableArray array];
            }
            [tribeList removeAllObjects];
            [tribeList addObjectsFromArray:tribes];
            
            if (isRunBlock) {
                if (_block) {
                    _block(tribeList);
                }
            }
        } else
        {
            // 失败
        }
    }];
}
-(void)updataTribeWhileComplete:(ZHArrayBlock)block
{
    _block = block;
    [self updataTribe:YES];
}
@end
