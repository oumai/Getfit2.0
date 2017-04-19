//
//  DeviceRefreshView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceRefreshView : UIView

typedef void(^RefreshViewBlock)(DeviceRefreshView *refreshView);

@property (nonatomic, strong) UIImageView *refreshView;
@property (nonatomic, assign) NSInteger angle;
@property (nonatomic, assign) float time;
@property (nonatomic, strong) RefreshViewBlock endRefreshBlock;
@property (nonatomic, strong) RefreshViewBlock StartrefreshBlock;
@property (nonatomic, assign) NSInteger totalAngle;

- (void)Start:(float)time refreshtype:(NSInteger)type startRefreshBlock:(RefreshViewBlock)startBlock
endRefreshBlock:(RefreshViewBlock)endBlock;

@end
