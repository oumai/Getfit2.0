//
//  UnitSelectionView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitSelectionView : UIView

@property (nonatomic, strong) UIButton *metricButton;
@property (nonatomic, strong) UIButton *inchButton;
@property (nonatomic, assign) BOOL isMetricSystem;

@end
