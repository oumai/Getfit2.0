//
//  heightViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "HeightViewController.h"
#import "UnitSelectionView.h"
#import "Information.h"
#import "WeightViewController.h"



@interface HeightViewController ()

@property (nonatomic, strong)UnitSelectionView *UnitSelectView;

@end

@implementation HeightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadUnit];
    
//    [self loadScrollView];
    
    self.view.backgroundColor = UIColorHEX(0x272727);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self performSelector:@selector(delayOffSet) withObject:nil afterDelay:0.20];
}

- (void)loadUnit
{
    _UnitSelectView = [[UnitSelectionView alloc]initWithFrame:CGRectMake(20, 100, self.view.width-40, 132)];
    [self performSelector:@selector(delaysPush) withObject:nil afterDelay:0.2];
}

- (void)loadScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = FitScreenRect(CGRectMake(self.view.width - 16-110, 0, 110 ,300), CGRectMake(self.view.width - 16-110, 0, 110 ,400), CGRectMake(self.view.width - 16-110, 0, 110 ,400), CGRectMake(self.view.width - 16-110, 0, 110 ,400), CGRectMake(self.view.width - 16-110, 0, 110 ,400));
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    CGFloat height = FitScreenNumber(1800, 1900, 1900, 1900, 1900);
    _scrollView.contentSize = CGSizeMake(110, height);

    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    UIImageView *MetricHeight = [[UIImageView alloc] initWithFrame:CGRectMake(0, 18, 110, 1900)];
    MetricHeight.image = [UIImage imageNamed:@"mark_metric_height_5s"];

    [_scrollView addSubview:MetricHeight];
    
    UIImageView * Target = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/2+40, 214, self.view.width/2-40-16, 10)];
    Target.image = [UIImage imageNamed:@"login_arrow_2_5s"];
    [self.view addSubview:Target];
    
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    heightLabel.textColor =UIColorHEX(0xa5d448);
    heightLabel.textAlignment = NSTextAlignmentCenter;
    heightLabel.center = CGPointMake(self.view.center.x, 185);
    heightLabel.text = KK_Text(@"Height");
    heightLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:heightLabel];
    
    UILabel *UnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    UnitLabel.textColor =UIColorHEX(0xa5d448);
    UnitLabel.textAlignment = NSTextAlignmentCenter;
    UnitLabel.center = CGPointMake(self.view.center.x, 245);
    UnitLabel.text = @"cm";
    [self.view addSubview:UnitLabel];
    
    _heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    _heightLabel.textColor =UIColorHEX(0xa5d448);
    _heightLabel.textAlignment = NSTextAlignmentCenter;
    _heightLabel.center = CGPointMake(self.view.center.x, 217);
    _heightLabel.font = [UIFont systemFontOfSize:27.0];
    [self.view addSubview:_heightLabel];
    
//    CGFloat contentoffsetY = (240 - [UserInfoHelper sharedInstance].userModel.height ) * 10 ;
//    NSLog(@"contentoffsetY>>>>%f",contentoffsetY);
//    _scrollView.contentOffset = CGPointMake(0, contentoffsetY);
    
    if ([UserInfoHelper sharedInstance].userModel.genderSex == 0) {
        _scrollView.contentOffset = CGPointMake(0, 700);
        _heightLabel.text = [[UserInfoHelper sharedInstance].userModel showHeight];
    } else {
        _scrollView.contentOffset = CGPointMake(0, 800);
        _heightLabel.text = [[UserInfoHelper sharedInstance].userModel showHeight];
    }
    
    UIImageView *TopBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    TopBackGround.image = [UIImage imageNamed:@"mark_mask1_5s"];
    [self.view addSubview:TopBackGround];
    [self.view bringSubviewToFront:TopBackGround];
    
    UIImageView *ButtomBackGround = [[UIImageView alloc] initWithFrame:FitScreenRect(CGRectMake(0, 240, self.view.width, 80), CGRectMake(0, 260, self.view.width, 150), CGRectMake(0, 260, self.view.width, 150), CGRectMake(0, 260, self.view.width, 150), CGRectMake(0, 260, self.view.width, 150))];
    ButtomBackGround.image = [UIImage imageNamed:@"mark_mask2_5s"];
    [self.view addSubview:ButtomBackGround];
    [self.view bringSubviewToFront:ButtomBackGround];
    ///////如果是英制
    if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
        MetricHeight.frame = CGRectMake(0, 18, 130, 1900);
        MetricHeight.image = [UIImage image:@"mark_inch_heigh_5s"];
        UnitLabel.text = KK_Text(@"Feet");
        _scrollView.frame = FitScreenRect(CGRectMake(self.view.width - 16-130, 0, 130 ,300), CGRectMake(self.view.width - 16-130, 0, 130 ,400), CGRectMake(self.view.width - 16-130, 0, 130 ,400), CGRectMake(self.view.width - 16-130, 0, 130 ,400), CGRectMake(self.view.width - 16-130, 0, 130 ,400));
        _scrollView.contentSize = CGSizeMake(130, 1900);
        NSString *tmpHeight = [[UserInfoHelper sharedInstance].userModel showHeight];
        _heightLabel.text = [NSString stringWithFormat:@"%0.2f", tmpHeight.floatValue / 30.48];
        NSLog(@"height.floatValue = %f %@", tmpHeight.floatValue, _heightLabel.text);
        _scrollView.contentOffset = CGPointMake(0, (8.0 - tmpHeight.floatValue / 30.48) * 120.5 + 478);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
        // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(inchOffSet) object:nil];
         // [self performSelector:@selector(inchOffSet) withObject:nil afterDelay:0.2];
        [self inchOffSet];
    } else {
//        NSLog(@"offset == %f",_scrollView.contentOffset.y);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayOffSet) object:nil];
        [self performSelector:@selector(delayOffSet) withObject:nil afterDelay:0.20];
    }
 
}

- (void)delayOffSet
{
    int index = _scrollView.contentOffset.y/10;
    CGFloat more = ((int)(_scrollView.contentOffset.y))%10;
    
    if (_scrollView.contentOffset.y>=0 && _scrollView.contentOffset.y<=1500) {
        if (more >5) {
            [_scrollView setContentOffset:CGPointMake(0, (index+1) *10) animated:YES];
        } else {
            [_scrollView setContentOffset:CGPointMake(0, index*10) animated:YES];
        }
    }
    
    NSInteger height =240- (NSInteger)(_scrollView.contentOffset.y/10);
    [UserInfoHelper sharedInstance].userModel.height = height;
//    [Information sharedInstance].selectHeight =height;
    _heightLabel.text = [NSString stringWithFormat:@"%ld",(long)height];

}

- (void)inchOffSet
{
//    NSLog(@"offset == %f",_scrollView.contentOffset.y);
    int index = (_scrollView.contentOffset.y)/10;
    CGFloat more = ((int)(_scrollView.contentOffset.y))%10;
    
    if (_scrollView.contentOffset.y>=478 && _scrollView.contentOffset.y<=960) {
        if (more >5) {
          //[_scrollView setContentOffset:CGPointMake(0, (index+1) * 10) animated:YES];
        } else {
           // [_scrollView setContentOffset:CGPointMake(0, index * 10) animated:YES];
        }
    } else if (_scrollView.contentOffset.y < 478) {
        [_scrollView setContentOffset:CGPointMake(0, 478) animated:NO];
    } else if (_scrollView.contentOffset.y > 960) {
        [_scrollView setContentOffset:CGPointMake(0, 960) animated:NO];
    }
    
    CGFloat height = 8.0 - (_scrollView.contentOffset.y - 478)/120.5;
    [UserInfoHelper sharedInstance].userModel.height = (int)(height * 30.48);
    //    [Information sharedInstance].selectHeight =height;
    _heightLabel.text = [NSString stringWithFormat:@"%.2f",height];
    
    NSLog(@"[UserInfoHelper sharedInstance].userModel.height>>>%@",[[UserInfoHelper sharedInstance].userModel showHeight]);
    NSLog(@"%d>>>>>",[UserInfoHelper sharedInstance].userModel.height);
    NSLog(@"_scrollView.contentOffset.y >>>>%f",_scrollView.contentOffset.y);
    //bug
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self adjustScrollViewOfLeftViewPosition];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self adjustScrollViewOfLeftViewPosition];
}

- (void)adjustScrollViewOfLeftViewPosition
{
    if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
        if (_scrollView.contentOffset.y > 960)
        {
            [self performSelectorOnMainThread:@selector(resetTableViewContentOffsetToBottom) withObject:nil waitUntilDone:NO];
        }
        
        if (_scrollView.contentOffset.y < 478)
        {
            [self performSelectorOnMainThread:@selector(resetTableViewContentOffsetToUp) withObject:nil waitUntilDone:NO];
        }
    }
}

// 将tableView移动至底部
- (void)resetTableViewContentOffsetToBottom
{
    [_scrollView setContentOffset:CGPointMake(0.0, 960) animated:YES];
}

//  将tableView移动至顶部
- (void)resetTableViewContentOffsetToUp
{
    [_scrollView setContentOffset:CGPointMake(0.0, 478) animated:YES];
}

- (void)delaysPush
{
    if (ISCHANGEMODEL) {
        [_UnitSelectView popupWithtype:PopupViewOption_colorLump succeedBlock:^(UIView *view) {
             
         } dismissBlock:^(UIView *view) {
               [self loadScrollView];
         }];
    }
}

- (void)nextButtonClick:(UIButton *)Sender
{
    [Information sharedInstance].infoProgressIndex = 3;
    WeightViewController * WeightVc = [[WeightViewController alloc]init];
    [self.navigationController pushViewController:WeightVc animated:NO];
}

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
