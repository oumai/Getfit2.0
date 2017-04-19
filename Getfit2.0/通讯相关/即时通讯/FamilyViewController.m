//
//  FamilyViewController.m
//  StoryPlayer
//
//  Created by zhanghao on 15/12/4.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "FamilyViewController.h"
#import "NoneFamilyTipsView.h"
#import "BaseNavigation.h"
#import "CreatFamilyViewController.h"
#import "ZbarScannerViewController.h"
#import "FamilyListCell.h"
#import "SearchResultViewController.h"
#import "IMObject.h"
#import "IQKeyboardManager.h"
#import "KKASIHelper.h"
#import "QrCodeScanerVC.h"

@interface FamilyViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIImageView *settingImageView;

@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (nonatomic, assign) BOOL isLoginVC;
@property (weak, nonatomic) IBOutlet UIView *navBarView;

@property (nonatomic, strong) NoneFamilyTipsView *noFamily;

@end

@implementation FamilyViewController
{
    NSMutableArray *_familyArray;
}

- (IBAction)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  创建家庭圈  导航栏顶部左边按钮的点击事件
 *
 */
- (IBAction)CreatTourismCircle:(UIButton *)sender {
    
    CreatFamilyViewController *creat = [[CreatFamilyViewController alloc]initWithTitle:@"CreatFamilyViewController"];
    [creat setCreatCompleteBlock:^{
        [self getMyFamilyInfomation];
    }];
    [self.navigationController pushViewController:creat animated:YES];
}

///顶部右上角按钮
- (IBAction)setting:(UIButton *)sender
{
    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:KK_Text(@"Tourism") cancelButtonItem:[RIButtonItem itemWithLabel:KK_Text(@"Cancel")] destructiveButtonItem:nil otherButtonItems:[RIButtonItem itemWithLabel:KK_Text(@"Scan QR code") action:^{
        [self goErweima];
    }],[RIButtonItem itemWithLabel:KK_Text(@"SearchID") action:^{
        [self goSearch:nil];
    }], [RIButtonItem itemWithLabel:KK_Text(@"Create group") action:^{
        [self CreatTourismCircle:nil];
    }], nil];
    [sheet showInView:self.view];
}
///修改资料
-(void)changeInfomations
{
    
}
///加入家庭圈
-(void)attentFamily
{
    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:KK_Text(@"Tourism") cancelButtonItem:[RIButtonItem itemWithLabel:KK_Text(@"Cancel")] destructiveButtonItem:nil otherButtonItems:[RIButtonItem itemWithLabel:KK_Text(@"Scan QR code") action:^{
        [self goErweima];
    }],[RIButtonItem itemWithLabel:KK_Text(@"SearchID") action:^{
        [self goSearch:nil];
    }], [RIButtonItem itemWithLabel:KK_Text(@"Create group") action:^{
        [self CreatTourismCircle:nil];
    }], nil];
    [sheet showInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = KK_MainColor;
    
    [self setTitle:KK_Text(@"Tourism")];
    self.hidesBottomBarWhenPushed = YES;

    _navBarView.backgroundColor = KK_MainColor;
    self.view.backgroundColor = KK_BgColor;
    
    _topTitleLabel.text = KK_Text(@"Tourism");
    
}
///显示没有家庭圈的view
-(void)showNoFamilyView
{
    if (_noFamily) {
        _noFamily.hidden = NO;
    } else {
        _noFamily = [[NSBundle mainBundle]loadNibNamed:@"NoneFamilyTipsView" owner:self options:nil].lastObject;
        __weak NoneFamilyTipsView *weakView = _noFamily;
        DEF_WEAKSELF_(FamilyViewController);
        [_noFamily setCreatBlock:^{
            CreatFamilyViewController *creat = [[CreatFamilyViewController alloc]initWithTitle:@"CreatFamilyViewController"];
            [creat setCreatCompleteBlock:^{
                [weakSelf getMyFamilyInfomation];
                [weakView removeFromSuperview];
            }];
            [weakSelf.navigationController pushViewController:creat animated:YES];
        } AndErWeiMaBlock:^{
            [weakSelf goErweima];
        } AndSearchBlock:^{
            [weakSelf goSearch:nil];
        }];
        _noFamily.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
        _noFamily.backgroundColor = KK_BgColor;
        [self.view addSubview:_noFamily];
    }
}

///扫描二维码加入家庭圈
-(void)goErweima
{
    /*
    ZbarScannerViewController *scanner = [[ZbarScannerViewController alloc]initWithTitle:KK_Text(@"扫描二维码")];
    [scanner setScannerBlock:^(NSString *string) {
        [self goSearch:string];
    }];
    [self.navigationController pushViewController:scanner animated:YES]; */
    
    DEF_WEAKSELF_(FamilyViewController);
    QrCodeScanerVC *vc = [[QrCodeScanerVC alloc] initWithBlock:^(id object) {
        [weakSelf goSearch:object];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self goSearch:searchBar.text];
}
-(void)goSearch:(NSString *)searchID
{
    SearchResultViewController *result = [[SearchResultViewController alloc] initWithTitle:KK_Text(@"Search")];
    
    if (searchID) {
        [result setFamilyID:searchID];
    }
    
    [result setAttentCompleteBlock:^{
        [self getMyFamilyInfomation];
    }];
    
    [self.navigationController pushViewController:result animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
///获取所有家庭圈
-(void)getMyFamilyInfomation
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REQMethod(@"/family/list")]];
    [request addPostValue:G_USERTOKEN forKey:@"access_token"];
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        ZHDEBUG(weakRequest.responseString);
        NSDictionary *dic= weakRequest.responseString.JSONValue;
        if (formartStr(dic[@"ret"]).intValue !=0)
        {
            [self showMessage:formartStr(dic[@"ret"]).intValue];
            return;
        }
        else
        {
            NSArray *data = dic[@"data"];
            if (data.count>0)
            {
                if (!_familyArray)
                {
                    _familyArray = [NSMutableArray array];
                }
                
                [_familyArray removeAllObjects];
                [_familyArray addObjectsFromArray:data];
                
                [_noFamily removeFromSuperview];
                [_table reloadData];
                [[IMObject shareObject] updataTribe:NO];
            }
            else
            {
                [_table reloadData];
                [self showNoFamilyView];
            }
        }
    }];
    [request setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:KK_Text(@"Server connection failed")];
    }];
    [request setTimeOutSeconds:TimeOut];
    [request startAsynchronous];
    [SVProgressHUD show];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // [IQKeyboardManager sharedManager].enable = YES;
    
    [self getMyFamilyInfomation];
}

#pragma mark TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _familyArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyListCell *cell = [[NSBundle mainBundle]loadNibNamed:@"FamilyListCell" owner:self options:nil].lastObject;
    [cell refreshUIWithDictionary:_familyArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dic = _familyArray[indexPath.row];
    NSString *familyID = formartStr(dic[@"id"]);
    NSString *tribeID = formartStr(dic[@"tribe_id"]);
    
    [KKASIHelper sharedInstance].familyID = familyID;
    [KKASIHelper sharedInstance].tribeLogo = formartStr(dic[@"head_img"]);

    NSLog(@"id : %@, %@", [KKASIHelper sharedInstance].familyID, tribeID);

    [[IMObject shareObject] getTribeListWhileCompelete:^(NSArray *array) {
        int i = 0;
        for (YWTribe *tribe in array)
        {
            if ([tribe.tribeId isEqualToString:tribeID])
            {
                NSDictionary *dic =  _familyArray[indexPath.row];
                NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/family/detail/%@",ServerURL,dic[@"id"]]];
                
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
                [request addPostValue:G_USERTOKEN forKey:@"access_token"];
                __weak ASIFormDataRequest *weakRequest = request;
                [request setCompletionBlock:^{
                    [SVProgressHUD dismiss];
                    
                    ZHDEBUG(weakRequest.responseString);
                    NSDictionary *dic= weakRequest.responseString.JSONValue;
                    
                    int is_manager = [dic[@"data"][@"is_manager"] intValue];  //为1就是群主
                    [[NSUserDefaults standardUserDefaults] setInteger:is_manager forKey:@"is_manager"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [IQKeyboardManager sharedManager].enable = NO;
                    [[SPKitExample sharedInstance]exampleOpenConversationViewControllerWithTribe:tribe fromNavigationController:self.navigationController];
                    
                }];
                [request setFailedBlock:^{
                    [SVProgressHUD showErrorWithStatus:KK_Text(@"Server connection failed")];
                }];
                [request setTimeOutSeconds:TimeOut];
                [request startAsynchronous];
                [SVProgressHUD show];

                
                break;
            }
            i++;
            ///如果在群列表中未找到当前群，则更新
            if (i==array.count)
            {
                [self updataTribeAndSearchFamily:familyID withTribeID:tribeID];
            }
        }
    }];
}
-(void)updataTribeAndSearchFamily:(NSString *)familyID withTribeID:(NSString *)tribeID
{
    [[IMObject shareObject] updataTribeWhileComplete:^(NSArray *array) {
        for (YWTribe *tribe in array)
        {
            if ([tribe.tribeId  isEqualToString:tribeID])
            {
                [[SPKitExample sharedInstance]exampleOpenConversationViewControllerWithTribe:tribe fromNavigationController:self.navigationController];
                break;
            }
        }
    }];
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
