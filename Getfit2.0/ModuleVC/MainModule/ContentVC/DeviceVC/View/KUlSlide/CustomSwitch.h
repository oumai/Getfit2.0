//
//  CustomSwitch.h
//  Main3d
//
//  Created by kinghuang on 15/8/5.
//  Copyright (c) 2015年 KingHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSwitch : UIControl

@property (nonatomic ,strong) UIImageView *btnImage;
@property (nonatomic ,strong) NSString *onImageName;
@property (nonatomic ,strong) NSString *offImageName;
@property (nonatomic ,strong) NSString *btnImageName;

@property (nonatomic ,strong) UIButton *switchBtn;

@property(nonatomic,assign) BOOL on;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setBtnState:(BOOL)on;
@end
