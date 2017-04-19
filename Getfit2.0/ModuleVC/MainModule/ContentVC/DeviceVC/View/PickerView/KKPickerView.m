//
//  KKPickerView.m
//  AJBracelet
//
//  Created by zorro on 16/3/26.
//  Copyright © 2016年 zorro. All rights reserved.
//

#import "KKPickerView.h"

@interface KKPickerView ()

@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation KKPickerView

- (instancetype)initWithFrame:(CGRect)frame withValues:(NSArray *)values
{
    self = [super initWithFrame:frame];
    if (self) {
        self.values = values;
        self.userInteractionEnabled = YES;
        
        // self.backgroundColor = [UIColor redColor];
        
        [self loadPickerView];
    }
    return self;
}

- (void)loadPickerView
{
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    [_pickerView selectRow:self.selectedIndex inComponent:0 animated:NO];
    [self addSubview:_pickerView];
}

- (NSString *)selectedValue
{
    return [self.values objectAtIndex:self.selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        if (_pickerView) {
            [_pickerView selectRow:selectedIndex inComponent:0 animated:YES];
        }
    }
}

- (void)setSelectedValue:(NSString *)selectedValue
{
    NSInteger index = [self.values indexOfObject:selectedValue];
    [self setSelectedIndex:index];
}

#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.values.count;
}

#pragma mark - Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.values objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        pickerLabel.textColor=[UIColor whiteColor];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
    }
    // Fill the label text here
    pickerLabel.text = [self.values objectAtIndex:row];
    
    return pickerLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
