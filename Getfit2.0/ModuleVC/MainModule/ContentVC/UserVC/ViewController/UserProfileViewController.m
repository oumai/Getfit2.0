//
//  UserProfileViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserProfileViewTableCell.h"
#import "CustomPickerView.h"
#import "CustomsPickView.h"
#import "UserProfilePhotoView.h"
#import "CameraController.h"
#import "IQKeyboardManager.h"

#import "BLTSendModel.h"

@interface UserProfileViewController ()<UITableViewDataSource,UITableViewDelegate,UserProfilePhotoDeleagte,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *userHeadImage;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *userDataArray;
@property (nonatomic, strong) CustomsPickView *pickViewBg;
@property (nonatomic, strong) CustomPickerView *PickView;
@property (nonatomic, assign) NSInteger settingSelectIndex;
@property (nonatomic, assign) BOOL sexValue;
@property (nonatomic, strong) UIView *adorableView;
@property (nonatomic, assign) CGFloat fitSizeHeight;
@property (nonatomic, strong) UserProfilePhotoView *PhotoView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *topView;

@end

@implementation UserProfileViewController
{
    NSInteger nowMonth;
    NSInteger nowYear;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    _fitSizeHeight = FitScreenNumber(30, 0, 0, 0, 0);
    
    [self loadViewSetup];
    [self loadNaBar];
    [self loadTableView];
    [self loadPickUpView];
    
    _picker = [[UIImagePickerController alloc] init];//初始化
    _picker.delegate = self;
    _picker.allowsEditing = YES;//设置可编辑
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _adorableView.hidden = YES;
    [_pickViewBg hiddenView];
}

- (void)loadPickUpView
{
    _adorableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, Maxheight)];
    _adorableView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    _adorableView.hidden = YES;
    [self.view addSubview:_adorableView];
    
    _pickViewBg = [[CustomsPickView alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, 216 + 44)];
    [self.view addSubview:_pickViewBg];
    
    _PickView = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 44, Maxwidth, 216 )];
    
    [_pickViewBg addSubview:_PickView];

    DEF_WEAKSELF_(UserProfileViewController)
    _pickViewBg.customPickClickBlock = ^(BOOL value)
    {
        if (value)
        {
            [weakSelf saveUserInfo];
        }
        weakSelf.adorableView.hidden = YES;
        [weakSelf.pickViewBg hiddenView];
    };
    
    _PickView.customPickerSelectBlock = ^ (NSInteger component,NSInteger row) {
        if (_settingSelectIndex == 1) {
            [weakSelf setdateArrayWithComponent:component andRow:row];
        }
    };
    _sexValue = YES;
}

- (void)saveUserInfo
{
    
    
    if (_settingSelectIndex == 1)
    {
        NSInteger row1 = [_PickView selectedRowInComponent:0];
        NSInteger row2 = [_PickView selectedRowInComponent:1];
        NSInteger row3 = [_PickView selectedRowInComponent:2];
        
        NSString *birth = [NSString stringWithFormat:@"%@-%@-%@",[_PickView.dataArray objectAtIndex:row1],[_PickView.dataArray2 objectAtIndex:row2],[_PickView.dataArray3 objectAtIndex:row3]];
        [_userDataArray replaceObjectAtIndex:_settingSelectIndex withObject:birth];
        
        [UserInfoHelper sharedInstance].userModel.birthDay = [NSString stringWithFormat:@"%@-%@-%@",[_PickView.dataArray objectAtIndex:row1],[_PickView.dataArray2 objectAtIndex:row2],[_PickView.dataArray3 objectAtIndex:row3]];
        [_userDataArray replaceObjectAtIndex:_settingSelectIndex withObject:birth];

    }
    else if  (_settingSelectIndex == 2)
    {
        NSInteger row1 = [_PickView selectedRowInComponent:0];
        
        NSString *sex = [_PickView.dataArray objectAtIndex:row1];
        
        if (row1 == 0)
        {
            _sexValue = YES;
            [UserInfoHelper sharedInstance].userModel.genderSex = 0;
        }else
        {
            _sexValue = NO;
            [UserInfoHelper sharedInstance].userModel.genderSex = 1;
        }

       [_userDataArray replaceObjectAtIndex:_settingSelectIndex withObject:sex];
    }
    else if  (_settingSelectIndex == 3)
    {
        NSInteger row1 = [_PickView selectedRowInComponent:0];
        NSString *height = [NSString stringWithFormat:@"%@ cm",[_PickView.dataArray objectAtIndex:row1]];
        if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
            height = [NSString stringWithFormat:@"%@ in",[_PickView.dataArray objectAtIndex:row1]];
        }
        [_userDataArray replaceObjectAtIndex:_settingSelectIndex withObject:height];
        
        [UserInfoHelper sharedInstance].userModel.height = height.integerValue;
        if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
            [UserInfoHelper sharedInstance].userModel.height = ceil(height.integerValue * 2.54);
        }
    }
    else if  (_settingSelectIndex == 4)
    {
        NSInteger row1 = [_PickView selectedRowInComponent:0];
        NSString *weight = [NSString stringWithFormat:@"%@ kg",[_PickView.dataArray objectAtIndex:row1]];
        if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
           weight = [NSString stringWithFormat:@"%@ lb",[_PickView.dataArray objectAtIndex:row1]];
        }
        [_userDataArray replaceObjectAtIndex:_settingSelectIndex withObject:weight];
        
        [UserInfoHelper sharedInstance].userModel.weight = weight.integerValue;
        if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
           [UserInfoHelper sharedInstance].userModel.weight = ceil(weight.integerValue/2.205);
        }
    }
    
    
    //同步用户信息 （把步长传送过去根据 身高的不同）
    [BLTSendModel sendSysUserInfo:^(id object, BLTAcceptModelType type) {
    }];
    
    [_tableView reloadData];
}


- (void)pickViewSetBirth
{
    NSString *birth = [UserInfoHelper sharedInstance].userModel.birthDay;
    NSArray *birthArray = [birth componentsSeparatedByString:@"-"];
    
    int year = [[birthArray objectAtIndex:0]intValue];
    int month = [[birthArray objectAtIndex:1]intValue];
    int days = [[birthArray objectAtIndex:2]intValue];
    [_PickView selectRow:year - 1900 inComponent:0 animated:NO];
    [_PickView selectRow:month -1 inComponent:1 animated:NO];
    [_PickView selectRow:days -1 inComponent:2 animated:NO];
    
    nowMonth = month - 1;
    nowYear = year - 1;
    [self setdateArrayWithComponent:100 andRow:100];  //根据生日设置日历
    
}

- (void)didselect:(NSInteger)index
{
    _settingSelectIndex = index ;
    
    _PickView.dataArray = nil;
    _PickView.dataArray2 = nil;
    _PickView.dataArray3 = nil;
    
    if (_settingSelectIndex == 1)
    {
        NSMutableArray * year = [[NSMutableArray alloc] init];
        
        for (int i = 1900; i < 2016; i++)
        {
            [year addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        NSMutableArray * month = [[NSMutableArray alloc] init];
        
        for (int i = 1; i < 13; i++)
        {
            [month addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        NSMutableArray * day = [[NSMutableArray alloc] init];
        
        for (int i = 1; i < 31; i++)
        {
            [day addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        _PickView.dataArray = [[NSArray alloc] initWithArray:year];
        _PickView.dataArray2 = [[NSArray alloc] initWithArray:month];
        _PickView.dataArray3 = [[NSArray alloc] initWithArray:day];
        [self pickViewSetBirth];
    }
    else if(_settingSelectIndex == 2)
    {
        _PickView.dataArray = [[NSArray alloc]initWithObjects:KK_Text(@"Boy"), KK_Text(@"Girl"), nil];
        [_PickView selectRow:[UserInfoHelper sharedInstance].userModel.genderSex inComponent:0 animated:NO];
    }
    else if(_settingSelectIndex == 3)
    {
        NSMutableArray * height = [[NSMutableArray alloc] init];
        
        for (int i = 30; i < 231; i++)
        {
            [height addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _PickView.dataArray = [[NSArray alloc] initWithArray:height];
        
        [_PickView selectRow:[UserInfoHelper sharedInstance].userModel.height - 30 inComponent:0 animated:NO];
        if(![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
            [_PickView selectRow:(int)([UserInfoHelper sharedInstance].userModel.height/2.54) - 30 inComponent:0 animated:NO];
        }
        
    }else if (_settingSelectIndex == 4)
    {
        NSMutableArray * weight = [[NSMutableArray alloc] init];
        
        for (int i = 25; i < 256; i++)
        {
            [weight addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        _PickView.dataArray = [[NSArray alloc] initWithArray:weight];
        [_PickView selectRow:[UserInfoHelper sharedInstance].userModel.weight - 25 inComponent:0 animated:NO];
        if(![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
            [_PickView selectRow:(int)([UserInfoHelper sharedInstance].userModel.weight * 2.205) - 25 inComponent:0 animated:NO];
        }
    }
    [_pickViewBg showView];
    self.adorableView.hidden = NO;
}

- (void)settingButtonClick:(UIButton*)sender
{
        NSLog(@"settingButtonClick>>>%ld",sender.tag);
        UserProfileViewTableCell *cell = (UserProfileViewTableCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.textField resignFirstResponder];
    
        _settingSelectIndex = sender.tag ;
        
        _PickView.dataArray = nil;
        _PickView.dataArray2 = nil;
        _PickView.dataArray3 = nil;
    
    if (_settingSelectIndex == 1)
    {
        NSMutableArray * year = [[NSMutableArray alloc] init];
        
        for (int i = 1900; i < 2016; i++)
        {
            [year addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        NSMutableArray * month = [[NSMutableArray alloc] init];
        
        for (int i = 1; i < 13; i++)
        {
            [month addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        NSMutableArray * day = [[NSMutableArray alloc] init];
        
        for (int i = 1; i < 31; i++)
        {
            [day addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        _PickView.dataArray = [[NSArray alloc] initWithArray:year];
        _PickView.dataArray2 = [[NSArray alloc] initWithArray:month];
        _PickView.dataArray3 = [[NSArray alloc] initWithArray:day];
        [self pickViewSetBirth];
    }
    else if(_settingSelectIndex == 2)
    {
        _PickView.dataArray = [[NSArray alloc] initWithObjects:KK_Text(@"Boy"), KK_Text(@"Girl"), nil];
        
    }
    else if(_settingSelectIndex == 3)
    {
        NSMutableArray * height = [[NSMutableArray alloc] init];
        
        for (int i = 30; i < 231; i++)
        {
            [height addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _PickView.dataArray = [[NSArray alloc] initWithArray:height];
        
        [_PickView selectRow:[UserInfoHelper sharedInstance].userModel.height - 30 inComponent:0 animated:NO];
        if(![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
            [_PickView selectRow:(int)([UserInfoHelper sharedInstance].userModel.height/2.54) - 30 inComponent:0 animated:NO];
        }


    }else if (_settingSelectIndex == 4)
    {
        NSMutableArray * weight = [[NSMutableArray alloc] init];
        
        for (int i = 25; i < 206; i++)
        {
            [weight addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        _PickView.dataArray = [[NSArray alloc] initWithArray:weight];
        [_PickView selectRow:[UserInfoHelper sharedInstance].userModel.weight - 25 inComponent:0 animated:NO];
        if(![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
            [_PickView selectRow:(int)([UserInfoHelper sharedInstance].userModel.weight * 2.205) - 25 inComponent:0 animated:NO];
        }
    }
    [_pickViewBg showView];
    self.adorableView.hidden = NO;
}
////根据所选年月份,确定日期的最大值
- (void)setdateArrayWithComponent:(NSInteger)component andRow:(NSInteger)row {
    int daynum = 31;
    BOOL isLeapYear = NO;
    
    if (component == 1) {
        nowMonth = row;
    }
    if (component == 0) {
        nowYear = row+1900;
    }
    NSLog(@"nowYear == %ld,nowMonth == %ld",nowYear,nowMonth);
    if (((nowYear%4==0)&&(nowYear%100!=0))||(nowYear%400==0)) {
        isLeapYear = YES;
    }else {
        isLeapYear = NO;
    }

    switch (nowMonth) {
        case 1:
            if (isLeapYear) {
                daynum = 29;
            }else {
                daynum = 28;
            }
            break;
        case 3:
        case 5:
        case 8:
        case 10:
            daynum = 30;
            break;
        case 0:
        case 2:
        case 4:
        case 6:
        case 7:
        case 9:
        case 11:
            daynum = 31;
            break;
        default:
            break;
    }

    NSMutableArray * day = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= daynum; i++)
    {
        [day addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _PickView.dataArray3 = [[NSArray alloc] initWithArray:day];
    
}

- (void)loadNaBar
{
    self.tipTitle.text = KK_Text(@"Personal Profile");
    
    self.leftButton.titleNormal = @"";
    self.leftButton.imageNormal = @"Device_back_5s@2x.png";
    //self.leftButton.bgImageHighlight = @"Device_back_5s@2x.png";
}

- (void)rightBarButton
{
    NSLog(@"确定>>>>");

    [[UserInfoHelper sharedInstance] updateUserInfoToDevice:YES];
    [self performSelector:@selector(backButton:) withObject:nil afterDelay:2.0]; ////2秒后返回主页
    
}

- (void)backButton:(UIButton *)sender
{
    NSLog(@"返回>>>>");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadViewSetup
{
    self.view.backgroundColor = UIColorHEX(0x262626);
    
    CGFloat offsetY = FitScreenNumber(160, 210, 230, 230, 230);

    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, offsetY)];
    _topView.backgroundColor = KK_MainColor;
    //[self.view addSubview:_topView];
    
    _userHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - 96)/2, offsetY / 7, 96, 96)];
    _userHeadImage.layer.cornerRadius = 96/2;
    _userHeadImage.clipsToBounds = YES;
    _userHeadImage.image = UIImageNamed(@"mine_big_circle_5s@2x.png");
    //设置为保存的头像
    if ([[UserInfoHelper sharedInstance] getUserHeadImage]) {
        _userHeadImage.image = [[UserInfoHelper sharedInstance] getUserHeadImage];
    }
    [_topView addSubview:_userHeadImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectHeadImage)];
    _userHeadImage.userInteractionEnabled = YES;
    [_userHeadImage addGestureRecognizer:tap];
    
    _userName = [UILabel simpleWithRect:CGRectMake(0, _userHeadImage.totalHeight + offsetY / 18, Maxwidth, 25)];
    _userName.font = DEFAULT_FONTHelvetica(14.0);
    [_topView addSubview:_userName];
    
//    _userHeadImage.image = UIImageNamed(@"mine_big_circle_5s@2x.png");
    if ([UserInfoHelper sharedInstance].userModel.nickName == NULL)
    {
        _userName.text = @"user";
    }
    else
    {
        _userName.text = [UserInfoHelper sharedInstance].userModel.nickName;
    }
}

- (void)loadTableView
{
    _titleArray = [[NSArray alloc] initWithObjects:KK_Text(@"Username"),
                   KK_Text(@"Birthday"),
                   KK_Text(@"Gender"),
                   KK_Text(@"Height"),
                   KK_Text(@"Weight"), nil];
    _userDataArray = [[NSMutableArray alloc] init];
    
    if ([UserInfoHelper sharedInstance].userModel.nickName == NULL)
    {
        [_userDataArray addObject:@"user"];
    }
    else
    {
        [_userDataArray addObject:[NSString stringWithFormat:@"%@",[UserInfoHelper sharedInstance].userModel.nickName]];
    }
    
    [_userDataArray addObject:[NSString stringWithFormat:@"%@",[UserInfoHelper sharedInstance].userModel.birthDay]];
    
    if ([UserInfoHelper sharedInstance].userModel.genderSex == 1)
    {
          [_userDataArray addObject:KK_Text(@"Girl")];
    }
    else
    {
          [_userDataArray addObject:KK_Text(@"Boy")];
    }
    
    NSString *heightString = [NSString stringWithFormat:@"%ld cm",[UserInfoHelper sharedInstance].userModel.height];
    NSString *weightString = [NSString stringWithFormat:@"%ld kg",[UserInfoHelper sharedInstance].userModel.weight];
    if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
        heightString = [NSString stringWithFormat:@"%d in",(int)([UserInfoHelper sharedInstance].userModel.height/2.54)];
        weightString = [NSString stringWithFormat:@"%d lb",(int)([UserInfoHelper sharedInstance].userModel.weight * 2.205)];
    }
    [_userDataArray addObject:heightString];
    [_userDataArray addObject:weightString];

    
//    [_userDataArray addObject:@"180 cm"];
//    [_userDataArray addObject:@"72 kg"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, self.view.width, self.view.height - 84) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _topView;
    
    [self setExtraCellLineHidden:_tableView];
}

- (void)selectHeadImage
{
    if (!_headView)
    {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, 240)];
        _headView.image = [UIImage image:@"userphoto_5@2x.png"];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 240*4/5, Maxwidth, 44)];
        [cancelButton setTitle:KK_Text(@"Cancel") forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelbuttonClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:cancelButton];
        
        UIButton *takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0,240*3/5, Maxwidth, 44)];
        [takePhotoButton setTitle:KK_Text(@"Photograph") forState:UIControlStateNormal];
        [takePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [takePhotoButton addTarget:self action:@selector(takePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:takePhotoButton];
        
        UIButton *selectPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 240*2/5, Maxwidth, 44)];
        [selectPhotoButton setTitle:KK_Text(@"Choose Current Photo") forState:UIControlStateNormal];
        [selectPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:selectPhotoButton];
        
        UIButton *deletePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 240*1/5, Maxwidth, 44)];
        [deletePhotoButton setTitle:KK_Text(@"Remove photo") forState:UIControlStateNormal];
        [deletePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [deletePhotoButton addTarget:self action:@selector(deletePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:deletePhotoButton];
        
        UIButton *settingImageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, 44)];
        [settingImageButton setTitle:KK_Text(@"Profile Photo Setting")  forState:UIControlStateNormal];
        [settingImageButton setTitleColor:UIColorHEX(0x888b90) forState:UIControlStateNormal];
        [settingImageButton setFontSize:12.0];
        [settingImageButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:settingImageButton];

    }
    
    [_headView popupWithtype:PopupViewOption_colorLump succeedBlock:^(UIView *View)
     {
//          View.frame = CGRectMake(0, Maxheight - 240, Maxwidth, 240);
         View.center = CGPointMake(self.view.center.x,Maxheight - 150);
         
     } dismissBlock:^(UIView *View) {
         
     }];
}

-(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = UIColorHEX(0x272727);
    [tableView setTableFooterView:view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"UserProfileTableViewCell";
    UserProfileViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil)
    {
        cell = [[UserProfileViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        cell.frame = CGRectMake(0, 0, tableView.width, 55.0);
    }

    [cell userProfileUpateCellTitle:[_titleArray objectAtIndex:indexPath.row] update:[_userDataArray objectAtIndex:indexPath.row ]index:indexPath.row];
    cell.settingButton.tag = indexPath.row;
    [cell.settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row ==0 )
    {
        cell.textField.delegate = self;
        cell.textField.tag = 100;
    }

    return  cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*
    //设置动画的名字
    [UIView beginAnimations:@"Animation"context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.25];
    //使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    self.view.frame =CGRectMake(self.view.x,self.view.y ,self.view.width,self.view.height);
    //设置动画结束
    [UIView commitAnimations]; */
    
    [_userDataArray replaceObjectAtIndex:0 withObject:textField.text];

    if (textField.text.length > 0)
    {
        _userName.text = textField.text;
        [UserInfoHelper sharedInstance].userModel.nickName = textField.text;
    }
    [_tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return;
    }
    UserProfileViewTableCell *cell = (UserProfileViewTableCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.textField resignFirstResponder];
    [self didselect:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark ------- 设置用户头像 ---------
///照相机设置头像
- (void)takePhotoButtonClick:(UIButton *)sender
{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    _picker.sourceType = sourceType;
    [self.navigationController presentViewController:_picker animated:YES completion:^{
        
    }];
    [_headView dismissPopup];
}

- (void)deletePhotoButtonClick:(UIButton *)sender {
    [[UserInfoHelper sharedInstance] removeUserHeadImage];
    _userHeadImage.image = UIImageNamed(@"mine_big_circle_5s@2x.png");
    [_headView dismissPopup];
}

- (void)selectPhotoButtonClick:(UIButton *)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.sourceType = sourceType;
    [self.navigationController presentViewController:_picker animated:YES completion:^{
       
    }];
    [_headView dismissPopup];
}


#pragma mark --- UINavigationControllerDelegate ---
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    // bug fixes: UIImagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

#pragma mark --- UIImagePickerControllerDelegate ---
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UserInfoHelper sharedInstance] saveHeadImageToFileCacheWithPicker:_picker withInfo:info];
    [picker dismissViewControllerAnimated:YES completion:^{
        _userHeadImage.image = [[UserInfoHelper sharedInstance] getUserHeadImage];
        [_headView dismissPopup];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [_headView dismissPopup];
    }];

}

- (void)cancelbuttonClick
{
    [_headView dismissPopup];
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
