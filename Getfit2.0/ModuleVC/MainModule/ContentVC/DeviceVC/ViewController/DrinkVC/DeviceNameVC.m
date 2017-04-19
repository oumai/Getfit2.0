//
//  DeviceNameVC.m
//  AJBracelet
//
//  Created by zorro on 16/3/28.
//  Copyright © 2016年 zorro. All rights reserved.
//

#import "DeviceNameVC.h"
#import "BLTModel.h"

@interface DeviceNameVC () <UITextFieldDelegate>

@property (nonatomic, strong) BLTModel *model;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation DeviceNameVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KK_BgColor;
    
    self.tipTitle.text = KK_Text(@"Device Name");

    _model = [UserInfoHelper sharedInstance].bltModel;
    
    _textField = [UITextField simpleWithRect:CGRectMake(20, 104, self.view.width - 40, 44)  withPlaceholder:_model.bltName];
    _textField.delegate = self;
    _textField.textColor = [UIColor whiteColor];
    [self.view addSubview:_textField];
    
    _textField.text = _model.bltNickName;
}

- (void)rightBarButton
{
    [_model.bltUUID setObjectValue:_textField.text];
    
    SHOWMBProgressHUD(KK_Text(@"Setting success"), nil, nil, NO, 2.0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (!CGRectContainsPoint(_textField.frame, point))
    {
        [self.view endEditing:YES];
    }}


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

@end
