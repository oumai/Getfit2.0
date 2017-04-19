//
//  DrinkVC.m
//  AJBracelet
//
//  Created by zorro on 16/1/11.
//  Copyright © 2016年 zorro. All rights reserved.
//

#import "DrinkVC.h"
#import "CustomSwitch.h"

#import "CustomPickerView.h"
#import "CustomsPickView.h"

#import "BLTSendModel.h"

@interface DrinkVC ()

@property (nonatomic, strong) UIView *adorableView;
@property (nonatomic, strong) CustomsPickView *pickViewBg;
@property (nonatomic, strong) CustomPickerView *PickView;
@property (nonatomic, strong) CustomSwitch *switchBtn;

@property (nonatomic, assign) NSInteger lastIndex;

@end

@implementation DrinkVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KK_BgColor;

    [self loadButtons];
    [self loadSettingButtons];
    [self loadPickUpView];
}

- (void)loadPickUpView
{
    _adorableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, Maxheight)];
    _adorableView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    _adorableView.hidden = YES;
    [self.view addSubview:_adorableView];
    
    _pickViewBg = [[CustomsPickView alloc] initWithFrame:CGRectMake(0, self.view.height, Maxwidth, 216 + 44)];
    [self.view addSubview:_pickViewBg];
    
    _PickView = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 44, Maxwidth, 216)];
    [_pickViewBg addSubview:_PickView];
    
    DEF_WEAKSELF;
    _pickViewBg.customPickClickBlock = ^(BOOL value)
    {
        if (value)
        {
            [weakSelf saveUserInfo];
        }
        weakSelf.adorableView.hidden = YES;
        [weakSelf.pickViewBg hiddenView];
    };
}

- (void)saveUserInfo
{
    DrinkModel *model = [UserInfoHelper sharedInstance].bltModel.drinkModel;
    NSInteger row1 = [_PickView selectedRowInComponent:0];
    if (_lastIndex == 1) {
        model.startTime = row1;
    } else if (_lastIndex == 2) {
        model.endTime = row1;
    } else if (_lastIndex == 3) {
        model.drinkWater = (row1 + 5) * 100;
    } else if (_lastIndex == 4) {
        model.timeInterval = row1 + 30;
    }
    
    [self updateContentForSubViews];
}

- (void)updateContentForSubViews
{
    DrinkModel *model = [UserInfoHelper sharedInstance].bltModel.drinkModel;
    NSArray *numberArray = @[[NSString stringWithFormat:@"%02ld:00", (long)model.startTime],
                             [NSString stringWithFormat:@"%02ld:00", (long)model.endTime],
                             @(model.drinkWater),
                             @(model.timeInterval),
                             @(model.isOpen)];
    
    for (int i = 0; i < 4; i++) {
        UIView *view = [self.view viewWithTag:2001 + i];
        UILabel *label = (UILabel *)[view viewWithTag:3000];
        label.text = [NSString stringWithFormat:@"%@", numberArray[i]];
    }
}

- (void)loadButtons
{
    self.tipTitle.text = KK_Text(@"Remind drink");
}

- (void)rightBarButton
{
    if ([BLTManager sharedInstance].isConnected)
    {
        [BLTSendModel sendDrinkWater:^(id object, BLTAcceptModelType type) {
            
        }];
        SHOWMBProgressHUD(KK_Text(@"Setting success"), nil, nil, NO, 2.0);
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(leftBarButton) object:nil];
        [self performSelector:@selector(leftBarButton) withObject:nil afterDelay:2.0];
    }
    else
    {
        SHOWMBProgressHUD(KK_Text(@"Device not Connected"), nil, nil, NO, 2.0);
    }
}

- (void)loadSettingButtons
{
    DrinkModel *model = [UserInfoHelper sharedInstance].bltModel.drinkModel;
    NSArray *numberArray = @[[NSString stringWithFormat:@"%02ld:00", (long)model.startTime],
                             [NSString stringWithFormat:@"%02ld:00", (long)model.endTime],
                             @(model.drinkWater),
                             @(model.timeInterval),
                             @(model.isOpen)];
    
    NSString *text3 = [NSString stringWithFormat:@"%@ (ml)", KK_Text(@"Water")];
    NSString *text4 = [NSString stringWithFormat:@"%@ (min)", KK_Text(@"Time interval")];
    NSArray *array = @[KK_Text(@"Starting time"), KK_Text(@"End Time"), text3, text4, KK_Text(@"Remind")];
    for (int i = 0; i < array.count; i++) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 50 * i + 64, self.view.width, 50)];
        bgView.tag = 2001 + i;
        [self.view addSubview:bgView];
        bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        [bgView addGestureRecognizer:tap];
        
        UILabel *title = [UILabel simpleWithRect:CGRectMake(18, 0, 150, 50)];
        title.textAlignment = NSTextAlignmentLeft;
        title.text = array[i];
        [bgView addSubview:title];
        
        UILabel *numberTitle = [UILabel simpleWithRect:CGRectMake(self.view.width / 2, 0, 120, 50)];
        numberTitle.textAlignment = NSTextAlignmentLeft;
        numberTitle.tag = 3000;
        [bgView addSubview:numberTitle];
        if (i != array.count - 1) {
            numberTitle.text = [NSString stringWithFormat:@"%@", numberArray[i]];
        } else {
            _switchBtn = [[CustomSwitch alloc] initWithFrame:CGRectMake(self.view.width / 2, 12, 60, 25)];
            
            _switchBtn.offImageName = @"Device_btn_2_5s@2x.png";
            _switchBtn.onImageName = @"Device_btn_1_5s@2x.png";
            _switchBtn.btnImageName = @"Device_Stripe_1_5s@2x";
            _switchBtn.switchBtn.selected = model.isOpen;
            [_switchBtn setBtnState:model.isOpen];
            [_switchBtn.switchBtn addTarget:self action:@selector(drinkButton:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:_switchBtn];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.height - 1, self.view.width, 1)];
        line.backgroundColor = UIColorHEX(0x888b90);
        [bgView addSubview:line];
    }
}

- (void)clickItem:(UITapGestureRecognizer *)sender
{
    _lastIndex = sender.view.tag - 2000;
    DrinkModel *model = [UserInfoHelper sharedInstance].bltModel.drinkModel;
    
    if (_lastIndex == 1)
    {
        NSMutableArray *hours = [[NSMutableArray alloc] init];
        for (int i = 0; i < 24; i++) {
            [hours addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        _PickView.dataArray = hours;
        [_PickView selectRow:model.startTime inComponent:0 animated:NO];
    } else if(_lastIndex == 2) {
        NSMutableArray *hours = [[NSMutableArray alloc] init];
        for (int i = 0; i < 24; i++) {
            [hours addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        _PickView.dataArray = hours;
        [_PickView selectRow:model.endTime inComponent:0 animated:NO];
    }
    else if(_lastIndex == 3)
    {
        NSMutableArray *water = [[NSMutableArray alloc] init];
        for (int i = 5; i <= 30; i++) {
            [water addObject:[NSString stringWithFormat:@"%d",i * 100]];
        }
        
        _PickView.dataArray = water;
        [_PickView selectRow:(model.drinkWater / 100) - 5 inComponent:0 animated:NO];
    } else if (_lastIndex == 4) {
        NSMutableArray *interval = [[NSMutableArray alloc] init];
        for (int i = 30; i <= 120; i++) {
            [interval addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        _PickView.dataArray = interval;
        [_PickView selectRow:model.timeInterval - 30 inComponent:0 animated:NO];
    } else if (_lastIndex == 5) {
        return;
    }
    
    [UIView animateWithDuration:0.20 animations:^{
        _pickViewBg.frame = CGRectMake(0, self.view.height-260, Maxwidth,260);
    } completion:^(BOOL finished) {
    }];
    
    self.adorableView.hidden = NO;
}

- (void)drinkButton:(UIButton *)sender
{
    DrinkModel *model = [UserInfoHelper sharedInstance].bltModel.drinkModel;
    model.isOpen = !model.isOpen;
    _switchBtn.switchBtn.selected = model.isOpen;
    [_switchBtn setBtnState:model.isOpen];
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
