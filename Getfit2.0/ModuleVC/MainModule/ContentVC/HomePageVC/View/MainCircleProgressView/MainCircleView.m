//
//  MainCircleView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/3.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "MainCircleView.h"
#import "PedometerHelper.h"

#define BASEVALUE self.width/234
@implementation MainCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadButton];
        
        [self loadBascView];
    }
    
    return self;
}

// 更新主页数据
- (void)loadFrame
{
//    NSLog(@"日期:>>>%@  更新数据中>>>>",[HomePageClass sharedInstance].currentDate);
    
    _peopleImage.frame = CGRectMake(0, 0, 18, 65.0/2);
    _peopleImage.center = CGPointMake(self.width / 2, 60);
    
    _currentStepLabel.frame = CGRectMake(0, 0, 200, 40);
    _currentStepLabel.center = CGPointMake(90, self.height / 2);
    
    _stepUnit.frame = CGRectMake(0, 0, 60, 40);
    _stepUnit.center = CGPointMake(350 / 2, self.height / 2 + 3);
    
    _targetStepLabel.frame = CGRectMake(0, 0, 180, 40);
    _targetStepLabel.center = CGPointMake(self.width / 2, 160);
    
    _progressLabel.frame = CGRectMake(0, 0, 180, 40);
    _progressLabel.center = CGPointMake(self.width / 2, 180);
    
}

- (void)updateTarget
{
    _targetStepLabel.text = [NSString stringWithFormat:@"%@ : %ld %@", KK_Text(@"Daily Target"), [UserInfoHelper sharedInstance].userModel.targetSteps, KK_Text(@"Step")];
    CGFloat progress = 100.0 * _model.totalSteps / [UserInfoHelper sharedInstance].userModel.targetSteps;
    int imageIndex = progress * 1.0 / 100 * 60;
    
    NSString *imageString = [NSString stringWithFormat:@"homeCircle_5_%02d@2x.png",imageIndex];
    _bgImageView.image = UIImageNamedNoCache(imageString);
}

- (void)LoadData
{
    NSInteger stepValue = _model.totalSteps;
    _currentStepLabel.text = [NSString stringWithFormat:@"%ld", stepValue];
    _targetStepLabel.text = [NSString stringWithFormat:@"%@ : %ld %@", KK_Text(@"Daily Target"), [UserInfoHelper sharedInstance].userModel.targetSteps, KK_Text(@"Step")];
    CGFloat progress = 100.0 * stepValue / [UserInfoHelper sharedInstance].userModel.targetSteps;
    _progressLabel.text = [NSString stringWithFormat:@"%@ : %.0f %%", KK_Text(@"Update Done"), progress];
}

- (void)loadBascView
{
    _peopleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BASEVALUE * 18,self.BASEVALUE * 65.0/2)];
    _peopleImage.image = UIImageNamedNoCache(@"home_people_5s@2x.png");
    _peopleImage.center = CGPointMake(self.width / 2, BASEVALUE * 60);
    [self addSubview:_peopleImage];
    _peopleImage.autoresizesSubviews = YES;
    _peopleImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    _currentStepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, BASEVALUE * 40)];
//    _currentStepLabel.text = [[HomePageClass sharedInstance]currentStep];
    _currentStepLabel.font = [UIFont systemFontOfSize:BASEVALUE * 45] ;
    _currentStepLabel.textColor = [UIColor whiteColor];
    _currentStepLabel.textAlignment = NSTextAlignmentCenter;
    _currentStepLabel.center = CGPointMake(90, self.height / 2);
    _currentStepLabel.autoresizesSubviews = YES;
    _currentStepLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_currentStepLabel];
    
    _stepUnit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    _stepUnit.text = KK_Text(@"Step");
    _stepUnit.center = CGPointMake(350 / 2, self.height / 2 + 3);
    _stepUnit.font = [UIFont systemFontOfSize:12 * BASEVALUE] ;
    _stepUnit.textColor = [UIColor whiteColor];
    _stepUnit.textAlignment = NSTextAlignmentLeft;
    _stepUnit.autoresizesSubviews = YES;
    _stepUnit.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_stepUnit];
    
    _targetStepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BASEVALUE * 180, BASEVALUE * 40)];
    _targetStepLabel.text = [NSString stringWithFormat:@"%@ : %ld %@", KK_Text(@"Daily Target"), (long)[UserInfoHelper sharedInstance].userModel.targetSteps, KK_Text(@"Step")];
    _targetStepLabel.font = DEFAULT_FONTHelvetica(BASEVALUE * 12) ;
    _targetStepLabel.textColor = [UIColor whiteColor];
    _targetStepLabel.textAlignment = NSTextAlignmentCenter;
    _targetStepLabel.center = CGPointMake(self.width / 2, BASEVALUE * 160);
    _targetStepLabel.autoresizesSubviews = YES;
    _targetStepLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_targetStepLabel];
    
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BASEVALUE * 180, BASEVALUE * 40)];
    _progressLabel.text = [NSString stringWithFormat:@"%@ : 0%%", KK_Text(@"Update Done")];
    _progressLabel.font = DEFAULT_FONTHelvetica(BASEVALUE * 12) ;
    _progressLabel.textColor = [UIColor whiteColor];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.center = CGPointMake(self.width / 2, BASEVALUE * 180);
    _progressLabel.autoresizesSubviews = YES;
    _progressLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_progressLabel];

}

- (void)loadButton
{
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _bgImageView.center = self.center;
    _bgImageView.autoresizesSubviews = YES;
    _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_bgImageView];
    
    _topView = [[UIView alloc]initWithFrame:self.frame];
    _topView.center = self.center;
    _topView.layer.cornerRadius = self.width / 2;
    _topView.backgroundColor = UIColorHEX(0x262626);
    _topView.alpha = 0.5;
    _topView.autoresizesSubviews = YES;
    _topView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_topView];
    
    _mainView = [UIButton buttonWithType:UIButtonTypeCustom];
    _mainView.frame = CGRectMake(0, 0, BASEVALUE * 200, BASEVALUE * 200);
    _mainView.center = self.center;
    _mainView.layer.cornerRadius = _mainView.width / 2.0;
    _mainView.layer.masksToBounds = YES;
    _mainView.backgroundColor = BGCOLOR;
    _mainView.autoresizesSubviews = YES;
    _mainView.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _mainView.userInteractionEnabled = NO;
    
    [self addSubview:_mainView];
    [self bringSubviewToFront:_bgImageView];
    [self mainCircleUpdateProgress:_progress];
    
}

// 更新显示数值
- (void)updateProgress
{
    [self loadFrame];
    [self mainCircleUpdateProgress:0];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateData) object:nil];
}

- (void)StartupdateProgress
{
    [self mainCircleUpdateProgress:0];
    [self performSelector:@selector(updateData) withObject:nil afterDelay:0.2];
}

- (void)updateData
{
    if (_progress <= 100)
    {
        _progress++;
        
        CGFloat progress = 100.0 * _model.totalSteps / [UserInfoHelper sharedInstance].userModel.targetSteps;
        if (_progress > progress)
        {
            return;
        }
        
        [self mainCircleUpdateProgress:_progress];
        
        _progressLabel.text = [NSString stringWithFormat:@"%@ : %.0f %%", KK_Text(@"Update Done"), _progress];
        [self performSelector:@selector(updateData) withObject:nil afterDelay:1./20];
    } else {
        [self.mainViewUpdteDelegate MainUpdteProgressFinish];
    }
}

- (void)mainCircleUpdateProgress:(float)progress
{
    _progress = progress;
    
    int imageIndex = progress * 1.0 / 100 * 60;
    
    if(progress <= 60) {
        NSString *imageString = [NSString stringWithFormat:@"homeCircle_5_%02d@2x.png",imageIndex];
        _bgImageView.image = UIImageNamedNoCache(imageString);
        
    } else if (progress > 60) {
        _bgImageView.image = UIImageNamedNoCache(@"homeCircle_5_60@2x.png");
    }
}

#pragma mark ---   Func  ---
- (void)updateViewsWithModel:(PedometerModel *)model
{
    _model = model;

    [self LoadData];
}

@end
