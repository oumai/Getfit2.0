//
//  DetailVC.m
//  AJBracelet
//
//  Created by zorro on 15/6/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DetailVC.h"
#import "ShowScrollView.h"
#import "DetailStepShowView.h"
#import "DetailSegSelectView.h"
#import "BLTAcceptModel.h"

@interface DetailVC ()

@property (nonatomic, strong) ShowScrollView *showView;
@property (nonatomic, strong) DetailStepShowView *detailStepShowView;
@property (nonatomic, strong) DetailSegSelectView *detailSegSeletView;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation DetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat  height = FitScreenNumber(0, 0, 0, 0, 0);
    _detailStepShowView = [[DetailStepShowView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:_detailStepShowView];
    
    _detailSegSeletView = [[DetailSegSelectView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [self.view addSubview:_detailSegSeletView];
    
    DEF_WEAKSELF_(DetailVC)
    _selectIndex = 1;
    _detailSegSeletView.segmentSelectBlock = ^(NSInteger select)
    {
        NSLog(@"select >>>>%d",select);
        [weakSelf updateDetailView:select];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateDetailView:_selectIndex];
    
    // 接收到8个字节数据, 实时数据
    [BLTAcceptModel sharedInstance].realTimeBlock = ^ (id object, BLTAcceptModelType type) {
        [self updateDetailView:_selectIndex];
    };
    
    // 数据同步完成
    [BLTAcceptModel sharedInstance].detailDataBlock = ^ (id object, BLTAcceptModelType type) {
        [self updateDetailView:_selectIndex];
    };
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTAcceptModel sharedInstance].realTimeBlock = nil;
    [BLTAcceptModel sharedInstance].detailDataBlock = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDetailViewDate" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatDetailViewLabel" object:nil];
}

- (void)updateDetailView:(NSInteger)type
{
    _selectIndex = type;
    _detailStepShowView.selectType = type;
    [_detailStepShowView.detailScrollView detailScrollUpdate:type];
    
    if (type == 3) {
        _detailStepShowView.detailScrollView.middleView.tagrgetImage.image = [UIImage image:@""];
        _detailStepShowView.detailScrollView.middleView.targetLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
