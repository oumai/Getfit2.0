//
//  NavEnterViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "NavEnterViewController.h"

@interface NavEnterViewController ()

@end

@implementation NavEnterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadNaView];
    
    // Do any additional setup after loading the view.
}

- (void)loadNaView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor =BGCOLOR;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
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

- (void)back:(UIButton *)sender {
}

@end
