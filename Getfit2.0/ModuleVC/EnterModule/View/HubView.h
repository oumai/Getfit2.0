//
//  HubView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/6/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterPch.h"
@interface HubView : UIButton

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) NSTimer *progressTimer;       // 搜索动画定时器
@property (nonatomic, assign) NSInteger progressIndex;      // 搜索动画初始位置

- (void)start;
- (void)stopSearch;
- (void)startAnimation;                                     // 选中设备加载动画

@end
