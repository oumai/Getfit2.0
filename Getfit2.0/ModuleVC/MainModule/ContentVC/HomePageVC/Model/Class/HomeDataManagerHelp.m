//
//  HomeDataManagerHelp.m
//  AJBracelet
//
//  Created by 黄建华 on 15/12/5.
//  Copyright © 2015年 zorro. All rights reserved.
//

#import "HomeDataManagerHelp.h"

@implementation HomeDataManagerHelp

DEF_SINGLETON(HomeDataManagerHelp)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        /*
        [ShareData sharedInstance].isAllowHomeDataSave = NO;
        _homeDataModel = [HomeDataSysModel getModelFromDB];
        [ShareData sharedInstance].isAllowHomeDataSave = YES; */
    }
    
    return self;
}

//+ (HotMoxRemarkModel *)getModelFromDBWithDate:(NSDate *)date;

// 保存空模型到数据库.
+ (HomeDataSysModel *)pedometerSaveEmptyModelToisSaveAllDay:(BOOL)save;
{
    HomeDataSysModel *model = [HomeDataSysModel simpleInit];
    
    [model saveToDB];
    
    return model;
}

@end
