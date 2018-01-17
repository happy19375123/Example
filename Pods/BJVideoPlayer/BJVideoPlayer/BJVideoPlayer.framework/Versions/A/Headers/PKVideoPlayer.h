//
//  PKVideoPlayer.h
//  PKMoviePlayerProj
//
//  Created by xuke on 14-1-21.
//  Copyright (c) 2014年 xuke. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@class PKVideoPlayerItem;

typedef NS_ENUM(NSInteger, PKVideoPlayerLoadStatus) {
    PKVideoPlayerLoadStatus_Unload,
    PKVideoPlayerLoadStatus_LoadFailed,
    PKVideoPlayerLoadStatus_Loading,
    PKVideoPlayerLoadStatus_LoadSuccessed,
};

typedef NS_ENUM(NSInteger, PKVideoPlayerPlayStatus) {
    PKVideoPlayerPlayStatus_Unknow = -1,
    PKVideoPlayerPlayStatus_Failed,
    PKVideoPlayerPlayStatus_Stop,
    PKVideoPlayerPlayStatus_Play,
    PKVideoPlayerPlayStatus_Pause,
    PKVideoPlayerPlayStatus_ReachEnd,
    PKVideoPlayerPlayStatus_Forward,
    PKVideoPlayerPlayStatus_Backward
};

@class PKVideoPlayerError;
@protocol PKVideoPlayerItem;
@protocol PKVideoPlayerDelegate;

@interface PKVideoPlayer : AVPlayer

@property (nonatomic,     weak) id<PKVideoPlayerDelegate> playerDelegate;

@property (nonatomic,   assign) BOOL playerShouldAutoPlay; // Default is YES 是否自动播放

@property (nonatomic, readonly) PKVideoPlayerLoadStatus loadStatus;

@property (nonatomic, readonly) PKVideoPlayerPlayStatus playStatus;

@property (nonatomic, strong, readonly) PKVideoPlayerItem *currentPlayerItem;

@property (nonatomic, readonly) CGFloat playerCurrentTime;

@property (nonatomic, readonly) CGFloat playerDuration;

@property (nonatomic, readonly) CGFloat playerAvailableDuration;

@property (nonatomic, assign) CGFloat rateSpeed; // 播放倍率 default 1.0

@property (nonatomic, readonly) BOOL playerVideoPlayable;

- (void)setVideoPlayerItem:(id<PKVideoPlayerItem>)playerItem;

- (void)playerPlay;

- (void)plyerPlayOldItem;

- (void)playerPause;

- (void)playerStop;

- (void)playerSeekToTime:(CGFloat)time;

- (void)playerSeekToTime:(CGFloat)time completionHandler:(void (^)(BOOL finished))completionHandler;

- (void)useLocalVideo:(BOOL) flag;

- (BOOL)getLocalVideo;

@end

@protocol PKVideoPlayerDelegate <NSObject>

@optional

- (void)videoPlayerUpdateLoadStatus:(PKVideoPlayerLoadStatus)status error:(PKVideoPlayerError *)error;

- (void)videoPlayerUpdatePlayStatus:(PKVideoPlayerPlayStatus)status error:(PKVideoPlayerError *)error;

- (void)videoPlayer:(PKVideoPlayer *)player updateBufferTime:(CGFloat)bufferTime;

- (void)videoPlayer:(PKVideoPlayer *)player willLoadVideoPlayerItem:(id<PKVideoPlayerItem>)playerItem;

- (void)videoPlayer:(PKVideoPlayer *)player didLoadVideoPlayerItem:(id<PKVideoPlayerItem>)playerItem;

- (void)videoPlayer:(PKVideoPlayer *)player playbackFinishWithVideoPlayerItem:(id<PKVideoPlayerItem>)item;

@end

@protocol PKVideoPlayerItem <NSObject>

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign) CGFloat beginTime;

@end

