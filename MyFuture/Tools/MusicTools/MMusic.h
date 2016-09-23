//
//  MMusic.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/15.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioPlayer.h"


@class AudioButton, AudioStreamer;

@interface MMusic : NSObject<AudioPlayerDelegate>
{
    NSTimer *_timer;
}

@property (nonatomic, strong) AudioPlayer *audioPlayer;


///根据文件名播放本地音乐
- (void)audioPlayWithFileName:(NSString *)fileName;

///根据地址播放在线音乐
- (void)audioPlayWithHttpAddress:(NSString *)path;

+ (MMusic *)shareInstance;


@property (nonatomic, retain) AudioStreamer *streamer;
@property (nonatomic, retain) AudioButton *button;
@property (nonatomic, retain) NSURL *url;

//播放网络歌曲
- (void)play;

//暂停网络歌曲
- (void)stop;

- (BOOL)isProcessing;

//播放本地歌曲
- (void)playMusic;

//暂停本地歌曲
- (void)stopMusic;


@end
