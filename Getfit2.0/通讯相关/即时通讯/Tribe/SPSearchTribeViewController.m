//
//  SPSearchTribeViewController.m
//  WXOpenIMSampleDev
//
//  Created by shili.nzy on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPSearchTribeViewController.h"
#import "SPTribeProfileViewController.h"
#import "SPKitExample.h"
#import "SPUtil.h"

@interface SPSearchTribeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation SPSearchTribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.searchTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Actions
- (IBAction)onSearch:(id)sender {
    if( [self.searchTextField.text length] == 0 ){
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    [self.ywTribeService requestTribeFromServer:self.searchTextField.text completion:^(YWTribe *tribe, NSError *error) {
        if(!error) {
            [self.searchTextField resignFirstResponder];
            [self presentTribeProfileViewControllerWithTribe:tribe];
        }
        else {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:KK_Text(@"The group is not found , make sure \n the group account after retries")
                                                             subtitle:nil
                                                                 type:SPMessageNotificationTypeError];
        }
    }];
}

- (void)presentTribeProfileViewControllerWithTribe:(YWTribe *)tribe {
    if (!tribe) {
        return ;
    }
    SPTribeProfileViewController *controller =[self.storyboard instantiateViewControllerWithIdentifier:@"SPTribeProfileViewController"];
    controller.tribe = tribe;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];

    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];

}

#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchTextField) {
        [self onSearch:nil];
    }
    return YES;
}

#pragma makr - 
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}
@end
