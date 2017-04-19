//
//  AlarmTypePickerView.h
//  custom_button
//
//  Created by 黄建华 on 15/7/10.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmTypePickerView : UIPickerView <UIPickerViewDataSource,UIPickerViewDelegate>

typedef void(^AlarmTypePickerSelect)(NSInteger indexRow);

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) AlarmTypePickerSelect AlarmTypeSelectBlock;

- (void)alarmTypeSet:(NSInteger)type;


@end
