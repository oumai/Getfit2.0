//
//  AudioHelper.m
//  SmartStent
//
//  Created by zorro on 16/8/31.
//  Copyright © 2016年 zorro. All rights reserved.
//

#import "AudioHelper.h"

@interface AudioHelper ()

@property (nonatomic, assign) NSInteger volumeCount;

@end

@implementation AudioHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 开启后台音乐
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    
    return self;
}

- (void)startShakeTimer
{
    _volumeCount = 0;
    [self stopShakeTimer];
    _shakeTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self
                                                 selector:@selector(callSystemVibration)
                                                 userInfo:nil repeats:YES];
}

- (void)callSystemVibration
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)stopShakeTimer
{
    if (_shakeTimer) {
        if ([_shakeTimer isValid]) {
            [_shakeTimer invalidate];
            _shakeTimer = nil;
        }
    }
}

DEF_SINGLETON(AudioHelper)

// 播放录音文件.
- (void)playAudio
{
    if (![UserInfoHelper sharedInstance].userModel.isFindPhone) {
        return;
    }
    
    [self stopPlay];
    NSError *error = nil;
    NSLog(@"开始播放音乐...");
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"A2_3S" ofType:@"mp3"];
    NSURL *url = [self realURL:musicPath];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error) {
        [self stopPlay];
        return;
    }
    
    _player.delegate = self;
    [_player prepareToPlay];
    _player.numberOfLoops = 30;
    [_player play];
    
    // 开始震动
    [self startShakeTimer];
    _isFinding = YES;
    
    [self showAlertView];
}

- (void)showAlertView
{
    if (![ShareData sharedInstance].isBackGround) {
        if (_isFinding) {
            if (!_alertView.isVisible) {
                _alertView = [[UIAlertView alloc] initWithTitle:@"Getfit 2.0" message:KK_Text(@"Find the phone")
                                                       delegate:self cancelButtonTitle:KK_Text(@"OK")
                                              otherButtonTitles:nil, nil];
                [_alertView show];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self stopPlay];
}

// 暂停音乐...
- (void)pause
{
    if (_player) {
        [_player pause];
    }
}

- (BOOL)isPlaying
{
    if (_player) {
        return _player.isPlaying;
    }
    
    return NO;
}

// 停止播放.
- (void)stopPlay
{
    [_player stop];
    _player.delegate = nil;
    _player = nil;
    
    [self stopShakeTimer];
    
    _isFinding = NO;
}

#define AudioPlayer_Ipod @"ipod-library"
- (NSURL *)realURL:(NSString *)filePath
{
    NSURL *fileUrl;
    NSRange range = [filePath rangeOfString:AudioPlayer_Ipod];
    if (range.location != NSNotFound) {
        fileUrl = [NSURL URLWithString:filePath];
    } else {
        fileUrl = [NSURL fileURLWithPath:filePath];
    }
    
    return fileUrl;
}

@end
