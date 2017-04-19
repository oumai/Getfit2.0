//
//  SPTribeInvitationCell.h
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/21.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWMessageBodyTribeSystem.h>

@class SPTribeInvitationCell;
@protocol SPTribeInvitationCellDelegate <NSObject>
- (void)tribeInvitationCellWantsAccept:(SPTribeInvitationCell *)cell;
- (void)tribeInvitationCellWantsIgnore:(SPTribeInvitationCell *)cell;
@end

@interface SPTribeInvitationCell : UITableViewCell

@property (weak, nonatomic) id<SPTribeInvitationCellDelegate> delegate;

- (void)configureWithMessage:(id<IYWMessage>)body;

@end
