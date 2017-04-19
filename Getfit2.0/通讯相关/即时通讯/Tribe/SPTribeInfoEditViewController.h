//
//  SPTribeInfoEditViewController.h
//  WXOpenIMSampleDev
//
//  Created by shili.nzy on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

typedef enum : NSUInteger {
    SPTribeInfoEditModeModify,
    SPTribeInfoEditModeCreateNormal,
    SPTribeInfoEditModeCreateMultipleChat,
} SPTribeInfoEditMode;


@class SPTribeInfoEditViewController;
@protocol SPTribeInfoEditViewControllerDelegate <NSObject>
@optional

- (void)tribeInfoEditViewController:(SPTribeInfoEditViewController *)controller tribeDidChange:(YWTribe *)tribe;

@end


@interface SPTribeInfoEditViewController : UIViewController

@property (nonatomic, weak) id<SPTribeInfoEditViewControllerDelegate> delegate;

@property (nonatomic, strong) YWTribe *tribe;

@property (nonatomic, assign) SPTribeInfoEditMode mode;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submit;

@end
