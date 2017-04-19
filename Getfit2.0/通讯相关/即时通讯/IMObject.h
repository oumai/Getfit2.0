//
//  IMObject.h
//  StoryPlayer
//
//  Created by zhanghao on 15/12/10.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPKitExample.h"
#import "ZHObject.h"


@interface IMObject : NSObject
+(IMObject *)shareObject;
///获取群未读消息（未写）
-(NSString *)unreadMessageCount;
///获取群列表
-(void)getTribeListWhileCompelete:(ZHArrayBlock)block;
///更新群列表
-(void)updataTribeWhileComplete:(ZHArrayBlock)block;
///初始化群列表（后台更新群列表）
-(void)updataTribe:(BOOL)isRunBlock;

@end
