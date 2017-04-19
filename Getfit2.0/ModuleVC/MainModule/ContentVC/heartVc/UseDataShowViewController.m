//
//  UseDataShowViewController.m
//  Aircraft cup
//
//  Created by 黄建华 on 15/10/23.
//  Copyright © 2015年 kenny. All rights reserved.
//

#import "UseDataShowViewController.h"
#import "BLTSendModel.h"
#import "PedometerHelper.h"

@interface UseDataShowViewController ()

@end

@implementation UseDataShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    imageView.image = UIImageNamed(@"bg_day_5s.png");
    [self.view addSubview:imageView];
    
    /*
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    topView.backgroundColor = BGCOLOR;
    [self.view addSubview:topView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.5;
    [self.view addSubview:line];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    backButton.bgImageNormal = @"back_5s@2x.png";
    [backButton addTarget:self action:@selector(backMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 33, 100, 20)];
    titleLable.text = KK_Text(@"Heart");
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.font = [UIFont systemFontOfSize:16];
    titleLable.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLable]; */
    
    CGFloat offsetY = FitScreenNumber(8, 12, 12, 12, 12);
    _showDataView = [[showRemarkView alloc] initWithFrame:CGRectMake(5, offsetY, self.view.width - 10, 200)];
    // _showDataView.backgroundColor = UIColorHEXA(0xffffff, 1.0);
    [self.view addSubview:_showDataView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_showDataView addGestureRecognizer:tap];
    
    offsetY = FitScreenNumber(0, 20, 30, 30, 30);
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, _showDataView.totalHeight + 85 + offsetY, self.view.width/3, 36)];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width/3, label1.y, self.view.width/3, 36)];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width/3*2, label1.y, self.view.width/3, 36)];
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label3];
    label1.textAlignment = NSTextAlignmentCenter;
    label2.textAlignment = NSTextAlignmentCenter;
    label3.textAlignment = NSTextAlignmentCenter;
    label1.text = KK_Text(@"MaxHeart");
    label2.text = KK_Text(@"AverageHeart");
    label3.text = KK_Text(@"MinHeart");
    
    CGFloat offsetX = (self.view.width - 3 * 80) / 4;
    
    _maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, _showDataView.totalHeight + offsetY, 80, 80)];
    _maxLabel.textColor = [UIColor whiteColor];
    _maxLabel.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:_maxLabel];
    [_maxLabel addCorner:nil withWidth:0];
    _maxLabel.backgroundColor = KK_MainColor;
    
    _aveLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX*2 + 80, _showDataView.totalHeight + offsetY, 80, 80)];
    _aveLabel.textColor = [UIColor whiteColor];
    _aveLabel.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:_aveLabel];
    [_aveLabel addCorner:nil withWidth:0];
    _aveLabel.backgroundColor = KK_MainColor;

    _minLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX*3 + 160, _showDataView.totalHeight + offsetY, 80, 80)];
    _minLabel.textColor = [UIColor whiteColor];
    _minLabel.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:_minLabel];
    [_minLabel addCorner:nil withWidth:0];
    _minLabel.backgroundColor = KK_MainColor;

    _maxLabel.textAlignment = NSTextAlignmentCenter;
    _minLabel.textAlignment = NSTextAlignmentCenter;
    _aveLabel.textAlignment = NSTextAlignmentCenter;
    
    _switchBtn = [[CustomSwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    _switchBtn.offImageName = @"Device_btn_2_5s@2x.png";
    _switchBtn.onImageName = @"Device_btn_1_5s@2x.png";
    _switchBtn.btnImageName = @"Device_Stripe_1_5s@2x";
    _switchBtn.on = NO;
//    _switchBtn.switchBtn.selected = [UserInfoHelper sharedInstance].userModel.heartOpen;
    [_switchBtn setBtnState:_switchBtn.switchBtn.selected];
    [_switchBtn.switchBtn addTarget:self action:@selector(alarmSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:_switchBtn];
    
    UILabel *heartValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label3.totalHeight, self.view.width/3, 36)];
    heartValueLabel.textColor = [UIColor whiteColor];
    heartValueLabel.font = [UIFont systemFontOfSize:16];
    heartValueLabel.textAlignment = NSTextAlignmentCenter;
    heartValueLabel.text = KK_Text(@"Heart");
    [self.view addSubview:heartValueLabel];
    
    _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX*2 + 80, label2.totalHeight + 5, 80, 80)];
    _heartLabel.textColor = [UIColor whiteColor];
    _heartLabel.textAlignment = NSTextAlignmentCenter;
    _heartLabel.font = [UIFont systemFontOfSize:20.0];
    _heartLabel.text = @"--";
    [self.view addSubview:_heartLabel];
    [_heartLabel addCorner:nil withWidth:0];
    _heartLabel.backgroundColor = KK_MainColor;
    
    heartValueLabel.center = CGPointMake(_maxLabel.center.x, _heartLabel.center.y);
    _switchBtn.center = CGPointMake(_minLabel.center.x, _heartLabel.center.y);

    if ([BLTAcceptModel sharedInstance].isOpenHeart) {
        _heartLabel.text = @"0";
        _maxLabel.text = @"0";
        _minLabel.text = @"0";
        _aveLabel.text = @"0";
    } else {
        _heartLabel.text = @"-";
        _maxLabel.text = @"-";
        _minLabel.text = @"-";
        _aveLabel.text = @"-";
    }
    
    _heartDataArray = [[NSMutableArray alloc] init];
    
    [self updateDataWithAnimation:NO];
}

- (void)addDownLine:(CGRect)rect
{
    //UIColorHEX(0x888b90)
    
    UIView *downLine = [[UIView alloc] initWithFrame:rect];
    downLine.backgroundColor = UIColorHEX(0x888b90);
    [self.view addSubview:downLine];
}

// 视图控制
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DEF_WEAKSELF;
    
    [BLTAcceptModel sharedInstance].heartBlock = ^ (id object, BLTAcceptModelType type) {
    };
    
    [BLTAcceptModel sharedInstance].realTimeHeartBlock = ^ (id object, BLTAcceptModelType type) {
        [weakSelf updateTextLabel:object];
    };
    
    [BLTAcceptModel sharedInstance].heartStatusBlock = ^ (id object, BLTAcceptModelType type) {
        [weakSelf updateHeartStatus];
    };
    
//    _switchBtn.switchBtn.selected = [UserInfoHelper sharedInstance].userModel.heartOpen;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTAcceptModel sharedInstance].heartBlock = nil;
    [BLTAcceptModel sharedInstance].realTimeHeartBlock = nil;
    [BLTAcceptModel sharedInstance].heartStatusBlock = nil;
}

- (void)updateHeartStatus
{
//    _switchBtn.switchBtn.selected = [BLTAcceptModel sharedInstance].isOpenHeart;
//    _switchBtn.on = [BLTAcceptModel sharedInstance].isOpenHeart;
//    [_switchBtn setBtnState:[BLTAcceptModel sharedInstance].isOpenHeart];
    
    if ([BLTAcceptModel sharedInstance].isOpenHeart) {
        _heartLabel.text = @"0";
        _maxLabel.text = @"0";
        _minLabel.text = @"0";
        _aveLabel.text = @"0";
    } else {
        _heartLabel.text = @"-";
        _maxLabel.text = @"-";
        _minLabel.text = @"-";
        _aveLabel.text = @"-";
    }
}

- (void)alarmSwitchButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _switchBtn.on = sender.selected;
    [_switchBtn setBtnState:sender.selected];
    
    /*
    [BLTAcceptModel sharedInstance].isOpenHeart = _switchBtn.on;
    
    if ([BLTAcceptModel sharedInstance].isOpenHeart) {
        _heartLabel.text = @"0";
        _maxLabel.text = @"0";
        _minLabel.text = @"0";
        _aveLabel.text = @"0";
        [_heartDataArray removeAllObjects];
    } else {
        _heartLabel.text = @"-";
        _maxLabel.text = @"-";
        _minLabel.text = @"-";
        _aveLabel.text = @"-";
    } */
    
    [UserInfoHelper sharedInstance].userModel.heartOpen = sender.selected;
    
    [BLTSendModel sendHeartOpenWith:sender.selected
                          withBlock:^(id object, BLTAcceptModelType type) {
                              
                          }];
}

- (void)updateTextLabel:(NSArray *)numbers;
{
    _currentHeart = [numbers[3] integerValue];
    _heartLabel.text = [NSString stringWithFormat:@"%ld", [numbers[3] integerValue]];
    
    _maxLabel.text = [NSString stringWithFormat:@"%ld", [numbers[0] integerValue]];
    _aveLabel.text = [NSString stringWithFormat:@"%ld", [numbers[1] integerValue]];
    _minLabel.text = [NSString stringWithFormat:@"%ld", (long)[numbers[2] integerValue]];
    
    /*
    if (!_switchBtn.switchBtn.selected) {
        _switchBtn.switchBtn.selected = [BLTAcceptModel sharedInstance].isOpenHeart;
        _switchBtn.on = [BLTAcceptModel sharedInstance].isOpenHeart;
        [_switchBtn setBtnState:[BLTAcceptModel sharedInstance].isOpenHeart];
    } */
    
    [self updateDataWithAnimation:NO];
}

- (void)tapClick:(UITapGestureRecognizer*) tap
{
    [self updateDataWithAnimation:YES];
}

// 更新心率数据,
- (void)updateDataWithAnimation:(BOOL)isAnimation
{
    /*
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 96; i++) {
        NSInteger data = random() % 60 + 30;
        [array addObject:@(data)];
        
        NSLog(@"point =  %d", data );

    } */
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray *heartArray = [BLTAcceptModel sharedInstance].heartArray;

    CGFloat widthValue = (self.view.width - 50) / 96;
    
    for (int i = 0; i < heartArray.count; i++) {
        CGPoint point;
        int random = [[heartArray objectAtIndex:i] intValue];
        if (random < 30) {
            point = CGPointMake(i * widthValue, 150);
        } else {
            point = CGPointMake(i * widthValue, 150 - 150.0/90 * (random - 30));
        }
        
        // NSLog(@"point = %@ %d", NSStringFromCGPoint(point), [[heartArray objectAtIndex:i] intValue]);
        
        [dataArray addObject:[NSValue valueWithCGPoint:point]];
    }
    
    [_showDataView updateShowView:dataArray isAnimation:isAnimation];
}

- (void)buttonClick:(UIButton *)sender
{
    
}

- (void)backMain
{
    [self.navigationController popViewControllerAnimated:YES];
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
