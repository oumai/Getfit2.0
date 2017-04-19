//
//  CallReminderViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "CallReminderViewController.h"

@interface CallReminderViewController ()

@property (nonatomic, strong) BLTModel *model;
@property (nonatomic, assign) BOOL isDialingRemind;

@end

@implementation CallReminderViewController
{
    UILabel *LabelInfo;
    UILabel *LabelInfo2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorHEX(0x272727);

    _model = [UserInfoHelper sharedInstance].bltModel;
    [self loadViewSetup];
    [self loadButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isDialingRemind= _model.isDialingRemind;
}

- (void)loadViewSetup
{
    self.tipTitle.text = KK_Text(@"Call Alert");
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 55, self.view.width, 0.5)];
    line.backgroundColor = UIColorHEX(0x888b90);
    // [self.view addSubview:line];
}

- (void)leftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置来电提醒
- (void)rightBarButton
{
    _model.delayDialing = [_timeLabel.text intValue];
    _model.isDialingRemind = _isDialingRemind;
    SHOWMBProgressHUD(KK_Text(@"Setting success"), nil, nil, NO, 2.0);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(leftBarButton) object:nil];
    [self performSelector:@selector(leftBarButton) withObject:nil afterDelay:2.0];
}

- (void)loadButton
{
    _switchButton = [[CustomSwitch alloc] initWithFrame:CGRectMake(self.view.width - 70, 15 + 84, 60, 25)];
    _switchButton.offImageName = @"Device_btn_2_5s@2x.png";
    _switchButton.onImageName = @"Device_btn_1_5s@2x.png";
    _switchButton.btnImageName = @"Device_Stripe_1_5s@2x";
    _switchButton.switchBtn.selected = _model.isDialingRemind;
    [_switchButton setBtnState:_switchButton.switchBtn.selected];
    [_switchButton.switchBtn addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_switchButton];
    
    UILabel *callLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(55 - 20) /2.0 + 84, 200, 20)];
    callLabel.text = KK_Text(@"Call Alert");
    callLabel.textColor = [UIColor whiteColor];
    callLabel.font = DEFAULT_FONTHelvetica(14);
    [self.view addSubview:callLabel];
    
    LabelInfo = [[UILabel alloc] initWithFrame:CGRectMake(0,90 + 84, 115, 20)];
    LabelInfo.text = KK_Text(@"After a call come in");
    LabelInfo.textAlignment = NSTextAlignmentRight;
    LabelInfo.textColor = [UIColor whiteColor];
    LabelInfo.font = DEFAULT_FONTHelvetica(12);
    [self.view addSubview:LabelInfo];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(115 ,88 + 84, 30, 20)];
    
    _timeLabel.text = [NSString stringWithFormat:@"%ld",_model.delayDialing];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = UIColorHEX(0xef5543);
    _timeLabel.font = DEFAULT_FONTHelvetica(22);
    [self.view addSubview:_timeLabel];
    
    LabelInfo2 = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabel.totalWidth + 2 ,90 + 84, 150 + 50, 20)];
    LabelInfo2.text = KK_Text(@"s Band vibrates to remind");
    LabelInfo2.textColor = [UIColor whiteColor];
    LabelInfo2.font = DEFAULT_FONTHelvetica(12);
    [self.view addSubview:LabelInfo2];
    
    _slider=[[KUlSlide alloc] initWithFrame:CGRectMake(10, 150 + 84, self.view.width - 20, 30)];
    _slider.delegate =self;
    _slider.value = (_model.delayDialing - 3) * 1.0 / 27 ;
    [self.view addSubview:_slider];
    
    _minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _slider.origin.y + 30, 40, 20)];
    _minValueLabel.font = DEFAULT_FONTHelvetica(12);
    _minValueLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_minValueLabel];
    
    _minValueLabel.text = @"3";
    
    _maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 20, _slider.origin.y + 30, 40, 20)];
    _maxValueLabel.font = DEFAULT_FONTHelvetica(12);
    _maxValueLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_maxValueLabel];
    
    _maxValueLabel.text = @"30";
    
    if (_model.isDialingRemind) {
        [self onViewShow];
    }else{
        [self offViewShow];
    }
}

- (void)switchButtonClick:(UIButton *)sender
{
    if (sender.selected)
    {
        sender.selected = NO;
//        _model.isDialingRemind = NO;
        _isDialingRemind = NO;
        [self offViewShow];
    }
    else
    {
        sender.selected = YES;
//        _model.isDialingRemind = YES;
        _isDialingRemind = YES;
        [self onViewShow];
   
    }
    _switchButton.on = sender.selected;
    [_switchButton setBtnState:sender.selected];
}

- (void)SliderChangeValue:(KUlSlide *)Slide
{
    float value = Slide.value * 27 + 3;
    float realValue = value;
    if (Slide.value < 0.5) {
        realValue = ceil(value);
    }else {
        realValue = floor(value);
    }
    
    // NSLog(@"%f", realValue);
    _timeLabel.text = [NSString stringWithFormat:@"%.0f",realValue]; //数据不实时保存
    
}

- (void)SliderClickChangeValue:(KUlSlide *)Slide
{
    float value = Slide.value * 27 + 3;
    _model.delayDialing = ceil(value);
    _timeLabel.text = [NSString stringWithFormat:@"%ld",_model.delayDialing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _timeLabel.text = [NSString stringWithFormat:@"%ld",_model.delayDialing];
    if (_model.delayDialing == 0) {
        _timeLabel.text = @"3";
    }
    LabelInfo.text = KK_Text(@"After a call come in");
    LabelInfo2.text = KK_Text(@"s Band vibrates to remind");
    _slider.frame = CGRectMake(10, 150 + 84, self.view.width - 20, 30);
    _minValueLabel.text = @"3";
    _maxValueLabel.text = @"30";
}

- (void)offViewShow {
    _timeLabel.text = @"";
    LabelInfo.text = @"";
    LabelInfo2.text = @"";
    _slider.frame = CGRectMake(-100, -100, 0, 0);
    _slider.value = (_model.delayDialing - 3) * 1.0 / 27 ;
    _minValueLabel.text = @"";
    _maxValueLabel.text = @"";
}

@end
