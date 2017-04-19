
//
//  SPTribeProfileViewController.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/15.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPTribeProfileViewController.h"
#import "SPTribeInfoEditViewController.h"
#import "SPTribeMemberListViewController.h"
#import "SPKitExample.h"
#import "SPUtil.h"

#import "UIImage+Qrcode.h"
#import "KKASIHelper.h"


typedef enum : int {
    SPTribeMemberRoleNotKnown,
    SPTribeMemberRoleGuest,
    SPTribeMemberRoleNormal,
    SPTribeMemberRoleManager
} SPTribeMemberRole;

#define kSPTribeProfileActionTitleJoin KK_Text(@"Join group")
#define kSPTribeProfileActionTitleExit KK_Text(@"Quit Group")
#define kSPTribeProfileActionTitleDisband KK_Text(@"The dissolution of the group")


@interface SPTribeProfileViewController ()
<SPTribeInfoEditViewControllerDelegate,
UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *tribeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tribeIDLabel;

@property (weak, nonatomic) IBOutlet UIImageView *converImageView;

@property (strong, nonatomic) NSArray *members;
@property (weak, nonatomic) IBOutlet UIButton *closeLabel;

@end

@implementation SPTribeProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
//    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width * 0.5;
//    self.avatarImageView.clipsToBounds = YES;
    
    _converImageView.backgroundColor = KK_MainColor;
    
    _closeLabel.titleNormal = KK_Text(@"Close");
    _infoLabel.text = KK_Text(@"");
    // self.avatarImageView.backgroundColor = [UIColor whiteColor];
    
    self.members = [[self ywTribeService] fetchTribeMembers:self.tribe.tribeId];
    [self reloadData];

    [self addTribeCallbackBlocks];
}

- (void)dealloc {
    [self removeTribeCallbackBlocks];
}

- (void)addTribeCallbackBlocks {
    __weak __typeof(self) weakSelf = self;
    [[self ywTribeService] addDidExpelFromTribeBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        if ([tribeID isEqualToString:weakSelf.tribe.tribeId]) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];

            weakSelf.members = @[];
            [weakSelf.tableView reloadData];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];


    [[self ywTribeService] addMemberDidExitBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        YWPerson *person = userInfo[YWTribeServiceKeyPerson];
        YWPerson *me = [[[weakSelf ywIMCore] getLoginService] currentLoginedUser];
        if ([tribeID isEqualToString:weakSelf.tribe.tribeId]
            && [person isEqualToPerson:me]) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];

            weakSelf.members = @[];
            [weakSelf.tableView reloadData];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];


    [[self ywTribeService] addTribeDidDisbandBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        if ([tribeID isEqualToString:weakSelf.tribe.tribeId]) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];

            weakSelf.members = nil;
            [weakSelf reloadData];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf dismissViewController:nil];
            });
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

- (void)removeTribeCallbackBlocks {
    [[self ywTribeService] removeDidExpelFromTribeBlockForKey:self.description];
    [[self ywTribeService] removeMemberDidExitBlockForKey:self.description];
    [[self ywTribeService] removeTribeDidDisbandBlockForKey:self.description];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];

    [self requestTribe];
    [self requestTribeMembers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)reloadData {
    self.tribeIDLabel.text = [NSString stringWithFormat:@"%@ %@", KK_Text(@"Group No."), [KKASIHelper sharedInstance].familyID];
    self.tribeNameLabel.text = self.tribe.tribeName;
    
    
//    UIImage *avatar = nil;

//    if (self.tribe.tribeType == YWTribeTypeMultipleChat) {
//        avatar = [UIImage imageNamed:@"demo_discussion"];
//    }
//    else {
//        avatar = [UIImage imageNamed:@"demo_group_120"];
//    }
    
    
    
    UIImage *image = [UIImage createQRForString:[KKASIHelper sharedInstance].familyID withSize:160];
    
    self.avatarImageView.image = [UIImage imageBlackToTransparent:image withRed:255 andGreen:255 andBlue:255];
    
    
    [self.tableView reloadData];
}

- (void)requestTribeMembers {
    if (!self.tribe) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self.ywTribeService requestTribeMembersFromServer:self.tribe.tribeId completion:^(NSArray *members, NSString *tribeId, NSError *error) {
        if(!error) {
            weakSelf.members = members;
            [weakSelf.tableView reloadData];
        }
    }];
}
- (void)requestTribe {
    if (!self.tribe) {
        return;
    }

    __weak __typeof(self) weakSelf = self;
    [self.ywTribeService requestTribeFromServer:self.tribe.tribeId completion:^(YWTribe *tribe, NSError *error) {
        if(!error) {
            weakSelf.tribe = tribe;
            [weakSelf reloadData];
        }
        else {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:KK_Text(@"Updates Failed")
                                                             subtitle:[NSString stringWithFormat:@"%@", error]
                                                                 type:SPMessageNotificationTypeError];
        }
    }];
}

- (void)joinToTribe {
    __weak typeof (self) weakSelf = self;
    [self.ywTribeService joinTribe:self.tribe.tribeId completion:^(NSString *tribeId, NSError *error) {
        if(!error) {
            weakSelf.members = nil;
            [weakSelf reloadData];
            [weakSelf requestTribeMembers];

            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:KK_Text(@"Join the group success")
                                                             subtitle:nil
                                                                 type:SPMessageNotificationTypeSuccess];
        } else {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:KK_Text(@"Failure to join the group")
                                                             subtitle:[NSString stringWithFormat:@"%@", error]
                                                                 type:SPMessageNotificationTypeError];
        }
    }];
}

- (void)exitFromTribe {
    /*
    __weak __typeof(self) weakSelf = self;
    [[self ywTribeService] exitFromTribe:self.tribe.tribeId completion:^(NSString *tribeId, NSError *error) {
        if(!error) {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:@"已成功退出群"
                                                             subtitle:nil
                                                                 type:SPMessageNotificationTypeSuccess];
            weakSelf.members = @[];
            [weakSelf reloadData];
        } else {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:@"退出群失败"
                                                             subtitle:[NSString stringWithFormat:@"%@", error]
                                                                 type:SPMessageNotificationTypeError];
        }
    }];
     */
    [[KKASIHelper sharedInstance] exitFamily:[KKASIHelper sharedInstance].familyID withBlock:_exitBlock];
}

- (void)disbandTribe {
    /*
    __weak __typeof(self) weakSelf = self;
    [[self ywTribeService] disbandTribe:self.tribe.tribeId completion:^(NSString *tribeId, NSError *error) {
        if(!error) {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:@"已成功解散群"
                                                             subtitle:nil
                                                                 type:SPMessageNotificationTypeSuccess];
            
            weakSelf.members = nil;
            [weakSelf reloadData];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf dismissViewController:nil];
            });

        } else {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:@"解散群失败"
                                                             subtitle:[NSString stringWithFormat:@"%@", error]
                                                                 type:SPMessageNotificationTypeError];
        }
    }]; */

    NSLog(@"解散群 : %@", [KKASIHelper sharedInstance].familyID);

    [[KKASIHelper sharedInstance] exitFamily:[KKASIHelper sharedInstance].familyID withBlock:_exitBlock];
}

- (YWTribeMember *)myTribeMember {
    NSString *myPersonID = [[[self ywIMCore] getLoginService] currentLoginedUserId];

    YWTribeMember *myTribeMember = nil;
    for (YWTribeMember *tribeMember in self.members) {
        if ([tribeMember.personId isEqualToString:myPersonID]) {
            myTribeMember = tribeMember;
            break;
        }
    }
    return myTribeMember;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = 0;
    if (!self.members) { // 还未获取到成员信息
        number = 1;
    }
    else {
        number = 3;
    }
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = 1;
            break;
        case 1:
        {
            YWTribeMember *tribeMember = [self myTribeMember];
            if (tribeMember) {
                if (tribeMember.role == YWTribeMemberRoleOwner || tribeMember.role == YWTribeMemberRoleManager) {
                    number = 2;
                }
                else {
                    number = 1;
                }
            }
            else {
                number = 0;
            }

            break;
        }
        case 2:
            number = 1;
            break;
        default:
            break;
    }
    return number;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 85.0f;
    }
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TribeDescriptionCell"];
        [cell prepareForReuse];
        
        UILabel *noticeLabel = [cell.contentView viewWithTag:2045];
        noticeLabel.text = self.tribe.notice;

        CGSize fittingSize;
        cell.frame = tableView.frame;
        [cell layoutIfNeeded];
        noticeLabel.preferredMaxLayoutWidth = noticeLabel.frame.size.width;
        fittingSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

        if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
            fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
        }
        return fittingSize.height;
    }
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;

    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TribeDescriptionCell"
                                               forIndexPath:indexPath];
        
        UILabel *infoLabel = [cell.contentView viewWithTag:1001];
        infoLabel.text = KK_Text(@"Group Introduction");
        
        UILabel *noticeLabel = [cell.contentView viewWithTag:2045];
        noticeLabel.text = self.tribe.notice;
        noticeLabel.preferredMaxLayoutWidth = noticeLabel.frame.size.width;
    }
    else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RightDetailCell"
                                               forIndexPath:indexPath];

        if (indexPath.row == 0) {
            YWTribeMember *tribeMember = [self myTribeMember];
            if (tribeMember.role == YWTribeMemberRoleOwner || tribeMember.role ==   YWTribeMemberRoleManager) {
                cell.textLabel.text = KK_Text(@"Management group members");
            }
            else {
                cell.textLabel.text = KK_Text(@"Group members list");
            }
            NSString *memberCountText = (self.members.count > 0) ? [NSString stringWithFormat:@"%lu%@", (unsigned long)self.members.count, KK_Text(@"people")]: nil;
            cell.detailTextLabel.text = memberCountText;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = KK_Text(@"Edit group information");
            cell.detailTextLabel.text = nil;
        }
    }
    else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"
                                               forIndexPath:indexPath];

        cell.backgroundColor = KK_MainColor;
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:2046];

        label.textColor = [UIColor whiteColor];
        YWTribeMember *tribeMember = [self myTribeMember];
        if (!tribeMember) {
            label.text = kSPTribeProfileActionTitleJoin;
        }
        else if (tribeMember.role == YWTribeMemberRoleOwner
                 && self.tribe.tribeType == YWTribeTypeNormal) {
            label.text = KK_Text(@"The dissolution of the group");

        }
        else {
            label.text = KK_Text(@"Quit Group");
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    if (indexPath.section == 1 && indexPath.row == 0) {
        // 群成员列表
        SPTribeMemberListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SPTribeMemberListViewController"];
        controller.tribe = self.tribe;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        // 编辑群信息
        SPTribeInfoEditViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SPTribeInfoEditViewController"];
        controller.mode = SPTribeInfoEditModeModify;
        controller.tribe = self.tribe;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:2046];
        if ([label.text isEqualToString:kSPTribeProfileActionTitleJoin]) {
            [self joinToTribe];
        }
        else if ([label.text isEqualToString:KK_Text(@"The dissolution of the group")]) {
            [self disbandTribe];
        }
        else if ([label.text isEqualToString:KK_Text(@"Quit Group")]) {
            [self exitFromTribe];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        YWTribeMember *tribeMember = [self myTribeMember];
        if (!tribeMember) {
            return CGFLOAT_MIN;
        }
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        YWTribeMember *tribeMember = [self myTribeMember];
        if (!tribeMember) {
            return CGFLOAT_MIN;
        }
    }
    return UITableViewAutomaticDimension;
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        return;
    }

    CGFloat coverOriginalHeight = CGRectGetHeight(self.converImageView.superview.frame);

    if (scrollView.contentOffset.y < 0) {
        CGFloat scale = (fabs(scrollView.contentOffset.y) + coverOriginalHeight) / coverOriginalHeight;

        CATransform3D transformScale3D = CATransform3DMakeScale(scale, scale, 1.0);
        CATransform3D transformTranslate3D = CATransform3DMakeTranslation(0, scrollView.contentOffset.y/2, 0);
        self.converImageView.layer.transform = CATransform3DConcat(transformScale3D, transformTranslate3D);

        UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
        scrollIndicatorInsets.top = fabs(scrollView.contentOffset.y) + coverOriginalHeight;
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    }
    else {
        self.converImageView.layer.transform = CATransform3DIdentity;

        if (scrollView.scrollIndicatorInsets.top != coverOriginalHeight) {
            UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
            scrollIndicatorInsets.top = coverOriginalHeight;
            scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
        }
    }
}

#pragma mark - Navigation
- (IBAction)dismissViewController:(id)sender {
    if (self.presentingViewController && self.navigationController.viewControllers.firstObject == self) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - SPTribeInfoEditViewControllerDelegate
- (void)tribeInfoEditViewController:(SPTribeInfoEditViewController *)controller tribeDidChange:(YWTribe *)tribe {
    self.tribe = tribe;
    [self reloadData];
}

#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}

@end
