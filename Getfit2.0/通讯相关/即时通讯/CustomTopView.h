//
//  CustomTopView.h
//  StoryPlayer
//
//  Created by zhanghao on 15/12/10.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoLabel;
@property(nonatomic,strong)UIViewController *controller;
@end
