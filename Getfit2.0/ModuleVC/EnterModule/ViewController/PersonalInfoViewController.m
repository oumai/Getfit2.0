//
//  PersonalInfoViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "Information.h"
@interface PersonalInfoViewController ()

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSetup];

}

- (void)loadSetup
{
    self.title = KK_Text(@"Personal Profile");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButton)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage image:@"Device_back_5s@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButton)];
    // Do any additional setup after loading the view.
    
    _NextButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _NextButton.frame =FitScreenRect(CGRectMake(20, 430 - 110, self.view.width - 40, 40), CGRectMake(20, 430, self.view.width-40, 40), CGRectMake(20, 430, self.view.width-40, 40), CGRectMake(20, 430, self.view.width-40, 40), CGRectMake(20, self.view.height-138, self.view.width-40, 40));
    [_NextButton setBackgroundImage:[UIImage imageNamed:@"RefreshButtonSelect_5s"] forState:UIControlStateNormal];
    [_NextButton setTitle:KK_Text(@"Next") forState:UIControlStateNormal];
    [_NextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_NextButton];
    
    UIImageView *progressDotView = [[UIImageView alloc]initWithFrame:FitScreenRect(CGRectMake((self.view.width - 64)/2, 485 - 8/2 - 90 , 64, 8), CGRectMake((self.view.width - 64)/2, 485 - 8/2 , 64, 8), CGRectMake((self.view.width - 64)/2, 485 - 8/2 , 64, 8), CGRectMake((self.view.width - 64)/2, 485 - 8/2 , 64, 8), CGRectMake((self.view.width - 64)/2, 485 - 8/2 , 64, 8))];
    progressDotView.image = [UIImage imageNamed:@"RefreshButtonNormal_5s"];
    progressDotView.image = [UIImage imageNamed:[NSString stringWithFormat:@"login_%ld_5s",(long)[Information sharedInstance].infoProgressIndex]];
    [self.view addSubview:progressDotView];
}

- (void)leftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonClick:(UIButton *)Sender
{
   
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
