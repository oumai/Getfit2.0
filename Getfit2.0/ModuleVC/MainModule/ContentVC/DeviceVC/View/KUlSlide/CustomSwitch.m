//
//  CustomSwitch.m
//  Main3d
//
//  Created by kinghuang on 15/8/5.
//  Copyright (c) 2015年 KingHuang. All rights reserved.
//

#import "CustomSwitch.h"

@implementation CustomSwitch


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _switchBtn.frame = self.bounds;
    _switchBtn.clipsToBounds = YES;
//    [_switchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_switchBtn];
}


- (void)setOnImageName:(NSString *)onImageName {
    _onImageName = onImageName;
    [self.switchBtn setBackgroundImage:[UIImage imageNamed:onImageName] forState:UIControlStateSelected];
}

- (void)setOffImageName:(NSString *)offImageName {
    _offImageName = offImageName;
    [self.switchBtn setBackgroundImage:[UIImage imageNamed:offImageName] forState:UIControlStateNormal];
}

- (void)setBtnImageName:(NSString *)btnImageName {
    self.btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, self.frame.size.height-5, self.frame.size.height-5)];
    self.btnImage.image = [UIImage imageNamed:btnImageName];
    [self addSubview:self.btnImage];
}

- (void)setBtnState:(BOOL)on {
    if (on) {
        self.btnImage.frame = CGRectMake(self.frame.size.width - self.frame.size.height, 2, self.frame.size.height-5, self.frame.size.height-5);
//        [self setOnImageName:_onImageName];
    }else{
        self.btnImage.frame = CGRectMake(5, 2, self.frame.size.height-5, self.frame.size.height-5);
//        [self setOffImageName:_offImageName];
    }
}



- (void)btnClick:(UIButton *)sender {
  
}

@end
