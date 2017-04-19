//
//  SPContactManager.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/21.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPContactManager.h"
#import "SPUtil.h"

#define __SPContactsOfEService \
@[ \
kSPEServicePersonId, \
]

#define __SPContactsOfDevelopers \
@[ \
@"uid1", \
@"uid2", \
@"uid3", \
@"uid4", \
@"uid5", \
@"uid6", \
@"uid7", \
@"uid8", \
@"uid9", \
@"uid10", \
]

#define __SPContactsOfSections \
@[ \
kSPEServicePersonIds, \
kSPWorkerPersonIds, \
__SPContactsOfDevelopers, \
]

@interface SPContactManager ()
@property (strong, nonatomic) NSMutableArray *contactIDs;
@end


@implementation SPContactManager

+ (instancetype)defaultManager {
    static SPContactManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[SPContactManager alloc] init];
    });
    return defaultManager;
}

- (NSMutableArray *)contactIDs {
    if (!_contactIDs) {
        _contactIDs = [NSMutableArray arrayWithContentsOfFile:[self storeFilePath]];
        if (!_contactIDs) {
            _contactIDs = [NSMutableArray array];
            for (NSArray *contacts in __SPContactsOfSections) {
                [_contactIDs addObjectsFromArray:contacts];
            }
            [_contactIDs writeToFile:[self storeFilePath] atomically:YES];
        }
    }
    return _contactIDs;
}

- (NSArray *)fetchContactPersonIDs {
    return self.contactIDs;
}

- (BOOL)existContact:(YWPerson *)person {
    return [self.contactIDs containsObject:person.personId];
}

- (BOOL)addContact:(YWPerson *)person {
    if (!person.personId) {
        return NO;
    }
    [self.contactIDs addObject:person.personId];
    return [self saveContactIDs];
}
- (BOOL)removeContact:(YWPerson *)person {
    if (!person.personId) {
        return NO;
    }
    if (![self existContact:person]) {
        return NO;
    }

    [self.contactIDs removeObject:person.personId];

    return [self saveContactIDs];
}

- (BOOL)saveContactIDs {
    if (_contactIDs) {
        return [_contactIDs writeToFile:[self storeFilePath] atomically:YES];
    }
    return YES;
}
- (NSString *)storeFilePath {
    NSString* path = [[NSSearchPathForDirectoriesInDomains(
                                                           NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SPContacts.plist"];
    return path;
}

@end
