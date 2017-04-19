//
//  TargetViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TargetViewController.h"
#import "AppDelegate.h"
#import "Information.h"
@interface TargetViewController ()

@end

@implementation TargetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadScrollView];
    
    [self loadButton];
    
    self.view.backgroundColor = UIColorHEX(0x272727);
}

- (void)loadButton
{
    UIImageView *topBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(0,60, 80, 480)];
    topBackGround.image = [UIImage imageNamed:@"mask_metric_weight_left_5s"];
    [self.view addSubview:topBackGround];
    [self.view bringSubviewToFront:topBackGround];
    
    UIImageView *ButtomBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width-80,60, 80, 480)];
    ButtomBackGround.image = [UIImage imageNamed:@"mask_metric_weight_right_5s"];
    [self.view addSubview:ButtomBackGround];
    [self.view bringSubviewToFront:ButtomBackGround];

    self.title = KK_Text(@"Daily Target");
    CGFloat width = 88;
    self.NextButton.frame =FitScreenRect(CGRectMake(self.view.width - width  - 28, 450 - 45/2 - 70 , width, 45),
                                         CGRectMake(self.view.width - width  - 28, 450 - 45/2 , width, 45),
                                         CGRectMake(self.view.width - width  - 28, 450 - 45/2 , width, 45),
                                         CGRectMake(self.view.width - width  - 28, 450 - 45/2 , width, 45),
                                         CGRectMake(self.view.width - width  - 28, self.view.height-102 , width, 45));

    [self.NextButton setTitle:KK_Text(@"Done")forState:UIControlStateNormal];
    [self.NextButton setBackgroundImage:[UIImage imageNamed:@"login_btn_3_5s"] forState:UIControlStateNormal];
    
    UIButton *previousBtutton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousBtutton.frame = FitScreenRect(CGRectMake(28, 450 - 45/2 - 70, width, 45),
                                          CGRectMake(28, 450 - 45/2, width, 45),
                                          CGRectMake(28, 450 - 45/2, width, 45),
                                          CGRectMake(28, 450 - 45/2, width, 45),
                                          CGRectMake(28, self.view.height-102, width, 45));

    [previousBtutton setTitle:KK_Text(@"Last") forState:UIControlStateNormal];
    [previousBtutton setBackgroundImage:[UIImage imageNamed:@"login_btn_3_5s"] forState:UIControlStateNormal];
    [previousBtutton addTarget:self action:@selector(previousBtuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:previousBtutton];
    [self.view bringSubviewToFront:self.NextButton];
    [self.view bringSubviewToFront:previousBtutton];
}

- (void)loadScrollView
{
    CGFloat screenHeight = FitScreenNumber(33, 0, 0, 0, 0);
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    stepLabel.textColor =UIColorHEX(0xa5d448);
    stepLabel.textAlignment = NSTextAlignmentCenter;
    
    stepLabel.center = CGPointMake(self.view.center.x, 45 - screenHeight);
    stepLabel.text = KK_Text(@"Sports Target");
    stepLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:stepLabel];
    
    UILabel *stepUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    stepUnitLabel.textColor =UIColorHEX(0xa5d448);
    stepUnitLabel.textAlignment = NSTextAlignmentCenter;
    stepUnitLabel.center = CGPointMake(self.view.center.x, 100 - screenHeight);
    stepUnitLabel.text = KK_Text(@"Step");
    [self.view addSubview:stepUnitLabel];
    
    _stepTargetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _stepTargetLabel.textColor =UIColorHEX(0xa5d448);
    _stepTargetLabel.textAlignment = NSTextAlignmentCenter;
    _stepTargetLabel.center = CGPointMake(self.view.center.x, 75 - screenHeight);
    _stepTargetLabel.font = [UIFont systemFontOfSize:27.0];
    [self.view addSubview:_stepTargetLabel];

    
    CGFloat screenSleepHeight = FitScreenNumber(60, 0, 0, 0, 0);
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 230 - screenHeight, self.view.width, 1)];
    line.backgroundColor = UIColorHEX(0x888b90);
    [self.view addSubview:line];
    
    UILabel *sleepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    sleepLabel.textColor =UIColorHEX(0xa5d448);
    sleepLabel.textAlignment = NSTextAlignmentCenter;
    sleepLabel.center = CGPointMake(self.view.center.x, 260 - screenSleepHeight + 5);
    sleepLabel.text = KK_Text(@"Sleep Target");
    sleepLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:sleepLabel];
    
    UILabel *sleepUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    sleepUnitLabel.textColor =UIColorHEX(0xa5d448);
    sleepUnitLabel.textAlignment = NSTextAlignmentCenter;
    sleepUnitLabel.center = CGPointMake(self.view.center.x, 295 - screenSleepHeight);
    sleepUnitLabel.text = [NSString stringWithFormat:@"      %@          %@", KK_Text(@"H"), KK_Text(@"Min")];
    sleepUnitLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:sleepUnitLabel];
    
    _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _hourLabel.textColor =UIColorHEX(0xa5d448);
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    _hourLabel.center = CGPointMake(Maxwidth/2 - 50, 290 - screenSleepHeight);
    _hourLabel.font = [UIFont systemFontOfSize:27.0];
    [self.view addSubview:_hourLabel];
    _hourLabel.text = @"8";
    
    _minLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _minLabel.textColor =UIColorHEX(0xa5d448);
    _minLabel.textAlignment = NSTextAlignmentCenter;
    _minLabel.center = CGPointMake(Maxwidth/2 + 15, 290 - screenSleepHeight);
    _minLabel.font = [UIFont systemFontOfSize:27.0];
    [self.view addSubview:_minLabel];
    _minLabel.text = @"00";
    
    UIImageView * stepTarget = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/2-5, 113 - screenHeight, 10, 95)];
    stepTarget.image = [UIImage imageNamed:@"login_arrow_1_5s"];
    [self.view addSubview:stepTarget];
    
    _stepScrollView = [[UIScrollView alloc] init];
    _stepScrollView.frame = CGRectMake(0, 112 - screenHeight, Maxwidth ,96);
    _stepScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_stepScrollView];
    _stepScrollView.contentSize = CGSizeMake(3320, 96);
    _stepScrollView.showsHorizontalScrollIndicator = NO;
    _stepScrollView.showsVerticalScrollIndicator = NO;
    _stepScrollView.delegate = self;
    _stepScrollView.tag = 1;
    
    CGFloat stepX = 1.0 *([UserInfoHelper sharedInstance].userModel.targetSteps -1000) /10 ;
    
    [_stepScrollView setContentOffset:CGPointMake(stepX , 0)];
    
    UIImageView *StepMetric = [[UIImageView alloc] initWithFrame:FitScreenRect(CGRectMake(-87, 0, 3400, 96), CGRectMake(-87, 0, 3400, 96),CGRectMake(-59, 0, 3400, 96),CGRectMake(-40, 0, 3400, 96),CGRectMake(-15, 0, 3400, 96))];
    StepMetric.image = [UIImage imageNamed:@"mark_metric_sport_5s"];
    [_stepScrollView addSubview:StepMetric];
    
    UIImageView * sleepTarget = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/2-5, 305 - screenSleepHeight, 10, 95)];
    sleepTarget.image = [UIImage imageNamed:@"login_arrow_1_5s"];
    [self.view addSubview:sleepTarget];
    
    _sleepScrollView = [[UIScrollView alloc] init];
    _sleepScrollView.frame = CGRectMake(0, 304 - screenSleepHeight, self.view.width ,96);
    _sleepScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_sleepScrollView];
    _sleepScrollView.contentSize = CGSizeMake(1020, 96);
    _sleepScrollView.showsHorizontalScrollIndicator = NO;
    _sleepScrollView.showsVerticalScrollIndicator = NO;
    _sleepScrollView.delegate = self;
    _sleepScrollView.tag = 2;
    
    CGFloat sleepX = [UserInfoHelper sharedInstance].userModel.targetSleep;
    [_sleepScrollView setContentOffset:CGPointMake(sleepX  , 0)];
    
    UIImageView *SleepMetric = [[UIImageView alloc] initWithFrame:FitScreenRect(CGRectMake(-3, 0, 930, 96), CGRectMake(-3, 0, 930, 96),CGRectMake(24, 0, 930, 96),CGRectMake(44, 0, 930, 96),CGRectMake(-15, 0, 3400, 96))];
    SleepMetric.image = [UIImage imageNamed:@"mark_metric_sleep_5s"];
    [_sleepScrollView addSubview:SleepMetric];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1)
    {
        NSLog(@"step >>>%f",scrollView.contentOffset.x);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stepDelayOffSet) object:nil];
        [self performSelector:@selector(stepDelayOffSet) withObject:nil afterDelay:0.20];
    }
    else if(scrollView.tag == 2)
    {
        NSLog(@"sleep >>>%f",scrollView.contentOffset.x);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sleepDelayOffSet) object:nil];
        [self performSelector:@selector(sleepDelayOffSet) withObject:nil afterDelay:0.20];
    }
}

- (void)stepDelayOffSet
{
    int index = _stepScrollView.contentOffset.x / 10;
    CGFloat more = ((int)(_stepScrollView.contentOffset.x)) % 10;
    
    if (_stepScrollView.contentOffset.x>=0 && _stepScrollView.contentOffset.x <= 2900)
    {
        if (more > 5)
        {
            [_stepScrollView setContentOffset:CGPointMake((index+1) * 10, 0) animated:YES];
        }
        else
        {
            [_stepScrollView setContentOffset:CGPointMake(index * 10, 0) animated:YES];
        }
    }
    else if(_stepScrollView.contentOffset.x>2900)
    {
        [_stepScrollView setContentOffset:CGPointMake(2900, 0) animated:YES];
    }
    // 计算目标
    NSInteger step =1000 +(NSInteger)(_stepScrollView.contentOffset.x/10)*100;
    [UserInfoHelper sharedInstance].userModel.targetSteps = step;
    _stepTargetLabel.text = [NSString stringWithFormat:@"%ld",(long)step];
}

- (void)sleepDelayOffSet
{
    int index = _sleepScrollView.contentOffset.x / 10;
    CGFloat more = ((int)(_sleepScrollView.contentOffset.x)) % 10;
    
    if (_sleepScrollView.contentOffset.x>=0 && _sleepScrollView.contentOffset.x<=600)
    {
        if (more > 5)
        {
            [_sleepScrollView setContentOffset:CGPointMake((index+1) *10, 0) animated:YES];
        }
        else
        {
            [_sleepScrollView setContentOffset:CGPointMake(index*10, 0) animated:YES];
        }
    }
    else if(_sleepScrollView.contentOffset.x>600)
    {
            [_sleepScrollView setContentOffset:CGPointMake(600, 0) animated:YES];
    }
             int sleep = _sleepScrollView.contentOffset.x / 10 *10 ;
            [UserInfoHelper sharedInstance].userModel.targetSleep = sleep;
            _hourLabel.text = [NSString stringWithFormat:@"%d",(sleep  + 120)/60];
            _minLabel.text = [NSString stringWithFormat:@"%d",(sleep  + 120)%60];
}

- (void)nextButtonClick:(UIButton *)Sender
{
    [UserInfoHelper sharedInstance].userModel.nickName = @"user";
    
    [SAVEENTERUSERKEY setBOOLValue:YES];
    [[UserInfoHelper sharedInstance] updateUserInfoAndTarget];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app pushContenVc];

}

- (void)previousBtuttonClick:(UIButton *)Sender
{
    [self.navigationController popViewControllerAnimated:NO];
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

@end
