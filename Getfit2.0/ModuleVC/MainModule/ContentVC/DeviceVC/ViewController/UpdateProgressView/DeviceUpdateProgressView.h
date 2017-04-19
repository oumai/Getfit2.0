//
//  DeviceUpdatePoessView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceUpdateProgressView : UIView

- (void)loadUpdateProgressView;

@property (nonatomic, strong)UIView *progressView;

- (void)setProgress:(CGFloat)Value;

@end
