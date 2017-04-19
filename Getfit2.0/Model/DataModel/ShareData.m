//
//  ShareData.m
//  MultiMedia
//
//  Created by zorro on 15/3/13.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ShareData.h"
#import "BLTSendModel.h"
#import "XYSystemInfo.h"
#import "XYSandbox.h"
#import <AVFoundation/AVFoundation.h>

@implementation ShareData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _isPad = NO;
        _isIp4s = NO;
        _isIp5 = NO;
        _isIp6 = NO;
        _isIp6P = NO;
        
        _sheetNumber = 1;
        _intervalTime = 0;
        
        _language = (NSString *)[[NSLocale preferredLanguages] objectAtIndex:0];

        NSLog(@"当前系统语言 = %@", _language);
        // 减轻内存压力。
        _postionArray = [[NSMutableArray alloc] init];
        _loseArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setIsBackGround:(BOOL)isBackGround
{
    _isBackGround = isBackGround;
    
    if (_isBackGround)
    {
        [[BLTSendModel sharedInstance] startTimingCommunication];
    }
    else
    {
        [[BLTSendModel sharedInstance] stopTimingCommunication];
    }
}

- (void)checkDeviceModel
{
    if ([XYSystemInfo isDevicePad])
    {
        _isPad = YES;
    }
    else if ([XYSystemInfo isPhoneRetina35])
    {
        _isIp4s = YES;
    }
    else if ([XYSystemInfo isPhoneRetina4])
    {
        _isIp5 = YES;
    }
    else if ([XYSystemInfo isPhoneSix])
    {
        _isIp6 = YES;
    }
    else if ([XYSystemInfo isPhoneSixPlus])
    {
        _isIp6P = YES;
    }
    else
    {
        _isIp5 = YES;
    }
}

+ (BOOL)isPad
{
    return [ShareData sharedInstance].isPad;
}

+ (BOOL)isIpFour
{
    return [ShareData sharedInstance].isIp4s;
}

+ (BOOL)isIpFive
{
    return [ShareData sharedInstance].isIp5;
}

+ (BOOL)isIpSix
{
    return [ShareData sharedInstance].isIp6;
}

+ (BOOL)isIpSixP
{
    return [ShareData sharedInstance].isIp6P;
}

DEF_SINGLETON(ShareData)

// 对完整的文件路径进行判断,isDirectory 如果是文件夹返回YES, 如果不是返回NO.
- (BOOL)completePathDetermineIsThere:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:path];
    
    return existed;
}

// 删除文件夹和文件都可以用这个方法
- (void)removeFileName:(NSString *)file withFolderPath:(NSString *)path
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, file];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:filePath error:nil];
}

- (UIImage *)getImageFromFileCache:(NSString *)imageName
{
    NSString *string = [self.filePath stringByAppendingPathComponent:imageName];
    
    if ([self completePathDetermineIsThere:string]) {
        return [UIImage imageWithFile:string];
    }
    else
    {
        return UIImageNamedNoCache(@"perImage@2x.png");
    }
}

- (UIImage *)getImageFromFileCache:(NSString *)imageName withType:(ShareDataImageType)type;
{
    NSString *string = [self.filePath stringByAppendingPathComponent:imageName];
    
    if ([self completePathDetermineIsThere:string])
    {
        return [UIImage imageWithFile:string];
    }
    else
    {
        if (type == ShareDataImageSourceDisConnect)
        {
            return UIImageNamedNoCache(@"device01.png");
        }
        else if (type == ShareDataImageSourceDidConnect)
        {
            return UIImageNamedNoCache(@"device02.png");
        }
        else
        {
            return UIImageNamedNoCache(@"add_photo@2x.png");
        }
    }
}

#define Screen_Rect ([UIScreen mainScreen ].bounds)

- (NSInteger)getTimeOfBellWithMp3String:(NSString *)mp3String
{
    NSDictionary *dict = @{@"alarm_bird.mp3" : @"4.440813",
                           @"alarm_car.mp3" : @"6.818000",
                           @"alarm_cat.mp3" : @"1.018800",
                           @"alarm_chatcall.mp3" : @"0.705300",
                           @"alarm_dog.mp3" : @"30.406500",
                           @"alarm_fire.mp3" : @"4.427755",
                           @"alarm_music.mp3" : @"3.657125",
                           @"alarm_radar.mp3" : @"4.812167",
                           @"alarm_trumpet.mp3" : @"2.194300",
                           @"alarm_whistle.mp3" : @"1.358400",
                           @"Alarm.mp3" : @"4.700500"};
    
    /*
    NSArray *array = [dict allKeys];
    for (int i = 0; i < array.count; i++)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:array[i] ofType:nil];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
        
        NSLog(@"...%@...%f", array[i], player.duration);
    }
    */
    // NSLog(@"..%d", (NSInteger)([dict[mp3String] floatValue] * 10000));
    
    return (NSInteger)([dict[mp3String] floatValue] * BL_CountScale);
}

@end
