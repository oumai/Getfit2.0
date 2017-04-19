//
//  AlarmTypePickerView.h
//  custom_button
//
//  Created by 黄建华 on 15/7/10.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickerView : UIPickerView <UIPickerViewDataSource,UIPickerViewDelegate>

typedef void(^CustomPickerSelect)(NSInteger Component,NSInteger indexRow);

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *dataArray2;
@property (nonatomic, strong) NSArray *dataArray3;

@property (nonatomic, assign) NSInteger components;

@property (nonatomic, strong) CustomPickerSelect customPickerSelectBlock;

@end
