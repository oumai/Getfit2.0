//
//  SexViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "SexViewController.h"
#import "Information.h"
#import "HeightViewController.h"
@interface SexViewController ()

@end

@implementation SexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadButton];
    // Do any additional setup after loading the view.
}

- (void)loadButton
{
    _maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _maleButton.frame = FitScreenRect(CGRectMake((self.view.width/2 - 89)/2, 180 - 89.0/2 - 60, 89, 89), CGRectMake((self.view.width/2 - 89)/2, 180 - 89.0/2, 89, 89), CGRectMake((self.view.width/2 - 89)/2, 180 - 89.0/2, 89, 89), CGRectMake((self.view.width/2 - 89)/2, 180 - 89.0/2, 89, 89), CGRectMake((self.view.width/2 - 89)/2, 180 - 89.0/2, 89, 89));
    
    _maleButton.tag = 1;
    [_maleButton setBackgroundImage:[UIImage imageNamed:@"login_boy_2_5s"] forState:UIControlStateNormal];
    [_maleButton setBackgroundImage:[UIImage imageNamed:@"login_boy_1_5s"] forState:UIControlStateSelected];
    [_maleButton addTarget:self action:@selector(sexSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_maleButton];
    _maleButton.selected = YES;
    [Information sharedInstance].sex = YES;
    
    _femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _femaleButton.tag = 2;

    _femaleButton.frame = FitScreenRect(CGRectMake((self.view.width/2 - 89)/2 + self.view.width/2, 180 - 89.0/2 - 60, 89, 89), CGRectMake((self.view.width/2 - 89)/2 + self.view.width/2, 180 - 89.0/2, 89, 89), CGRectMake((self.view.width/2 - 89)/2 + self.view.width/2, 180 - 89.0/2, 89, 89), CGRectMake((self.view.width/2 - 89)/2 + self.view.width/2, 180 - 89.0/2, 89, 89), CGRectMake((self.view.width/2 - 89)/2 + self.view.width/2, 180 - 89.0/2, 89, 89));
    [_femaleButton setBackgroundImage:[UIImage imageNamed:@"login_girl_2_5s"] forState:UIControlStateNormal];
    [_femaleButton setBackgroundImage:[UIImage imageNamed:@"login_girl_1_5s"] forState:UIControlStateSelected];
    [_femaleButton addTarget:self action:@selector(sexSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_femaleButton];
    
    UILabel * maleLabel = [[UILabel alloc] initWithFrame:FitScreenRect(CGRectMake((self.view.width/2 - 60)/2 ,240 - 60,60,30), CGRectMake((self.view.width/2 - 60)/2 ,240,60,30), CGRectMake((Maxwidth/2 - 60)/2 ,240,60,30), CGRectMake((Maxwidth/2 - 60)/2 ,240,60,30), CGRectMake((Maxwidth - 60)/2 ,240,60,30))];
    maleLabel.text = KK_Text(@"Boy");
    maleLabel.textAlignment = NSTextAlignmentCenter;
    maleLabel.textColor = UIColorHEX(0xa5d448);
    maleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:maleLabel];
    

    UILabel * FemaleLabel = [[UILabel alloc] initWithFrame:FitScreenRect(CGRectMake((self.view.width/2 - 60)/2 + self.view.width/2 ,240 - 60,60,30), CGRectMake((self.view.width/2 - 60)/2 + self.view.width/2 ,240,60,30), CGRectMake((self.view.width/2 - 60)/2 + self.view.width/2,240,60,30), CGRectMake((self.view.width/2 - 60)/2 + self.view.width/2,240,60,30), CGRectMake((Maxwidth - 60)/2 + Maxwidth/2 ,240,60,30))];
    FemaleLabel.text = KK_Text(@"Girl");
    FemaleLabel.textAlignment = NSTextAlignmentCenter;
    FemaleLabel.textColor = UIColorHEX(0xa5d448);
    FemaleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:FemaleLabel];
    
}

- (void)sexSelectButtonClick:(UIButton *)Sender
{
    if (Sender.tag ==1)
    {
        _femaleButton.selected = NO;
        _maleButton.selected = YES;
        
        [Information sharedInstance].sex = YES;
        [UserInfoHelper sharedInstance].userModel.genderSex = 0;
    }
    else if(Sender.tag ==2)
    {
        _femaleButton.selected = YES;
        _maleButton.selected = NO;
        
        [Information sharedInstance].sex = NO;
        [UserInfoHelper sharedInstance].userModel.genderSex = 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextButtonClick:(UIButton *)Sender
{
    [Information sharedInstance].infoProgressIndex = 2;
    HeightViewController * heightVc = [[HeightViewController alloc]init];
    [self.navigationController pushViewController:heightVc animated:NO];
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
