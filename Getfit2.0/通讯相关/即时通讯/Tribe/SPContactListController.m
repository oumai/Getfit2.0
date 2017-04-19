//
//  SPContactListController.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPContactListController.h"

#import <WXOpenIMSDKFMWK/YWFMWK.h>

#import "SPKitExample.h"
#import "SPUtil.h"

#import "AppDelegate.h"
#import "SPContactCell.h"
#import "SPSearchContactViewController.h"
#import "SPContactManager.h"


@interface SPContactListController ()
<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary *sections;
@property (nonatomic, strong) NSArray *sortedSectionTitles;

@end

@implementation SPContactListController

#pragma mark - life circle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // 初始化
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.tableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil]
         forCellReuseIdentifier:@"ContactCell"];
    self.tableView.separatorColor =[UIColor colorWithWhite:1.f*0xdf/0xff alpha:1.f];
    if ([self.tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    [self.navigationItem setTitle:KK_Text(@"Contacts")];

    if (self.mode == SPContactListModeNormal) {
        self.navigationItem.title = KK_Text(@"Contacts");

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:KK_Text(@"Search")
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(searchBarButtonItemPressed:)];

    }
    else {
        self.navigationItem.title = KK_Text(@"Select Contacts");

        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                        target:self
                                                                                        action:@selector(doneBarButtonItemPressed:)];

        self.navigationItem.rightBarButtonItem = doneButtonItem;
        [self.tableView setEditing:YES animated:NO];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.presentingViewController) {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelBarButtonItemPressed:)];

        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    _sections = nil;
    _sortedSectionTitles = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (NSInteger)self.sortedSectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionKey = self.sortedSectionTitles[(NSUInteger)section];
    NSArray *array = self.sections[sectionKey];
    return (NSInteger)array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SPContactCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ContactCell"
                                                         forIndexPath:indexPath];

    NSString *sectionKey = self.sortedSectionTitles[(NSUInteger)indexPath.section];
    NSArray *array = self.sections[sectionKey];
    NSString *personId = array[(NSUInteger)indexPath.row];
    YWPerson *person = [[YWPerson alloc] initWithPersonId:personId];

    cell.identifier = personId;

    __block NSString *displayName = nil;
    __block UIImage *avatar = nil;
    //  SPUtil中包含的功能都是Demo中需要的辅助代码，在你的真实APP中一般都需要替换为你真实的实现。
    [[SPUtil sharedInstance] syncGetCachedProfileIfExists:person completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
        displayName = aDisplayName;
        avatar = aAvatarImage;
    }];

    if (!avatar) {
        avatar = [UIImage imageNamed:@"demo_head_120"];
    }
    if (!displayName) {
        displayName = personId;

        __weak __typeof(self) weakSelf = self;
        __weak __typeof(cell) weakCell = cell;
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:person
                                                  progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndexPath = [weakSelf.tableView indexPathForCell:weakCell];
                                                          if (!aIndexPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.tableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  } completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndexPath = [weakSelf.tableView indexPathForCell:weakCell];
                                                          if (!aIndexPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.tableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  }];
    }

    [cell configureWithAvatar:avatar title:displayName subtitle:nil];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sortedSectionTitles[(NSUInteger)section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sortedSectionTitles;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mode == SPContactListModeSelection) {
        return;
    }
    NSString *sectionKey = self.sortedSectionTitles[(NSUInteger)indexPath.section];
    NSArray *array = self.sections[sectionKey];
    NSString *personId = array[(NSUInteger)indexPath.row];

    BOOL isEService = personId && [kSPEServicePersonIds containsObject:personId];
    
    if (isEService) {
        //  SPUtil中包含的功能都是Demo中需要的辅助代码，在你的真实APP中一般都需要替换为你真实的实现。
        [[SPKitExample sharedInstance] exampleOpenEServiceConversationWithPersonId:personId fromNavigationController:self.tabBarController.navigationController];
    } else {
        YWPerson *person = [[YWPerson alloc] initWithPersonId:personId];
        [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.tabBarController.navigationController];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mode == SPContactListModeSelection) {
        return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mode == SPContactListModeNormal) {
        NSString *sectionKey = self.sortedSectionTitles[(NSUInteger)indexPath.section];
        NSMutableArray *array = self.sections[sectionKey];
        NSString *personId = array[(NSUInteger)indexPath.row];

        [array removeObjectAtIndex:indexPath.row];

        YWPerson *person = [[YWPerson alloc] initWithPersonId:personId];
        [[SPContactManager defaultManager] removeContact:person];

        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark - Data

- (NSDictionary *)sections
{
    if (!_sections) {
        NSMutableDictionary *sections = [NSMutableDictionary dictionary];
        NSArray *personIDs = [[SPContactManager defaultManager] fetchContactPersonIDs];
        for (NSString *userID in personIDs) {
            if ([self.excludedPersonIDs containsObject:userID]) {
                continue;
            }

            YWPerson *person = [[YWPerson alloc] initWithPersonId:userID];
            NSString *name = nil;
            NSString *indexKey = [self indexTitleForName:userID];
            NSMutableArray *names = sections[indexKey];
            if (!names) {
                names = [NSMutableArray array];
                sections[indexKey] = names;
            }
            [names addObject:userID];
        }
        _sections = sections;
    }

    return _sections;
}

- (NSArray *)sortedSectionTitles
{
    if (!_sortedSectionTitles) {
        _sortedSectionTitles = [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    return _sortedSectionTitles;
}

- (NSString *)indexTitleForName:(NSString *)name {
    static NSString *otherKey = @"#";
    if (!name) {
        return otherKey;
    }

    NSMutableString *mutableString = [NSMutableString stringWithString:[name substringToIndex:1]];
    CFMutableStringRef mutableStringRef = (__bridge CFMutableStringRef)mutableString;
    CFStringTransform(mutableStringRef, nil, kCFStringTransformToLatin, NO);
    CFStringTransform(mutableStringRef, nil, kCFStringTransformStripCombiningMarks, NO);

    NSString *key = [[mutableString uppercaseString] substringToIndex:1];
    unichar capital = [key characterAtIndex:0];
    if (capital >= 'A' && capital <= 'Z') {
        return key;
    }
    return otherKey;
}

- (void)cancelBarButtonItemPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)doneBarButtonItemPressed:(id)sender {
    NSMutableArray *selectedIDs = [NSMutableArray array];
    NSArray *indexPathsForSelectedRows = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in indexPathsForSelectedRows) {
        NSString *sectionKey = self.sortedSectionTitles[(NSUInteger)indexPath.section];
        NSArray *array = self.sections[sectionKey];
        NSString *personId = array[(NSUInteger)indexPath.row];
        if (personId) {
            [selectedIDs addObject:personId];
        }
    }

    if ([self.delegate respondsToSelector:@selector(contactListController:didSelectPersonIDs:)]) {
        [self.delegate contactListController:self didSelectPersonIDs:[selectedIDs copy]];
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)searchBarButtonItemPressed:(id)sender {
    SPSearchContactViewController *controller = [[SPSearchContactViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:controller
                                                          animated:YES];
}

@end
