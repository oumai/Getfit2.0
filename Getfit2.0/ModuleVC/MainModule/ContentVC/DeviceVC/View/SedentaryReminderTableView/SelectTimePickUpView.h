//
//  SelectTimePickUpView.h
//  PickUpview
//
//  Created by 黄建华 on 15/7/21.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTimePickUpView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

typedef void(^CustomsPickViewClick) (NSString *hour,NSString *minute);
typedef void(^CustomsPickViewShow) (BOOL hidden);

@property (nonatomic, strong) CustomsPickViewClick customPickClickBlock;
@property (nonatomic, strong) CustomsPickViewShow CustomsPickViewShowBlock;

@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) NSMutableArray *hoursArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *pgView;

- (void)pickUpViewSetBeginTime;
- (void)pickUpViewSetEndTime;

- (void)showView;

- (void)cancelView;
@end
