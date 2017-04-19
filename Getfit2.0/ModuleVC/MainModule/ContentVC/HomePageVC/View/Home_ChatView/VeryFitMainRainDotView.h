//
//  VeryFitMainRainDotView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VeryFitMainRainDotView : UIView

@property (nonatomic, strong)UIView *rainDotView;

@property (nonatomic, assign)NSInteger rightCount;
@property (nonatomic, assign)NSInteger leftCount;

- (void)loadrainDotView;

@end
