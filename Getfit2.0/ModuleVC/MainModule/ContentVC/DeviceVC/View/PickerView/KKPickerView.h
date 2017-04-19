
//
//  KKPickerView.h
//  AJBracelet
//
//  Created by zorro on 16/3/26.
//  Copyright © 2016年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSString *selectedValue;
@property (nonatomic, assign) NSUInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame withValues:(NSArray *)values;

@end
