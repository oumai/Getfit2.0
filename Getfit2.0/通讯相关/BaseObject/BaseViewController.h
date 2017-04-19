//
//  BaseViewController.h
//  Elevator
//
//  Created by 张浩 on 15/6/17.
//  Copyright (c) 2015年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHObject.h"
#import "LoginViewController.h"
@interface BaseViewController : UIViewController
@property(nonatomic,strong)UIView *naviView;
@property(nonatomic,strong)UILabel *naviTitle;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *buttonTitleLabel;


-(void)pushViewController:(UIViewController *)viewController;

-(void)popBack:(UIButton *)sender;
//登录
-(void)goLogin;
//登录之后重写
-(void)whileLoginSucess;
///处理消息
-(void)handleNotice;
///初始化
-(instancetype)initWithTitle:(NSString *)title;
//判断是否登录，没有登录就跳转登录
-(void)checkIfLogin;
@end
