//
//  SPTribeMemberCell.h
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/23.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWTribeMember.h>


@interface SPTribeMemberCell : UITableViewCell

- (void)configureWithAvatar:(UIImage *)image name:(NSString *)title role:(YWTribeMemberRole)role;

@end
