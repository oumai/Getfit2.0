//
//  DetailScrollView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DetailScrollView.h"
#import "DateTools.h"

@implementation DetailScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadScrollView];
    }
    return self;
}

- (void)loadScrollView
{
    self.backgroundColor = [UIColor clearColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bouncesZoom = NO;
    self.bounces = YES;
    self.delegate = self;
    self.autoresizingMask = 0xFF;
    self.contentMode = UIViewContentModeCenter;
    self.pagingEnabled = YES;

//    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 , 130, 120, 25)];
//    infoLabel.textAlignment = NSTextAlignmentCenter;
//    infoLabel.textColor = [UIColor blackColor];
//    infoLabel.text = @"无数据";
//    infoLabel.font = [UIFont systemFontOfSize:22];
//    [self addSubview: infoLabel];
    
    _changeValue = 1;
    [self loadBeforeView];
    [self loadMiddleView];
    [self loadNextView];
    [self detailScrollUpdate:1];

}

- (void)loadBeforeView
{
    if (_beforeView)
    {
        [_beforeView removeFromSuperview];
        _beforeView = nil;
    }
    _beforeView = [[DetailStepView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _beforeView.tag = 1;
    [self addSubview: _beforeView];
    _beforeView.backgroundColor = [UIColor clearColor];
    [_beforeView showView:_changeValue];
}

- (void)loadMiddleView
{
    if (_middleView)
    {
        [_middleView removeFromSuperview];
        _middleView = nil;
    }
    _middleView = [[DetailStepView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
    _middleView.tag = 2;
    [self addSubview: _middleView];
    _middleView.backgroundColor = [UIColor clearColor];
    [_middleView showView:_changeValue];

}

- (void)loadNextView
{
    if (_nextView)
    {
        [_nextView removeFromSuperview];
        _nextView = nil;
    }
    _nextView = [[DetailStepView alloc] initWithFrame:CGRectMake(self.width * 2, 0, self.width, self.height)];
    _nextView.tag = 3;
    [self addSubview: _nextView];
    _nextView.backgroundColor = [UIColor clearColor];
    [_nextView showView:_changeValue];
}

- (void)showStepOrSleepView:(BOOL)value
{
    _changeValue = value;
    [_beforeView showView:_changeValue];
    [_middleView showView:_changeValue];
    [_nextView showView:_changeValue];
}

// 更新表
- (void)detailScrollUpdate:(NSInteger)Type
{
    _historyIndex = 1;
    [self getDataCount:Type]; // 1:是周 2:是日 3:是年
    
    [self UpdateView];
    if (_dataCount == 2)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateDetailViewDate" object:[_historyData objectAtIndex:1]];
    }
    
}
- (NSInteger)getDataCount:(NSInteger)Type
{
    _beforeDate = [SAVEFIRSTUSERDATE getObjectValue];
    if (Type == 1) {
        if (ISTESTMODEL) {
            _beforeDate = [[NSDate alloc]initWithTimeIntervalSinceNow:- 24 *3600 * 20];
        }
        
        NSInteger beforeWeekIndex = _beforeDate.weekOfYear;
        NSInteger NowWeekIndex = [NSDate date].weekOfYear;
        
        NSLog(@"beforeWeekIndex>>>>%d NowWeekIndex >>>%d",beforeWeekIndex,NowWeekIndex);
        
        
        _dataCount = NowWeekIndex - beforeWeekIndex + 1;
        
        if (_dataCount < 0) {
            _dataCount = _dataCount + 52;
        }
        
        _interval = 7;
    }
    else if (Type == 2) {
        if (ISTESTMODEL) {
            _beforeDate = [[NSDate alloc]initWithTimeIntervalSinceNow:- 24 *3600 * 365];
        }
        
        NSDate *today = [NSDate date];
        _dataCount = (today.year - _beforeDate.year) * 12 + (today.month - _beforeDate.month);
        _dataCount +=1;
    } else if (Type == 3) {
        if (ISTESTMODEL) {
            _dataCount = [NSDate date].year  - _beforeDate.year + 1 +2;
        } else {
            _dataCount = [NSDate date].year  - _beforeDate.year + 1;
        }
    }
    _typeValue = Type;
    
    return _dataCount;
}

- (void)UpdateView
{
    [DATAVALUECOUNT setObjectValue:[NSString stringWithFormat:@"%d",_dataCount]];
    [self loadBeforeView];
    [self loadMiddleView];
    [self loadNextView];
    _middleView.hidden = NO;
    _beforeView.hidden = NO;
    _nextView.hidden = NO;
    self.scrollEnabled = YES;
    _currentIndex = 0;
    _monthIndex = [NSDate date].month;
    _yearIndex = [NSDate date].year;
    
    if (_dataCount == 0) {
//        _middleView.hidden = YES;
//        _beforeView.hidden = YES;
//        _nextView.hidden = YES;
        self.scrollEnabled = NO;
        self.contentSize = CGSizeMake(Maxwidth, 0);
        self.contentOffset = CGPointMake(0, 0);
    }
    
    if (_dataCount == 1) {
        if (_typeValue == 1) {
            [_middleView detailScrollUpdateWeek:[self getDate:0]];
        }
        else if (_typeValue ==2) {
            [_middleView detailScrollUpdateMonth:[NSDate date].month];
        }
        else if (_typeValue ==3) {
            [_middleView detailScrollUpdateYear:[NSDate date].year];
        }
        
     self.contentSize = CGSizeMake(2 *Maxwidth, 0);
     self.contentOffset = CGPointMake(Maxwidth, 0);
     self.scrollEnabled = NO;
        
    } else if (_dataCount ==2) {
        _historyData = [[NSMutableArray alloc] init];
        
        if (_typeValue == 1) {
            WeekModel *before = [WeekModel getWeekModelFromDBWithDate:[self getDate:1] isContinue:NO];
            WeekModel *middle = [WeekModel getWeekModelFromDBWithDate:[self getDate:0] isContinue:NO];
            
//            NSLog(@"before>>>>>%@",before.showDaySleep);
//            
//             NSLog(@"middle>>>>>%@",before.showDaySleep);
//            
            [_historyData addObject:before];
            [_historyData addObject:middle];

            [_beforeView detailScrollUpdateWeek:[self getDate:1]];
            [_middleView detailScrollUpdateWeek:[self getDate:0]];
        } else if (_typeValue == 2) {
            MonthModel *before = [MonthModel getMonthModelFromDBWithMonthIndex:_monthIndex -1 isContinue:NO];
            MonthModel *middle = [MonthModel getMonthModelFromDBWithMonthIndex:_monthIndex isContinue:NO];
            
            [_historyData addObject:before];
            [_historyData addObject:middle];
            
            [_beforeView detailScrollUpdateMonth:_monthIndex -1];
            [_middleView detailScrollUpdateMonth:_monthIndex];
        } else if (_typeValue ==3) {
            YearModel *before = [YearModel getYearModelFromDBWithYearIndex:_yearIndex -1 isContinue:NO];
            YearModel *middle = [YearModel getYearModelFromDBWithYearIndex:_yearIndex isContinue:NO];
            
            [_historyData addObject:before];
            [_historyData addObject:middle];
            
            [_beforeView detailScrollUpdateYear:_yearIndex -1];
            [_middleView detailScrollUpdateYear:_yearIndex];
        }
        
        self.contentSize = CGSizeMake(2 * Maxwidth, 0);
        self.contentOffset = CGPointMake(Maxwidth, 0);
        
    } else if (_dataCount > 2) {
        if (_typeValue == 1) {
            [_beforeView detailScrollUpdateWeek:[self getDate:1]];
            [_middleView detailScrollUpdateWeek:[self getDate:0]];
        } else if (_typeValue == 2) {
            [_beforeView detailScrollUpdateMonth:_monthIndex -1];
            [_middleView detailScrollUpdateMonth:_monthIndex];
        } else if (_typeValue ==3) {
            [_beforeView detailScrollUpdateYear:_yearIndex -1];
            [_middleView detailScrollUpdateYear:_yearIndex];
        }
        self.contentSize = CGSizeMake(3 * Maxwidth, 0);
        self.contentOffset = CGPointMake(Maxwidth, 0);
    }
}

- (NSDate *)getDate:(NSInteger)index;
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[NSDate dateFormatterTemp];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval time = - 24 * 3600 * index * _interval;
    NSDate *beforeData =[senddate initWithTimeIntervalSinceNow:time];
    return beforeData;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_dataCount == 2) {
        if (scrollView.contentOffset.x < 320) {
            _currentIndex = 0;
            _monthIndex = 0;
            _yearIndex = 0;
        } else {
            _currentIndex = 1;
            _monthIndex = 1;
            _yearIndex = 1;
        }
        
        [self updateViewIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (_dataCount == 2) {
        if(contentOffsetX > Maxwidth )
        {
            [self setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
        } else if (contentOffsetX < 0 ) {
            [self setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
    
    if (_dataCount >2 )
    {
        if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
            [self updateView:YES];
        } else if(contentOffsetX <= 0) {
            [self updateView:NO];
        } else if(contentOffsetX > Maxwidth) {
            if (_typeValue == 1) {
                if (_currentIndex < 1 ) {
                    [self setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
                }
            } else if (_typeValue ==2)
            {
                
                if (_monthIndex >= [NSDate date].month)
                {
                    [self setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
                }
            }
            else if (_typeValue ==3)
            {
                if (_yearIndex >= [NSDate date].year)
                {
                    [self setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
                }
            }
        }
        else if (contentOffsetX < Maxwidth )
        {
            
            if (_typeValue ==1)
            {     // 左边
                if (_currentIndex + 2 > _dataCount)
                {
                    [self setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
                }
            }
            else if (_typeValue == 2)
            {
                if (_monthIndex + _dataCount - 2 <  [NSDate date].month)
                {
                    [self setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
                }
            }
            else if (_typeValue == 3)
            {
                if (_yearIndex + _dataCount - 2 <  [NSDate date].year)
                {
                    [self setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
                }
            }
        }
    }
}

- (void)updateViewIndex
{
    if (_typeValue == 1)
    {
        _historyIndex = _currentIndex;
    }
    else if (_typeValue == 2)
    {
        _historyIndex = _monthIndex;
    }
    else if (_typeValue == 3)
    {
        _historyIndex = _yearIndex;
    }
    if ((_dataCount == 2)&&(_historyData.count > _historyIndex)) ////切换时栈溢出崩溃
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDetailViewDate" object:[_historyData objectAtIndex:_historyIndex]];
    }

//    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateDetailViewDate" object:[_historyData objectAtIndex:_historyIndex]];
}

- (void)updateView:(BOOL)Direction
{
    [self loadBeforeView];
    [self loadMiddleView];
    [self loadNextView];
    
    if (Direction == NO)  // 更新最左边
    {
        NSLog(@" Move Left ");
        if (_typeValue == 1)
        {
            [_nextView detailScrollUpdateWeek: [self getDate:_currentIndex] ];
            [_middleView detailScrollUpdateWeek:[self getDate:_currentIndex + 1]];
            [_beforeView detailScrollUpdateWeek:[self getDate:_currentIndex + 2 ]];
            _currentIndex ++;
        }
        else if (_typeValue == 2)
        {
            [_nextView detailScrollUpdateMonth:_monthIndex];
            [_middleView detailScrollUpdateMonth:_monthIndex -1];
            [_beforeView detailScrollUpdateMonth:_monthIndex -2];
            _monthIndex --;
        }
        else if (_typeValue == 3)
        {
            [_nextView detailScrollUpdateYear:_yearIndex];
            [_middleView detailScrollUpdateYear:_yearIndex -1];
            [_beforeView detailScrollUpdateYear:_yearIndex -2];
            _yearIndex --;
        }
    }
    else   // 更新最右边
    {
        NSLog(@"Move Right ");
        if (_typeValue == 1)
        {
            [_nextView detailScrollUpdateWeek:[self getDate:_currentIndex - 2]];
            [_middleView detailScrollUpdateWeek:[self getDate:_currentIndex - 1]];
            [_beforeView detailScrollUpdateWeek:[self getDate:_currentIndex]];
            _currentIndex --;
        }
        else if (_typeValue == 2)
        {
            [_nextView detailScrollUpdateMonth:_monthIndex + 2];
            [_middleView detailScrollUpdateMonth:_monthIndex +1];
            [_beforeView detailScrollUpdateMonth:_monthIndex];
            _monthIndex ++;
        }
        else if (_typeValue == 3)
        {
            [_nextView detailScrollUpdateYear:_yearIndex + 2];
            [_middleView detailScrollUpdateYear:_yearIndex +1];
            [_beforeView detailScrollUpdateYear:_yearIndex];
            _yearIndex ++;
        }
    }
     [self setContentOffset:CGPointMake(self.size.width, 0)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
