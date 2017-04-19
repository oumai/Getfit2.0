//
//  DeviceTableViewCell.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceTableViewCell.h"
#import "DeviceInfoClass.h"
#import "BLTSendModel.h"


@implementation DeviceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[ super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self loadCell];
    }
    
    return self;
}

- (void)loadCell
{
//    _functionDefaultView = [[UIView alloc] init];
//    [self addSubview:_functionDefaultView];
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    
    _openStateLabel = [[UILabel alloc] init];
    [self addSubview:_openStateLabel];
    
    _nextArrow = [[UIImageView alloc] init];
    [self addSubview:_nextArrow];
    
    _whiteLine = [[UIView alloc] init];
    _whiteLine.frame = CGRectMake(0, 0, Maxwidth , 0.5);
    _whiteLine.layer.borderWidth = 0.5;
    _whiteLine.layer.borderColor = UIColorHEX(0x888b90).CGColor;
    [self addSubview:_whiteLine];
    
    _whiteLine2 = [[UIView alloc] init];
    _whiteLine2.frame = CGRectMake(0, 44, Maxwidth , 0.5);
    _whiteLine2.layer.borderWidth = 0.5;
    _whiteLine2.layer.borderColor = UIColorHEX(0x888b90).CGColor;
    [self addSubview:_whiteLine2];
    
    _nextArrow.frame = CGRectMake(Maxwidth - 44  , 0, 44, 44);
    _nextArrow.image = UIImageNamed(@"Device_btn_next_1_5s@2x");
    [self addSubview:_nextArrow];

    _titleLabel.frame = CGRectMake(18, 10, 300, 25);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = DEFAULT_FONTHelvetica(14.0);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    
    _openStateLabel.frame = CGRectMake(Maxwidth - 105, 10, 80, 25);
    _openStateLabel.textColor = BGCOLOR;
    _openStateLabel.textAlignment = NSTextAlignmentRight;
    [_openStateLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.]];
    [self addSubview:_openStateLabel];
}

- (void)DeviceTableViewUpdateCell:(NSString *)title tableindexPath:(NSIndexPath *)indexPath;
{
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = UIColorHEX(0x363636);

    _titleLabel.text = title;
    _openStateLabel.text = [[DeviceInfoClass sharedInstance] Callreminder:title];
    if([title isEqualToString:KK_Text(@"Anti-lost Alert")] ||
       [title isEqualToString:KK_Text(@"Turn the hand")] ||
       [title isEqualToString:KK_Text(@"Find phone")] ||
       [title isEqualToString:KK_Text(@"SMS Notification")] ||
       [title isEqualToString:KK_Text(@"Notice reminder")]) {
        [_switchBtn removeFromSuperview];
        _nextArrow.image = [UIImage image:@""];
        _switchBtn = [[CustomSwitch alloc] initWithFrame:CGRectMake(Maxwidth - 60  , 10, 60, 25)];
        
        _switchBtn.offImageName = @"Device_btn_2_5s@2x.png";
        _switchBtn.onImageName = @"Device_btn_1_5s@2x.png";
        _switchBtn.btnImageName = @"Device_Stripe_1_5s@2x";
        
        if ([title isEqualToString:KK_Text(@"Anti-lost Alert")]) {
            _switchBtn.switchBtn.selected = [UserInfoHelper sharedInstance].bltModel.isLostModel;
        } else if ([title isEqualToString:KK_Text(@"Turn the hand")]) {
            _switchBtn.switchBtn.selected = [UserInfoHelper sharedInstance].bltModel.isTurnHand;
        } else if ([title isEqualToString:KK_Text(@"Find phone")]) {
            _switchBtn.switchBtn.selected = [UserInfoHelper sharedInstance].userModel.isFindPhone;
        } else if ([title isEqualToString:KK_Text(@"SMS Notification")]) {
            _switchBtn.switchBtn.selected = [UserInfoHelper sharedInstance].userModel.isSMS;
        } else if ([title isEqualToString:KK_Text(@"Notice reminder")]) {
            _switchBtn.switchBtn.selected = [UserInfoHelper sharedInstance].userModel.isNotice;
        }
        
        [_switchBtn setBtnState:_switchBtn.switchBtn.selected];
        [_switchBtn.switchBtn addTarget:self action:@selector(alarmSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
        self.userInteractionEnabled = YES;
        [self addSubview:_switchBtn];
    } else {
        [_switchBtn removeFromSuperview];
        _nextArrow.image = UIImageNamed(@"Device_btn_next_1_5s@2x");
    }
    
    if ([title isEqualToString:KK_Text(@"Device Name")]) {
        _openStateLabel.hidden = YES;
    } else {
        _openStateLabel.hidden = NO;
    }
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
- (void)alarmSwitchButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _switchBtn.on = sender.selected;
    if ([_titleLabel.text isEqualToString:KK_Text(@"Anti-lost Alert")]) {
        [[UserInfoHelper sharedInstance] sendLostMode:sender.selected WithBackBlock:^(id object) {
        }];
        [UserInfoHelper sharedInstance].bltModel.isLostModel = sender.selected;
    } else if ([_titleLabel.text isEqualToString:KK_Text(@"Turn the hand")]) {
        [[UserInfoHelper sharedInstance] sendTurnHand:sender.selected WithBackBlock:^(id object) {
        }];
        [UserInfoHelper sharedInstance].bltModel.isTurnHand = sender.selected;
    } else if ([_titleLabel.text isEqualToString:KK_Text(@"Turn the hand")]) {
        [UserInfoHelper sharedInstance].userModel.isFindPhone = sender.selected;
    } else if ([_titleLabel.text isEqualToString:KK_Text(@"SMS Notification")]) {
        [BLTSendModel sendSMSAlert:sender.selected withUpdateBlock:^(id object, BLTAcceptModelType type) {
        }];
        [UserInfoHelper sharedInstance].userModel.isSMS = sender.selected;
    } else if ([_titleLabel.text isEqualToString:KK_Text(@"Notice reminder")]) {
        [BLTSendModel sendNoticeAlert:sender.selected withUpdateBlock:^(id object, BLTAcceptModelType type) {
        }];
        [UserInfoHelper sharedInstance].userModel.isNotice = sender.selected;
    }
    
    [_switchBtn setBtnState:sender.selected];
}

@end
