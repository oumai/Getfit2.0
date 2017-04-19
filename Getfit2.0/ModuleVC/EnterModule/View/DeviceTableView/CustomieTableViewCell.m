//
//  Customie_TableViewCell.m
//  Customize
//
//  Created by 黄建华 on 15/5/25.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "CustomieTableViewCell.h"

@implementation CustomieTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[ super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    _rssiLable = [[UILabel alloc] init];
    _rssiLable.textColor = [UIColor blackColor];
    _rssiLable.textAlignment = NSTextAlignmentLeft;
    _rssiLable.font = [UIFont systemFontOfSize:14.0];
    
    
    
    _cellimageView = [[UIImageView alloc] init];
    _cellimageView.image = [UIImage imageNamed:@"login_device_5s"];
    
    _selectImage = [[UIImageView alloc] init];
    _selectImage.image = [UIImage imageNamed:@"login_right_5s@2x.png"];
    _selectImage.hidden = YES;
    
    _whiteLine = [[UIView alloc] init];
    
    [self addSubview:_whiteLine];
    [self addSubview:_titleLabel];
    [self addSubview:_cellimageView];
    [self addSubview: _selectImage];
    [self addSubview:_rssiLable];
}

- (void)cellUpdate:(BLTModel *)model
{
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = UIColorHEX(0xededed);
    
    _titleLabel.frame = CGRectMake(60, 10, 200, 25);
    _titleLabel.text = model.bltNickName;
    
    _rssiLable.frame = CGRectMake(60, 40, 25, 25);
    _rssiLable.text = model.bltRSSI;

    
    _cellimageView.frame = CGRectMake(5, 10, 50, 50);
    _selectImage.frame = CGRectMake(self.width - 50, 25, 30, 22);
    
    _whiteLine.frame = CGRectMake(-1, 0, self.width +2 , 70);
    _whiteLine.layer.borderWidth = 2;
    _whiteLine.layer.borderColor = UIColorHEX(0xededed).CGColor;
    
    if (model.peripheral.state == CBPeripheralStateConnected)
    {
        _selectImage.hidden = NO;
    }
    else
    {
        _selectImage.hidden = YES;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
