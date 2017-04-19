//
//  NSObject+Uislider.h
//  slide
//
//  Created by bodyconn on 15/2/4.
//  Copyright (c) 2015年 bodyconn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderDelegate;

@interface KUlSlide : UISlider<UIGestureRecognizerDelegate>

@property (nonatomic, assign) id <SliderDelegate> delegate;
@property (nonatomic, assign) BOOL transformType;

- (void)Settransform:(BOOL)Type;

@end

@protocol SliderDelegate <NSObject>

- (void)SliderChangeValue:(KUlSlide*)Slide;
- (void)SliderTouchChangeValue:(KUlSlide*)Slide;
- (void)SliderClickChangeValue:(KUlSlide*)Slide;

@end