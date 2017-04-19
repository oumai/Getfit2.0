//
//  PickUpView.m
//  HappySleep
//
//  Created by 黄建华 on 15/3/23.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "QS_PickUpView.h"
@implementation QS_PickUpView
#define UIColorHEX(hexValue) [UIColor colorFromHex:hexValue]
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupView];
    }
    
    return self;
}

- (void)setDaySplitArray:(NSArray *)daySplitArray
{
    _daySplitArray = daySplitArray;
}

-(void)setHourArray:(NSArray *)HourArray
{
    _hourArray = HourArray;
}

-(void)setMinArray:(NSArray *)minArray
{
    _minArray = minArray;
}

- (void)setupView
{
    UIImageView  *backGroundView  = [[UIImageView alloc]initWithFrame:self.frame];
    [self addSubview:backGroundView];
    
    _daySplitpickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    _daySplitpickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _daySplitpickerView.dataSource = self;
    
    _daySplitpickerView.delegate = self;
    
    //        _daySplitpickerView.frame = CGRectMake(20, -20, self.width/3 - 20, 60);
    _daySplitpickerView.showsSelectionIndicator = YES;
    
    [self addSubview:_daySplitpickerView];
    
    _yearpickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    _yearpickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; //这里设置了就可以自定义高度了，一般默认是无法修改其216像素的高度
    
    _yearpickerView.dataSource = self;
    
    _yearpickerView.delegate = self;
    
    //        _yearpickerView.frame = CGRectMake(self.width/3 , -20, self.width/3 - 20, 60);
    _yearpickerView.showsSelectionIndicator = YES;
    
    [self addSubview:_yearpickerView];
    
    _monthpickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    _monthpickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    _monthpickerView.dataSource = self;
    
    _monthpickerView.delegate = self;
    
    //        _monthpickerView.frame = CGRectMake(self.width * 2 /3 - 20, -20, self.width/2, 60);
    
    _monthpickerView.showsSelectionIndicator = YES;
    
    [self addSubview:_monthpickerView];
    
//    UILabel *year = [[UILabel alloc] init];
//    year.text = @":";
//    year.textColor = [UIColor whiteColor];
//    year.font =[UIFont systemFontOfSize:18.];
//    [self addSubview:year];
//    

//    UIView *selectView01 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.width, 0.5)];
//    selectView01.backgroundColor = [UIColor whiteColor];
//    [self addSubview:selectView01];
//    
//    UIView *selectView02 = [[UIView alloc] initWithFrame:CGRectMake(0, 77, self.width, 0.5)];
//    selectView02.backgroundColor = [UIColor whiteColor];
//    [self addSubview:selectView02];
    
    if ([UIApplication isHasAMPMTimeSystem]) {
        _daySplitpickerView.frame = CGRectMake(20, 0, self.width/3 - 20, 60);
        _yearpickerView.frame = CGRectMake(self.width/3 , 0, self.width/3 - 20, 60);
        _monthpickerView.frame = CGRectMake(self.width * 2 /3 - 20, 0, self.width/2, 60);
//        year.frame = CGRectMake(self.width * 2/3 , 50, 20, 20);
    }else{
        _yearpickerView.frame = CGRectMake(20 , 0, self.width/2 - 30, 60);
        _monthpickerView.frame = CGRectMake(self.width/2 + 20, 0, self.width/2 -30, 60);
//        year.frame = CGRectMake(self.width / 2 , 50, 20, 20);
    }

}

- (void)updatePickTime:(NSInteger)hour min:(NSInteger)min daySplit:(NSInteger)daySplit
{
    

    [_yearpickerView selectRow:hour inComponent:0 animated:NO];

    
    for (int i = 0; i < _minArray.count; i++)
    {
        if (min ==[[_minArray objectAtIndex:i]integerValue])
        {
            [_monthpickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    if (daySplit == 0) {
        [_daySplitpickerView selectRow:0 inComponent:0 animated:NO];
    }else {
        [_daySplitpickerView selectRow:1 inComponent:0 animated:NO];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    if (pickerView == _yearpickerView)
    {
        return _hourArray.count;
    }
    else if (pickerView == _monthpickerView){
        return _minArray.count;
    }else {
        return _daySplitArray.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger daySplit = [_daySplitpickerView selectedRowInComponent:0];
    NSInteger hourrow = [_yearpickerView selectedRowInComponent:0];
    NSInteger Minrow  = [_monthpickerView selectedRowInComponent:0];
    
    NSString *hourStr = [NSString stringWithFormat:@"%ld",hourrow];
    if ((hourrow > 12)||(hourrow == 12 && Minrow > 0)) {
        [self updatePickTime:hourrow min:Minrow daySplit:1];
        daySplit = 1;
    }else{
        [self updatePickTime:hourrow min:Minrow daySplit:0];
        daySplit = 0;
    }
    
    // NSInteger sum = hourrow*60 +Minrow;
    
    [self.PickDelegate selectHours:hourStr SelectMin:[_minArray objectAtIndex:Minrow] SelectDay:[NSString stringWithFormat:@"%ld",daySplit]];
    
    // 使用一个UIAlertView来显示用户选中的列表项
    
//    if (pickerView == _YearpickerView)
//    {
//        UIAlertView* alert = [[UIAlertView alloc]
//                              initWithTitle:@"提示"
//                              message:[NSString stringWithFormat:@"你选中的年份是：%@"
//                                       , [_yearArray objectAtIndex:row]]
//                              delegate:nil
//                              cancelButtonTitle:@"确定"
//                              otherButtonTitles:nil];
//        [alert show];
//    }else{
//        UIAlertView* alert = [[UIAlertView alloc]
//                              initWithTitle:@"提示"
//                              message:[NSString stringWithFormat:@"你选中月份：%@"
//                                       , [_MonthArray objectAtIndex:row]]
//                              delegate:nil
//                              cancelButtonTitle:@"确定"
//                              otherButtonTitles:nil];
//        [alert show];
//    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    myView = [[UILabel alloc] initWithFrame:CGRectMake(50, 0.0, 70, 30)];
        
    myView.textAlignment = NSTextAlignmentCenter;
    
    if (pickerView == _yearpickerView)
    {
        myView.text = [_hourArray objectAtIndex:row];
    }
    else if(pickerView == _monthpickerView)
    {
        myView.text = [_minArray objectAtIndex:row];
    }else {
        
        myView.text = [_daySplitArray objectAtIndex:row];
    }
    
    myView.textColor = [UIColor whiteColor];
    myView.font = [UIFont systemFontOfSize:18];
    return myView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = self.width/2 - 40;
    return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

@end
