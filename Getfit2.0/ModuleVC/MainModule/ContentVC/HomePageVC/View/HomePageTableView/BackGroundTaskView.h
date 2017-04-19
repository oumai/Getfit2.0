//
//  BackGroundTaskView.h
//  CoreBlueTooth
//
//  Created by bodyconn on 15/2/2.
//  Copyright (c) 2015年 bodyconn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackGroundTaskView : NSObject

AS_SINGLETON(BackGroundTaskView)

typedef void (^BackGroundTask)(BOOL BackState);

@property (nonatomic, strong) BackGroundTask BackGroundTaskBlock;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskId; /* 后台任务*/
@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, assign) int Runcount;
@property (nonatomic, assign) int RunTotalCount;
@property (nonatomic, assign) BOOL isBackGroundTask;              /* 是否自动重连*/
@end
