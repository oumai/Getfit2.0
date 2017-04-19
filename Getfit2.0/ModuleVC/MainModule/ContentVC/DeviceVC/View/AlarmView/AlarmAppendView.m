//
//  AlarmAppendView.m
//  custom_button
//
//  Created by 黄建华 on 15/7/8.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "AlarmAppendView.h"
#define BACKGROUNDVIEWCOLOR [[UIColor whiteColor] colorWithAlphaComponent:0.2]
#define ANIMATEWITHDURATION 0.4

@implementation AlarmAppendView
{
    NSString *_alremType;
//    NSMutableArray *hourArray;
//    NSMutableArray *MinArray;
//    BOOL *isAM;
}

- (instancetype)initWithFrame:(CGRect)frame withModel:(AlarmClockModel *)model
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _model = model;
        
        [self loadAlarmAppendView];
    }
    
    return self;
}

//@property (nonatomic, strong) UIButton *remindButton;
//@property (nonatomic, strong) UIButton *repeatButton;
//@property (nonatomic, strong) UIButton *timeButton;
//@property (nonatomic, strong) UIButton *nameButton;

- (void)loadAlarmAppendView
{
//    self.backgroundColor = UIColorHEX(0x262626);

    _originy = 0;
    _titleArray = [[NSArray alloc]initWithObjects:KK_Text(@"Alert"),KK_Text(@"Repeat"),KK_Text(@"Time"),KK_Text(@"Name"), nil];
    
    NSMutableArray *typeArray = [[NSMutableArray alloc] init];
    for (NSString *str in _model.alarmTypeArray) {
        [typeArray addObject:KK_Text(str)];
    }
    _alarmTypeArray = typeArray;
    for (NSString *alarm  in _model.alarmTypeArray)
    {
        NSLog(@"alarm>>>>>>%@",alarm);
    }
    
    [self loadremindView];
    [self loadrepeatView];
    [self loadtimeView];
    // [self loadnameView];
    
}

- (void)loadremindView
{
    // 背景view
    _remindView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 + _originy, self.frame.size.width, 44)];
    _remindView.backgroundColor = BACKGROUNDVIEWCOLOR;
    [self addSubview: _remindView];
    
    // 下拉按钮
    _remindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _remindButton.frame = CGRectMake(self.frame.size.width - 44, 0 , 44, 44);
    _remindButton.tag = 0;
    [_remindButton setBackgroundImage:[UIImage imageNamed:@"Device_btn_pull_down_5s@2x.png"] forState:UIControlStateNormal];
    [_remindButton setBackgroundImage:[UIImage imageNamed:@"Device_btn_pull_up_5s@2x.png"] forState:UIControlStateSelected];
    [_remindButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_remindView addSubview:_remindButton];
    
    // 标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 12,100, 20)];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = [_titleArray objectAtIndex:0];
    title.font = [UIFont systemFontOfSize:14.0];
    title.textColor = [UIColor whiteColor];
    [_remindView addSubview:title];
    
    _alremType = KK_Text(_model.alarmType);
    
    // 标签
    _alarmTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 120 - 44, 12,120,20)];
    _alarmTypeLabel.textAlignment = NSTextAlignmentRight;
    _alarmTypeLabel.text = [NSString stringWithFormat:@"%@",_alremType];
    if ([KK_Text(_model.alarmType) isEqualToString:KK_Text(@"Custom")]) {
        _alarmTypeLabel.text = KK_Text(@"Drink");
    }
    
    _alarmTypeLabel.font = [UIFont systemFontOfSize:11.0];
    _alarmTypeLabel.textColor = [UIColor whiteColor];
    [_remindView addSubview:_alarmTypeLabel];
    
      // 为UIPickerView控件设置dataSource和delegate
    
      _alarmTypePickView = [[AlarmTypePickerView alloc] initWithFrame:CGRectMake(0, 44, self.width, 216)];
      _alarmTypePickView.dataArray = _alarmTypeArray;
      [_alarmTypePickView selectRow:[_alarmTypePickView.dataArray indexOfObject:_alremType] inComponent:0 animated:NO];
      [_remindView addSubview:_alarmTypePickView];
      _remindView.clipsToBounds = YES;
    
      __weak  AlarmAppendView *safely = self;
    
      _alarmTypePickView.AlarmTypeSelectBlock = ^(NSInteger row)
      {
          safely.alarmTypeLabel.text = [ safely.alarmTypeArray objectAtIndex:row];
          safely.model.alarmType = [safely.model.alarmTypeArray objectAtIndex:row];
          if ([KK_Text( safely.model.alarmType) isEqualToString:KK_Text(@"Custom")]) {
              safely.alarmTypeLabel.text = KK_Text(@"Drink");
          }
      };  
}

- (void)loadrepeatView
{
    _repeatView = [[UIView alloc]initWithFrame:CGRectMake(0,_remindView.frame.origin.y + 44 + 1, self.frame.size.width, 44)];
    _repeatView.backgroundColor = BACKGROUNDVIEWCOLOR;
    [self addSubview: _repeatView];
    
    _repeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _repeatButton.frame = CGRectMake(self.frame.size.width - 44, 0 , 44, 44);
    _repeatButton.tag = 1;
    
//    [_repeatButton setBackgroundImage:[UIImage imageNamed:@"Device_btn_pull_down_5s@2x.png"] forState:UIControlStateNormal];
//    [_repeatButton setBackgroundImage:[UIImage imageNamed:@"Device_btn_pull_up_5s@2x.png"] forState:UIControlStateSelected];
//    [_repeatButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_repeatView addSubview:_repeatButton];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 12,100, 20)];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = [_titleArray objectAtIndex:1];
    title.font = [UIFont systemFontOfSize:14.0];
    title.textColor = [UIColor whiteColor];
    [_repeatView addSubview:title];
    
    _alarmWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 200 - 44, 12,200, 20)];
    _alarmWeekLabel.textAlignment = NSTextAlignmentRight;
    _alarmWeekLabel.text = [_model showStringForWeekDay];
    _alarmWeekLabel.font = [UIFont systemFontOfSize:11.0];
    _alarmWeekLabel.textColor = [UIColor whiteColor];
    [_repeatView addSubview:_alarmWeekLabel];
    
    __weak AlarmAppendView *safely = self;
    
    _WeekView = [[WeekView alloc]initWithFrame:CGRectMake(0,45, self.frame.size.width, 120) withWeekBlock:^(WeekView *weekView) {
        safely.model.weekArray = weekView.selArray;
        safely.alarmWeekLabel.text = [safely.model showStringForWeekDay];
    }];
    
    [_WeekView updateSelButtonForWeekView:_model.weekArray];
    _repeatView.clipsToBounds = YES;
    [_repeatView addSubview:_WeekView];
}

- (NSString *)alarmWeekArray:(NSArray *)weekArray
{
    NSMutableString *weekText = [[NSMutableString alloc] init];
    
    for (int i = 0; i < weekArray.count; i++)
    {
        [weekText appendString:[self weekString:[weekArray objectAtIndex:i]]];
    }
    
    return weekText;
}

- (NSString *)weekString:(NSString *)date
{
    NSString * string = @"";
    if (date.intValue == 0)
    {
        string = KK_Text(@"Mon");
    }
    else if (date.intValue == 1)
    {
        string = KK_Text(@"Tue");
    }
    else if (date.intValue == 2)
    {
        string = KK_Text(@"Wed");
    }
    else if (date.intValue == 3)
    {
        string = KK_Text(@"Thu");
    }
    else if (date.intValue == 4)
    {
        string = KK_Text(@"Fri");
    }
    else if (date.intValue == 5)
    {
        string = KK_Text(@"Sat");
    }
    else if (date.intValue == 6)
    {
        string = KK_Text(@"Sun") ;
    }
    return string;
}

- (void)loadtimeView
{
    _timeView = [[UIView alloc]initWithFrame:CGRectMake(0,_repeatView.frame.origin.y + 44 + 1, self.frame.size.width, 44)];
    _timeView.backgroundColor = BACKGROUNDVIEWCOLOR;
    [self addSubview: _timeView];
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.frame = CGRectMake(self.frame.size.width - 44, 0 , 44, 44);
    _timeButton.tag = 2;
    [_timeButton setBackgroundImage:[UIImage imageNamed:@"Device_btn_pull_down_5s@2x.png"] forState:UIControlStateNormal];
    [_timeButton setBackgroundImage:[UIImage imageNamed:@"Device_btn_pull_up_5s@2x.png"] forState:UIControlStateSelected];
    [_timeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_timeButton];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 12,100, 20)];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = [_titleArray objectAtIndex:2];
    title.font = [UIFont systemFontOfSize:14.0];
    title.textColor = [UIColor whiteColor];
    [_timeView addSubview:title];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100 - 44, 12,100, 20)];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:11.0];
    _timeLabel.textColor = [UIColor whiteColor];
    [_timeView addSubview:_timeLabel];
    
    _timepickView = [[QS_PickUpView alloc] initWithFrame:CGRectMake(0,70, self.width, 120)];
    _timepickView.PickDelegate = self;
//    _timepickView.backgroundColor = [UIColor redColor];
    
    
    NSMutableArray *daySplitArray = [[NSMutableArray alloc]init];
    NSInteger hourCount = 24;
    if([AlarmClockModel isHasAMPMTimeSystem]) {
        [daySplitArray addObject:KK_Text(@"am")];
        [daySplitArray addObject:KK_Text(@"pm")];
    }
   
    
    NSMutableArray *hourArray = [[NSMutableArray alloc]init];
    
    for (int i =0; i<hourCount; i++) {
        if([AlarmClockModel isHasAMPMTimeSystem]&&(i > 12)) {
             [hourArray addObject:[NSString stringWithFormat:@"%02d",i - 12]];
        } else {
            [hourArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    
    NSMutableArray *MinArray = [[NSMutableArray alloc]init];
    
    for (int i =0; i<60; i++)
    {
        [MinArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    _timepickView.daySplitArray = daySplitArray;
    _timepickView.hourArray = hourArray;
    _timepickView.minArray = MinArray;
    [_timeView addSubview:_timepickView];
    _timeView.clipsToBounds = YES;
    _timeLabel.text = [_model showTimeString];
    
    [_timepickView updatePickTime:_model.hour min:_model.minutes daySplit:_model.daySplit];
    
}


- (void)loadnameView
{
     _nameView = [[UIView alloc]initWithFrame:CGRectMake(0,_timeView.frame.origin.y + 44 + 1, self.frame.size.width, 44)];
    _nameView.backgroundColor = BACKGROUNDVIEWCOLOR;
    [self addSubview: _nameView];
    
    _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nameButton.frame = CGRectMake(self.frame.size.width - 44, 0 , 44, 44);
    _nameButton.tag = 3;
    [_nameButton setBackgroundImage:[UIImage imageNamed:@"Device_btn_pull_down_5s@2x.png"] forState:UIControlStateNormal];
    [_nameButton setBackgroundImage:[UIImage imageNamed:@"Device_btn_pull_up_5s@2x.png"] forState:UIControlStateSelected];
    [_nameButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_nameView addSubview:_nameButton];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 12,100, 20)];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = [_titleArray objectAtIndex:3];
    title.font = [UIFont systemFontOfSize:14.0];
    title.textColor = [UIColor whiteColor];
    [_nameView addSubview:title];
    
    _alarmRemarksLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100 - 44, 12,100, 20)];
    _alarmRemarksLabel.textAlignment = NSTextAlignmentRight;
    _alarmRemarksLabel.text = @"";
    _alarmRemarksLabel.font = [UIFont systemFontOfSize:11.0];
    _alarmRemarksLabel.textColor = [UIColor whiteColor];
    if (![_model.noteString isEqualToString:@""]) {
        _alarmRemarksLabel.text = _model.noteString;
    }
    [_nameView addSubview:_alarmRemarksLabel];
    
    
    _remarkTextBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 + 4, self.width, 300)];
    _remarkTextBgView.backgroundColor = [UIColor whiteColor];
    [_nameView addSubview:_remarkTextBgView];
    
    _remarkText = [[UITextField alloc] initWithFrame:CGRectMake(0, 30, self.width, 50)];
    _remarkText.textColor = UIColorHEX(0x888b90);
    _remarkText.textAlignment = NSTextAlignmentCenter;
    _remarkText.placeholder = KK_Text(@"Remind name is as more as 6 words");
    _remarkText.delegate = self;
    if (![_model.noteString isEqualToString:@""]) {
        _remarkText.text = _model.noteString;
    }
    [_remarkTextBgView addSubview:_remarkText];
    _nameView.clipsToBounds = YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //设置动画名字
    [UIView beginAnimations:@"Animation"context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.20];
    //在当前正在运行的状态下开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的偏移量
    self.frame =CGRectMake(self.frame.origin.x,self.frame.origin.y - 165,self.frame.size.width,self.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //设置动画的名字
    [UIView beginAnimations:@"Animation"context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.25];
    //使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    self.frame =CGRectMake(self.frame.origin.x,self.frame.origin.y + 165,self.frame.size.width,self.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
    _alarmRemarksLabel.text = _remarkText.text;
    _model.noteString = _remarkText.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_remarkText resignFirstResponder];
    return YES;
}

- (void)selectHours:(NSString *)hours SelectMin:(NSString *)min SelectDay:(NSString *)splitDay
{
    _model.daySplit = [splitDay integerValue];
 
    _model.hour = [hours integerValue];
    
    _model.minutes = [min integerValue];
    
    _timeLabel.text = [_model showTimeString];
}

- (void)buttonClick:(UIButton *)sender
{
    NSLog(@"闹钟>>>%ld",sender.tag);
    
        _currentMeum = sender.tag;
   
    if (_lastButton == sender)
    {
        if (_lastButton.selected)
        {
            [self disMissView];
            [_lastButton setSelected:NO];
   
        }else
        {
            [_lastButton setSelected:YES];
            [self disMissView];
            [self showViewFrame:sender.tag];
        }
    }else
    {
        _lastButton.selected = NO;
        sender.selected = YES;
        [self disMissView];
        [self showViewFrame:sender.tag];
        _lastButton = (UIButton*)sender;
        
    }
    if (_model.isChanged) {
        _model.isSys = NO;
    }
}

// 收起窗口
- (void)disMissView
{
        [_remarkText resignFirstResponder];
    
        [UIView animateWithDuration:ANIMATEWITHDURATION animations:^{
         
        _remindView.frame = CGRectMake(0, 0 + _originy , self.frame.size.width, 44 );
            
        _repeatView.frame = CGRectMake(0,_remindView.frame.origin.y + 44 + 1  , self.frame.size.width, 44);
        
        _timeView .frame = CGRectMake(0,_repeatView.frame.origin.y + 44 + 1, self.frame.size.width, 44);
        
        _nameView.frame = CGRectMake(0,_timeView.frame.origin.y + 44 + 1, self.frame.size.width, 44);
            
        } completion:^(BOOL finished) {
            
        }];
}

// 显示窗口
- (void)showViewFrame:(NSInteger )viewTag
{
    float _originOffSizey = 200.0;
    
    [UIView animateWithDuration:ANIMATEWITHDURATION animations:^{
        if (viewTag == 0)
        {
            _remindView.frame = CGRectMake(0, 0 + _originy , self.frame.size.width, 44 + 200);
            _repeatView.frame = CGRectMake(0,_remindView.frame.origin.y + 44 + 1  + _originOffSizey, self.frame.size.width, 44);
            
            _timeView .frame = CGRectMake(0,_repeatView.frame.origin.y + 44 + 1, self.frame.size.width, 44);
            
            _nameView.frame = CGRectMake(0,_timeView.frame.origin.y + 44 + 1, self.frame.size.width, 44);
        }
        else if (viewTag == 1)
        {
            _remindView.frame = CGRectMake(0, 0 + _originy , self.frame.size.width, 44 );
            _repeatView.frame = CGRectMake(0,_remindView.frame.origin.y + 44 + 1 , self.frame.size.width, 44 +200);
            
            _timeView .frame = CGRectMake(0,_repeatView.frame.origin.y + 44 + 1 + _originOffSizey, self.frame.size.width, 44);
            
            _nameView.frame = CGRectMake(0,_timeView.frame.origin.y + 44 + 1, self.frame.size.width, 44);
        }
        else if (viewTag == 2)
        {
            _remindView.frame = CGRectMake(0, 0 + _originy , self.frame.size.width, 44 );
            _repeatView.frame = CGRectMake(0,_remindView.frame.origin.y + 44 + 1 , self.frame.size.width, 44 );
            
            _timeView .frame = CGRectMake(0,_repeatView.frame.origin.y + 44 + 1 , self.frame.size.width, 44 + 200);
            
            _nameView.frame = CGRectMake(0,_timeView.frame.origin.y + 44 + 1+ _originOffSizey, self.frame.size.width, 44);
        }
        else if (viewTag == 3)
        {
            _remindView.frame = CGRectMake(0, 0 + _originy , self.frame.size.width, 44 );
            _repeatView.frame = CGRectMake(0,_remindView.frame.origin.y + 44 + 1 , self.frame.size.width, 44 );
            
            _timeView .frame = CGRectMake(0,_repeatView.frame.origin.y + 44 + 1 , self.frame.size.width, 44 );
            
            _nameView.frame = CGRectMake(0,_timeView.frame.origin.y + 44 + 1, self.frame.size.width, 44 + 200);
        }
    } completion:^(BOOL finished) {
        
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
