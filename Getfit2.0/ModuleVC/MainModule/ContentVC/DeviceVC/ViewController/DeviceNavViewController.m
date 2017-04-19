//
//  DeviceNavViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceNavViewController.h"

@interface DeviceNavViewController ()

@end

@implementation DeviceNavViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSuperBgView];
}

- (void)loadSuperBgView
{
    _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _navBarView.backgroundColor = KK_MainColor;
    [self.view addSubview:_navBarView];
    
    _leftButton = [UIButton simpleWithRect:CGRectMake(6, 20, 60, 40)
                                 withTitle:KK_Text(@"Back")
                           withSelectTitle:KK_Text(@"Back")
                       withBackgroundColor:[UIColor clearColor]];
    [_leftButton addTouchUpTarget:self action:@selector(leftBarButton)];
    [_navBarView addSubview:_leftButton];
    
    _rightButton = [UIButton simpleWithRect:CGRectMake(self.view.width - 100, 20, 94, 40)
                                  withTitle:KK_Text(@"Confirm")
                            withSelectTitle:KK_Text(@"Confirm")
                        withBackgroundColor:[UIColor clearColor]];
    [_rightButton addTouchUpTarget:self action:@selector(rightBarButton)];
    _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_navBarView addSubview:_rightButton];
    
    _tipTitle = [UILabel simpleWithRect:CGRectMake(72, 20, self.view.width - 144, 40)
                          withAlignment:NSTextAlignmentCenter
                           withFontSize:16
                               withText:@""
                          withTextColor:[UIColor whiteColor]];
    [_navBarView addSubview:_tipTitle];
    
    /*
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = BGCOLOR;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIView * stateView = [[UIView alloc] initWithFrame:CGRectMake(0, - 20, self.view.width, 20)];
    stateView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:stateView]; */

//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.bgImageNormal = @"Device_back_5s@2x.png";
//    backButton.frame = CGRectMake(0, 0, 44, 44);
//    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:backButton];
    
}

- (void)leftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButton
{
    
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
