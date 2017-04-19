//
//  Customie_TableViewCell.h
//  Customize
//
//  Created by 黄建华 on 15/5/25.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HubView.h"
#import "BLTModel.h"

@interface CustomieTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *cellimageView;
@property (nonatomic, strong) HubView *hubProgressView;
@property (nonatomic, strong) UIView *whiteLine;
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) UILabel *rssiLable;

- (void)cellUpdate:(BLTModel *)model;

@end
