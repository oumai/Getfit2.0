//
//  SPTribeMemberCell.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/23.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPTribeMemberCell.h"

@interface SPTribeMemberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roleLabelWidthConstaint;

@end

@implementation SPTribeMemberCell

- (void)awakeFromNib {
    // Initialization code
    self.roleLabel.layer.cornerRadius = 2.0;
    self.roleLabel.clipsToBounds = YES;

    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) * 0.5;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.roleLabelWidthConstaint.constant = self.roleLabel.intrinsicContentSize.width + 4 * 2;
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *color = self.roleLabel.backgroundColor;
    [super setSelected:selected animated:animated];
    self.roleLabel.backgroundColor = color;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor *color = self.roleLabel.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.roleLabel.backgroundColor = color;
}

- (void)configureWithAvatar:(UIImage *)image name:(NSString *)title role:(YWTribeMemberRole)role {
    self.avatarImageView.image = image;
    self.nameLabel.text = title;

    switch (role) {
        case YWTribeMemberRoleOwner:
            self.roleLabel.text = KK_Text(@"Lord");
            self.roleLabel.backgroundColor = [UIColor colorWithRed:1.0 green:189./255 blue:4./255 alpha:1.0];
            self.roleLabel.hidden = NO;
            break;
        case YWTribeMemberRoleManager:
            self.roleLabel.text = KK_Text(@"Administrator");
            self.roleLabel.backgroundColor = [UIColor colorWithRed:69.0/255 green:210./255 blue:130./255 alpha:1.0];
            self.roleLabel.hidden = NO;
            break;
        default:
            self.roleLabel.text = nil;
            self.roleLabel.hidden = YES;
            break;
    }

    self.roleLabel.hidden = YES;
}

@end
