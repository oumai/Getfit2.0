//
//  SPTribeInvitationListViewController.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/21.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPTribeInvitationListViewController.h"
#import "SPUtil.h"
#import "SPKitExample.h"
#import "SPTribeInvitationCell.h"
#import <WXOpenIMSDKFMWK/YWTribeSystemConversation.h>

@interface SPTribeInvitationListViewController ()<SPTribeInvitationCellDelegate>
@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) YWTribeSystemConversation *conversation;
@end

@implementation SPTribeInvitationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top = 5.0f;
    self.tableView.contentInset = contentInset;
    self.tableView.scrollIndicatorInsets = contentInset;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;


    self.conversation = [[[self ywIMCore] getTribeService] fetchTribeSystemConversation];
    [self addContentChangeBlocks];

    [self refreshControlAction];
}

- (void)refreshControlAction {
    __weak __typeof(self) weakSelf = self;
    [self.conversation loadMoreMessages:10 completion:^(BOOL existMore) {
        [weakSelf.refreshControl endRefreshing];
        weakSelf.refreshControl.enabled = existMore;
    }];;
}

- (void)dealloc {
    [self removeContentChangeBlocks];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.conversation markConversationAsRead];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)addContentChangeBlocks
{
    // 当出现多个聊天窗口时，消息气泡会抢占，
    // 返回当前窗口需要刷新，气泡才能正常显示
    [self.tableView reloadData];

    __weak typeof(self) weakSelf = self;

    __block BOOL needScrollToBottom;

    __weak YWConversation *weakConversation = self.conversation;

    [self.conversation setDidResetContentBlock:^{
        if (weakConversation != weakSelf.conversation) {
            return ;
        }

        needScrollToBottom = [weakSelf isTableViewDidScrollBottom];
        [weakSelf.tableView reloadData];
        if( needScrollToBottom ) {
            [weakSelf scrollTableViewToLastRow:NO];
            needScrollToBottom = NO;
        }
    }];

    [self.conversation setWillChangeContentBlock:^{
        if (weakConversation != weakSelf.conversation) {
            return ;
        }

        needScrollToBottom = [weakSelf isTableViewDidScrollBottom];
        [weakSelf.tableView beginUpdates];
    }];

    [self.conversation setDidChangeContentBlock:^{
        if (weakConversation != weakSelf.conversation) {
            return ;
        }

        [weakSelf.tableView endUpdates];

        if ( needScrollToBottom )
        {
            if (weakSelf.tableView.window) {
                [weakSelf scrollTableViewToLastRow:NO];
            }
        }
    }];

    [self.conversation setObjectDidChangeBlock:^(id<IYWMessage> object, NSIndexPath *atIndexPath, YWObjectChangeType type, NSIndexPath *newIndexPath) {
        if (weakConversation != weakSelf.conversation) {
            return ;
        }


        switch (type) {
            case YWObjectChangeTypeInsert: {
                [weakSelf.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            } break;
            case YWObjectChangeTypeDelete: {
                [weakSelf.tableView deleteRowsAtIndexPaths:@[atIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            } break;
            case YWObjectChangeTypeMove:
                [weakSelf.tableView deleteRowsAtIndexPaths:@[atIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
            case YWObjectChangeTypeUpdate: {
                [weakSelf.tableView reloadRowsAtIndexPaths:@[atIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            } break;
            default:
                break;
        }
    }];
}

- (void)removeContentChangeBlocks
{
    [self.conversation setDidResetContentBlock:nil];
    [self.conversation setWillChangeContentBlock:nil];
    [self.conversation setDidChangeContentBlock:nil];
    [self.conversation setObjectDidChangeBlock:nil];
}

- (IBAction)clearBarButtonItemPressed:(id)sender {
    [self.conversation removeAllLocalMessages];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversation.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPTribeInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPTribeInvitationCell"
                                                                  forIndexPath:indexPath];

    id<IYWMessage> message = [self.conversation objectAtIndexPath:indexPath];
    [cell configureWithMessage:message];
    cell.delegate = self;
    return cell;
}

#pragma mark- 

- (BOOL)isTableViewDidScrollBottom
{
    CGFloat offset = self.tableView.contentSize.height - (self.tableView.frame.size.height + self.tableView.contentOffset.y);
    NSInteger sectionCount = self.tableView.numberOfSections;
    NSInteger rowCount = [self.tableView numberOfRowsInSection:sectionCount - 1];
    if (rowCount == 0) YES;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount - 1  inSection: sectionCount - 1];
    CGFloat lastCellHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];

    return offset < lastCellHeight;
}

- (void)scrollTableViewToLastRow:(BOOL)animated
{
    if ([self.tableView numberOfSections] == 0) return;

    NSInteger sectionCount = self.tableView.numberOfSections;
    NSInteger rowCount = [self.tableView numberOfRowsInSection:sectionCount - 1];
    if (rowCount == 0) return;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount - 1  inSection: sectionCount - 1];
    [self.tableView scrollToRowAtIndexPath: indexPath
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:animated];
}
#pragma mark - SPTribeInvitationCellDelegate

- (void)tribeInvitationCellWantsAccept:(SPTribeInvitationCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id<IYWMessage> message = [self.conversation objectAtIndexPath:indexPath];
    YWMessageBodyTribeSystem *messageBody = (YWMessageBodyTribeSystem *)[message messageBody];
    NSString *tribeID = messageBody.userInfo[YWTribeServiceKeyTribeId];

    __weak __typeof(self) weakSelf = self;
    [[self ywTribeService] acceptInviteFromTribe:tribeID completion:^(NSString *tribeId, NSError *error) {
        if(!error) {
            ;
        }
        else {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:KK_Text(@"Failure to accept the group invitation")
                                                             subtitle:[NSString stringWithFormat:@"%@", error]
                                                                 type:SPMessageNotificationTypeError];
        }

    }];
}

- (void)tribeInvitationCellWantsIgnore:(SPTribeInvitationCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id<IYWMessage> message = [self.conversation objectAtIndexPath:indexPath];
    YWMessageBodyTribeSystem *messageBody = (YWMessageBodyTribeSystem *)[message messageBody];
    NSString *tribeID = messageBody.userInfo[YWTribeServiceKeyTribeId];

    [[self ywTribeService] ignoreInviteFromTribe:tribeID];
}

#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}

@end
