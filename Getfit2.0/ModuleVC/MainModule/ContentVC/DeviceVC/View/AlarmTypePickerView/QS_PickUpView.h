//
//  PickUpView.h
//  HappySleep
//
//  Created by 黄建华 on 15/3/23.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol PickUpDelegate <NSObject>

- (void)selectHours:(NSString*)hours SelectMin:(NSString*)min SelectDay:(NSString *)daySplit;

@end

@interface QS_PickUpView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>




@property (nonatomic, strong) UIPickerView *yearpickerView;
@property (nonatomic, strong) UIPickerView *monthpickerView;
@property (nonatomic, strong) UIPickerView *daySplitpickerView;
@property (nonatomic, strong) NSArray *daySplitArray;
@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) NSArray *minArray;
@property (nonatomic, assign) NSInteger mytag;
@property (nonatomic, assign) id <PickUpDelegate> PickDelegate;


- (void)updatePickTime:(NSInteger)hour min:(NSInteger)min daySplit:(NSInteger)daySplit;

@end
