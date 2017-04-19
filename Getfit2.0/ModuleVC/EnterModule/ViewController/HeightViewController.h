//
//  heightViewController.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PersonalInfoViewController.h"

@interface HeightViewController : PersonalInfoViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *heightLabel;

@end
