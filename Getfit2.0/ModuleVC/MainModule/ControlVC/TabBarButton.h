//
//  TabBarButton.h
//  BopLost
//
//  Created by zorro on 15/4/10.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarButton : UIButton

@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIViewSimpleBlock backBlock;

- (instancetype)initWithFrame:(CGRect)frame withBackBlock:(UIViewSimpleBlock)block;
- (void)setNomarlImage:(NSString *)string withTitle:(NSString *)text withTextColor:(UIColor *)color;
- (void)setSelectorlImage:(NSString *)string withTitle:(NSString *)text withTextColor:(UIColor *)color;

@end
