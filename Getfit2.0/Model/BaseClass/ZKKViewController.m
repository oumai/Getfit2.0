//
//  ZKKViewController.m
//  VPhone
//
//  Created by zorro on 14-10-22.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "ZKKViewController.h"
#import "BLTAcceptModel.h"

@implementation ZKKViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadTabBarItem];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)updateContentWithObject:(id)object withType:(BLTAcceptModelType)type
{

}

- (void)loadTabBarItem
{

}

- (void)loadLeftItemButton
{
    UIButton *button = [UIButton simpleWithRect:CGRectMake(0, 0, 44, 44)
                                      withImage:@"nav_back.png"
                                withSelectImage:@"nav_back.png"];
    [button addTouchUpTarget:self action:@selector(backLastVC)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backLastVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadTitleView:(NSString *)text
{
    _titleLabel = [UILabel simpleWithRect:CGRectMake(0, 0, 120, 40)];
    _titleLabel.text = text;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationController.navigationBar.barTintColor = UIColorHEX(0x272530);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadLeftItemButton];
}

// 下面的是6.0以后的
#pragma mark 旋屏
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
#pragma mark -todo
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
