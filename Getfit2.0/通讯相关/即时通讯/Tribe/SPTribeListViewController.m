//
//  SPTribeListViewController.m
//  WXOpenIMSampleDev
//
//  Created by shili.nzy on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPTribeListViewController.h"
#import "SPTribeInfoEditViewController.h"
#import "SPUtil.h"
#import "SPKitExample.h"

#import "SPContactCell.h"

@interface SPTribeListViewController ()
<UITableViewDataSource, UITableViewDelegate,
UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableDictionary *groupedTribes;
@end

@implementation SPTribeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil]
         forCellReuseIdentifier:@"ContactCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.refreshControl addTarget:self action:@selector(requestData) forControlEvents:UIControlEventValueChanged];

    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self reloadData];
    [self addTribeCallbackBlocks];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self removeTribeCallbackBlocks];
}

- (void)addTribeCallbackBlocks {
    __weak __typeof(self) weakSelf = self;
    [[self ywTribeService] addDidExpelFromTribeBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        NSNumber *tribeType = userInfo[YWTribeServiceKeyTribeType];
        [weakSelf deleteTribeFromTableViewWithTribeID:tribeID tribeType:[tribeType integerValue]];
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];

    [[self ywTribeService] addMemberDidJoinBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        YWPerson *person = userInfo[YWTribeServiceKeyPerson];
        YWPerson *me = [[[weakSelf ywIMCore] getLoginService] currentLoginedUser];
        if ([person isEqualToPerson:me]) {
            [weakSelf insertTribeToTableViewWithTribeID:tribeID];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];


    [[self ywTribeService] addMemberDidExitBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        NSNumber *tribeType = userInfo[YWTribeServiceKeyTribeType];
        YWPerson *person = userInfo[YWTribeServiceKeyPerson];
        YWPerson *me = [[[weakSelf ywIMCore] getLoginService] currentLoginedUser];
        if ([person isEqualToPerson:me]) {
            [weakSelf deleteTribeFromTableViewWithTribeID:tribeID tribeType:[tribeType integerValue]];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];


    [[self ywTribeService] addTribeDidDisbandBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        NSNumber *tribeType = userInfo[YWTribeServiceKeyTribeType];
        [weakSelf deleteTribeFromTableViewWithTribeID:tribeID tribeType:[tribeType integerValue]];
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

- (void)removeTribeCallbackBlocks {
    [[self ywTribeService] removeDidExpelFromTribeBlockForKey:self.description];
    [[self ywTribeService] removeMemberDidJoinBlockForKey:self.description];
    [[self ywTribeService] removeMemberDidExitBlockForKey:self.description];
    [[self ywTribeService] removeTribeDidDisbandBlockForKey:self.description];
}


- (void)reloadData {
    NSArray *tribes = [self.ywTribeService fetchAllTribes];
    [self configureDataWithTribes:tribes];
    [self.tableView reloadData];
}

- (void)requestData {
    if ([[[self ywIMCore] getLoginService] isCurrentLogined]) {
        __weak typeof(self) weakSelf = self;
        [self.ywTribeService requestAllTribesFromServer:^(NSArray *tribes, NSError *error) {
            if( error == nil ) {
                [weakSelf configureDataWithTribes:tribes];
                [weakSelf.tableView reloadData];
            } else {
                [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                    title:KK_Text(@"Get group list failed")
                                                                 subtitle:nil
                                                                     type:SPMessageNotificationTypeError];
            }
            [weakSelf.refreshControl endRefreshing];
        }];
    }
}

- (void)configureDataWithTribes:(NSArray *)tribes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *normalTribes = [NSMutableArray array];
    dictionary[[@(YWTribeTypeNormal) stringValue]] = normalTribes;
    NSMutableArray *multipleChatTribes = [NSMutableArray array];
    dictionary[[@(YWTribeTypeMultipleChat) stringValue]] = multipleChatTribes;

    for (YWTribe *tribe in tribes) {
        if (tribe.tribeType == YWTribeTypeNormal) {
            [normalTribes addObject:tribe];
        }
        else if (tribe.tribeType == YWTribeTypeMultipleChat) {
            [multipleChatTribes addObject:tribe];
        }
    }
    self.groupedTribes = dictionary;
}

- (void)insertTribeToTableViewWithTribeID:(NSString *)tribeId {
    YWTribe *tribe = [[self ywTribeService] fetchTribe:tribeId];
    if (!tribe) {
        return;
    }

    NSInteger section = tribe.tribeType;
    NSMutableArray *tribes = self.groupedTribes[[@(section) stringValue]];
    if (!tribes) {
        return;
    }

    NSInteger row = [tribes indexOfObject:tribe];
    if (row != NSNotFound) {
        return;
    }

    [tribes addObject:tribe];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tribes.count - 1 inSection:section];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)deleteTribeFromTableViewWithTribeID:(NSString *)tribeId tribeType:(YWTribeType)tribeType {
    if (!tribeId) {
        return;
    }

    NSInteger section = tribeType;
    NSMutableArray *tribes = self.groupedTribes[[@(section) stringValue]];
    if (!tribes) {
        return;
    }

    NSInteger row = [tribes indexOfObjectPassingTest:^BOOL(YWTribe *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.tribeId isEqualToString:tribeId]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if (row == NSNotFound) {
        return;
    }

    [tribes removeObjectAtIndex:row];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Actions
- (IBAction)tribeCreationBarItemPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:KK_Text(@"Create group")
                                                             delegate:self
                                                    cancelButtonTitle:KK_Text(@"Cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:KK_Text(@"Normal group"), KK_Text(@"Multi chat group"), nil];
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [actionSheet showFromBarButtonItem:sender animated:YES];
    }
    else {
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        SPTribeInfoEditViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SPTribeInfoEditViewController"];
        if (buttonIndex == 0) {
            controller.mode = SPTribeInfoEditModeCreateNormal;
        }
        else if (buttonIndex == 1) {
            controller.mode = SPTribeInfoEditModeCreateMultipleChat;
        }

        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navigationController
                           animated:YES
                         completion:NULL];
    }
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedTribes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *groupedTribesKey = @(section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];
    return tribes.count;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *groupedTribesKey = @(section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];
    if (section == 0) {
        return tribes.count ? KK_Text(@"Normal group") : nil;
    }
    else if (section == 1) {
        return tribes.count ? KK_Text(@"Multi chat group") : nil;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithWhite:242./255 alpha:1.0];
    header.textLabel.textColor = [UIColor colorWithWhite:155./255 alpha:1.0];
    header.textLabel.font = [UIFont systemFontOfSize:12.0];
    header.textLabel.shadowColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *groupedTribesKey = @(indexPath.section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];

    SPContactCell *cell = nil;
    if( indexPath.row >= [tribes count] ) {
        NSAssert(0, @"数据出错了");
    }
    else {
        YWTribe *tribe = tribes[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"
                                               forIndexPath:indexPath];

        UIImage *avatar = nil;
        if (tribe.tribeType == YWTribeTypeMultipleChat) {
            avatar = [UIImage imageNamed:@"demo_discussion"];
        }
        else {
            avatar = [UIImage imageNamed:@"demo_group_120"];
        }
        [cell configureWithAvatar:avatar
                            title:tribe.tribeName
                         subtitle:nil];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *groupedTribesKey = @(indexPath.section).stringValue;
        NSMutableArray *tribes = self.groupedTribes[groupedTribesKey];
        YWTribe *tribe = tribes[indexPath.row];
        __weak typeof(self) weakSelf = self;
        [self.ywTribeService exitFromTribe:tribe.tribeId completion:^(NSString *tribeId, NSError *error) {
            if( error == nil ) {
                NSUInteger index= [tribes indexOfObject:tribe];
                if (index != NSNotFound) {
                    [tribes removeObjectAtIndex:index];
                    NSIndexPath *indexPathToRemove = [NSIndexPath indexPathForRow:index
                                                                        inSection:indexPath.section];
                    [tableView deleteRowsAtIndexPaths:@[indexPathToRemove]
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            } else {
                [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                      title:KK_Text(@"Exit group fails")
                                                   subtitle:[NSString stringWithFormat:@"%@", error]
                                                       type:SPMessageNotificationTypeError];
            }
        }];
    }
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KK_Text(@"Quit Group");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *groupedTribesKey = @(indexPath.section).stringValue;
    NSMutableArray *tribes = self.groupedTribes[groupedTribesKey];
    YWTribe *tribe = [tribes objectAtIndex:indexPath.row];
    
    [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithTribe:tribe fromNavigationController:self.tabBarController.navigationController];
}


#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}

@end
