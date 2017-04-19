//
//  SPTribeInfoEditViewController.m
//  WXOpenIMSampleDev
//
//  Created by shili.nzy on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPTribeInfoEditViewController.h"
#import "SPTribeProfileViewController.h"
#import "SPKitExample.h"
#import "SPUtil.h"
#import "ZHObject.h"
#import "KKASIHelper.h"

@interface SPTribeInfoEditViewController ()<UITextFieldDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBulletin;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) UIControl *activeControl;
@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation SPTribeInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.avatarButton.layer.cornerRadius = self.avatarButton.frame.size.width * 0.5;
    self.avatarButton.clipsToBounds = YES;
    //self.avatarButton.imageNormal = @"xiangji.png";
    
    [self.avatarButton setImageWithURL:[NSURL URLWithString:[KKASIHelper sharedInstance].tribeLogo]
                              forState:UIControlStateNormal
                      placeholderImage:UIImageNamed(@"xiangji.png")];
    
    _submit.title = KK_Text(@"Submit");
    _infoLabel.text = KK_Text(@"Group Introduction");
    
    if( self.mode == SPTribeInfoEditModeModify ) {
        self.title = KK_Text(@"Edit group information");

        [self.navigationItem.rightBarButtonItem setAction:@selector(saveModificationButtonPressed:)];
    }
    if( self.tribe != nil ) {
        __weak typeof(self) weakSelf = self;
        [self.ywTribeService requestTribeFromServer:self.tribe.tribeId completion:^(YWTribe *tribe, NSError *error) {
            if( error == nil ) {
                weakSelf.tribe = tribe;
                [weakSelf reloadData];
            } else {
                [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                    title:KK_Text(@"Updates Failed")
                                                                 subtitle:[NSString stringWithFormat:@"%@", error]
                                                                     type:SPMessageNotificationTypeError];
            }
        }];
    }

    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    if( self.tribe != nil ) {
        self.textFieldName.text = self.tribe.tribeName;
        self.textFieldBulletin.text = self.tribe.notice;
        /*
        UIImage *avatar = nil;
        if (self.tribe.tribeType == YWTribeTypeMultipleChat) {
            avatar = [UIImage imageNamed:@"demo_discussion"];
        }
        else {
            avatar = [UIImage imageNamed:@"demo_group_120"];
        }
        [self.avatarButton setImage:avatar forState:UIControlStateNormal];
         */
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    if (self.presentingViewController && self.navigationController.viewControllers.firstObject == self) {
        UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:KK_Text(@"Close")
                                                                          style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController:)];
        self.navigationItem.leftBarButtonItem = dismissButton;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveModificationButtonPressed:(id)sender
{
    NSString *name = nil;
    NSString *bulletin = nil;
     /*
    if( [self.textFieldName.text length] > 0 && ![self.textFieldName.text isEqualToString:self.tribe.tribeName] ) {
        name = self.textFieldName.text;
    }

    if ([self.textFieldBulletin.text length] > 0 && ![self.textFieldBulletin.text isEqualToString:self.tribe.notice]) {
        bulletin = self.textFieldBulletin.text;
    }

    if( name != nil || bulletin != nil ) {

        NSString *indicatorKey = self.description;
        [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:indicatorKey];

        __weak typeof(self) weakSelf = self;
        [self.ywTribeService modifyName:name notice:bulletin forTribe:self.tribe.tribeId completion:^(NSString *tribeId, NSError *error) {

            [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:indicatorKey];

            if( error == nil ) {
                if (weakSelf.activeControl) {
                    [weakSelf.activeControl resignFirstResponder];
                }

                [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                    title:KK_Text(@"更新信息成功")
                                                                 subtitle:nil
                                                                     type:SPMessageNotificationTypeSuccess];

                YWTribe *tribe = [weakSelf.ywTribeService fetchTribe:tribeId];
                if( [weakSelf.delegate respondsToSelector:@selector(tribeInfoEditViewController:tribeDidChange:)] ) {
                    [weakSelf.delegate tribeInfoEditViewController:weakSelf tribeDidChange:tribe];
                }
            }
            else {
                [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                    title:KK_Text(@"更新群信息失败")
                                                                 subtitle:[NSString stringWithFormat:@"%@", error]
                                                                     type:SPMessageNotificationTypeError];
            }
        }];
    } */
    
    name = self.textFieldName.text;
    bulletin = self.textFieldBulletin.text;
    NSDictionary *dict = @{@"access_token" : G_USERTOKEN,
                           @"family_id" : [KKASIHelper sharedInstance].familyID,
                           @"title" : name,
                           @"description" : bulletin};
    
    [[KKASIHelper sharedInstance] updateFamily:dict withImage:_selectedImage];
}

- (IBAction)createTribeButtonPressed:(id)sender {
    /*
    YWTribeDescriptionParam *param = [[YWTribeDescriptionParam alloc] init];
    param.tribeName = self.textFieldName.text;
    param.tribeNotice = self.textFieldBulletin.text;

    if (self.mode == SPTribeInfoEditModeCreateMultipleChat) {
        param.tribeType = YWTribeTypeMultipleChat;
    }
    else {
        param.tribeType = YWTribeTypeNormal;
    }

    NSString *indicatorKey = self.description;
    [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:indicatorKey];

    __weak typeof(self) weakSelf = self;
    [self.ywTribeService createTribeWithDescription:param completion:^(YWTribe *tribe, NSError *error) {

        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:indicatorKey];

        if( error == nil ) {
            [weakSelf pushTribeProfileViewControllerWithTribe:tribe];
        }
        else {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:KK_Text(@"创建失败")
                                                             subtitle:[NSString stringWithFormat:@"%@", error]
                                                                 type:SPMessageNotificationTypeError];
        }
    }]; */
    
    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:@"Logo" cancelButtonItem:[RIButtonItem itemWithLabel:KK_Text(@"Cancel")] destructiveButtonItem:nil otherButtonItems:[RIButtonItem itemWithLabel:KK_Text(@"Choose Current Photo") action:^{
        [self LocalPhoto];
    }],[RIButtonItem itemWithLabel:KK_Text(@"Take Photo") action:^{
        [self takePhoto];
    }], nil];
    [sheet showInView:self.view];
}

- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
        }];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选择图片");
    [picker dismissViewControllerAnimated:YES completion:Nil];
}
//完成选择图片
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [_avatarButton setImage:image forState:UIControlStateNormal];
        _selectedImage = image;
    }];
}

- (IBAction)backgroundTapped:(UIGestureRecognizer *)gestureRecognizer;
{
    [self.textFieldName resignFirstResponder];
    [self.textFieldBulletin resignFirstResponder];
}

- (void)pushTribeProfileViewControllerWithTribe:(YWTribe *)tribe {
    if (!tribe) {
        return;
    }
    SPTribeProfileViewController *controller =  [self.storyboard instantiateViewControllerWithIdentifier:@"SPTribeProfileViewController"];
    controller.tribe = tribe;

    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    [viewControllers removeObject:self];
    [viewControllers addObject:controller];
    [self.navigationController setViewControllers:viewControllers
                                         animated:YES];
}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeControl = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeControl = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldName) {
        [self.textFieldBulletin becomeFirstResponder];
    }
    else if (textField == self.textFieldBulletin) {
        if( self.mode == SPTribeInfoEditModeModify ) {
            [self saveModificationButtonPressed:nil];
        }
        else {
            [self createTribeButtonPressed:nil];
        }
    }
    return YES;
}


#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification*)aNotification {
    CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = self.scrollView.contentInset;
    contentInsets.bottom = keyboardSize.height;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;


    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        if (!self.activeControl) {
            return;
        }

        CGRect aRect = self.scrollView.frame;
        aRect.size.height -= keyboardSize.height;
        CGRect activeControlFrame = [self.scrollView convertRect:self.activeControl.bounds fromView:self.activeControl];

        if (!CGRectContainsPoint(aRect, activeControlFrame.origin) ) {
            [self.scrollView scrollRectToVisible:activeControlFrame animated:YES];
        }
    }
}
- (void)keyboardWillHide:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = self.scrollView.contentInset;
    contentInsets.bottom = 0;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}

@end
