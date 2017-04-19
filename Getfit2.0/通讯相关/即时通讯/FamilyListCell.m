//
//  FamilyListCell.m
//  StoryPlayer
//
//  Created by zhanghao on 15/12/8.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "FamilyListCell.h"
#import "ZHObject.h"
@implementation FamilyListCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)refreshUIWithDictionary:(NSDictionary *)dic
{
    NSLog(@"dic is %@",dic);
    [_rootView setCornerRadiusss:4];
    [_logoView setRoundLayer];
    [_logoView setImageWithURL:[NSURL URLWithString:formartStr(dic[@"head_img"])]
              placeholderImage:UIImageNamed(@"xiangji.png")];
    _familyName.text = formartStr(dic[@"title"]);
    [_familyRemark setText:formartStr(dic[@"description"]) AutoResizeInHeight:88];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
