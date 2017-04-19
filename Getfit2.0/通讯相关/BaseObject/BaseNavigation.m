//
//  BaseNavigation.m
//  Elevator
//
//  Created by 张浩 on 15/6/17.
//  Copyright (c) 2015年 zhanghao. All rights reserved.
//

#import "BaseNavigation.h"
#import "SVProgressHUD.h"
@interface BaseNavigation ()

@end

@implementation BaseNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
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
-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [SVProgressHUD dismiss];
    return  [super popViewControllerAnimated:animated];
}
@end
