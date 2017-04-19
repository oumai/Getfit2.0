//
//  DeviceTableViewCell.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSwitch.h"

@interface DeviceTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *openStateLabel;
@property (nonatomic, strong) UIView *functionDefaultView;
@property (nonatomic, strong) UIView *whiteLine;
@property (nonatomic, strong) UIView *whiteLine2;
@property (nonatomic, strong) UIImageView *nextArrow;
@property (nonatomic, strong) CustomSwitch *switchBtn;


- (void)DeviceTableViewUpdateCell:(NSString *)title tableindexPath:(NSIndexPath *)indexPath;

@end
