//
//  ResetPasswordViewController.m
//  BluetoothWallet
//
//  Created by zhanghao on 15/11/18.
//  Copyright © 2015年 ZhiHengChuang. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *psw;
@property (weak, nonatomic) IBOutlet UITextField *repeatPSW;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view viewWithTag:333].layer.borderWidth = 1;
    [self.view viewWithTag:333].layer.borderColor = RGB(241, 241, 241).CGColor;
    [self.view viewWithTag:333].layer.masksToBounds = YES;
    [self.view viewWithTag:333].layer.cornerRadius = 4;
    
    [self.view viewWithTag:444].layer.masksToBounds = YES;
    [self.view viewWithTag:444].layer.cornerRadius = 4;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirm:(id)sender
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REQMethod(@"/user/reset-password")]];
    if (![_psw.text isEqualToString:_repeatPSW.text])
    {
        [SVProgressHUD showErrorWithStatus:KK_Text(@"The two passwords do not match")];
        return;
    }
    [request addPostValue:_userName forKey:@"login_name"];
    [request addPostValue:[OtherTools md5:[NSString stringWithFormat:@"%@D6E45YJ67T",_psw.text]]  forKey:@"password"];
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        ZHDEBUG(weakRequest.responseString);
        NSDictionary *dic= weakRequest.responseString.JSONValue;
        if (formartStr(dic[@"ret"]).intValue != 0)
        {
            [self showMessage:formartStr(dic[@"ret"]).intValue];
            return;
        }
        G_USERTOKEN = formartStr(dic[@"data"][@"access_token"]);
        [self dismissViewControllerAnimated:YES completion:nil];
        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:KK_Text(@"Server connection failed")];
    }];
    [request setTimeOutSeconds:TimeOut];
    [request startAsynchronous];
    [SVProgressHUD show];
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
