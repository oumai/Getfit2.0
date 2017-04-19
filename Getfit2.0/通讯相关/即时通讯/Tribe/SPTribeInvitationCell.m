//
//  SPTribeInvitationCell.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/21.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPTribeInvitationCell.h"
#import <WXOpenIMSDKFMWK/YWIMCore.h>
#import <WXOpenIMSDKFMWK/IYWMessage.h>
#import <WXOpenIMSDKFMWK/YWPerson.h>
#import <WXOpenIMSDKFMWK/IYWTribeServiceDef.h>
#import "SPUtil.h"

@interface SPTribeInvitationCell ()
@property (weak, nonatomic) IBOutlet UIView *contentBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *tribeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *operationsContentView;

@property (weak) id<IYWMessage> message;

@end

@implementation SPTribeInvitationCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.contentBackgroundView.layer.cornerRadius = 6.0f;
    self.contentBackgroundView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) * 0.5;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)configureWithMessage:(id<IYWMessage>)message {

    self.message = message;

    YWMessageBodyTribeSystem *body = (YWMessageBodyTribeSystem *)[message messageBody];

    NSDictionary *userInfo = body.userInfo;
    NSString *tribeName = userInfo[YWTribeServiceKeyTribeName];
    YWPerson *person = [message messageFromPerson];
    int status = [userInfo[YWTribeServiceKeyStatus] intValue];

    __block NSString *personDisplayName = nil;
    [[SPUtil sharedInstance] syncGetCachedProfileIfExists:person
                                               completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                   personDisplayName = aDisplayName;
                                               }];
    if (personDisplayName) {
        self.userNameLabel.text = personDisplayName;
    }
    else {
        self.userNameLabel.text = person.personId;

        __weak __typeof(self) weakSelf = self;
        NSString *messsageId = [message messageId];
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:person
                                                  progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [[weakSelf.message messageId] isEqualToString:messsageId]) {
                                                          weakSelf.userNameLabel.text = aDisplayName;
                                                      }
                                                  } completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [[weakSelf.message messageId] isEqualToString:messsageId]) {
                                                          weakSelf.userNameLabel.text = aDisplayName;
                                                      }
                                                  }];
    }

    self.tribeNameLabel.text = tribeName ?: @"";
    
    UIImage *avatar = nil;
    if ([userInfo[YWTribeServiceKeyTribeType] integerValue] == YWTribeTypeMultipleChat) {
        avatar = [UIImage imageNamed:@"demo_discussion"];
    }
    else {
        avatar = [UIImage imageNamed:@"demo_group_120"];
    }
    self.avatarImageView.image = avatar;

    if (status == YWMessageBodyTribeSystemStatusWait2BProcess) {
        self.operationsContentView.hidden = NO;
        self.statusInfoLabel.hidden = YES;
    }
    else {
        self.operationsContentView.hidden = YES;
        self.statusInfoLabel.hidden = NO;

        NSString *statusInfo = nil;
        switch ((YWMessageBodyTribeSystemStatus)status) {
            case YWMessageBodyTribeSystemStatusAdded:
                statusInfo = KK_Text(@"Joined");
                break;
            case YWMessageBodyTribeSystemStatusIgnored:
                statusInfo = KK_Text(@"Ignored");
                break;
            default:
                break;
        }

        self.statusInfoLabel.text = statusInfo;
    }
}

- (IBAction)acceptButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tribeInvitationCellWantsAccept:)]) {
        [self.delegate tribeInvitationCellWantsAccept:self];
    }
}
- (IBAction)ignoreButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tribeInvitationCellWantsIgnore:)]) {
        [self.delegate tribeInvitationCellWantsIgnore:self];
    }
}

@end
