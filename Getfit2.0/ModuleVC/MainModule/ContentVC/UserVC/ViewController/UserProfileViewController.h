//
//  UserProfileViewController.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceNavViewController.h"

@interface UserProfileViewController : DeviceNavViewController <UITextFieldDelegate>

@property (nonatomic,strong) UIImagePickerController *picker;

@end
