//
//  VeryFitMainSleepChatView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "VeryFitMainSleepChatView.h"

#define SPACEWIDTH 10.0
#define SLEEPWIDTH 0.5

@implementation VeryFitMainSleepChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self loadView];
    }
    
    return self;
}

- (void)loadView
{
    if (!_scrollView)
    {
        CGFloat offsetY = FitScreenNumber(40, 65, 65, 65, 65);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offsetY, self.width, self.height - (offsetY + 25))];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(self.width, _scrollView.height);
        [self addSubview:_scrollView];
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [_scrollView addGestureRecognizer:tapGest];
    }
    
    _sleepDataArray = [[NSMutableArray alloc] init];
}

- (void)loadValueLabel
{
    float widthX = 0;
    
    CGFloat end = [[_sleepLabelArray objectAtIndex:3] floatValue];
    
    int Sleep = 1;
    
    for (int i = 0; i <_sleepDataArray.count; i++)
    {
        if ([[[_sleepDataArray objectAtIndex:i] objectAtIndex:1] integerValue] < 9999)
        {
            Sleep = 0;
            break;
        }
    }
    
    for (int i = 0; i < 2 - Sleep; i++)
    {
        if (i == 0) {
            widthX = 10;
        } else {
            // widthX = end / 288 / 5 * _scrollView.width - 10;
            widthX = _scrollView.width - 70;
        }
        
        _scrollView.clipsToBounds = NO;
        _mainView.clipsToBounds = NO;
        UILabel *sleepLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthX, _mainView.height, 60, 25)];
        sleepLabel.text =[_sleepLabelArray objectAtIndex:i];
        sleepLabel.font = [UIFont systemFontOfSize:8.0];
        sleepLabel.textColor = [UIColor whiteColor];
        sleepLabel.textAlignment = i == 0 ? NSTextAlignmentLeft : NSTextAlignmentRight;;
        
        [_mainView addSubview:sleepLabel];
    }
}

- (void)tap
{
    NSDictionary *dic = @{@"isTouch":@"yes",@"obj":self.veryFitMainSleepDelegate};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chattap" object:dic];
    [self setHidden:YES];
    [self.veryFitMainSleepDelegate dismissView];
}

- (void)loadTestData
{
    }

- (NSString *)getTimeString:(NSInteger )time
{
    return  [NSString stringWithFormat:@"%02d:%02d",time/60,time%60];
}

- (void)updateView:(NSArray *)dateArray
{
    if (_mainView) {
        [_mainView removeFromSuperview];
        _mainView = nil;
    }

    _sleepDataArray = [[NSMutableArray alloc] init];
    if (ISTESTMODEL) {
        for (int i = 0; i< 20; i++) {
            [_sleepDataArray addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",i],[NSString stringWithFormat:@"%d",arc4random()%3 + 1],[NSString stringWithFormat:@"%d",27], nil]];
        }
    } else {
        [_sleepDataArray addObjectsFromArray:dateArray];
    }
    
    float maxWidth = _scrollView.width;
    _mainView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    [_scrollView addSubview:_mainView];
    
//    int totalSleepTime = 0;
//    
//    for (int i = 0; i < _sleepDataArray.count; i++) {
//        int viewWidth = [[[_sleepDataArray objectAtIndex:i] objectAtIndex:1] integerValue];
//        totalSleepTime += viewWidth;
//    }
    
    CGFloat vieworigin = 0.0;
    
    NSDate *date = [@"chooseDate" getObjectValue];
    NSDate *yesdate = [@"lastDate" getObjectValue];
    PedometerModel *todayModel = [PedometerHelper getModelFromDBWithDate:date];
    PedometerModel *yesModel = [PedometerHelper getModelFromDBWithDate:yesdate];

    
    //现在时间
//    NSDate *nowTimedate = [NSDate date];
//    NSInteger nowTime = (nowTimedate.hour * 60 + nowTimedate.minute / 5 * 5)/5;
    
    
    //如果昨天18:00 - 0:00开始睡觉
//    if (currenttime > nowTime) {
        //昨晚18:00-0:00的开始睡眠的时间
        NSInteger index = 0;
        for (NSInteger i = 0; i < yesModel.yesterdayArray.count ; i++) {
            int value = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];
            
            if (value < 9999)
            {
                index =  i;
                break;
            }
            else{
                index = 72;
            }
        }
 
    //总长度对应个数
    NSInteger currenttime = todayModel.sleepEndTime/5-todayModel.sleepStartTime/5+(72-index);
    //每段长度
    CGFloat width = maxWidth / currenttime;
    
        for (NSInteger i = index; i < yesModel.yesterdayArray.count; i++) {
            int viewWidth = [[[yesModel.yesterdayArray objectAtIndex:i] objectAtIndex:1] intValue];
            int state = 1;
            
            if (viewWidth < 10) {
                state = 3;
            } else if(viewWidth < 30&&viewWidth>=10) {
                state = 2;
            } else {
                state = 1;
            }
            
            if (viewWidth == 9999) {
                state = 4;
            }
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(vieworigin , 0, width, _mainView.height)];
            vieworigin += width;
            
            if (state == 1) {
                view.backgroundColor = UIColorHEX(0xffffff);    // 清醒
            } else if (state == 2) {
                view.backgroundColor = UIColorHEX(0x999999);    // 浅睡
            } else if (state ==3){
                view.backgroundColor = UIColorHEX(0x666666);    // 深睡
            }else
            {
                view.backgroundColor = [UIColor clearColor];    // 隔断区域

            }
//            view.alpha = 0.5;
            [_mainView addSubview:view];

        }
//    }
//    NSLog(@"%d %d",(todayModel.sleepStartTime)/5,(todayModel.sleepEndTime)/5);
    for (NSInteger i = (todayModel.sleepStartTime)/5; i < (todayModel.sleepEndTime)/5; i++) {
 
        int viewWidth = [[[todayModel.sleepArray objectAtIndex:i] objectAtIndex:1] intValue];
        int state = 1;
        
        if (viewWidth < 10) {
            state = 3;
        } else if(viewWidth < 30&&viewWidth>=10) {
            state = 2;
        } else {
            state = 1;
        }
        
        if (viewWidth == 9999) {
            state = 4;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(vieworigin , 0, width, _mainView.height)];
        vieworigin += width;
        
        if (state == 1) {
            view.backgroundColor = UIColorHEX(0xffffff);    // 清醒
        } else if (state == 2) {
            view.backgroundColor = UIColorHEX(0x999999);    // 浅睡
        } else if (state ==3){
            view.backgroundColor = UIColorHEX(0x666666);    // 深睡
        }else
        {
            view.backgroundColor = [UIColor clearColor];    // 隔断区域
            
        }
        
        [_mainView addSubview:view];
    }
    
    [self loadValueLabel];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
