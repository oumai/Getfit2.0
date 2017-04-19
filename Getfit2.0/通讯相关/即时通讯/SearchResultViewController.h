//
//  SearchResultViewController.h
//  StoryPlayer
//
//  Created by zhanghao on 15/12/7.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchResultViewController : BaseViewController
-(void)setFamilyID:(NSString *)familyID;
-(void)setAttentCompleteBlock:(ZHVoidBlock)block;
@end
