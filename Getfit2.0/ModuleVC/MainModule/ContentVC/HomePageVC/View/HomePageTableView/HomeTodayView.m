//
//  HomeTodayView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/24.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "HomeTodayView.h"
#import "BLTModel.h"
#import "BLTSendModel.h"
@implementation HomeTodayView
{
    UIView *x8View;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    
    if (self)
    {
        

        
        [self loadTodayView];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(isConnected)
                                                     name: @"连接蓝牙"
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(X7Info:)
                                                     name: @"X7通知"
                                                   object: nil];
    }
    return self;
}

- (void)loadTodayView
{
    _backgroundView = [[UIImageView alloc] initWithFrame:self.frame];
    _backgroundView.image = UIImageNamedNoCache(@"bg_day_5s.png");
    [self addSubview:_backgroundView];
    
    CGFloat height=  FitScreenNumber(30, 0, 0, 0, 0);
    
    UIView *blackView = [[UIView alloc] initWithFrame:FitScreenRect(CGRectMake(0, 375 - height, self.width, 199 - height),
                                                                    CGRectMake(0, 375, self.width, 199),
                                                                    CGRectMake(0, self.height - 229, self.width, 229),
                                                                    CGRectMake(0, self.height - 229, self.width, 229),
                                                                    CGRectMake(0, self.height - 199, self.width, 199))];
    
    blackView.backgroundColor = [UIColor clearColor];
    [self addSubview:blackView];
    
    UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 25)/2, 110 -height * 1.4, 25, 8)];
    dot.image = [UIImage imageNamed:@"home_dot_1_5s"];
    // [blackView addSubview:dot];
    [self loadLabel];
    [self loadMainView];

}

- (void)loadMainView
{
    CGFloat height=  FitScreenNumber(175, 230, 250, 290, 310);
    _circleView = [[MainCircleView alloc] initWithFrame:CGRectMake(0, 0, 468/2, 468/2)];
    _circleView.layer.cornerRadius = 468/4;
    _circleView.layer.masksToBounds = YES;
    _circleView.center = CGPointMake(self.center.x, height);
    _circleView.mainViewUpdteDelegate = self;
    [self addSubview:_circleView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTouch)];
    [_circleView addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    _circleView.userInteractionEnabled = YES;
    
    
    

    NSLog(@"self=%p====%p",self,_circleView);
    
    CGFloat offsetY=  FitScreenNumber(80, 110, 120, 140, 150);
    _Chart = [[VeryFitMainChatView alloc]initWithFrame:CGRectMake(0, offsetY, self.width , 234 - 10)];
    [self addSubview:_Chart];
    _Chart.customieChartViewDelegate = self;
    [_Chart setHidden:YES];
    
    // [_mainView updateProgress];
    [_circleView StartupdateProgress];
    
    
}

// 大圆进度更新完成
- (void)MainUpdteProgressFinish
{

}

// 大圆点击
- (void)tapTouch {
    [self mainViewTouch];
    NSDictionary *dic = @{@"isTouch":@"yes",@"obj":self};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tap" object:dic];
}

- (void)mainViewTouch
{
    _mainFrameCount = 230;
    _mainViewCenterCount = 0;
    [self performSelector:@selector(mainDiss) withObject:nil afterDelay:0.015];
    [UIView animateWithDuration:0.3 animations:^{

    }
                     completion:^(BOOL finished) {
                           [self showRainView];
                     }];
}
// 大圆消失
- (void)mainDiss
{
    if (_mainFrameCount >0)
    {
        CGFloat height=  FitScreenNumber(175, 230, 250, 290, 310);

        _mainFrameCount -= 10;
        _mainViewCenterCount += 2.5;
        _circleView.frame = CGRectMake(0, 0, _mainFrameCount, _mainFrameCount);
        _circleView.layer.cornerRadius = _mainFrameCount / 2;
        _circleView.layer.masksToBounds = YES;
        _circleView.center = CGPointMake(self.center.x, height - _mainViewCenterCount + 5);
        [self performSelector:@selector(mainDiss) withObject:nil afterDelay:0.015];
    }
}

// 显示雨点
- (void)showRainView
{
    CGFloat offsetY=  FitScreenNumber(80, 110, 120, 140, 150);
    if (_rainDotView == nil) {
        _rainDotView = [[VeryFitMainRainDotView alloc]initWithFrame:CGRectMake(0, offsetY, self.width , 234 - 10)];
    }
    [self addSubview:_rainDotView];
    [_rainDotView loadrainDotView];
    [self performSelector:@selector(showChartView) withObject:nil afterDelay:1.8];
}

// 显示图表
- (void)showChartView
{
    [_rainDotView removeFromSuperview];
    [_rainDotView removeFromSuperview];
    _rainDotView = nil;
    [_Chart bringSubviewToFront:self];
    [_Chart setHidden:NO];
    [_Chart updateView:_model]; // 改动部分
}

-(void)dismissView
{
    CGFloat height=  FitScreenNumber(175, 230, 250, 290, 310);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showChartView) object:nil];
    [_rainDotView removeFromSuperview];
    [_rainDotView removeFromSuperview];
    _rainDotView = nil;
    [_Chart setHidden:YES];
    [_circleView setHidden:NO];
    _circleView.frame = CGRectMake(0, 0, 468 / 2, 468 / 2);
    _circleView.layer.cornerRadius = 468 / 4;
    _circleView.center = CGPointMake(self.center.x, height);
    _circleView.layer.masksToBounds = YES;
    [self updateTodayDetail];
}

- (void)updateTodayDetail
{
    [_circleView updateProgress];
    [_circleView StartupdateProgress];
}

- (void)loadLabel
{
    CGFloat offSetX = (self.width - 90) / 4;
    CGFloat offSetY = FitScreenNumber(10, 20, 60, 100, 100);
    CGFloat height=  367;//_circleView.totalHeight;
    
    NSLog(@"height = %f=wide = %foffSetY=%f  offSetX =%f",height,_circleView.totalWidth,offSetY,offSetX);
    x8View = [[UIView alloc]initWithFrame:self.bounds];
    x8View.backgroundColor = [UIColor clearColor];
    [self addSubview:x8View];
    NSString *deviceName =[UserInfoHelper sharedInstance].bltModel.bltName;
    NSArray *array = @[@"X7", @"X7S", @"X5", @"X5S"];
    if ([array containsObject:deviceName]) {
        x8View.hidden = NO;
    } else {
        x8View.hidden = YES;
    }
    x8View.userInteractionEnabled = YES;

    UIImageView *temperatureImage = [[UIImageView alloc]initWithFrame:CGRectMake(offSetX + 0,
                                                                                 height + offSetY, 30, 30)];
    temperatureImage.image = [UIImage image:@"温度.png"];
    // temperatureImage.center = CGPointMake(85, 370-height);
    temperatureImage.contentMode = UIViewContentModeScaleAspectFit;
    [x8View addSubview:temperatureImage];
    // temperatureImage.backgroundColor = [UIColor redColor];

    _temperature = [[UILabel alloc]initWithFrame:CGRectMake(50, temperatureImage.totalHeight, 50, 30)];
    _temperature.font = [UIFont systemFontOfSize:12.0f];
    _temperature.textColor = [UIColor whiteColor];
    _temperature.text = @"0";
    _temperature.center = CGPointMake(temperatureImage.center.x - 8, _temperature.y+10);
    _temperature.textAlignment = NSTextAlignmentCenter;
    [x8View addSubview:_temperature];
    // _temperature.backgroundColor = [UIColor redColor];
    
    UIImageView *pressureImage = [[UIImageView alloc]initWithFrame:CGRectMake(offSetX * 2 + 30,
                                                                              height + offSetY, 30, 30)];
    pressureImage.image = [UIImage image:@"气压.png"];
    // pressureImage.center = CGPointMake(165, 370-height);
    pressureImage.contentMode = UIViewContentModeScaleAspectFit;
    [x8View addSubview:pressureImage];
    
    _pressure = [[UILabel alloc]initWithFrame:CGRectMake(50, pressureImage.totalHeight, 80, 30)];
    _pressure.font = [UIFont systemFontOfSize:12.0f];
    _pressure.textColor = [UIColor whiteColor];
    _pressure.text = @"0";
    _pressure.center = CGPointMake(pressureImage.center.x, _pressure.y+10);
    _pressure.textAlignment = NSTextAlignmentCenter;
    [x8View addSubview:_pressure];
    
    UIImageView *altitudeImage = [[UIImageView alloc]initWithFrame:CGRectMake(offSetX*3+60,
                                                                              height + offSetY, 30, 30)];
    altitudeImage.image = [UIImage image:@"海拔.png"];
    // altitudeImage.center = CGPointMake(245, 370-height);
//    altitudeImage.contentMode = UIViewContentModeScaleAspectFit;

    [x8View addSubview:altitudeImage];
    _altitude = [[UILabel alloc]initWithFrame:CGRectMake(50, altitudeImage.totalHeight, 80, 30)];
    _altitude.font = [UIFont systemFontOfSize:12.0f];
    _altitude.textColor = [UIColor whiteColor];
    _altitude.text = @"0";
    _altitude.center = CGPointMake(altitudeImage.center.x, _altitude.y+10);
    _altitude.textAlignment = NSTextAlignmentCenter;
    [x8View addSubview:_altitude];
    
    _kilometreLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 400, 130, 30)];
    _kilometreLabel.font = [UIFont systemFontOfSize:25.0f];
    _kilometreLabel.textColor = [UIColor whiteColor];
    _kilometreLabel.text = @"0";
    _kilometreLabel.center = CGPointMake(_temperature.center.x, _altitude.totalHeight + 15);
    _kilometreLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_kilometreLabel];
    
    _kilometreUnit = [[UILabel alloc] initWithFrame:CGRectMake(55, 400, 130, 30)];
    _kilometreUnit.font = [UIFont systemFontOfSize:12.];
    _kilometreUnit.textColor = [UIColor whiteColor];
    _kilometreUnit.text = KK_Text(@"KM");
    _kilometreUnit.center = CGPointMake(_temperature.center.x, _altitude.totalHeight + 35);
    _kilometreUnit.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_kilometreUnit];
    
    _calorieLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 400, 120, 30)];
    _calorieLabel.font = [UIFont systemFontOfSize:25.0f];
    _calorieLabel.textColor = [UIColor whiteColor];
    _calorieLabel.text = @"0";
    _calorieLabel.center = CGPointMake(_altitude.center.x, _altitude.totalHeight + 15);
    _calorieLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_calorieLabel];
    
    UILabel *calorieUnit = [[UILabel alloc] initWithFrame:CGRectMake(180, 400, 120, 30)];
    calorieUnit.font = [UIFont systemFontOfSize:12.];
    calorieUnit.textColor = [UIColor whiteColor];
    calorieUnit.text = KK_Text(@"Cal");
    calorieUnit.center = CGPointMake(_altitude.center.x, _altitude.totalHeight + 35);
    calorieUnit.textAlignment = NSTextAlignmentCenter;
    [self addSubview:calorieUnit];
}

//赋值  公里数和卡路里
- (void)updateDataHomeToday
{
    int height = [UserInfoHelper sharedInstance].userModel.showHeight.intValue;
    int weight = [UserInfoHelper sharedInstance].userModel.showWeight.intValue;
    
    NSInteger stepValue = 0;
    stepValue = _model.totalSteps;
    
    CGFloat distance = height *0.45*stepValue *0.01/1000;
    int calorie = (int)(weight *1.036 * (height *0.45 *stepValue *0.00001));
    
    
    if (![UserInfoHelper sharedInstance].userModel.isMetricSystem) {
        
        _kilometreUnit.text =  KK_Text(@"MI");  //英里
        
        distance = distance*0.6214;
    } else {
        _kilometreUnit.text =  KK_Text(@"KM"); //公里
        distance = distance;

    }

    /*
     公里   卡路里
     改成截取字符串不用四舍五入
     四舍五入 [NSString stringWithFormat:@"%.2f", distance]
     截取    [getString substringWithRange:NSMakeRange(0, 4)];
     
     NSLog(@"%@==========%@==========%f",_kilometreLabel.text,[NSString stringWithFormat:@"%.2f", distance],distance);
     NSLog(@"%@==========%@==========",_calorieLabel.text,[NSString stringWithFormat:@"%d", calorie]);
     */
    NSString *getString = [NSString stringWithFormat:@"%f", distance];
    NSString *cutOutString = [getString substringWithRange:NSMakeRange(0, 4)];
    _kilometreLabel.text = cutOutString;
    _calorieLabel.text = [NSString stringWithFormat:@"%d", calorie];

    

   
}

-(void)isConnected
{
    [self performSelector:@selector(performDevice) withObject:self afterDelay:3.0f];
}

-(void)performDevice
{
    NSString *deviceName =[UserInfoHelper sharedInstance].bltModel.bltName;
    NSArray *array = @[@"X7", @"X7S", @"X5", @"X5S"];
    if ([array containsObject:deviceName]) {
        x8View.hidden = NO;
    } else {
        x8View.hidden = YES;
    }
    
    [BLTSendModel sendGetDeviceTemperature:^(id object, BLTAcceptModelType type) {
    }];
}

#pragma mark ---   Func  ---
- (void)updateViewsWithModel:(PedometerModel *)model
{
    _model = model;
    [self updateDataHomeToday];
    [_circleView updateViewsWithModel:_model];
}
//接受通知  每十分钟接受一次
//赋值:温度值  压力值   海拔
- (void)X7Info:(NSNotification*)noti
{
    NSDictionary *dic=[noti userInfo];
    if (dic[@"temperature"]) {
        if ([UserInfoHelper sharedInstance].userModel.isFahrenheit)
        {
            CGFloat temp = ((NSString *)dic[@"temperature"]).floatValue;
            _temperature.text = [NSString stringWithFormat:@"%0.3f℉", (temp * 1.8 + 32)];
        } else {
            _temperature.text = [NSString stringWithFormat:@"%@", dic[@"temperature"]];
        }
        NSLog(@"temperature = %@",dic[@"temperature"]);
        
    }
    if (dic[@"altitude"]) {
        _altitude.text = dic[@"altitude"];
    }
    if (dic[@"pressure"]) {
        
        
        _pressure.text = dic[@"pressure"];//dic[@"pressure"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
