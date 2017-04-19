//
//  UseDataShowViewController.h
//  Aircraft cup
//
//  Created by 黄建华 on 15/10/23.
//  Copyright © 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "showRemarkView.h"
#import "AppDelegate.h"
#import "CustomSwitch.h"

@interface UseDataShowViewController : UIViewController
@property (nonatomic, strong) showRemarkView *showDataView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *aveLabel;
@property (nonatomic, strong) CustomSwitch *switchBtn;
@property (nonatomic, strong) NSMutableArray *heartArray;

@property (nonatomic, strong) UILabel *heartLabel;

@property (nonatomic, assign) NSInteger currentHeart;
@property (nonatomic, assign) NSInteger maxHeart;
@property (nonatomic, assign) NSInteger minHeart;
@property (nonatomic, assign) NSInteger aveHeart;

@property (nonatomic, strong) NSMutableArray *heartDataArray;

@end
