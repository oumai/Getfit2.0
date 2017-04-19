//
//  SearchResultViewController.m
//  StoryPlayer
//
//  Created by zhanghao on 15/12/7.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController (){

    ZHVoidBlock _block;
}
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *familyName;
@property (weak, nonatomic) IBOutlet UILabel *familyRemark;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTest;
@property (weak, nonatomic) IBOutlet UIButton *searButton;

@end

@implementation SearchResultViewController
{
    NSString *_familyID;
}

- (IBAction)searchFamilyWithID:(id)sender
{
    if (_searchTest.text.length > 0) {
        _familyID = _searchTest.text;
        [self getFamilyInfomation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.view viewWithTag:222]setCornerRadiusss:4];
    [_logoView setRoundLayer];
    [_logoView.superview setCornerRadiusss:4];
    
    _infoView.hidden = YES;
    _joinButton.hidden = YES;
    
    _searButton.bgImageNormal = @"0enter_login_btn_normal_5@2x.png";
    _searButton.titleColorNormal = [UIColor whiteColor];
    _searButton.titleNormal = KK_Text(@"Search");
    
    _joinButton.bgImageNormal = @"0enter_login_btn_normal_5@2x.png";
    _joinButton.titleColorNormal = [UIColor whiteColor];
    _joinButton.titleNormal = KK_Text(@"Join");
    // self.navigationController.navigationBar.barTintColor = KK_MainColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_familyID) {
        _searchTest.text = _familyID;
        [self getFamilyInfomation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)attend:(id)sender
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REQMethod(@"/family/member/create")]];
    [request addPostValue:G_USERTOKEN forKey:@"access_token"];
    [request addPostValue:_familyID forKey:@"family_id"];
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        ZHDEBUG(weakRequest.responseString);
        NSDictionary *dic= weakRequest.responseString.JSONValue;
        if (formartStr(dic[@"ret"]).intValue !=0 && formartStr(dic[@"ret"]))
        {
            [SVProgressHUD showErrorWithStatus:formartStr(dic[@"message"])];
            return;
        }
        else
        {
            NSDictionary *data = dic[@"data"];
            
            if (_block) {
                _block();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [request setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:KK_Text(@"Server connection failed")];
    }];
    [request setTimeOutSeconds:TimeOut];
    [request startAsynchronous];
    [SVProgressHUD show];
}
-(void)setFamilyID:(NSString *)familyID
{
    _familyID =familyID;
    
}
-(void)setAttentCompleteBlock:(ZHVoidBlock)block
{
    _block = block;
    
}
-(void)getFamilyInfomation
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/family/%@",ServerURL,_familyID]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    [request addPostValue:G_USERTOKEN forKey:@"access_token"];
    
    __weak ASIHTTPRequest *weakRequest = request;
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        ZHDEBUG(weakRequest.responseString);
        NSDictionary *dic= weakRequest.responseString.JSONValue;
        
        if (formartStr(dic[@"ret"]).intValue != 0 && formartStr(dic[@"ret"]))
        {
            [self showMessage:formartStr(dic[@"ret"]).intValue];
            return;
        }
        else
        {
            NSDictionary *data = dic[@"data"];
  
            [_logoView setImageWithURL:[NSURL URLWithString:data[@"head_img"]]];
            _familyName.text = formartStr(data[@"title"]);
            [_familyRemark setText:formartStr(data[@"description"]) AutoResizeInHeight:78];
            
            _infoView.hidden = NO;
            _joinButton.hidden = NO;
        }
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
