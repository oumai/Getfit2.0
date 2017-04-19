//
//  segMentScrollView.h
//  Logistics
//
//  Created by zhou on 15/7/4.
//  Copyright (c) 2015年 Shawsan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailSegSelectView : UIView

typedef void(^SegmentSelect)(NSInteger select);

@property (nonatomic, strong) UIButton *weekButton;
@property (nonatomic, strong) UIButton *monthButton;
@property (nonatomic, strong) UIButton *yearButton;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) SegmentSelect segmentSelectBlock;

@end
