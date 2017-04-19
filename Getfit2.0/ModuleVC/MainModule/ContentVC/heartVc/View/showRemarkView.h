//
//  showRemarkView.h
//  Warm
//
//  Created by 黄建华 on 15/8/6.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeedDrawView.h"
#import "ShapeView.h"
#import "NavLabel.h"

@interface showRemarkView : UIView <UIScrollViewDelegate>

@property (nonatomic, readonly) NeedDrawView *pathBuilderView;
@property (nonatomic, strong) NavLabel *startTime;
@property (nonatomic, strong) NavLabel *endTime;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)updateShowView:(NSArray *)array isAnimation:(BOOL)isAnimation;

@end
