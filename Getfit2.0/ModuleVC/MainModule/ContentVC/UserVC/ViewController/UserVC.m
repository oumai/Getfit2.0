//
//  UserVC.m
//  AJBracelet
//
//  Created by zorro on 15/6/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserVC.h"
#import "ShowScrollView.h"
#import "UserProfileViewController.h"
#import "UserSettingViewController.h"
#import "UserTargetViewController.h"
#import "UserProfilePhotoView.h"
#import "CameraController.h"


#import "FamilyViewController.h"
#import "LoginViewController.h"
#import "ZHObject.h"
#import "IQKeyboardManager.h"

#import "BLTSendModel.h"
@interface UserVC () <UserProfilePhotoDeleagte,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)ShowScrollView *showView;

@property (nonatomic, strong) UIImageView *userHeadImage;
@property (nonatomic, strong) UIButton *targetSetting;
@property (nonatomic, strong) UIButton *userProfile;
@property (nonatomic, strong) UIButton *systemSetting;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *targetLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *systemLabel;

@property (nonatomic, strong) UIButton *tourButton;
@property (nonatomic, strong) UILabel *tourLabel;

@property (nonatomic, strong) UserProfilePhotoView *PhotoView;
@property (nonatomic, strong) UIImageView *headView;

@property (nonatomic, strong) UIView *topView;

@end

@implementation UserVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;

    [IQKeyboardManager sharedManager].enable = YES;
    
    if ([[UserInfoHelper sharedInstance] getUserHeadImage]) {
        _userHeadImage.image = [[UserInfoHelper sharedInstance] getUserHeadImage];
    }
    
    if ([UserInfoHelper sharedInstance].userModel.nickName == NULL) {
        _userName.text = @"";
    } else {
        _userName.text = [UserInfoHelper sharedInstance].userModel.nickName;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"showMine01.jpg",@"showMine02.jpg",@"showMine03.jpg",@"showMine04.jpg",@"showMine05.jpg", nil];
//    _showView = [[ShowScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//    _showView.imageArray = imageArray;
//    [self.view addSubview:_showView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 230 + 141, self.view.width, self.view.height - 230 - 140)];
    backView.backgroundColor = [UIColor blackColor];
   // [self.view addSubview:backView];
    
    [self loadViewSetup];
    
    [self loadSettingButtonAndLabel];
    
    _picker = [[UIImagePickerController alloc] init];//初始化
    _picker.delegate = self;
    _picker.allowsEditing = YES;//设置可编辑
    
    /**
     * 添加聊天按钮
     */
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.center = CGPointMake(backView.width * 0.5, backView.height * 0.4);
    btn.bounds = CGRectMake(0, 0, 200, 40);
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColorNormal:[UIColor blackColor]];
    [btn setTitle:@"旅游圈" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToTourismCircle) forControlEvents:UIControlEventTouchUpInside];
  //  [backView addSubview:btn];
}

/**
 *  旅游圈按钮点击事件
 */
-(void)goToTourismCircle{

//     FamilyViewController *family =  [[FamilyViewController alloc] initWithNibName:@"FamilyViewController" bundle:nil];
//     [self.navigationController pushViewController:family animated:YES];
 
    if (G_USERTOKEN) {
        [self pushToFamilyVC];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
        DEF_WEAKSELF_(UserVC);
        loginVC.backBlock = ^ (NSObject *object) {
            [weakSelf pushToFamilyVC];
        };
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)pushToFamilyVC
{
    [IQKeyboardManager sharedManager].enable = NO;
    
    FamilyViewController *family =  [[FamilyViewController alloc] initWithNibName:@"FamilyViewController" bundle:nil];
    [self.navigationController pushViewController:family animated:YES];
}

- (void)loadViewSetup
{
    self.view.backgroundColor = UIColorHEX(0x262626);
    
    CGFloat offsetY = FitScreenNumber(160, 210, 230, 230, 230);
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, Maxwidth, offsetY)];
    _topView.backgroundColor = KK_MainColor;
    [self.view addSubview:_topView];
    
    _userHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - 96)/2, offsetY / 7, 96, 96)];
    _userHeadImage.layer.cornerRadius = 96/2;
    _userHeadImage.clipsToBounds = YES;
    [_topView addSubview:_userHeadImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectHeadImage)];
    _userHeadImage.userInteractionEnabled = YES;
    [_userHeadImage addGestureRecognizer:tap];
    
    _userName = [UILabel simpleWithRect:CGRectMake(Maxwidth/2-60, _userHeadImage.totalHeight + offsetY / 18, 120, 25)];
    _userName.font = DEFAULT_FONTHelvetica(14.0);
    [_topView addSubview:_userName];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10 , 230 + 141 , Maxwidth - 20, 0.5)];
    line.backgroundColor = UIColorHEX(0xa7a8aa);
    // [self.view addSubview:line];
}

- (void)loadSettingButtonAndLabel
{
    CGFloat offsetX = (Maxwidth - 56 * 2) / 3;
    CGFloat offsetY = _topView.totalHeight + 20;

    _targetSetting = [UIButton simpleWithRect:CGRectMake(offsetX, offsetY, 56, 56) withImage:@"目标_5@2x.png" withSelectImage:@"目标_5@2x.png"];
    [self.view addSubview: _targetSetting];
    [_targetSetting addTarget:self action:@selector(targetSetting:) forControlEvents:UIControlEventTouchUpInside];
    
    _userProfile = [UIButton simpleWithRect:CGRectMake(Maxwidth - (56 + offsetX), offsetY, 56, 56) withImage:@"资料_5@2x.png" withSelectImage:@"资料_5@2x.png"];
    [self.view addSubview: _userProfile];
    [_userProfile addTarget:self action:@selector(userProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    _systemSetting = [UIButton simpleWithRect:CGRectMake(offsetX, offsetY + 86, 56, 56) withImage:@"设置_5@2x.png" withSelectImage:@"设置_5@2x.png"];
    [self.view addSubview: _systemSetting];
    [_systemSetting addTarget:self action:@selector(systemSetting:) forControlEvents:UIControlEventTouchUpInside];
    
    _tourButton = [UIButton simpleWithRect:CGRectMake(Maxwidth - (offsetX + 56), offsetY + 86, 56, 56)
                                 withImage:@"4me_quanzi_5@2x.png"
                           withSelectImage:@"4me_quanzi_5@2x.png"];
    // [self.view addSubview: _tourButton];
    [_tourButton addTarget:self action:@selector(goToTourismCircle) forControlEvents:UIControlEventTouchUpInside];
    
    _targetLabel = [UILabel simpleWithRect:CGRectMake(offsetX - 30, _targetSetting.totalHeight, 116, 25)];
    _targetLabel.text = KK_Text(@"Target Setting");
    [self.view addSubview:_targetLabel];
    
    _userLabel = [UILabel simpleWithRect:CGRectMake(Maxwidth - (86 + offsetX), _targetSetting.totalHeight, 116, 25)];
    _userLabel.text = KK_Text(@"My info") ;
    [self.view addSubview:_userLabel];
    
    _systemLabel = [UILabel simpleWithRect:CGRectMake(offsetX - 30, _systemSetting.totalHeight, 116, 25)];
    _systemLabel.text = KK_Text(@"System Setting");
    [self.view addSubview:_systemLabel];
    
    _tourLabel = [UILabel simpleWithRect:CGRectMake(Maxwidth - (86 + offsetX), _systemSetting.totalHeight, 116, 25)];
    _tourLabel.text = KK_Text(@"Tourism");
    // [self.view addSubview:_tourLabel];
}

- (void)targetSetting:(UIButton *)sender
{
    UserTargetViewController *userTargetVc = [[UserTargetViewController alloc] init];
    [self.navigationController pushViewController:userTargetVc animated:YES];
}

- (void)userProfile:(UIButton *)sender
{
    UserProfileViewController *userProfileVc = [[UserProfileViewController alloc] init];
    [self.navigationController pushViewController:userProfileVc animated:YES];
}

- (void)systemSetting:(UIButton *)sender
{
    UserSettingViewController *userSettingVc = [[UserSettingViewController alloc] init];
    [self.navigationController pushViewController:userSettingVc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//////点击头像放大
- (void)selectHeadImage
{
    UIImage *image = [[UserInfoHelper sharedInstance] getUserHeadImage];
    if (!_headView)
    {
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, image.size.width, image.size.height)];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    
    [_headView popupWithtype:PopupViewOption_colorLump succeedBlock:^(UIView *View)
     {
         View.frame = CGRectMake(0, 0, image.size.width, image.size.height);
         View.center = self.view.center;
         _headView.image = image;
         
     } dismissBlock:^(UIView *View) {
         
     }];
}


@end
