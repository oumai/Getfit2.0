//
//  CustomsPickView.h
//  PickUpview
//
//  Created by 黄建华 on 15/7/20.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomsPickView : UIView

typedef void(^CustomsPickViewClick) (BOOL value);

@property (nonatomic, strong) CustomsPickViewClick customPickClickBlock;

- (void)showView;

- (void)hiddenView;

@end
