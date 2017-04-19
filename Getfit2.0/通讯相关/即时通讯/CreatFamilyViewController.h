//
//  CreatFamilyViewController.h
//  StoryPlayer
//
//  Created by zhanghao on 15/12/5.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "BaseViewController.h"

@interface CreatFamilyViewController : BaseViewController
-(void)setCreatCompleteBlock:(ZHVoidBlock)block;
@property(nonatomic,copy)NSString *familyID;
@property(nonatomic,retain)NSDictionary *familyInfo;
@end
