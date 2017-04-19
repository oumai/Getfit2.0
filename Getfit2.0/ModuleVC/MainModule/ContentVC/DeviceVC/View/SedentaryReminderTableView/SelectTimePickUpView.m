//
//  SelectTimePickUpView.m
//  PickUpview
//
//  Created by 黄建华 on 15/7/21.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "SelectTimePickUpView.h"

@implementation SelectTimePickUpView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadPickUpView];
    }
    return self;
}

- (void)loadPickUpView
{
    _bgView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:_bgView];
    
    _pgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.height, 300 )];
    _pgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pgView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 0.5)];
    line.backgroundColor = UIColorHEX(0x363636);
    [_pgView addSubview:line];
    
    UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [cancelButton setTitle:KK_Text(@"Cancel") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pgView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 0, 100, 50)];
    [confirmButton setTitle:KK_Text(@"Confirm") forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pgView addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 250)];
    _pickView.dataSource = self;
    _pickView.delegate = self;
    _hoursArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 24; i ++)
    {
        [_hoursArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    _minuteArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 60; i ++)
    {
        [_minuteArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    [_pgView addSubview:_pickView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap)];
    [_pickView addGestureRecognizer:tap];
}

- (void)bgTap
{
    [self cancelView];
}

- (void)showView
{
    _bgView.backgroundColor =[[UIColor blackColor]colorWithAlphaComponent:0.7];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _pgView.frame = CGRectMake(0, self.frame.size.height - 300, self.frame.size.height, 300 );
        
    } completion:^(BOOL finished) {
        
    }];
    
    if (_CustomsPickViewShowBlock)
    {
        _CustomsPickViewShowBlock(YES);
    }
}

- (void)cancelView
{
    _bgView.backgroundColor =[[UIColor blackColor]colorWithAlphaComponent:1.0];
    [UIView animateWithDuration:0.25 animations:^{
        
        _pgView.frame = CGRectMake(0, self.frame.size.height , self.frame.size.height, 260 );
        
    } completion:^(BOOL finished) {
    }];
    if (_CustomsPickViewShowBlock)
    {
        _CustomsPickViewShowBlock(NO);
    }
}

- (void)pickUpViewSetBeginTime;
{
    [_pickView selectRow:9 inComponent:0 animated:NO];
//    NSInteger hourRow = [_pickView selectedRowInComponent:0];
//    NSInteger minuteRow = [_pickView selectedRowInComponent:1];
//    
//    if (_customPickClickBlock)
//    {
//        _customPickClickBlock([_hoursArray objectAtIndex:hourRow],[_minuteArray objectAtIndex:minuteRow]);
//    }
}

- (void)pickUpViewSetEndTime
{
    [_pickView selectRow:18 inComponent:0 animated:NO];
//    NSInteger hourRow = [_pickView selectedRowInComponent:0];
//    NSInteger minuteRow = [_pickView selectedRowInComponent:1];
//    
//    if (_customPickClickBlock)
//    {
//        _customPickClickBlock([_hoursArray objectAtIndex:hourRow],[_minuteArray objectAtIndex:minuteRow]);
//    }
}

- (void)cancelButtonClick:(UIButton *)sender
{
    [self cancelView];
}

- (void)confirmButtonClick:(UIButton *)sender
{
    NSInteger hourRow = [_pickView selectedRowInComponent:0];
    NSInteger minuteRow = [_pickView selectedRowInComponent:1];
    
    if (_customPickClickBlock)
    {
        _customPickClickBlock([_hoursArray objectAtIndex:hourRow],[_minuteArray objectAtIndex:minuteRow]);
    }
    [self cancelView];
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return _hoursArray.count;
    }
    else
        return _minuteArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [_hoursArray objectAtIndex:row];
    }
    else
        return [_minuteArray objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
