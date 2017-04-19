//
//  FamilyListCell.h
//  StoryPlayer
//
//  Created by zhanghao on 15/12/8.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *familyName;
@property (weak, nonatomic) IBOutlet UILabel *familyRemark;
@property (weak, nonatomic) IBOutlet UIView *rootView;
-(void)refreshUIWithDictionary:(NSDictionary *)dic;
@end
