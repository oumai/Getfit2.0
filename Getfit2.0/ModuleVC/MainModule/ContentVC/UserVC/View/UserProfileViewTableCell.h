//
//  UserProfileViewTableCell.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewTableCell : UITableViewCell

@property (nonatomic, strong) UIView *whiteLine;
@property (nonatomic, strong) UIView *whiteLine2;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *userData;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UITextField *textField;

- (void)userProfileUpateCellTitle:(NSString *)title update:(NSString *)Data index:(NSInteger)row;

@end
