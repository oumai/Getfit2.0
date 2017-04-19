//
//  V_Active_ProgressView.h
//  VeryFit_Active_ProgressView
//
//  Created by 黄建华 on 15/6/9.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomieScrollViewDelegate <NSObject>

- (void)CustomieScrollViewCheekDate:(NSInteger)index;

@end

@interface CustomieScrollView : UIView <UIScrollViewDelegate>

typedef void(^CustomieScrollViewSelectIndex) (NSInteger indexRow);

@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger loadIndex;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *heightPointArray;
@property (nonatomic, strong) UIImageView *redDot;
@property (nonatomic, assign) BOOL stepOrSleep;
@property (nonatomic, strong) CustomieScrollViewSelectIndex CustomieScrollViewSelectBlock;

@property (nonatomic, strong) id<CustomieScrollViewDelegate>  CustomieScrollViewDelegate;

- (void)CustomieScrollViewUpdate:(NSInteger)type dataArray:(NSArray *)Array;

- (void)resetOffSet:(NSInteger)index;

@end
