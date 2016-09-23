//
//  MMusic.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/15.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MMusic.h"
#import "AudioButton.h"
#import "AudioStreamer.h"

@implementation MMusic

+ (MMusic *)shareInstance
{
    MMusic *music = [[MMusic alloc] init];
    music.audioPlayer = [[AudioPlayer alloc] init];
    music.audioPlayer.delegate = music;
    return music;
}

- (void)audioPlayWithFileName:(NSString *)fileName
{
    NSString * path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSURL* url = [NSURL fileURLWithPath:path];
    [self.audioPlayer setDataSource:[_audioPlayer dataSourceFromURL:url] withQueueItemId:url];
}

- (void)audioPlayWithHttpAddress:(NSString *)path
{
    NSURL *url = [NSURL URLWithString:path];
    [_audioPlayer setDataSource:[_audioPlayer dataSourceFromURL:url] withQueueItemId:url];
}


- (void)playMusic
{
    if (!_audioPlayer) {
        return;
    }
    if (_audioPlayer.state == AudioPlayerStatePaused) {
        [_audioPlayer resume];
    }else{
        [_audioPlayer pause];
    }
}

- (void)stopMusic
{
    if (!_audioPlayer) {
        return;
    }
    [_audioPlayer stop];
}

#pragma mark----播放网络歌曲

- (BOOL)isProcessing
{
    return [self.streamer isPlaying] || [self.streamer isWaiting] || [self.streamer isFinishing] ;
}


- (void)play
{
    if (!_streamer) {
        
        self.streamer = [[AudioStreamer alloc] initWithURL:self.url];
        
        // set up display updater
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(updateProgress)]];
        [invocation setSelector:@selector(updateProgress)];
        [invocation setTarget:self];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             invocation:invocation
                                                repeats:YES];
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:ASStatusChangedNotification
                                                   object:_streamer];
    }
    
    if ([_streamer isPlaying]) {
        [_streamer pause];
    } else {
        [_streamer start];
    }
}


- (void)stop
{
    [_button setProgress:0];
    [_button stopSpin];
    
    _button.image = [UIImage imageNamed:playImage];
    _button = nil; // 避免播放器的闪烁问题
    
    // release streamer
    if (_streamer)
    {
        [_streamer stop];
        _streamer = nil;
        
        // remove notification observer for streamer
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:ASStatusChangedNotification
                                                      object:_streamer];
    }
}

- (void)updateProgress
{
    if (_streamer.progress <= _streamer.duration ) {
        [_button setProgress:_streamer.progress/_streamer.duration];
    } else {
        [_button setProgress:0.0f];
    }
}

/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
    if ([_streamer isWaiting])
    {
        _button.image = [UIImage imageNamed:stopImage];
        [_button startSpin];
    } else if ([_streamer isIdle]) {
        _button.image = [UIImage imageNamed:playImage];
        [self stop];
    } else if ([_streamer isPaused]) {
        _button.image = [UIImage imageNamed:playImage];
        [_button stopSpin];
        [_button setColourR:0.0 G:0.0 B:0.0 A:0.0];
    } else if ([_streamer isPlaying] || [_streamer isFinishing]) {
        _button.image = [UIImage imageNamed:stopImage];
        [_button stopSpin];
    } else {
        
    }
    [_button setNeedsLayout];
    [_button setNeedsDisplay];
}


#pragma mark -----AudioPlayerDelegate

-(void) audioPlayer:(AudioPlayer*)audioPlayer stateChanged:(AudioPlayerState)state
{
    NSLog(@"--------stateChanged--------");
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didEncounterError:(AudioPlayerErrorCode)errorCode
{
    NSLog(@"--------didEncounterError--------");
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    NSLog(@"--------didStartPlayingQueueItemId--------");
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    
    
    NSLog(@"--------didFinishBufferingSourceWithQueueItemId--------");
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(AudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    NSLog(@"--------didFinishPlayingQueueItemId--------");
    
//    [self audioPlayWithFileName:@"sample.m4a"];
    [self stopMusic];
    
}

- (void)dealloc
{
    [_timer invalidate];
}
@end
