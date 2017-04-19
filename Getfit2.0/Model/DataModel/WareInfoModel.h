//
//  WareInfoModel.h
//  AJBracelet
//
//  Created by zorro on 15/7/22.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WareInfoModel : NSObject

@property (nonatomic, strong) NSString *device_id;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *file;
@property (nonatomic, strong) NSString *info_ch;
@property (nonatomic, strong) NSString *info_en;

@property (nonatomic, assign) BOOL isDownload; // 文件是否已经下载下来了.

@end
