//
//  BaseViewController.m
//  Elevator
//
//  Created by 张浩 on 15/6/17.
//  Copyright (c) 2015年 zhanghao. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigation.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
-(void)handleNotice
{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    _naviView.backgroundColor = UIColorFromRGB(ZHBLUE);
    [self.view addSubview:_naviView];
//导航图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    // imageView.image = [UIImage imageNamed:@"naviImage.png"];
    imageView.backgroundColor = KK_MainColor;
    [_naviView addSubview:imageView];
    
//标题
    _naviTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, screenWidth, 44)];
    _naviTitle.font = [UIFont boldSystemFontOfSize:18.0];
    _naviTitle.textColor = [UIColor whiteColor];
    _naviTitle.textAlignment = NSTextAlignmentCenter;
    _naviTitle.backgroundColor = [UIColor clearColor];
    [_naviView addSubview:_naviTitle];
    if (self.title)
    {
        _naviTitle.text = self.title;
    }
//返回的View
    _backView = [[UIView alloc]initWithFrame: CGRectMake(0, 20, screenWidth/3, 44)];
    _backView.backgroundColor = [UIColor clearColor];
    //返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth/3, _backView.height)];
    [backButton addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:backButton];
    //返回图片
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 20, 20)];
    backImage.image = [UIImage imageNamed:@"backButton"];
    [_backView addSubview:backImage];
    [_naviView addSubview:_backView];
    
    
    ///上一页的title
    _buttonTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, 0, 60, backButton.height)];
    _buttonTitleLabel.font = [UIFont systemFontOfSize:14.0];
    
    
    _buttonTitleLabel.textColor = [UIColor whiteColor];
    [backButton addSubview:_buttonTitleLabel];
    _buttonTitleLabel.text = [self getLastViewControllerTitle];
    // Do any additional setup after loading the view.
    
    
    
}
-(void)didRecieveNotice:(NSNotification *)userInfo
{
    NSLog(@"------%@",userInfo.userInfo);
    
}




//- (Class)getCurrentVC
//{
//    UIViewController *result = nil;
//    
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//    
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//        result = nextResponder;
//    else
//        result = window.rootViewController;
//    
//    return result.class;
//}


-(NSString *)getLastViewControllerTitle
{
    NSInteger viewCount = self.navigationController.viewControllers.count;
    if (viewCount>=2)
    {
        return ((UIViewController *)self.navigationController.viewControllers[viewCount-2]).title;
    }
    else
    {
        return @"返回";
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [SVProgressHUD dismiss];
}
-(void)popBack:(UIButton *)sender
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"HandlePushMessage" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRecieveNotice:) name:@"HandlePushMessage" object:nil];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0f)
    {
        //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        //[self setNeedsStatusBarAppearanceUpdate];
    }
}
//- ( UIStatusBarStyle )preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}
/*
#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)goLogin
{
    
}

-(void)whileLoginSucess
{
    
}
-(instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        [self setTitle:title];
    }
    return self;
}

-(void)checkIfLogin
{
    if(G_USERTOKEN)
    {
        return;
    }
    else
    {
        LoginViewController *view = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        BaseNavigation *nv = [[BaseNavigation alloc]initWithRootViewController:view];
        [self presentViewController:nv animated:YES completion:^{
            
        }];
    }
}

@end
