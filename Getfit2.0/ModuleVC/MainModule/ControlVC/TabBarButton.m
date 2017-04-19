//
//  TabBarButton.m
//  BopLost
//
//  Created by zorro on 15/4/10.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TabBarButton.h"

@interface TabBarButton ()

@property (nonatomic, strong) NSString *norImage;
@property (nonatomic, strong) NSString *norTitle;
@property (nonatomic, strong) NSString *selImage;
@property (nonatomic, strong) NSString *selTitle;
@property (nonatomic, strong) UIColor *norColor;
@property (nonatomic, strong) UIColor *selColor;
@end

@implementation TabBarButton

- (instancetype)initWithFrame:(CGRect)frame withBackBlock:(UIViewSimpleBlock)block
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backBlock = block;
        
        [self addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BGCOLOR;
        
        [self loadViews];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        _markImage.image = UIImageNamed(_selImage);
        _title.text = _selTitle;
        _title.textColor = _selColor;
    }
    else
    {
        _markImage.image = UIImageNamed(_norImage);
        _title.text = _norTitle;
        _title.textColor = _norColor;
    }
}

- (void)loadViews
{
    // 这里需要个向左的图标.
    _markImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 44) / 2, 0, 44, 44)];
    _markImage.backgroundColor = [UIColor clearColor];
    _markImage.image = [UIImage imageNamed:@""];
    [self addSubview:_markImage];
    _markImage.userInteractionEnabled = NO;
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 20, self.width, 20)];
    
    _title.backgroundColor = [UIColor clearColor];
    _title.font = [UIFont systemFontOfSize:11.0];
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title];
    _title.userInteractionEnabled = NO;
}

- (void)setNomarlImage:(NSString *)string withTitle:(NSString *)text withTextColor:(UIColor *)color
{
    _norImage = string;
    _norTitle = text;
    _norColor = color;
}

- (void)setSelectorlImage:(NSString *)string withTitle:(NSString *)text withTextColor:(UIColor *)color
{
    _selImage = string;
    _selTitle = text;
    _selColor = color;
}

- (void)clickBack:(UIButton *)button
{
    if (_backBlock)
    {
        _backBlock(self, nil);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
