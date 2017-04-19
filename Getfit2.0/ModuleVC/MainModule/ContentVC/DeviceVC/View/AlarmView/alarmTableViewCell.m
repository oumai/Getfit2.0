//
//  alarmTableViewCell.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "alarmTableViewCell.h"
#import "DeviceInfoClass.h"

@implementation alarmTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[ super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.clipsToBounds = YES;
        [self loadCell];
    }
    
    return self;
}

- (void)loadCell
{
    _alarmIcon = [[UIImageView alloc] init];
    [self addSubview:_alarmIcon];
 
    _alarmSwitchButton = [[CustomSwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    _alarmSwitchButton.offImageName = @"Device_btn_2_5s@2x.png";

    _alarmSwitchButton.onImageName = @"Device_btn_1_5s@2x.png";
    
    _alarmSwitchButton.btnImageName = @"Device_Stripe_1_5s@2x";

    [_alarmSwitchButton.switchBtn addTarget:self action:@selector(alarmSwitchButton:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_alarmSwitchButton];
    
    _alarmTimeLabel = [[UILabel alloc] init];
    _alarmTimeLabel.textAlignment = NSTextAlignmentLeft;
    _alarmTimeLabel.textColor = [UIColor whiteColor];
    _alarmTimeLabel.font = DEFAULT_FONTHelvetica(16);
    [self addSubview:_alarmTimeLabel];
    
    _alarmWeeksLabel = [[UILabel alloc] init];
    _alarmWeeksLabel.textAlignment = NSTextAlignmentLeft;
    _alarmWeeksLabel.textColor = UIColorHEX(0x888b90);
    _alarmWeeksLabel.font = DEFAULT_FONTHelvetica(10);
    [self addSubview:_alarmWeeksLabel];
    
    _alarmTypeLabel = [[UILabel alloc] init];
    _alarmTypeLabel.textAlignment = NSTextAlignmentRight;
    _alarmTypeLabel.textColor = UIColorHEX(0x888b90);
    _alarmTypeLabel.font = DEFAULT_FONTHelvetica(10);
    [self addSubview:_alarmTypeLabel];
    
    _isSysLable = [[UILabel alloc] init];
    _isSysLable.textAlignment = NSTextAlignmentRight;
    _isSysLable.textColor = UIColorHEX(0x888b90);
    _isSysLable.font = DEFAULT_FONTHelvetica(10);
    [self addSubview:_isSysLable];

    // 添加
    _addAlarm = [[UIView alloc] init];
    [self addSubview:_addAlarm];
    [_addAlarm setHidden:YES];

    _addAlarmLabel = [[UILabel alloc] init];
    _addAlarmLabel.font = DEFAULT_FONTHelvetica(16);
    _addAlarmLabel.textColor = [UIColor whiteColor];
    _addAlarmLabel.textAlignment = NSTextAlignmentLeft;
    _addAlarmLabel.text = KK_Text(@"Add Alarm List");
    [_addAlarm addSubview:_addAlarmLabel];
    
    _addAlarmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addAlarmButton.bgImageNormal = @"Device_btn_add_5s@2x.png";
    [_addAlarm addSubview:_addAlarmButton];

    _whiteLine = [[UIView alloc] init];
    _whiteLine.backgroundColor = UIColorHEX(0x888b90);
    [self addSubview:_whiteLine];

    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = UIColorHEX(0x363636);
}

- (void)addWhiteLine
{
    _whiteLine.frame = CGRectMake(0, 0, Maxwidth , 53);
    _whiteLine.layer.borderWidth = 0.5;
    _whiteLine.layer.borderColor = UIColorHEX(0x888b90).CGColor;
}

//NSDictionary *alarm01 = [[NSDictionary alloc]init];
//[alarm01 setValue:@"锻炼" forKey:@"remindType"];
//[alarm01 setValue:@"周一,周二,周三,周四,周五" forKey:@"repeatWeek"];
//[alarm01 setValue:@"6:30" forKey:@"AlarmTime"];
//[alarm01 setValue:@"我的锻炼" forKey:@"SportSypeInfo"];
//[alarm01 setValue:@"1" forKey:@"alarmState"];
//[_alarmArray addObject:alarm01];

- (void)alarmTableViewUpdateCell:(AlarmClockModel *)model withHeight:(CGFloat)height
{
    if (!model)
    {
        _addAlarm.frame = CGRectMake(0, 0, Maxwidth, height);
        _addAlarmLabel.frame = CGRectMake(10, 0, 150, height);
        _addAlarmButton.frame = CGRectMake(Maxwidth - 60, (height - 44) / 2, 44, 44);
        
        [self resetViewsHidden:YES];
    }
    else
    {
        _model = model;
        [self resetViewsHidden:NO];

        _alarmIcon.frame = CGRectMake(10, (height - 40) / 2.0, 40, 40);
        _alarmIcon.image = [model showIconImage];
    
        _alarmSwitchButton.frame = CGRectMake(Maxwidth - 70, (height - 25) / 2, 60, 25);
        _alarmSwitchButton.switchBtn.selected = _model.isOpen;
        [_alarmSwitchButton setBtnState:_model.isOpen];
  
        _alarmTimeLabel.frame = CGRectMake(60, 0, 200, height);
        _alarmTimeLabel.text = model.showTimeString;;
        
        _alarmWeeksLabel.frame = CGRectMake(60, height - 20, 200, 20);
        _alarmWeeksLabel.text = [model showStringForWeekDay];
        
        _alarmTypeLabel.frame = CGRectMake(Maxwidth - 50, height - 20, 40, 20);
        _alarmTypeLabel.text = KK_Text(model.alarmType);
        if ([model.alarmType isEqualToString:KK_Text(@"Custom")]) {
            _alarmTypeLabel.text = KK_Text(@"Drink");
        }
        
        _isSysLable.frame = CGRectMake(Maxwidth - 90, height - 20, 40, 20);
        NSLog(@"%d",model.isSys);
        if (model.isSys) {
            _isSysLable.text = KK_Text(@"Synced");
        } else {
            _isSysLable.text = KK_Text(@"unsync");
        }
    }
    
    _whiteLine.frame = CGRectMake(0, height - 0.5, Maxwidth, 0.5);
}

- (void)resetViewsHidden:(BOOL)hidden
{
    _alarmIcon.hidden = hidden;
    _alarmSwitchButton.hidden = hidden;
    _alarmTimeLabel.hidden = hidden;
    _alarmWeeksLabel.hidden = hidden;
    _alarmTypeLabel.hidden = hidden;
    
    // 添加
    _addAlarm.hidden = !hidden;
}

- (void)alarmSwitchButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _alarmSwitchButton.on = sender.selected;
    [_alarmSwitchButton setBtnState:sender.selected];
//    NSLog(@"%d",_alarmSwitchButton.on);
    _model.isOpen = _alarmSwitchButton.on;
    _model.isSys = NO;
    _model.isChanged = YES;
    _isSysLable.text = KK_Text(@"unsync");
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

@end
