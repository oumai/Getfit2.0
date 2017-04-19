//
//  CameraController.h
//  AJBracelet
//
//  Created by kinghuang on 15/8/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceNavViewController.h"
#import "SCCaptureSessionManager.h"
#import "BLTAcceptModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraController : DeviceNavViewController <BLTControlTypeDelegate>

@property (nonatomic, assign) CGRect previewRect;
@property (nonatomic, assign) BOOL ifSaveImageToLocal;  ////YES为拍照，NO为设置头像

@end
