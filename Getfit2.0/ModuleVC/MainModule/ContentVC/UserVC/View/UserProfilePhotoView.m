//
//  UserProfilePhotoView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/31.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserProfilePhotoView.h"

@implementation UserProfilePhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        [self loadPhotoView];//这个界面已经有了，谁写重复了，注释掉
    }
    return self;
}

- (void)loadPhotoView
{
    _backGroundView = [[UIView alloc] initWithFrame:self.frame];
    _backGroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    [self addSubview:_backGroundView];
    
    _actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, Maxheight, Maxwidth, 240)];
//    _actionSheetView = [[UIView alloc] init];
    [self addSubview:_actionSheetView];
    _actionSheetView.image = [UIImage image:@"userphoto_5@2x.png"];
//    [self showActionSheetView];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 240*4/5, Maxwidth, 44)];
    [cancelButton setTitle:KK_Text(@"Cancel") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [_actionSheetView addSubview:cancelButton];
    
    UIButton *takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 240*3/5 - 104, Maxwidth, 44)];
    [takePhotoButton setTitle:KK_Text(@"Photograph") forState:UIControlStateNormal];
    [takePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [takePhotoButton addTarget:self action:@selector(takePhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_actionSheetView addSubview:takePhotoButton];
    
    UIButton *selectPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 240*2/5 - 151, Maxwidth, 44)];
    [selectPhotoButton setTitle:KK_Text(@"Choose Current Photo") forState:UIControlStateNormal];
    [selectPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_actionSheetView addSubview:selectPhotoButton];
    
    UIButton *deletePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 240*1/5 - 195, Maxwidth, 44)];
    [deletePhotoButton setTitle:KK_Text(@"Remove photo") forState:UIControlStateNormal];
    [deletePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deletePhotoButton addTarget:self action:@selector(deletePhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_actionSheetView addSubview:deletePhotoButton];
    
    UIButton *settingImageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, 44)];
    [settingImageButton setTitle:KK_Text(@"Profile Photo Setting") forState:UIControlStateNormal];
    [settingImageButton setTitleColor:UIColorHEX(0x888b90) forState:UIControlStateNormal];
    [settingImageButton setFontSize:12.0];
    [settingImageButton addTarget:self action:@selector(settingImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_actionSheetView addSubview:settingImageButton];
    
    [self showActionSheetView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    [_backGroundView addSubview:tap];
}

- (void)settingImageButtonClick
{
    
}

- (void)deletePhotoButtonClick
{
//    if ([self.delegate respondsToSelector:@selector(deletePhotoButtonClick:)]) {
//        [self.delegate performSelector:@selector(deletePhotoButtonClick:) withObject:nil];
//    }
}

- (void)selectPhotoButtonClick
{
//    if ([self.delegate respondsToSelector:@selector(selectPhotoButtonClick:)]) {
//        [self.delegate performSelector:@selector(selectPhotoButtonClick:) withObject:nil];
//    }
}

- (void)takePhotoButtonClick
{
//    if ([self.delegate respondsToSelector:@selector(takePhotoButtonClick:)]) {
//        [self.delegate performSelector:@selector(takePhotoButtonClick:) withObject:nil];
//    }

}

- (void)cancelbuttonClick
{
    [self hiddenActionSheetView];
    self.hidden = YES;
}

- (void)showActionSheetView
{
    [UIView animateWithDuration:0.25 animations:^{
        _actionSheetView.frame = CGRectMake(0, Maxheight - 240, Maxwidth, 240);
    }];
}

- (void)hiddenActionSheetView
{
    [UIView animateWithDuration:0.25 animations:^{
        _actionSheetView.frame = CGRectMake(0, Maxheight, Maxwidth, 240);
    }];
}

@end
