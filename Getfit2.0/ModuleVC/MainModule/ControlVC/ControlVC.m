//
//  ControlVC.m
//  AJBracelet
//
//  Created by zorro on 15/6/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ControlVC.h"
#import "HomePageVC.h"
#import "DetailVC.h"
#import "DeviceVC.h"
#import "UserVC.h"
#import "UseDataShowViewController.h"
#import "TabBarButton.h"

#import "AppDelegate.h"
#import "BLTAcceptModel.h"
#import "KKASIHelper.h"

@interface ControlVC ()

@end

@implementation ControlVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [BLTAcceptModel sharedInstance].pushToHeartVC = ^(id object, BLTAcceptModelType type)
    {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app pushHeartVc];
    };
    
}


- (void)dealloc
{
    [BLTAcceptModel sharedInstance].pushToHeartVC = nil;
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

+ (id)simpleInit
{
    HomePageVC *vc1 = [[HomePageVC alloc] init];
    DetailVC *vc2 = [[DetailVC alloc] init];
    UseDataShowViewController *vc3 = [[UseDataShowViewController alloc] init];
    DeviceVC *vc4 = [[DeviceVC alloc] init];
    UserVC *vc5 = [[UserVC alloc] init];
    
    NSArray *vcArray = @[vc1, vc3, vc2, vc4, vc5];
    NSMutableArray *itemsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *imageArray = @[@"bottom_home_normal_5",
                            @"xinlv1_home_selected_5@2x.png",
                            @"bottom_analyse_normal_5",
                            @"bottom_device_normal_5",
                            @"bottom_me_normal_5"];
    NSArray *selImageArray = @[@"bottom_home_selected_5",
                               @"xinlv2_home_selected_5@2x.png",
                               @"bottom_analyse_selected_5",
                               @"bottom_device_selected_5",
                               @"bottom_me_selected_5"];
    NSArray *titleArray = @[KK_Text(@"Mainpage"),
                            KK_Text(@"Heart"),
                            KK_Text(@"Details"),
                            KK_Text(@"Device"),
                            KK_Text(@"User")];
    
    for (int i = 0; i < vcArray.count; i++)
    {
        TabBarButton *button = [[TabBarButton alloc] initWithFrame:CGRectMake(0, 0, vc1.view.width / 4, 44)];
        
         button.exclusiveTouch = YES;
        [button setNomarlImage:imageArray[i] withTitle:titleArray[i] withTextColor:[UIColor whiteColor]];
        [button setSelectorlImage:selImageArray[i] withTitle:titleArray[i] withTextColor:[UIColor whiteColor]];
         button.selected = NO;
        [itemsArray addObject:button];
    }
    
    ControlVC *tabBarController = [[ControlVC alloc] initWithViewControllers:vcArray items:itemsArray];
    
    return tabBarController;
}

@end
