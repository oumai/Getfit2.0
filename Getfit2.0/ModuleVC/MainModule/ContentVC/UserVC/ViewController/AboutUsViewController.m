//
//  AboutusViewController.m
//  AJBracelet
//
//  Created by Choujeff on 15/9/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "AboutusViewController.h"
#import "UserProfileViewTableCell.h"

@interface AboutusViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *AboutTitle;
@property (nonatomic, strong) NSArray *AboutSubTitle;
@property (nonatomic, strong) UIView *topView;

@end

@implementation AboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNaBar];

    [self apearHeadview];
    
    [self loadTableView];

//    [self loadPickUpView];
    // Do any additional setup after loading the view.
}
- (void)loadNaBar
{
    self.view.backgroundColor = UIColorHEX(0x262626);
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, 64)];
    topView.backgroundColor = BGCOLOR;
    [self.view addSubview:topView];
    
    UILabel *title = [UILabel simpleWithRect:CGRectMake(Maxwidth/2 - 60, 20 + 12, 120, 20)];
    title.font = DEFAULT_FONTHelvetica(16.0);
    title.text = KK_Text(@"About Us");
    title.textColor = [UIColor whiteColor];
    [self.view addSubview:title];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    backButton.bgImageNormal = @"Device_back_5s@2x.png";
    backButton.bgImageHighlight = @"Device_back_5s@2x.png";
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
- (void)backButton:(UIButton *)sender
{
    NSLog(@"返回>>>>");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)apearHeadview{

    self.view.backgroundColor = UIColorHEX(0x262626);
    CGFloat offsetY = FitScreenNumber(160, 210, 230, 230, 230);

    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, Maxwidth, offsetY)];
    _topView.backgroundColor = BGCOLOR;
    [self.view addSubview:_topView];
    
    UIImageView *Logoimage = [[UIImageView alloc] initWithFrame:CGRectMake((Maxwidth - 96)/2, offsetY / 9, 96, 96)];
    [Logoimage setImage:[UIImage image:@"Icon-aboutus-96.png"]];
    Logoimage.layer.cornerRadius = 96/2;
    Logoimage.clipsToBounds = YES;
    [_topView addSubview:Logoimage];
    
    UILabel *Productname = [UILabel simpleWithRect:CGRectMake(Maxwidth/2 - 60, Logoimage.totalHeight + offsetY / 25, 120, 25)];
    Productname.font = DEFAULT_FONTsize(12.0);
    Productname.text = @"GetFit";
    [_topView addSubview:Productname];
    
    UILabel *PDVersion = [UILabel simpleWithRect:CGRectMake(Maxwidth/2 - 60, Productname.frame.origin.y + 16, 120, 25)];
    PDVersion.font = DEFAULT_FONTsize(12.0);
    PDVersion.text = [NSString stringWithFormat:@"%@%@",KK_Text(@"Version ID"),DEVICESVISION];
    // [_topView addSubview:PDVersion];

}

- (void)loadTableView
{
    _AboutTitle = [[NSArray alloc]initWithObjects:KK_Text(@"Functions"),KK_Text(@"User Manual"),KK_Text(@"Normal Problem"), nil];
    _AboutSubTitle = [[NSArray alloc]initWithObjects:@"",@"",@"", nil];
    UITableView *AboutusTable = [[UITableView alloc] initWithFrame:CGRectMake(0,_topView.totalHeight, Maxwidth, self.view.height - 160) style:UITableViewStylePlain];
    
    AboutusTable.delegate = self;
    AboutusTable.dataSource = self;
    AboutusTable.backgroundColor = [UIColor clearColor];
    AboutusTable.scrollEnabled = NO;
    AboutusTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:AboutusTable];
    
    UILabel *Copyright = [UILabel simpleWithRect:CGRectMake(0, self.view.frame.size.height-45, Maxwidth, 30)];
    Copyright.text = @"Copyright @2015";
    Copyright.font = DEFAULT_FONTsize(12.0);
    [self.view addSubview:Copyright];
    
//    UIView *view = [UIView new];
//    view.backgroundColor = UIColorHEX(0x272727);
//    [AboutusTable setTableFooterView:view];
//    [self setExtraCellLineHidden:AboutusTable];
}
//-(void)setExtraCellLineHidden:(UITableView *)tableView
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = UIColorHEX(0x272727);
//    [_table setTableFooterView:view];
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
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
    }
    
    [cell userProfileUpateCellTitle:[_AboutTitle objectAtIndex:indexPath.row] update:[_AboutSubTitle objectAtIndex:indexPath.row ]index:indexPath.row];
    
    cell.userData.frame = CGRectMake(self.view.width - 110, (55 - 25)/2, 80, 25);
    cell.userData.textAlignment = NSTextAlignmentRight;
    cell.userData.font = DEFAULT_FONTHelvetica(10.0);
    cell.userData.textColor = UIColorHEX(0x888b90);
    
    cell.textField.hidden = YES;
    
    if (indexPath.row == 1)
    {
        cell.userData.hidden = YES;
    }else
    {
        cell.userData.hidden = NO;
    }
   
    cell.settingButton.hidden = YES;
    cell.settingButton.tag = indexPath.row;
    [cell.settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return  cell;
}
-(void)settingButtonClick:(id)sender{
    //尾部箭头点击响应
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击第几行响应
    
}

- (void)didReceiveMemoryWarning {
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
