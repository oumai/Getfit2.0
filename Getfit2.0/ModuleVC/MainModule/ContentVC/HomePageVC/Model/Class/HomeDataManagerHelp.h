//
//  HomeDataManagerHelp.h
//  AJBracelet
//
//  Created by 黄建华 on 15/12/5.
//  Copyright © 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeDataSysModel.h"

@interface HomeDataManagerHelp : NSObject

AS_SINGLETON(HomeDataManagerHelp)
// 保存空模型到数据库.
+ (HomeDataSysModel *)pedometerSaveEmptyModelToisSaveAllDay:(BOOL)save;

// 当前用户信息
@property (nonatomic, strong) HomeDataSysModel *homeDataModel;

@end
