//
//  NSObject+Uislider.m
//  slide
//
//  Created by bodyconn on 15/2/4.
//  Copyright (c) 2015年 bodyconn. All rights reserved.
//

#import "KUlSlide.h"

@implementation KUlSlide

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self loadSlider];
        _transformType = NO;
    }
    return self;
}
- (void)Settransform:(BOOL)Type
{
    if (Type == YES)
    {
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.transform =transform;
        _transformType =YES;
    }else
    {
        _transformType =NO;
    }
}

- (void)loadSlider
{
    [self setMinimumTrackImage:[UIImage imageNamed:@"Device_Schedule_2_5s@2x"] forState:UIControlStateNormal];
    [self setMaximumTrackImage:[UIImage imageNamed:@"Device_Schedule_1_5s@2x"] forState:UIControlStateNormal];
    [self setThumbImage:[UIImage imageNamed:@"Device_Stripe_1_5s@2x.png"] forState:UIControlStateNormal];

    self.maximumValue = 1.0;
    self.minimumValue = 0.0;
    self.value = 0.0;
    [self addTarget:self action:@selector(panSlider:) forControlEvents:UIControlEventValueChanged];
    [self addTarget:self action:@selector(TouchSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(TouchSlider:) forControlEvents:UIControlEventTouchUpOutside];
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(fingerIncident:)];
    singleFingerOne.numberOfTouchesRequired = 1;
    singleFingerOne.numberOfTapsRequired = 1;
    singleFingerOne.delegate= self;
    [self addGestureRecognizer:singleFingerOne];
    
    //    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    //    [self addGestureRecognizer:panGesture];
}
- (void)panSlider:(UISlider *)slider
{
    if ([_delegate respondsToSelector:@selector(SliderChangeValue:)])
    {
        [_delegate SliderChangeValue:self];
    }
}
- (void)TouchSlider:(UISlider *)slider
{
    if ([_delegate respondsToSelector:@selector(SliderTouchChangeValue:)])
    {
        [_delegate SliderTouchChangeValue:self];
    }
}
- (void)fingerIncident:(UITapGestureRecognizer *)sender
{
    if (self.state == 1) {
        return;
    }
    if (sender.numberOfTouchesRequired==1) {
        
        if(sender.numberOfTapsRequired == 1) {
            
            CGPoint tapPoint = [sender locationInView:self];
            
            float setValue = 0.0;
            
            if (_transformType) {
                setValue = tapPoint.x/self.frame.size.height ;
            }else{
                setValue = tapPoint.x/self.frame.size.width ;
            }
            
            [self setValue:setValue animated:NO];
            
            if ([_delegate respondsToSelector:@selector(SliderClickChangeValue:)])
            {
                [_delegate SliderClickChangeValue:self];
            }
        }
        
    }
}


@end
