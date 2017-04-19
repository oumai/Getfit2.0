//
//  SedentaryReminderViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "SedentaryReminderViewController.h"
#import "RemindModel.h"
#import "BLTSendModel.h"
#import "KKPickerView.h"

@interface SedentaryReminderViewController ()

@property (nonatomic, strong) RemindModel *remindModel;
@property (nonatomic, strong) KKPickerView *pickerView;

@property (nonatomic, assign) CGFloat fitSizeHeight;
@property (nonatomic, assign) BOOL isOpen;

@end

@implementation SedentaryReminderViewController
{
    UILabel *LabelInfo;
    UILabel *LabelInfo2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _remindModel = [[UserInfoHelper sharedInstance].bltModel.remindArray lastObject];
    _setTimeArray = [[NSMutableArray alloc]init];
    [_setTimeArray addObject:_remindModel.showStartTimeString];
    [_setTimeArray addObject:_remindModel.showEndTimeString];
    NSLog(@"_setTimeArray>>>>%@",_setTimeArray);
    
    _fitSizeHeight = FitScreenNumber(40, 0, 0, 0, 0);
    
    [self loadViewSetup];
    
    [self loadButton];
    
//    [self loadTableView];
    
//    [self loadWeekView];
    
    [self loadPickUpSelectView];
    if(_remindModel.isOpen) {
        [self onViewShow];
    } else {
        [self offViewShow];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isOpen= _remindModel.isOpen;
}

- (void)loadViewSetup
{
    self.tipTitle.text = KK_Text(@"Sedentary Alert");
    self.view.backgroundColor = UIColorHEX(0x272727);
}

// 设置久坐提醒
- (void)rightBarButton
{
    _remindModel.isOpen = _isOpen;
    _remindModel.interval = _pickerView.selectedValue.integerValue;
    
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendSysRemind:^(id object, BLTAcceptModelType type)
         {
             
         }];
        SHOWMBProgressHUD(KK_Text(@"Setting success"), nil, nil, NO, 2.0);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(leftBarButton) object:nil];
        [self performSelector:@selector(leftBarButton) withObject:nil afterDelay:2.0];
    }
    else
    {
        SHOWMBProgressHUD(KK_Text(@"Device not Connected"), nil, nil, NO, 2.0);
    }
}

- (void)loadPickerView
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 30; i <= 120; i++) {
        [array addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    _pickerView = [[KKPickerView alloc] initWithFrame:CGRectMake(0, 120 - _fitSizeHeight + 84, self.view.width - 0, 180)
                                           withValues:array];
    
    [self.view addSubview:_pickerView];
    
    _pickerView.selectedIndex = _remindModel.interval - 30;
}

- (void)loadButton
{
    _switchButton = [[CustomSwitch alloc] initWithFrame:CGRectMake(self.view.width - 70, 15 + 84, 60, 25)];
    _switchButton.offImageName = @"Device_btn_2_5s@2x.png";
    _switchButton.onImageName = @"Device_btn_1_5s@2x.png";
    _switchButton.btnImageName = @"Device_Stripe_1_5s@2x";
    _switchButton.switchBtn.selected = _remindModel.isOpen;
    [_switchButton setBtnState:_remindModel.isOpen];

    [_switchButton.switchBtn addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_switchButton];
    
    UILabel *callLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(55 - 20) /2.0 + 84, 100 + 200, 20)];
    callLabel.text = KK_Text(@"Sedentary Alert");
    callLabel.textColor = [UIColor whiteColor];
    callLabel.font = DEFAULT_FONTHelvetica(14);
    [self.view addSubview:callLabel];
    
    LabelInfo = [[UILabel alloc] initWithFrame:CGRectMake(25,80 - _fitSizeHeight / 2 + 84, 120, 20)];
    LabelInfo.text = KK_Text(@"Remind Time");
    LabelInfo.textColor = [UIColor whiteColor];
    LabelInfo.font = DEFAULT_FONTHelvetica(14);
    [self.view addSubview:LabelInfo];
    
    [self loadPickerView];
    
    /*
    _button01 = [[UIButton alloc] initWithFrame:CGRectMake(20 +(self.view.width -100)/3 *0, 120 - _fitSizeHeight + 84, (self.view.width -40)/3, 44)];
    _button01.bgImageNormal = @"btn_select_5@2x.png";
    _button01.bgImageSelecte = @"btn_normal_5@2x.png";
    [_button01 setTitle:@"30" forState:UIControlStateNormal];
    [_button01 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button01 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button01.tag = 1;
    [self.view addSubview:_button01];
    
    _button02 = [[UIButton alloc] initWithFrame:CGRectMake(20 +(self.view.width -40)/3 *1, 120 - _fitSizeHeight + 84, (self.view.width -40)/3, 44)];
    _button02.bgImageNormal = @"btn_select_5@2x.png";
    _button02.bgImageSelecte = @"btn_normal_5@2x.png";
    [_button02 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button02 setTitle:@"60" forState:UIControlStateNormal];
    [_button02 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button02.tag = 2;
    [self.view addSubview:_button02];
    
    _button03 = [[UIButton alloc] initWithFrame:CGRectMake(20 +(self.view.width -40)/3 *2, 120 - _fitSizeHeight + 84, (self.view.width -40)/3, 44)];
    _button03.bgImageNormal = @"btn_select_5@2x.png";
    _button03.bgImageSelecte = @"btn_normal_5@2x.png";
    [_button03 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button03 setTitle:@"90" forState:UIControlStateNormal];
    [_button03 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button03.tag = 3;
    [self.view addSubview:_button03];
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, self.view.width - 30, 120 - _fitSizeHeight + 45, 0.5)];
//    line.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:line];
    
    _settingTime = _remindModel.interval;
    
    if (_settingTime == 30)
    {
        _button01.selected = YES;
    }
    else if(_settingTime == 60)
    {
        _button02.selected = YES;
    }
    else
    {
        _button03.selected = YES;
    } */
    
}

- (void)buttonClick:(UIButton *)sender
{
    _button01.selected = NO;
    _button02.selected = NO;
    _button03.selected = NO;
    
    if (sender.tag == 1)
    {
        _button01.selected = YES;
        _settingTime = 30;
    }
    else if(sender.tag == 2)
    {
        _button02.selected = YES;
        _settingTime = 60;
    }
    else if(sender.tag == 3)
    {
        _button03.selected = YES;
        _settingTime = 90;
    }
}

- (void)loadTableView
{
    _tableView = [[SedentaryReminderTableView alloc] initWithFrame:CGRectMake(0, 216 - _fitSizeHeight * 1.2 ,self.view.width, 130)];
    _tableView.SedentaryReminderSelectDelegate = self;
    [self.view addSubview:_tableView];
    _tableView.timeArray = _setTimeArray;
}

- (void)SedentaryReminderSelect:(NSInteger)indexRow
{
    _selectTimeIndex = indexRow;
    if (indexRow == 0)
    {
        [_pickUpSelectView pickUpViewSetBeginTime];
        [_pickUpSelectView showView];
    }
    else if(indexRow == 1)
    {
        [_pickUpSelectView pickUpViewSetEndTime];
        [_pickUpSelectView showView];
    }
}

- (void)loadPickUpSelectView
{
//    _setTimeArray = [[NSMutableArray alloc]init];
//    [_setTimeArray addObject:_remindModel.showStartTimeString];
//    [_setTimeArray addObject:_remindModel.showEndTimeString];
    _pickUpSelectView = [[SelectTimePickUpView alloc] initWithFrame:self.view.frame];
    
    DEF_WEAKSELF_(SedentaryReminderViewController)
    _pickUpSelectView.customPickClickBlock  = ^(NSString *hour ,NSString *min)
    {
        NSString * time = [NSString stringWithFormat:@"%@:%@",hour,min];
        
        if (weakSelf.selectTimeIndex ==0)
        {
            weakSelf.remindModel.startHour = hour.integerValue;
            weakSelf.remindModel.startMin = min.integerValue;
        }
        else
        {
            weakSelf.remindModel.endHour = hour.integerValue;
            weakSelf.remindModel.endMin = min.integerValue;
        }
        [weakSelf updatTime:time];
    };

    _pickUpSelectView.CustomsPickViewShowBlock = ^(BOOL show)
    {
        if (show)
        {
            weakSelf.pickUpSelectView.hidden = !show;
        }
        else
        {
             weakSelf.pickUpSelectView.hidden = !show;
        }
    };
    
    [self.view addSubview:_pickUpSelectView];
    _pickUpSelectView.hidden = YES;
}

- (void)updatTime:(NSString *)time
{
    [_setTimeArray replaceObjectAtIndex:_selectTimeIndex withObject:time];
    NSLog(@"_setTimeArray>>>>%@",_setTimeArray);
    
    _tableView.timeArray = _setTimeArray;
    
}

- (void)loadWeekView
{
    DEF_WEAKSELF_(SedentaryReminderViewController)
    _weekView = [[WeekView alloc]initWithFrame:CGRectMake(0,346 - _fitSizeHeight *1.5, self.view.width, 120) withWeekBlock:^(WeekView *weekView) {
        weakSelf.remindModel.weekArray = weekView.selArray;
        
    }];
    NSArray *array = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    
    [_weekView updateSelButtonForWeekView:_remindModel.weekArray];
    if (_remindModel.weekArray.count == 0) {
       [_weekView updateSelButtonForWeekView:array];
    }
    
    [self.view addSubview:_weekView];

}

- (void)switchButtonClick:(UIButton *)sender
{
    if (sender.selected)
    {
        sender.selected = NO;
        _isOpen = NO;
//        _remindModel.isOpen = NO;
        [self offViewShow];
    }
    else
    {
        sender.selected = YES;
        _isOpen = YES;
        [self onViewShow];
//        _remindModel.isOpen = YES;
    }
    _switchButton.on = sender.selected;
    [_switchButton setBtnState:sender.selected];
}

- (void)SliderChangeValue:(KUlSlide *)Slide
{
    float value = Slide.value * 165 + 15;
    _timeLabel.text = [NSString stringWithFormat:@"%d",(int)value];
//    _remindModel.interval = (NSInteger)value;
}

- (void)SliderClickChangeValue:(KUlSlide *)Slide
{
    float value = Slide.value *  165 + 15;
    _timeLabel.text = [NSString stringWithFormat:@"%d",(int)value];
//    _remindModel.interval = (NSInteger)value;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)onViewShow {
    _timeLabel.text = [NSString stringWithFormat:@"%ld",_remindModel.interval];
    if (_remindModel.interval == 0) {
        _timeLabel.text = @"15";
    }
    LabelInfo.text = KK_Text(@"Remind Time");
    LabelInfo2.text = KK_Text(@"mins without movement");
    _slider.frame = CGRectMake(10, 150 - _fitSizeHeight, self.view.width - 20, 30);
    _minValueLabel.text = @"15";
    _maxValueLabel.text = @"180";
    _tableView.frame = CGRectMake(0, 216 - _fitSizeHeight * 1.2 ,self.view.width, 130);
    _weekView.frame = CGRectMake(0,346 - _fitSizeHeight *1.5, self.view.width, 120);
}

- (void)offViewShow {
    _timeLabel.text = @"";
    LabelInfo.text = @"";
    LabelInfo2.text = @"";
    _slider.frame = CGRectMake(-100,-100,0,0);
    _slider.value = (_remindModel.interval - 15) * 1.0 / 165 ;
    _minValueLabel.text = @"";
    _maxValueLabel.text = @"";
    _tableView.frame = CGRectMake(-1000,-1000,0,0);
    _weekView.frame = CGRectMake(-1000, -1000, 0, 0);
    
}

@end
