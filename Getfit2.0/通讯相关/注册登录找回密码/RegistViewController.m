//
//  RegistViewController.m
//  BluetoothWallet
//
//  Created by zhanghao on 15/11/18.
//  Copyright © 2015年 ZhiHengChuang. All rights reserved.
//

#import "RegistViewController.h"
typedef enum {
    registTypePhone = 1,
    registTypeAccount
}registType;


@interface RegistViewController ()
///手机号注册View
@property (weak, nonatomic) IBOutlet UIView *v_phoneRegist;
///手机号注册帐号
@property (weak, nonatomic) IBOutlet UITextField *t_phoneRegistAccount;
///手机号注册密码
@property (weak, nonatomic) IBOutlet UITextField *t_PhoneRegistPSW;
///手机号注册重复密码
@property (weak, nonatomic) IBOutlet UITextField *t_phoneRegistRepeatPSW;
///手机号注册验证码
@property (weak, nonatomic) IBOutlet UITextField *t_PhoneRegistValidCode;
///手机号注册获取验证码
@property (weak, nonatomic) IBOutlet UIButton *b_PhoneRegistGetCode;
@property (weak, nonatomic) IBOutlet UILabel *phoneOrEmail;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *regButton;
@property (weak, nonatomic) IBOutlet UILabel *psdLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatpsdLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@end

@implementation RegistViewController
{
    ///验证码倒计时
    NSTimer *timer;
    ///验证码
    NSString *_validCode;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = KK_BgColor;
    _v_phoneRegist.backgroundColor = KK_BgColor;
    [self resizeTopView];
    // Do any additional setup after loading the view from its nib.
    
    _regButton.bgImageNormal = @"0enter_login_btn_normal_5@2x.png";
    _regButton.titleColorNormal = [UIColor whiteColor];
    _regButton.titleNormal = KK_Text(@"Registered");
    
    _phoneOrEmail.text = KK_Text(@"Username:");
    _psdLabel.text = KK_Text(@"Password:");
    _repeatpsdLabel.text = KK_Text(@"RepeatPSD:");
    _codeLabel.text = KK_Text(@"Email:");
}

-(void)resizeTopView
{
    ///初始化默认手机号注册
    
    [self.view viewWithTag:222].layer.masksToBounds = YES;
    [self.view viewWithTag:222].layer.cornerRadius = 4;
    
    [self.view viewWithTag:333].layer.masksToBounds = YES;
    [self.view viewWithTag:333].layer.cornerRadius = 4;
    
    [self.view viewWithTag:444].layer.masksToBounds = YES;
    [self.view viewWithTag:444].layer.cornerRadius = 4;
}

///获取验证码
- (IBAction)getCode:(id)sender
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/captcha?relate=%@&type=1",ServerURL,_t_phoneRegistAccount.text]]];
    __weak ASIHTTPRequest *weakRequest = request;
    [request setCompletionBlock:^{
        ZHDEBUG(weakRequest.responseString);
        NSDictionary *dic= weakRequest.responseString.JSONValue;
        
        if (formartStr(dic[@"ret"]).intValue != 0)
        {
            [self showMessage:formartStr(dic[@"ret"]).intValue];
            return;
        }
        _validCode = formartStr(dic[@"data"][@"verify_code"]);
        [SVProgressHUD showSuccessWithStatus:@"Verification code has been sent"];
        
        ///写在获取到验证码之后
        _b_PhoneRegistGetCode.enabled=NO;
        [_b_PhoneRegistGetCode setTitle:@"120S" forState:UIControlStateDisabled];
        [_b_PhoneRegistGetCode setTitleColor:UIColorFromRGB(ZHBLUE) forState:UIControlStateNormal];
        _b_PhoneRegistGetCode.backgroundColor = [UIColor whiteColor];
        timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeat) userInfo:nil repeats:YES];
    }];
    [request setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:KK_Text(@"Server connection failed")];
    }];
    [request setTimeOutSeconds:TimeOut];
    [request startAsynchronous];
    [SVProgressHUD show];
}

///验证码倒计时
- (void)repeat
{
    if (_b_PhoneRegistGetCode.titleLabel.text.intValue>0)
    {
        [_b_PhoneRegistGetCode setTitleColor:UIColorFromRGB(ZHBLUE) forState:UIControlStateNormal];
        _b_PhoneRegistGetCode.backgroundColor = [UIColor whiteColor];
        [_b_PhoneRegistGetCode setTitle:[NSString stringWithFormat:@"%dS",_b_PhoneRegistGetCode.titleLabel.text.intValue-1] forState:UIControlStateDisabled];
        
        _b_PhoneRegistGetCode.layer.masksToBounds = YES;
        _b_PhoneRegistGetCode.layer.borderWidth =1 ;
        _b_PhoneRegistGetCode.layer.borderColor = [UIColorFromRGB(ZHBLUE) CGColor];
    }
    else
    {
        [timer invalidate];
        _b_PhoneRegistGetCode.enabled=YES;
        [_b_PhoneRegistGetCode setTitle:KK_Text(@"Codes") forState:UIControlStateNormal];
        [_b_PhoneRegistGetCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _b_PhoneRegistGetCode.layer.borderWidth =0 ;
        _b_PhoneRegistGetCode.backgroundColor = UIColorFromRGB(ZHBLUE);
    }
}
///确认注册
- (IBAction)go_PhoneRegist:(id)sender
{
    if (![_t_phoneRegistAccount.text isUserName]) {
        SHOWMBProgressHUD(KK_Text(@"Please enter 4-18 digits \n or letters username"), nil, nil, NO, 2.0);
        return;
    } else if (![_t_PhoneRegistPSW.text isPassword]) {
        SHOWMBProgressHUD(KK_Text(@"Please enter 6-18 digits \n or letters username"), nil, nil, NO, 2.0);
        return;
    } else if (![_t_PhoneRegistPSW.text isEqualToString:_t_phoneRegistRepeatPSW.text]) {
        SHOWMBProgressHUD(KK_Text(@"The two passwords do not match"), nil, nil, NO, 2);
        return;
    } else if (![_t_PhoneRegistValidCode.text isEmail]) {
        SHOWMBProgressHUD(KK_Text(@"Email wrong format"), nil, nil, NO, 2.0);
        return;
    } else {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REQMethod(@"/user/signin")]];
        [request addPostValue:_t_phoneRegistAccount.text forKey:@"user_name"];
        [request addPostValue:_t_PhoneRegistPSW.text forKey:@"password"];
        [request addPostValue:_t_PhoneRegistValidCode.text forKey:@"email"];
  
        // [request addPostValue:[OtherTools md5:[NSString stringWithFormat:@"%@D6E45YJ67T",_t_PhoneRegistPSW.text]]  forKey:@"password"];
        __weak ASIFormDataRequest *weakRequest = request;
        [request setCompletionBlock:^{
            ZHDEBUG(weakRequest.responseString);
            NSDictionary *dic= weakRequest.responseString.JSONValue;
            if (formartStr(dic[@"ret"]).intValue !=0 && formartStr(dic[@"ret"]))
            {
                [self showMessage:formartStr(dic[@"ret"]).intValue];
                return;
            }
            G_USERTOKEN = formartStr(dic[@"data"][@"access_token"]);
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }];
        [request setFailedBlock:^{
            [SVProgressHUD showErrorWithStatus:KK_Text(@"Server connection failed")];
        }];
        [request setTimeOutSeconds:TimeOut];
        [request startAsynchronous];
        [SVProgressHUD show];
    }
}

#pragma mark用户名注册

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
