//
//  AudioHelper.h
//  SmartStent
//
//  Created by zorro on 16/8/31.
//  Copyright © 2016年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define KK_AudioHelper ([AudioHelper sharedInstance])

@interface AudioHelper : NSObject <AVAudioPlayerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSObjectSimpleBlock backBlock;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, assign) NSInteger audioIndex;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) BOOL isFinding;
@property (nonatomic, strong) NSTimer *shakeTimer;
@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic, strong) NSObjectSimpleBlock audioStartBlock;
@property (nonatomic, strong) NSObjectSimpleBlock audioEndBlock;

AS_SINGLETON(AudioHelper)

- (void)playAudio;
- (void)pause;
- (void)stopPlay;
- (void)showAlertView;

@end
