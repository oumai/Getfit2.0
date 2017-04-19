//
//  WeightViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "WeightViewController.h"
#import "Information.h"
#import "BirthYearViewController.h"
@interface WeightViewController ()

@end

@implementation WeightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadScrolloView];
    
    [self loadButton];
    
    self.view.backgroundColor = UIColorHEX(0x272727);

}

- (void)loadButton
{
    UIImageView *TopBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(0,60, 80, 480)];
    TopBackGround.image = [UIImage imageNamed:@"mask_metric_weight_left_5s"];
    [self.view addSubview:TopBackGround];
    [self.view bringSubviewToFront:TopBackGround];
    
    UIImageView *ButtomBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width-80,60, 80, 480)];
    ButtomBackGround.image = [UIImage imageNamed:@"mask_metric_weight_right_5s"];
    [self.view addSubview:ButtomBackGround];
    [self.view bringSubviewToFront:ButtomBackGround];
    
    CGFloat width = 88;
    self.NextButton.frame = FitScreenRect(CGRectMake(self.view.width - width  - 28, 450 - 45/2 - 90 , width, 45),
                                          CGRectMake(self.view.width - width  - 28, 450 - 45/2 , width, 45),
                                          CGRectMake(self.view.width - width  - 28, 450 - 45/2 , width, 45),
                                          CGRectMake(self.view.width - width  - 28, 450 - 45/2 , width, 45),
                                          CGRectMake(self.view.width - width  - 28, self.view.height-132 , width, 45));
    [self.NextButton setBackgroundImage:[UIImage imageNamed:@"login_btn_3_5s"] forState:UIControlStateNormal];
    
    UIButton *previousBtutton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousBtutton.frame = FitScreenRect(CGRectMake(28, 450 - 45/2 - 90, width, 45),
                                          CGRectMake(28, 450 - 45/2, width, 45),
                                          CGRectMake(28, 450 - 45/2, width, 45),
                                          CGRectMake(28, 450 - 45/2, width, 45),
                                          CGRectMake(28, self.view.height-132, width, 45));
    [previousBtutton setTitle:KK_Text(@"Last") forState:UIControlStateNormal];
    [previousBtutton setBackgroundImage:[UIImage imageNamed:@"login_btn_3_5s"] forState:UIControlStateNormal];
    [previousBtutton addTarget:self action:@selector(previousBtuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousBtutton];
    
    [self.view bringSubviewToFront:self.NextButton];
    [self.view bringSubviewToFront:previousBtutton];
}

- (void)loadScrolloView
{
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    heightLabel.textColor =UIColorHEX(0xa5d448);
    heightLabel.textAlignment = NSTextAlignmentCenter;
    heightLabel.center = CGPointMake(self.view.center.x, 138);
    heightLabel.text = KK_Text(@"Weight");
    heightLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:heightLabel];
    
    UILabel *UnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    UnitLabel.textColor =UIColorHEX(0xa5d448);
    UnitLabel.textAlignment = NSTextAlignmentCenter;
    UnitLabel.center = CGPointMake(self.view.center.x, 195);
    UnitLabel.text = @"kg";
    [self.view addSubview:UnitLabel];
    
    _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _weightLabel.textColor =UIColorHEX(0xa5d448);
    _weightLabel.textAlignment = NSTextAlignmentCenter;
    _weightLabel.center = CGPointMake(self.view.center.x, 170);
    _weightLabel.font = [UIFont systemFontOfSize:27.0];
    [self.view addSubview:_weightLabel];
    
    UIImageView * Target = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/2-5, 214, 10, 96)];
    Target.image = [UIImage imageNamed:@"login_arrow_1_5s"];
    [self.view addSubview:Target];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 214, self.view.width ,96);
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(3800+320, 96);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    UIImageView *MetricHeight = [[UIImageView alloc] initWithFrame:FitScreenRect(CGRectMake(108, 0, 3800, 96), CGRectMake(108, 0, 3800, 96), CGRectMake(135, 0, 3800, 96), CGRectMake(155, 0, 3800, 96), CGRectMake(86, 0, 3800, 96))];
    MetricHeight.image = [UIImage imageNamed:@"mark_metric_weight_5s"];
    if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
        MetricHeight.image = [UIImage imageNamed:@"mark_metric_weight_5s_en"];
    }

    [_scrollView addSubview:MetricHeight];
    
    _weightLabel.text = [[UserInfoHelper sharedInstance].userModel showWeight];
    CGFloat weight = 10.0 * [UserInfoHelper sharedInstance].userModel.showWeight.integerValue - 300;
    _scrollView.contentOffset = CGPointMake(weight, 0);
    
    if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
        UnitLabel.text = @"磅";
        weight = 2.205 * 10.0 * [UserInfoHelper sharedInstance].userModel.showWeight.integerValue - 300;
        _scrollView.contentOffset = CGPointMake(ceil(weight), 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"x>>>%f",_scrollView.contentOffset.x);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayOffSet) object:nil];
    [self performSelector:@selector(delayOffSet) withObject:nil afterDelay:0.20];
}

- (void)delayOffSet
{
    int index = _scrollView.contentOffset.x/10;
    CGFloat more = ((int)(_scrollView.contentOffset.x))%10;
    
    if (_scrollView.contentOffset.x>=0 && _scrollView.contentOffset.x<=3700)
    {
        if (more >5)
        {
            [_scrollView setContentOffset:CGPointMake((index+1) *10, 0) animated:YES];
        }
        else
        {
            [_scrollView setContentOffset:CGPointMake(index*10, 0) animated:YES];
        }
    }
    else if(_scrollView.contentOffset.x>3700)
    {
         [_scrollView setContentOffset:CGPointMake(3700, 0) animated:YES];
    }
    
    NSInteger Weight =30 +(NSInteger)(_scrollView.contentOffset.x/10);
    [UserInfoHelper sharedInstance].userModel.weight = Weight;
    if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
        Weight =60 +(NSInteger)(_scrollView.contentOffset.x*2/10);
        [UserInfoHelper sharedInstance].userModel.weight = (int)Weight/2.205;
    }
//    [Information sharedInstance].selectWeight =Weight;
    _weightLabel.text = [NSString stringWithFormat:@"%ld",(long)Weight];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextButtonClick:(UIButton *)Sender
{
    [Information sharedInstance].infoProgressIndex = 4;
    BirthYearViewController * BirthYeartVc = [[BirthYearViewController alloc]init];
    [self.navigationController pushViewController:BirthYeartVc animated:NO];
}

- (void)previousBtuttonClick:(UIButton *)Sender
{
    [self.navigationController popViewControllerAnimated:NO];
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
