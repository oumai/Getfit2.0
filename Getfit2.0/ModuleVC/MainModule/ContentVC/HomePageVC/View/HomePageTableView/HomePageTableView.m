//
//  HomePageTableView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/25.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "HomePageTableView.h"
#import "BLTSimpleSend.h"
#import "TestViewController.h"
#import "ShareSDKHelper.h"

#define MOVESPACE 40.0
#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation HomePageTableView
{
    CGPoint _beginPoint;
    CGPoint _beginPoint2;
    CGFloat x_offset;
    CGFloat angle;
    CGFloat nextstep;
    CGFloat laststep;
    CGFloat nextangle;
    CGFloat lastangle;
    int step;
    int step2;
    
    NSDate *startDate;
    NSDate *endDate;
    BOOL mainViewCanScrol;
    NSData *_imageData;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadView];
    }
    
    return self;
}


- (void)loadView
{
    [self loadMainView];
    
    [self loadSwipeGesture];
    
    [self createPanGuesture];
    
    [self loadTableView];
    
//    [self loadScrollView];
    [self loadConttentViews];
    
    [self loadPublicButtons];
    
    _firstLoadData = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tap:) name:@"tap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatTap:) name:@"chattap" object:nil];
}

-(void)loadMainView
{
    _mainView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:_mainView];
    [self setBackgroundImageByImageView];
    mainViewCanScrol = YES;
}

/////加载内容
- (void)loadConttentViews {
    _homeView = [[HomeTodayView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _backHomeView = [[HomeTodayView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _sleepView = [[HomeSleepView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _backSleepView = [[HomeSleepView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [_mainView addSubview:_backSleepView];
    [_mainView addSubview:_backHomeView];
    [_mainView addSubview:_sleepView];
    [_mainView addSubview:_homeView];
    
    NSLog(@"_daysModel>>>%@",_daysModel.stepsArray);
    NSLog(@"_daysModel>>>%@",_daysModel.sleepArray);
    
    if (_daysModel)
    {
        if (_firstLoadData)
        {
            _chatScrollIndex = [[UserInfoHelper sharedInstance]getUserDateArray].count;
            _firstLoadData = NO;
        }
    }
    _currentPage = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.width, 15)];
    _currentPage.center = CGPointMake(self.center.x, self.height - 20);
    _currentPage.numberOfPages = 2;
    [self addSubview:_currentPage];
    
    _tableView.tableHeaderView = _mainView;

}
/////创建手势
-(void)createPanGuesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [pan setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:pan];
}

/*
 20150730  HJ 添加  
 用imageView的方式设置背景图片
 并将类中的 self.image方式都注释掉了
 */
- (void)setBackgroundImageByImageView {
    
    _dayBgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_dayBgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_dayBgImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    _dayBgImageView.image = UIImageNamedNoCache(@"bg_day_5s.png");
    _nightBgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_nightBgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_nightBgImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    _nightBgImageView.image = UIImageNamedNoCache(@"bg_night_5s.png");
    
//    [self addSubview:_nightBgImageView];
//    [self addSubview:_dayBgImageView];
    self.backgroundColor = UIColorHEX(0x262626);;

}

- (void)loadSwipeGesture
{
//    UISwipeGestureRecognizer *recognizer;
//    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [self addGestureRecognizer:recognizer];
//    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [self addGestureRecognizer:recognizer];
     _todayOrSleep = YES;
}

- (void)loadTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tag = 100;
    _tableView.showsVerticalScrollIndicator = NO;
    [self setExtraCellLineHidden:_tableView];
    _refreshDown = NO;
//    _tableView.header.state = MJRefreshHeaderStatePulling;
    
    [_tableView.header setStateHidden:YES];
    [_tableView.header setUpdatedTimeHidden:YES];
    
    __weak HomePageTableView *safely = self;
    
    [_tableView addLegendHeaderWithRefreshingBlock:^ {
        mainViewCanScrol = NO;  ///下拉过程中不许滚动主视图
        [NSObject cancelPreviousPerformRequestsWithTarget:safely selector:@selector(endRefresh) object:nil];
        if(![[BLTManager sharedInstance] isConnected]) {
            [safely.tableView.legendHeader.activityView stopAnimating];
            safely.tableView.legendHeader.stateImageV.image = [UIImage image:@"home_btn_unlink_5s"];
            [safely performSelector:@selector(endRefresh) withObject:nil afterDelay:1];
            safely.tableView.header.titleLabel.text = KK_Text(@"Device not paired");
            
        } else {
            if ([BLTSimpleSend sharedInstance].isSyning)
            {
                if ([BLTSimpleSend sharedInstance].synState == BLTSimpleSendSynAuto)
                {
                    safely.tableView.header.titleLabel.text = KK_Text(@"Synchronizing");
                }
            }
            else
            {
                [BLTSendModel sendSysDeviceDataWithUpdate:^(id object, BLTAcceptModelType type)
                 {
                 }];
                
                [safely performSelector:@selector(endRefresh) withObject:nil afterDelay:2.0];
            }
        }
    } dateKey:@"table"];
}

// 下拉刷新结束
- (void)endRefresh
{
    mainViewCanScrol = YES;  ///结束之后可以滚动主视图
    [_tableView.header endRefreshing];
    if (_todayOrSleep)
    {
        [_homeView dismissView]; // 更新今天详情数据
        [_backHomeView dismissView];
        // 发蓝牙指令 同步数据.
    }
    else
    {
        [_sleepView dismissView];
        [_backSleepView dismissView];
    }
    [self backtodayButtonClick:nil];  //////刷新后回到今天数据
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endRefreshDown) object:nil];
    [self performSelector:@selector(endRefreshDown) withObject:nil afterDelay:0.4];
}

- (void)endRefreshDown
{
    self.tableView.header.titleLabel.text = KK_Text(@"Pull-down Refresh");
    self.tableView.legendHeader.stateImageV.image = [UIImage image:@""];
    _refreshDown = NO;
    _scrollViewDidScroll = NO;
    _scrollView.scrollEnabled = YES;
}

- (void)loadPublicButtons
{
    CGFloat offsetY = FitScreenNumber(0, 20, 20, 20, 20);
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.bgImageNormal = @"home_btn_share_5s@2x.png";
    _shareButton.bgImageSelecte = @"home_btn_share_5s@2x.png";
    _shareButton.frame = CGRectMake(0, offsetY, 44, 44);
    [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareButton];
    
    _blueToothButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _blueToothButton.bgImageNormal = @"home_btn_unlink_5s@2x.png";
    _blueToothButton.frame = CGRectMake(self.width-44, offsetY, 44, 44);
    [_blueToothButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_blueToothButton];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressBtn:)];
    [longPressGesture setDelegate:self];
    longPressGesture.minimumPressDuration = 0.5;//默认0.5秒
    [_blueToothButton addGestureRecognizer:longPressGesture];
    
    
    _todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _todayButton.frame = CGRectMake(0, 0, 150, 44);
    [_todayButton addTarget:self action:@selector(todayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_todayButton setTitle:KK_Text(@"Today") forState:UIControlStateNormal];
    _todayButton.center = CGPointMake(self.center.x, _shareButton.center.y);
    [self addSubview:_todayButton];
    
    _backTodayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backTodayButton.frame = CGRectMake(self.width - 60, 44 + offsetY, 60, 44);
    [_backTodayButton addTarget:self action:@selector(backtodayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backTodayButton setTitle:KK_Text(@"back to Today") forState:UIControlStateNormal];
    [_backTodayButton setHidden:YES];
    [_backTodayButton setFontSize:12.0];
    
    _backTodayButton.center = CGPointMake(self.width - 30, _blueToothButton.center.y + 18);
//    [self addSubview:_backTodayButton];
    
    _todayDot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 6)];
    _todayDot.image = [UIImage imageNamed:@"home_triangle_5s"];
    _todayDot.center = CGPointMake(self.center.x, _todayButton.center.y + 14);
    [self addSubview:_todayDot];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self changePubulicBtnFrame:scrollView.contentOffset.y];
    if (_refreshDown == NO )
    {
        if (_tableView.contentOffset.y >0 )
        {
            [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }else{
        
         [scrollView setContentOffset:scrollView.contentOffset animated:NO];
         return;
    }
    
    if (scrollView == _scrollView && _refreshDown == NO )
    {
        if (_scrollViewDidScroll == NO)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewMoveEnd:) object:scrollView];
            [self performSelector:@selector(scrollViewMoveEnd:) withObject:scrollView afterDelay:0.01];
            _scrollViewDidScroll = YES;
        }
    }
}



- (void)scrollViewMoveEnd:(UIScrollView *)scrollView
{
//    NSLog(@"scrollView -- %f",scrollView.contentOffset.y);

    if (scrollView == _scrollView && _refreshDown == NO)
    {
        if (_todayOrSleep == YES)
        {
            if (_scrollView.contentOffset.x > MOVESPACE)
            {
                [_sleepView dismissView];
                [_backSleepView dismissView];
                _todayOrSleep = NO;
                [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:YES];
                
            }else
            {   [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }else
        {
            if (_scrollView.contentOffset.x < self.width - MOVESPACE)
            {
//                [_homeView dismissView];
                _todayOrSleep = YES;
                [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else
            {
                [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:YES];
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_todayOrSleep && scrollView == _scrollView)
    {
        _scrollViewDidScroll = NO;
    }
    else
    {
        _scrollViewDidScroll = NO;
    }
    
}

- (void)scrollViewEndScroll:(UIScrollView *)scrollView
{
    _scrollViewDidScroll = NO;
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        [_sleepView dismissView];
        [_backSleepView dismissView];
        _todayOrSleep = NO;
        [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
//        self.image = [UIImage imageNamed:@"bg_night_5s@2x.png"];
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    {
        [_homeView dismissView];
        [_backHomeView dismissView];
        _todayOrSleep = YES;
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//       self.image = [UIImage imageNamed:@"bg_day_5s@2x.png"];
    }
}

// 分享按钮 测试
- (void)shareButtonClick:(UIButton *)Sender
{
    /*
    if ([BLTAcceptModel sharedInstance].pushToHeartVC) {
        [BLTAcceptModel sharedInstance].pushToHeartVC(nil, 0);
    } */
   
    [self showShareView];
    
    // [self showTestDetailView];
}

-(void)longPressBtn:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        //长按事件开始"
        //do something
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        //长按事件结束
        //do something
          [self showTestDetailView];
    }
}

- (void)rightButtonClick:(UIButton *)Sender
{
//    [self showTestDetailView];  //测试用
    
//    [[HomePageClass sharedInstance]updateBraceletData:2.0 backBlock:^(id object) {
//        
//        NSLog(@"object>>>>>%@",object);
//        
//    }];
}

///显示分享视图
- (void)showShareView {
        
        if (!_shareViewBackGround)
        {
            _shareViewBackGround = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.frame.size.height)];
            _shareViewBackGround.backgroundColor = [UIColor clearColor];
            _shareViewBackGround.image =  [UIImage image:@"share_background.png"];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, _shareViewBackGround.width, 33)];
            title.textAlignment = NSTextAlignmentCenter;
            title.text = KK_Text(@"Share");
            title.backgroundColor = [UIColor clearColor];
            title.textColor =[UIColor whiteColor];
            title.font = [UIFont systemFontOfSize:14.0];
            [_shareViewBackGround addSubview:title];
            
            CGFloat scale = 1;
            
            _ShareImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _shareViewBackGround.frame.size.width, _shareViewBackGround.frame.size.height)];
            
            [_shareViewBackGround addSubview:_ShareImageView];
            
            _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _ShareImageView.frame.size.width, _ShareImageView.frame.size.height)];
            _backgroundView.image = UIImageNamedNoCache(@"bg_day_5s.png");
            [_ShareImageView addSubview:_backgroundView];
            
            
            UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            head.center = CGPointMake(_backgroundView.center.x, 45);
            if ([[UserInfoHelper sharedInstance] getUserHeadImage]) {
                head.image = [[UserInfoHelper sharedInstance] getUserHeadImage];
            }
            [_ShareImageView addSubview:head];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
            name.center = CGPointMake(head.center.x, head.center.y + 45);
            name.textColor = [UIColor whiteColor];
            name.textAlignment = NSTextAlignmentCenter;
            name.text = [UserInfoHelper sharedInstance].userModel.nickName;
            [_ShareImageView addSubview:name];
            
            _mainView2 = [[MainCircleView alloc] initWithFrame:FitScreenRect(CGRectMake(0, 0, 200,200), CGRectMake(0, 0, 468/2,468/2), CGRectMake(0, 0, 468/2,468/2), CGRectMake(0, 0, 468/2,468/2), CGRectMake(0, 0, 468/2,468/2))];
            _mainView2.center = CGPointMake(name.center.x, name.center.y + 15 + _mainView2.width/2);
            _mainView2.layer.cornerRadius = _mainView2.width/2;
            _mainView2.layer.masksToBounds = YES;
          
//            _mainView2.center = CGPointMake(self.center.x, 210);
            _mainView2.mainViewUpdteDelegate = self;
            [_ShareImageView addSubview:_mainView2];

            [_mainView2 StartupdateProgress];
            CGFloat perH =  _mainView2.frame.origin.y + _mainView2.frame.size.height;
            
            UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(0, perH, _ShareImageView.width/3, 70)];
            distance.textColor = [UIColor whiteColor];
            distance.textAlignment = NSTextAlignmentCenter;
            distance.numberOfLines = 2;
            distance.font = [UIFont systemFontOfSize:13];
            distance.text = [NSString stringWithFormat:@"%ld%@\n%@",_model.totalDistance, KK_Text(@"KM"), KK_Text(@"Total distance")];
            if(![UserInfoHelper sharedInstance].userModel.isMetricSystem){
                distance.text = [NSString stringWithFormat:@"%ld%@\n%@",_model.totalDistance, KK_Text(@"MI"), KK_Text(@"Total distance")];
            }
            [_ShareImageView addSubview:distance];
            
            UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(_ShareImageView.width/3.0,perH, _ShareImageView.width/3, 70)];
            time.textColor = [UIColor whiteColor];
            time.textAlignment = NSTextAlignmentCenter;
            time.numberOfLines = 2;
            time.font = [UIFont systemFontOfSize:13];
            time.text = [NSString stringWithFormat:@"%ld%@\n%@",_model.totalSportTime, KK_Text(@"Hour"), KK_Text(@"Total time")];
            [_ShareImageView addSubview:time];
            
            UILabel *cost = [[UILabel alloc] initWithFrame:CGRectMake(_ShareImageView.width*2/3.0, perH, _ShareImageView.width/3, 70)];
            cost.textColor = [UIColor whiteColor];
            cost.textAlignment = NSTextAlignmentCenter;
            cost.numberOfLines = 2;
            cost.font = [UIFont systemFontOfSize:13];
            cost.text = [NSString stringWithFormat:@"%ld%@\n%@",_model.totalCalories, KK_Text(@"Calorie"), KK_Text(@"Total cost")];
            [_ShareImageView addSubview:cost];
            
            UIImageView *underline = [[UIImageView alloc] initWithFrame:CGRectMake(5, cost.frame.origin.y + cost.frame.size.height - 15, _ShareImageView.frame.size.width - 10, 4)];
            underline.image = [UIImage imageNamed:@"underline"];
            underline.contentMode = UIViewContentModeScaleAspectFit;
            [_ShareImageView addSubview:underline];
            
            UIImageView *vline1 = [[UIImageView alloc] initWithFrame:CGRectMake(time.frame.origin.x, time.frame.origin.y + 10, 4, 50)];
            vline1.image = [UIImage imageNamed:@"Vline"];
            vline1.contentMode = UIViewContentModeScaleAspectFit;
            [_ShareImageView addSubview:vline1];

            UIImageView *vline2 = [[UIImageView alloc] initWithFrame:CGRectMake(cost.frame.origin.x, cost.frame.origin.y + 10, 4, 50)];
            vline2.image = [UIImage imageNamed:@"Vline"];
            vline2.contentMode = UIViewContentModeScaleAspectFit;
            [_ShareImageView addSubview:vline2];
            
            _ShareImageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            /*
            NSArray *shareName = @[@"FaceBook",KK_Text(@"Wechat"),KK_Text(@"Friends"),@"QQ",@"Twitter"];
            NSArray *shareImageName = @[@"faceBook",@"wechat",@"wechatFriends",@"qq",@"twitter"];
            CGFloat width = (self.width - 250)/6.0;
            
            for (NSInteger i = 0; i < 5; i++) {
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                shareBtn.tag = 9000 + i;
                shareBtn.frame = CGRectMake(width + i * (50 + width) ,_shareViewBackGround.frame.size.height - 50 - 70, 50, 50);
                NSString *nomal = [NSString stringWithFormat:@"%@_nomal",shareImageName[i]];
                NSString *selected = [NSString stringWithFormat:@"%@_click",shareImageName[i]];
                [shareBtn setBackgroundImage:[UIImage image:nomal] forState:UIControlStateNormal];
                [shareBtn setBackgroundImage:[UIImage image:selected] forState:UIControlStateSelected];
                UILabel *shareType = [[UILabel alloc]init];
                shareType.frame = CGRectMake(width + i * (50 + width),_shareViewBackGround.frame.size.height - 85 , 50, 50);
                shareType.textAlignment = NSTextAlignmentCenter;
                shareType.text = shareName[i];
                shareType.textColor = [UIColor whiteColor];
                shareType.font = [UIFont systemFontOfSize:10];
                
                [shareBtn addTarget:self action:@selector(shareToSocial:) forControlEvents:UIControlEventTouchUpInside];
                [_shareViewBackGround addSubview:shareBtn];
                [_shareViewBackGround addSubview:shareType];
            } */
            
            NSArray *shareName = @[KK_Text(@"FaceBook"), KK_Text(@"Wechat"), KK_Text(@"Friends"), @"QQ", @"Twitter", @"qqZone"];
            NSArray *shareImageName = @[@"faceBook", @"wechat", @"wechatFriends", @"qq", @"twitter", @"qqZone"];
            CGFloat width = self.width / shareName.count;
            
            for (NSInteger i = 0; i < shareName.count; i++) {
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                shareBtn.tag = 9000 + i;
                shareBtn.frame = CGRectMake(i * width ,_shareViewBackGround.height - 50 - 70, width, 50);
                NSString *nomal = [NSString stringWithFormat:@"%@_nomal",shareImageName[i]];
                NSString *selected = [NSString stringWithFormat:@"%@_click",shareImageName[i]];
                [shareBtn setImage:[UIImage image:nomal] forState:UIControlStateNormal];
                [shareBtn setImage:[UIImage image:selected] forState:UIControlStateSelected];
                shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
                UILabel *shareType = [[UILabel alloc]init];
                shareType.frame = CGRectMake(i * width,_shareViewBackGround.height - 85 , width, 50);
                shareType.textAlignment = NSTextAlignmentCenter;
                shareType.text = shareName[i];
                shareType.numberOfLines = 2;
                shareType.textColor = [UIColor whiteColor];
                shareType.font = [UIFont systemFontOfSize:10];
                
                [shareBtn addTarget:self action:@selector(shareToSocial:) forControlEvents:UIControlEventTouchUpInside];
                [_shareViewBackGround addSubview:shareBtn];
                [_shareViewBackGround addSubview:shareType];
            }
            
            UIButton * disbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            disbutton.frame = CGRectMake(0, _shareViewBackGround.height - 49, _shareViewBackGround.width, 49);
            [disbutton setTitle:KK_Text(@"Cancel") forState:UIControlStateNormal];
            disbutton.titleLabel.font = [UIFont systemFontOfSize:20.0];
            [disbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [disbutton addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
            [_shareViewBackGround addSubview:disbutton];
        }
        
        [_shareViewBackGround popupWithtype:PopupViewOption_colorLump succeedBlock:^(UIView *View)
         {
             // View.center = CGPointMake(self.width/2, self.height - 107);
             _mainView2.currentStepLabel.text = _homeView.circleView.currentStepLabel.text;
             _mainView2.targetStepLabel.text = _homeView.circleView.targetStepLabel.text;  // 目标步数
             _mainView2.progressLabel.text = _homeView.circleView.progressLabel.text;    // 进度
             _mainView2.bgImageView.image = _homeView.circleView.bgImageView.image;
             
         } dismissBlock:^(UIView *View) {
             
         }];
 
}
- (void)MainUpdteProgressFinish
{
    
}

- (void)cancelShare {
    [_shareViewBackGround dismissPopup];
}


- (void)showTestDetailView
{
    if (!_deviceViewBackGround)
    {
        _deviceViewBackGround = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 280)];
        _deviceViewBackGround.backgroundColor = [UIColor whiteColor];
        [_deviceViewBackGround addSubview:[TestViewController shareInstance].bleDetailTextView];
    }
    
    [_deviceViewBackGround popupWithtype:PopupViewOption_colorLump succeedBlock:^(UIView *View)
     {
         View.center = CGPointMake(self.width/2, self.height - (self.height - 200)/2);
     } dismissBlock:^(UIView *View) {
         
     }];

}

- (void)backtodayButtonClick:(UIButton *)Sender
{
    _chatScrollIndex = [[UserInfoHelper sharedInstance]getUserDateArray].count;

    [_homeView dismissView];
    [_backHomeView dismissView];
    [_homeView.circleView StartupdateProgress];
    [_backHomeView.circleView StartupdateProgress];
    [_todayButton setTitle:KK_Text(@"Today") forState:UIControlStateNormal];
    [_backTodayButton setHidden:YES];
    
    [_homePageTableDelegate HomePageTableDateUpdate:[NSDate date]];
    
    [@"chooseDate" setObjectValue:[NSDate date]];
    [@"lastDate" setObjectValue:[[NSDate date] dateAfterDay:-1]];

}

// 更新今天模型
- (void)updateTodayDaysModel
{
    _daysModel = [DaysStepModel getCurrentDaysStepModelFromDB];
    
    if (ISTESTMODEL)
    {
        _chatScrollIndex = 30;
    }
    else
    {
        if (_daysModel)
        {
            if (_firstLoadData)
            {
                _chatScrollIndex = [[UserInfoHelper sharedInstance]getUserDateArray].count;
                _firstLoadData = NO;
            }
        }
    }
}

- (void)todayButtonClick:(UIButton *)Sender
{
//    NSLog(@"_chatScrollIndex>>>>%d",_chatScrollIndex);
    
    __weak HomePageTableView *safely = self;
    
    // 步数图表
    if (_todayOrSleep)
    {
        if (_trendChartViewStep)
        {
            [_trendChartViewStep removeFromSuperview];
            _trendChartViewStep = nil;
             _trendChartViewStep.CustomieScrollViewDelegate = nil;
        }
        _trendChartViewStep = [[CustomieScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width-16, 263)];
        _trendChartViewStep.CustomieScrollViewDelegate = self;
     
        [_trendChartViewStep CustomieScrollViewUpdate:1 dataArray:_daysModel.stepsArray];
        [_trendChartViewStep resetOffSet:_chatScrollIndex];

        _trendChartViewStep.CustomieScrollViewSelectBlock = ^(NSInteger index)
        {
            [safely showButtonTitle:index];
        };
        
        [_trendChartViewStep popupWithtype:PopupViewOption_none succeedBlock:^(UIView *View)
         {
             View.center = CGPointMake(self.center.x, 189);
             _todayDot.image = [UIImage imageNamed:@"home_triangle_2_5s@2x.png"];

         } dismissBlock:^(UIView *View) {
             _todayDot.image = [UIImage imageNamed:@"home_triangle_5s@2x.png"];
              [_homeView dismissView]; // 更新今天详情数据
             [_backHomeView dismissView];
             
//             NSLog(@"22222  safely>>>>>>%d ",safely.chatScrollIndex);
             
             [safely showButtonTitle:_chatScrollIndex];
        }];

    }
    else
    {
        if (_trendChartViewSleep)
        {
            [_trendChartViewStep removeFromSuperview];
            _trendChartViewStep = nil;
            _trendChartViewStep.CustomieScrollViewDelegate = nil;
        }
        
        _trendChartViewSleep = [[CustomieScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width-16, 263)];
        _trendChartViewSleep.CustomieScrollViewDelegate = self;
        [_trendChartViewSleep CustomieScrollViewUpdate:2 dataArray:_daysModel.sleepArray];
        [_trendChartViewSleep resetOffSet:_chatScrollIndex];
        
        _trendChartViewSleep.CustomieScrollViewSelectBlock = ^(NSInteger index)
        {
            [safely showButtonTitle:index];
        };
        
        [_trendChartViewSleep popupWithtype:PopupViewOption_none succeedBlock:^(UIView *View)
         {
             View.center = CGPointMake(self.center.x, 189);
             _todayDot.image = [UIImage imageNamed:@"home_triangle_2_5s@2x.png"];
             
         } dismissBlock:^(UIView *View) {
             _todayDot.image = [UIImage imageNamed:@"home_triangle_5s@2x.png"];
             [safely showButtonTitle:_chatScrollIndex];
             
         }];
    }
}

- (void)CustomieScrollViewCheekDate:(NSInteger)index
{
    if(index == 0) {
        index = 1;
    }
    _chatScrollIndex = index;
    [_trendChartViewStep resetOffSet:_chatScrollIndex];
    [_trendChartViewSleep resetOffSet:_chatScrollIndex];
    NSInteger count = 0;
//    NSLog(@"11111111  safely>>>>>>%d ",_chatScrollIndex);
   
    
    count  = [[UserInfoHelper sharedInstance]getUserDateArray].count;

    NSDate *date = [[NSDate date] dateAfterDay:(int)(index - count)];
    NSDate *yesdate = [[NSDate date] dateAfterDay:(int)(index - count - 1)];
    NSLog(@"-------%d",index - count);
    [@"lastDate" setObjectValue:yesdate];
    [@"chooseDate" setObjectValue:date];

//    NSLog(@"change date >>>%@",date);
    
    [_homePageTableDelegate HomePageTableDateUpdate:date];
}

// 选择返回日期
- (void)showButtonTitle:(NSInteger)index
{
//    NSLog(@"showButtonTitle>>>>%d",index);
    
    NSInteger maxCount = 0;
    
    maxCount = [[UserInfoHelper sharedInstance]getUserDateArray].count;
    
    if (index == maxCount)
    {
        [_backTodayButton setHidden:YES];
        [_todayButton setTitle:KK_Text(@"Today") forState:UIControlStateNormal];
    }
    else
    {
        [_backTodayButton setHidden:NO];
        int dateIndex = (int)(maxCount - index);
        dateIndex = 0 - dateIndex;
        NSDate *date = [[NSDate date] dateAfterDay:dateIndex];
        NSString *dateStr = [NSString stringWithFormat:@"%04d/%02d/%02d", date.year, date.month, date.day];
        [_todayButton setTitle:dateStr forState:UIControlStateNormal];
    }
}

- (void)backToday
{
    [self backtodayButtonClick:nil];
}

-(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = UIColorHEX(0x272727);
    [_tableView setTableFooterView:view];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"Home_TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    
    return  cell;
}

#pragma mark ---   Func  ---
- (void)updateTodayViewAndSleepView:(PedometerModel *)model
{
    _model = model;
    [self updateTodayDaysModel];

    [USERUPDATEDATETIME setObjectValue:[NSDate date]];
    [_homeView updateViewsWithModel:model];
    [_sleepView updateViewsWithModel:model];
    [_backHomeView updateViewsWithModel:model];
    [_backSleepView updateViewsWithModel:model];
}


#pragma mark ------
-(void)pan:(UIPanGestureRecognizer *)p
{
    if(!mainViewCanScrol) {
        return;
    }
    switch (p.state) {
        case UIGestureRecognizerStateBegan:
        {
            _beginPoint = [p locationInView:_mainView];
            _beginPoint2 = _beginPoint;
            startDate = [NSDate date];
//            NSLog(@"%f",[startDate timeIntervalSinceDate:endDate]);
          
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if ([startDate timeIntervalSinceDate:endDate] < 0.2) {
                return;
            }
            CGPoint point = [p locationInView:_mainView];
            x_offset = _beginPoint.x - point.x;
            _beginPoint =point;
            
            angle = angle + x_offset/VIEWSTEP/50.0f;
            
            [self setFlipAngle:angle];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if ([startDate timeIntervalSinceDate:endDate] < 0.2) {
                return;
            }
            CGPoint point = [p locationInView:_mainView];
            CGFloat xoffSet = _beginPoint2.x - point.x ;
//            NSLog(@"%f",xoffSet);
            endDate = [NSDate date];
            NSTimeInterval delta = [endDate timeIntervalSinceDate:startDate];
            if (delta < 0.15) {
                if (xoffSet>0 && delta< 0.15) {
                    nextangle = (ceil(angle/VIEWSTEP_2)) * VIEWSTEP_2;
                    nextstep = nextangle - angle;
                    [self nextView];
                    
                }
                if (xoffSet<0 && delta< 0.15) {
                    lastangle = (floor(angle/VIEWSTEP_2)) * VIEWSTEP_2;
                    laststep = angle - lastangle;
                    [self lastView];
                }
            }else {
                
                if ((angle/VIEWSTEP_2 - floor(angle/VIEWSTEP_2))>=0.5) {
                    nextangle = (ceil(angle/VIEWSTEP_2)) * VIEWSTEP_2;
                    nextstep = nextangle - angle;
                    [self nextView];
                }else{
                    lastangle = (floor(angle/VIEWSTEP_2)) * VIEWSTEP_2;
                    laststep = angle - lastangle;
                    [self lastView];
                }
            }
        }
            break;
            
        default:
            break;
    }

}

- (void)setFlipAngle:(float)ang {
    
    NSInteger page = (int)ceil(ang/1.57);
    switch (page%4) {
        case 0:
            [_mainView sendSubviewToBack:_sleepView];
            
            break;
        case 1:
            [_mainView sendSubviewToBack:_backHomeView];
            
            break;
        case 2:
            [_mainView sendSubviewToBack:_backSleepView];
        
            break;
        case 3:
            [_mainView sendSubviewToBack:_homeView];
            
            break;
            
        default:
            break;
    }
    float dis = self.width/2 ;
    if (page > 0) {
        if (page%2 == 1) {
            _todayOrSleep = YES;
            _currentPage.currentPage = 0;
        }else{
            _todayOrSleep = NO;
            _currentPage.currentPage = 1;
        }
    }
    if (page < 0) {
        if (page%2 == -1) {
            _todayOrSleep = NO;
            _currentPage.currentPage = 1;
        }else{
            _todayOrSleep = YES;
            _currentPage.currentPage = 0;
        }
        
    }
    CATransform3D move = CATransform3DMakeTranslation(0, 0, dis);
    CATransform3D back = CATransform3DMakeTranslation(0, 0, -dis);
    
    CATransform3D rotate0 = CATransform3DMakeRotation(-ang, 0, 1, 0);
    CATransform3D rotate1 = CATransform3DMakeRotation(VIEWSTEP_2-ang, 0, 1, 0);
    CATransform3D rotate2 = CATransform3DMakeRotation(VIEWSTEP_2*2-ang, 0, 1, 0);
    CATransform3D rotate3 = CATransform3DMakeRotation(VIEWSTEP_2*3-ang, 0, 1, 0);
    
    CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
    CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
    CATransform3D mat2 = CATransform3DConcat(CATransform3DConcat(move, rotate2), back);
    CATransform3D mat3 = CATransform3DConcat(CATransform3DConcat(move, rotate3), back);
    
    CGPoint zpoint = CGPointMake(0, 0);
    
    _homeView.layer.transform = CATransform3DPerspect(mat0, zpoint, 200 , angle);
    _sleepView.layer.transform = CATransform3DPerspect(mat1, zpoint, 200, angle);
    _backHomeView.layer.transform = CATransform3DPerspect(mat2, zpoint, 200, angle);
    _backSleepView.layer.transform = CATransform3DPerspect(mat3, zpoint, 200, angle);
}

- (void)nextView {
//    NSLog(@"---%@----angle == %f,Nextangle == %f,Nextstep == %f step ==%d ",_time,angle,nextangle,nextstep,step);
    if (step >= 10) {
        step = 0;
        return;
    }
    
    step += 1;
    if (nextangle > angle  ) {
        angle = angle + nextstep/10;
        [self setFlipAngle:angle];
    }
//    NSLog(@"nest == %f",nextstep/100);
    [self performSelector:@selector(nextView) withObject:nil afterDelay:nextstep/100];
}
- (void)lastView {
//        NSLog(@"angle == %f,Lastangle == %f,Laststep == %f,step2 == %d",angle,lastangle,laststep,step2);
    if (step2 >= 10) {
        step2 = 0;
        return;
    }
    step2 += 1;
    if (angle > lastangle) {
        angle = angle - laststep/10;
        [self setFlipAngle:angle];
    }
//    NSLog(@"last == %f",laststep/100);
    [self performSelector:@selector(lastView) withObject:nil afterDelay:laststep/100];
}
////
- (void)tap:(NSNotification *)sender {
    NSDictionary *dic = [sender object];
    if ([[dic valueForKey:@"isTouch"] isEqualToString:@"yes"]) {
        if ([[dic valueForKey:@"obj"] isEqual:_homeView]) {
            [_backHomeView mainViewTouch];
        }else if ([[dic valueForKey:@"obj"] isEqual:_backHomeView]) {
            [_homeView mainViewTouch];
        }else if ([[dic valueForKey:@"obj"] isEqual:_sleepView]) {
            [_backSleepView mainViewTouch];
        }else if ([[dic valueForKey:@"obj"] isEqual:_backSleepView]) {
            [_sleepView mainViewTouch];
        }
    }
}
///点击雨点
- (void)chatTap:(NSNotification *)sender {
    NSDictionary *dic = [sender object];
    if ([[dic valueForKey:@"isTouch"] isEqualToString:@"yes"]) {
        if ([[dic valueForKey:@"obj"] isEqual:_homeView]) {
            [_backHomeView dismissView];
        }else if ([[dic valueForKey:@"obj"] isEqual:_backHomeView]) {
            [_homeView dismissView];
        }else if ([[dic valueForKey:@"obj"] isEqual:_sleepView]) {
            [_backSleepView dismissView];
        }else if ([[dic valueForKey:@"obj"] isEqual:_backSleepView]) {
            [_sleepView dismissView];
        }
    }
}
///公共按钮随下拉刷新位移整体发生位移
- (void) changePubulicBtnFrame:(CGFloat)yOffset {
    
    CGFloat offsetY = FitScreenNumber(0, 20, 20, 20, 20);
    CGRect shareRect = _shareButton.frame;
    shareRect.origin.y = -yOffset + offsetY;
    _shareButton.frame = shareRect;
    
    CGRect blutoothRect = _blueToothButton.frame;
    blutoothRect.origin.y = -yOffset + offsetY;
    _blueToothButton.frame = blutoothRect;

    _todayButton.center = CGPointMake(self.center.x, _shareButton.center.y);
    _backTodayButton.center = CGPointMake(self.width - 30, _blueToothButton.center.y + 18);
    _todayDot.center = CGPointMake(self.center.x, _todayButton.center.y + 14);
}


//////截图
- (void)getShareImage
{
    _imageData = nil;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [_ShareImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    _imageData = UIImagePNGRepresentation(viewImage);
}

/////分享
- (void)shareToSocial:(UIButton *)sender
{
    [self getShareImage];
    [ShareSDKHelper shareContentWithIndex:sender.tag view:_shareViewBackGround image:_imageData];
}

@end
