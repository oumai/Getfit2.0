//
//  UserProfileViewTableCell.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserProfileViewTableCell.h"

@implementation UserProfileViewTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[ super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self loadCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)loadCell
{
    _title = [[UILabel alloc] init];
    _title.font = DEFAULT_FONTHelvetica(14.0);
    _title.textColor = [UIColor whiteColor];
    [self addSubview:_title];
    
    _userData = [[UILabel alloc] init];
    _userData.font = DEFAULT_FONTHelvetica(14.0);
    _userData.textColor = [UIColor whiteColor];
    [self addSubview:_userData];
    
    _whiteLine = [[UIView alloc] init];
    [self addSubview:_whiteLine];
    
    _whiteLine2 = [[UIView alloc] init];
    [self addSubview:_whiteLine2];
    
    _settingButton = [[UIButton alloc] init];
    _settingButton.bgImageNormal = @"mine_btn_next_5s@2x.png";
    [self addSubview:_settingButton];
    
    _textField = [[UITextField alloc] init];
    _textField.textColor =[UIColor whiteColor];
    _textField.keyboardType  =  UIKeyboardTypeDefault;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.font = DEFAULT_FONTHelvetica(14.0);
    [self addSubview:_textField];
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)userProfileUpateCellTitle:(NSString *)title update:(NSString *)Data index:(NSInteger)row
{
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = UIColorHEX(0x363636);
    
    _title.frame = CGRectMake(18, (55 - 40)/2, 120, 40);
    _title.text = title;
    
    _userData.frame = CGRectMake(self.width/2, (55 - 40)/2, 150, 40);
    _userData.text = Data;
    
    _whiteLine.frame = CGRectMake(0, 0, Maxwidth , 0.5);
    _whiteLine.layer.borderWidth = 0.5;
    _whiteLine.layer.borderColor = UIColorHEX(0x888b90).CGColor;
    
    _whiteLine2.frame = CGRectMake(0, 55, Maxwidth , 0.5);
    _whiteLine2.layer.borderWidth = 0.5;
    _whiteLine2.layer.borderColor = UIColorHEX(0x888b90).CGColor;

    _settingButton.frame = CGRectMake(Maxwidth - 44, (55 - 44) / 2.0, 44, 44);
    if (row == 0)
    {
        _settingButton.hidden = YES;
        _userData.hidden = YES;
        _textField.frame = CGRectMake(self.width/2, (55 - 40)/2, self.width/2-6, 40);
        
        if (Data.length == 0)
        {
            _textField.placeholder = KK_Text(@"Please type in your name");
        }
        else
        {
            _textField.text = Data;
        }
    }
    else
    {
        _settingButton.hidden = NO;
        _textField.hidden = YES;
    }
}
@end
