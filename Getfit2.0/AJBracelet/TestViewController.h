//
//  TestViewController.h
//  AJBracelet
//
//  Created by kinghuang on 15/8/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController

@property (nonatomic, strong) UITextView *bleDetailTextView;
@property (nonatomic, strong) UITextView *bleDetailTextView2;
+ (TestViewController *)shareInstance;
-(void)updateLog:(NSString *)s;
-(void)updateLog2:(NSString *)s;
@end
