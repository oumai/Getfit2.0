//
//  AlarmTypePickerView.m
//  custom_button
//
//  Created by 黄建华 on 15/7/10.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "CustomPickerView.h"

@implementation CustomPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadPickerView];
    }

    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self calculationComponents];
}

- (void)setDataArray2:(NSArray *)dataArray2
{
    _dataArray2 = dataArray2;
    [self calculationComponents];
}

- (void)setDataArray3:(NSArray *)dataArray3
{
    _dataArray3 = dataArray3;
    [self calculationComponents];
}

- (void)calculationComponents
{
    _components = 0;
    if (_dataArray.count > 0)
    {
        _components ++;
    }
    if (_dataArray2.count > 0)
    {
        _components ++;
    }
    if (_dataArray3.count > 0)
    {
        _components ++;
    }
    [self reloadAllComponents];
    NSLog(@"component>>>%d",_components);
    
}

- (void)loadPickerView
{
    self.dataSource = self;
    self.delegate = self;
    
    UIView *selectView01 = [[UIView alloc] initWithFrame:CGRectMake(0, 84, self.frame.size.width, 0.5)];
    selectView01.backgroundColor = [UIColor whiteColor];
    [self addSubview:selectView01];
    
    UIView *selectView02 = [[UIView alloc] initWithFrame:CGRectMake(0, 44 * 3 - 1 , self.frame.size.width, 0.5)];
    selectView02.backgroundColor = [UIColor whiteColor];
    [self addSubview:selectView02];
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    
    return _components;
    // 返回1表明该控件只包含1列
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回books.count，表明books包含多少个元素，该控件就包含多少行
    
    if(component == 0)
    {
       return _dataArray.count;
    }
    else if (component == 1)
    {
        return _dataArray2.count;
    }else
    {
        return _dataArray3.count;
    }
}

// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回books中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用books中的第几个元素
    
    if(component == 0)
    {
        return [_dataArray objectAtIndex:row];
    }
    else if (component == 1)
    {
        return [_dataArray2 objectAtIndex:row];
    }else
    {
        return [_dataArray3 objectAtIndex:row];
    }

}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    // 使用一个UIAlertView来显示用户选中的列表项
    //     UIAlertView* alert = [[UIAlertView alloc]
    //                          initWithTitle:@"提示"
    //                          message:[NSString stringWithFormat:@"你选中的图书是：%@"
    //                                   , [_dataArray objectAtIndex:row]]
    //                          delegate:nil
    //                          cancelButtonTitle:@"确定"
    //                          otherButtonTitles:nil];
    //   [alert show];
    
    if (_customPickerSelectBlock)
    {
        _customPickerSelectBlock (component,row);
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0;
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
//    label.textAlignment = NSTextAlignmentCenter;
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [label setBackgroundColor:[UIColor clearColor]];
//    label.textColor = [UIColor blackColor];
//    label.font = [UIFont systemFontOfSize:20.0];
//    label.text= [self pickerView:pickerView titleForRow:row forComponent:component];
//    
//    if (_components == 1)
//    {
//        if (component == 0) {
//            [label setText:[_dataArray objectAtIndex:row]];
//        }
//    }
//    else if (_components == 2)
//    {
//        if (component == 0) {
//            [label setText:[_dataArray objectAtIndex:row]];
//        }
//        else if (component == 1)
//        {
//            [label setText:[_dataArray2 objectAtIndex:row]];
//        }
//
//    }
//    else if (_components == 3)
//    {
//        if (component == 0) {
//            [label setText:[_dataArray objectAtIndex:row]];
//        }
//        else if (component == 1)
//        {
//            [label setText:[_dataArray2 objectAtIndex:row]];
//        }
//        else if (component == 2)
//        {
//            [label setText:[_dataArray3 objectAtIndex:row]];
//        }
//    }
//    
//    return label;
//}

// NSInteger row=[_pickerViewController.pickerView selectedRowInComponent:0];
/*
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
