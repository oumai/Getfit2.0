//
//  LoginViewController.m
//  BluetoothWallet
//
//  Created by zhanghao on 15/11/17.
//  Copyright © 2015年 ZhiHengChuang. All rights reserved.
//

// 登录聊天系统 接口文档 http://120.25.103.18:8086/apidoc/

#import "LoginViewController.h"
#import "GetPSWByValidCodeViewController.h"
#import "RegistViewController.h"
#import "WXLogin.h"
#import "SPKitExample.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *psdLabel;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *psw;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UIButton *regButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#define KK_LastAccount @"KK_LastAccount"
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:KK_Text(@"Log in")];
    // Do any additional setup after loading the view from its nib.
    [self.view viewWithTag:222].layer.masksToBounds = YES;
    [self.view viewWithTag:222].layer.cornerRadius = 4;
    [self.view viewWithTag:222].layer.borderWidth = 1;
    [self.view viewWithTag:222].layer.borderColor = RGB(233, 233, 233).CGColor;

    [self.view viewWithTag:333].layer.masksToBounds = YES;
    [self.view viewWithTag:333].layer.cornerRadius = 4;
    
    //_navBarView.backgroundColor = KK_MainColor;
    self.view.backgroundColor = KK_BgColor;
    
    if (![KK_LastAccount getObjectValue]) {
        [KK_LastAccount setObjectValue:@[@"", @""]];
    }
    
    _regButton.titleColorNormal = UIColorHEX(0x888890);
    _forgotButton.titleColorNormal = UIColorHEX(0x888890);
    
    _loginButton.bgImageNormal = @"0enter_login_btn_normal_5@2x.png";
    _loginButton.titleColorNormal = [UIColor whiteColor];
    _loginButton.titleNormal = KK_Text(@"Log in");
    
    _userNameLabel.text = KK_Text(@"Username:");
    _psdLabel.text = KK_Text(@"Password:");
    
    _regButton.titleNormal = KK_Text(@"Registered");
    _forgotButton.titleNormal = KK_Text(@"Forgot password");
    
    NSArray *lastAccount = [KK_LastAccount getObjectValue];
    _account.text = lastAccount[0];
    _psw.text = lastAccount[1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==1234)
    {
        [[self.view viewWithTag:1235]becomeFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
        [self login:nil];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark 登录——————完成登录动作就登录IM
- (IBAction)login:(id)sender
{
    [self.view endEditing:YES];
    if ([_account.text isEqualToString:@""] || [_psw.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:KK_Text(@"Username and password \n can not be empty")];
        return;
    }
    
    [KK_LastAccount setObjectValue:@[_account.text ? _account.text : @"",
                                     _psw.text ? _psw.text : @""]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REQMethod(@"/user/login")]];
    [request addPostValue:_account.text forKey:@"login_name"];
    [request addPostValue:_psw.text forKey:@"password"];
    
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        ZHDEBUG(weakRequest.responseString);
        NSDictionary *dic= weakRequest.responseString.JSONValue;
        if (formartStr(dic[@"ret"]).intValue != 0  && formartStr(dic[@"ret"]))
        {
            [self showMessage:formartStr(dic[@"ret"]).intValue];
            return;
        }
        G_USERTOKEN = formartStr(dic[@"data"][@"access_token"]);
        
        NSString *ID = [NSString stringWithFormat:@"%@",dic[@"data"][@"id"]];
        NSString *pwd = [NSString stringWithFormat:@"%@",dic[@"data"][@"im_password"]];

        [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:ID passWord:pwd preloginedBlock:^{
            NSLog(@"可以显示回话列表");
        } successBlock:^{
            NSLog(@"旺信登录成功");
        } failedBlock:^(NSError *error) {
            NSLog(@"登录旺信失败:%@",error);
        }];
        
        [OtherTools saveLoginData:weakRequest.responseString];
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:NO];
        
        if (_backBlock) {
            _backBlock(nil);
        }
    }];
    [request setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:KK_Text(@"Server connection failed")];
    }];
    [request setTimeOutSeconds:TimeOut];
    [request startAsynchronous];
    [SVProgressHUD show];
}

- (IBAction)forget:(id)sender
{
    GetPSWByValidCodeViewController *forgot = [[GetPSWByValidCodeViewController alloc]initWithNibName:@"GetPSWByValidCodeViewController" bundle:nil];
    [forgot setTitle:KK_Text(@"Forgot password")];
    [self.navigationController pushViewController:forgot animated:YES];
    // UIAlertView
}

- (IBAction)regist:(id)sender
{
    RegistViewController *regist = [[RegistViewController alloc]initWithNibName:@"RegistViewController" bundle:nil];
    [regist setTitle:KK_Text(@"Registered")];
    [self.navigationController pushViewController:regist animated:YES];
}

- (IBAction)backUpVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
