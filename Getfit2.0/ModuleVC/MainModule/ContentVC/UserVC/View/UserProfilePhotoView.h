//
//  UserProfilePhotoView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/31.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserProfilePhotoDeleagte;
@interface UserProfilePhotoView : UIView

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *actionSheetView;

@property (nonatomic, assign) id <UserProfilePhotoDeleagte> delegate;

- (void)cancelbuttonClick;

@end

@protocol UserProfilePhotoDeleagte <NSObject>
@end