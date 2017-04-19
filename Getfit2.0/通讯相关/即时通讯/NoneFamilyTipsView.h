//
//  NoneFamilyTipsView.h
//  StoryPlayer
//
//  Created by zhanghao on 15/12/4.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHObject.h"
@interface NoneFamilyTipsView : UIView
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

-(void)setCreatBlock:(ZHVoidBlock)creat AndErWeiMaBlock:(ZHVoidBlock)erweima AndSearchBlock:(ZHVoidBlock)search;

@end
