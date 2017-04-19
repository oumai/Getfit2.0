//
//  ShowScrollView.h
//  AJBracelet
//
//  Created by 黄建华 on 15/7/15.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imageArray;

@end
