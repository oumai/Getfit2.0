//
//  GetPSWByValidCodeViewController.m
//  BluetoothWallet
//
//  Created by zhanghao on 15/11/18.
//  Copyright © 2015年 ZhiHengChuang. All rights reserved.
//

#import "GetPSWByValidCodeViewController.h"
#import "ResetPasswordViewController.h"
@interface GetPSWByValidCodeViewController ()
@property(weak,nonatomic)IBOutlet UITextField *phoneNum;
///手机号注册验证码
@property (weak, nonatomic) IBOutlet UITextField *t_validCode;
///手机号注册获取验证码
@property (weak, nonatomic) IBOutlet UIButton *senderButton;
@property (weak, nonatomic) IBOutlet UILabel *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *b_getCode;
@end

@implementation GetPSWByValidCodeViewController
{
    NSTimer *timer;
    NSString *_validCode;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view viewWithTag:222].layer.masksToBounds = YES;
    [self.view viewWithTag:222].layer.cornerRadius = 4;
    
    [self.view viewWithTag:333].layer.masksToBounds = YES;
    [self.view viewWithTag:333].layer.cornerRadius = 4;
    
    [self.view viewWithTag:444].layer.masksToBounds = YES;
    [self.view viewWithTag:444].layer.cornerRadius = 4;
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = KK_BgColor;
    
    _emailButton.text = KK_Text(@"Email:");
    _phoneNum.placeholder = KK_Text(@"");
    
    _senderButton.bgImageNormal = @"0enter_login_btn_normal_5@2x.png";
    _senderButton.titleColorNormal = [UIColor whiteColor];
    _senderButton.titleNormal = KK_Text(@"Send");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///获取验证码
- (IBAction)getCode:(id)sender
{
    
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REQMethod(@"/user/captcha")]];
//    [request addPostValue:_phoneNum.text forKey:@"login_name"];
//    [request addPostValue:@"2" forKey:@"type"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/captcha?relate=%@&type=2",ServerURL,_phoneNum.text]]];
    __weak ASIHTTPRequest *weakRequest = request;
    [request setCompletionBlock:^{
        ZHDEBUG(weakRequest.responseString);
        NSDictionary *dic= weakRequest.responseString.JSONValue;
        
        if (formartStr(dic[@"ret"]).intValue !=0 && formartStr(dic[@"ret"]))
        {
            [self showMessage:formartStr(dic[@"ret"]).intValue];
            return;
        }
        _validCode = formartStr(dic[@"data"][@"verify_code"]);
        [SVProgressHUD showSuccessWithStatus:@"Codes has been sent"];
        
        ///写在获取到验证码之后
        _b_getCode.enabled=NO;
        [_b_getCode setTitle:@"120S" forState:UIControlStateDisabled];
        [_b_getCode setTitleColor:UIColorFromRGB(ZHBLUE) forState:UIControlStateNormal];
        _b_getCode.backgroundColor = [UIColor whiteColor];
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
-(void)repeat
{
    if (_b_getCode.titleLabel.text.intValue>0)
    {
        [_b_getCode setTitleColor:UIColorFromRGB(ZHBLUE) forState:UIControlStateNormal];
        _b_getCode.backgroundColor = [UIColor whiteColor];
        [_b_getCode setTitle:[NSString stringWithFormat:@"%dS",_b_getCode.titleLabel.text.intValue-1] forState:UIControlStateDisabled];
        
        _b_getCode.layer.masksToBounds = YES;
        _b_getCode.layer.borderWidth =1 ;
        _b_getCode.layer.borderColor = [UIColorFromRGB(ZHBLUE) CGColor];
    }
    else
    {
        [timer invalidate];
        _b_getCode.enabled=YES;
        [_b_getCode setTitle:KK_Text(@"Codes") forState:UIControlStateNormal];
        [_b_getCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _b_getCode.layer.borderWidth =0 ;
        _b_getCode.backgroundColor = UIColorFromRGB(ZHBLUE);
    }
}
- (IBAction)resetPSW:(id)sender
{
    /*
    if (![_validCode isEqualToString:_t_validCode.text]) {
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return;
    }
    ResetPasswordViewController *reset = [[ResetPasswordViewController alloc]initWithNibName:@"ResetPasswordViewController" bundle:nil];
    [reset setTitle:@"重设密码"];
    reset.userName = _phoneNum.text;
    [self pushViewController:reset];*/
    
    if (![_phoneNum.text isEmail]) {
        SHOWMBProgressHUD(KK_Text(@"Email wrong format"), nil, nil, NO, 2.0);
    } else {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://120.25.103.18:8086/user/reset-password"]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
        
        [request addPostValue:_phoneNum.text forKey:@"login_name"];

        __weak ASIHTTPRequest *weakRequest = request;
        [request setCompletionBlock:^{
            ZHDEBUG(weakRequest.responseString);
            NSDictionary *dic= weakRequest.responseString.JSONValue;
            
            if (formartStr(dic[@"ret"]).intValue !=0 && formartStr(dic[@"ret"]))
            {
                [self showMessage:formartStr(dic[@"ret"]).intValue];
                return;
            } else {
                SHOWMBProgressHUD(KK_Text(@"Password has been sent to your mailbox"), nil, nil, NO, 2.0);
                G_USERTOKEN = nil;
            }
        }];
        [request setFailedBlock:^{
            [SVProgressHUD showErrorWithStatus:KK_Text(@"Server connection failed")];
        }];
        [request setTimeOutSeconds:TimeOut];
        [request startAsynchronous];
        [SVProgressHUD show];
    }
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
