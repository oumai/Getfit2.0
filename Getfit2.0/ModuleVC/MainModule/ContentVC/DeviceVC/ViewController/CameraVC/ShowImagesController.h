//
//  ShowImagesController.h
//  AJBracelet
//
//  Created by kinghuang on 15/8/29.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ShowImagesController : UIViewController

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) UIButton *backToCamera;
@property (nonatomic,copy) NSString *albumPath;
@property (nonatomic, strong) UIScrollView *scrollerImageView;
@end
