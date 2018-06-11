//
//  PKMoviePlayerController.h
//  PKMoviePlayerProj
//
//  Created by xuke on 14-3-5.
//  Copyright (c) 2014年 xuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "PKMoviePlayback.h"
#import "PKMoviePlayer.h"
#import "PKVideoPlayer.h"

enum {
    PKMovieScalingModeNone,       // No scaling
    PKMovieScalingModeAspectFit,  // Uniform scale until one dimension fits
    PKMovieScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    PKMovieScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};
typedef NSInteger PKMovieScalingMode;

enum {
    PKMoviePlaybackStateStopped,
    PKMoviePlaybackStatePlaying,
    PKMoviePlaybackStatePaused,
    PKMoviePlaybackStateInterrupted,
    PKMoviePlaybackStateSeekingForward,
    PKMoviePlaybackStateSeekingBackward
};
typedef NSInteger PKMoviePlaybackState;

enum {
    PKMovieLoadStateUnknown        = 0,
    PKMovieLoadStatePlayable       = 1 << 0,
    PKMovieLoadStatePlaythroughOK  = 1 << 1, // buffer 满了,可以播放了
    PKMovieLoadStateStalled        = 1 << 2, // buffer 不满,卡顿状态
};
typedef NSInteger PKMovieLoadState;

typedef enum {
    PKMovieADPlayer     = 0,
    PKMovieNormalPlayer = 1 << 0,
    PKMovieEPPlayer     = 1 << 1,
    PKMovieUnknowPlayer = 1 << 2,
}PKMovieCurrentPlayer;

typedef enum {
    PKMoviePlaying = 0,
    PKMoviePausing = 1 << 0,
    PKMovieStoping = 1 << 1,
    PKMovieSeeking = 1 << 2,
}PKMovieCurrentStatus;

//enum {
//    PKMovieRepeatModeNone,
//    PKMovieRepeatModeOne
//};
//typedef NSInteger PKMovieRepeatMode;

//enum {
//    PKMovieControlStyleNone,       // No controls
//    PKMovieControlStyleEmbedded,   // Controls for an embedded view
//    PKMovieControlStyleFullScreen, // Controls for fullscreen playback
//    
//    PKMovieControlStyleDefault = PKMovieControlStyleEmbedded
//};
//typedef NSInteger PKMovieControlStyle;

enum {
    PKMovieFinishReasonPlaybackEnded,
    PKMovieFinishReasonPlaybackError,
    PKMovieFinishReasonUserExited
};
typedef NSInteger PKMovieFinishReason;

// -----------------------------------------------------------------------------
// Movie Property Types

//enum {
//    PKMovieMediaTypeMaskNone  = 0,
//    PKMovieMediaTypeMaskVideo = 1 << 0,
//    PKMovieMediaTypeMaskAudio = 1 << 1
//};
//typedef NSInteger PKMovieMediaTypeMask;

//enum {
//    PKMovieSourceTypeUnknown,
//    PKMovieSourceTypeDownloadM3U8File,       // Local downloaded M3U8
//    PKMovieSourceTypeDownloadMP4File,        // Local downloaded MP4
//    PKMovieSourceTypelocalServerM3U8File, // localServer downloaded M3U8 network content
//    PKMovieSourceTypelocalServerMP4File,  // localServer downloaded MP4 network content  走代理 不支持airplay
//    PKMovieSourceTypeOnDemandM3u8,        // On-demand M3u8 streaming content
//    PKMovieSourceTypeOnDemandMP4,         // On-demand MP4 streaming content 支持airplay 无法走代理
//    PKMovieSourceTypeLiveStreaming,        // Live streaming content
//    PKMovieSourceTypeH265
//
//};
//typedef NSInteger PKMovieSourceType;

@protocol LocalHttpServerDelegate;

// -----------------------------------------------------------------------------
// Movie Player
//
@interface PKMovieView : UIView
@property (nonatomic) AVPlayer *player;

@end

@interface PKMoviePlayerController : NSObject <PKMoviePlayback, ADVideoPlayerDelegate, AVPictureInPictureControllerDelegate>
{
    BOOL _isPreparedToPlay;
    PKMovieLoadState _loadState;
    PKMoviePlaybackState _playbackState;
    PKMovieCurrentPlayer _runningPlayer;
    PKMovieCurrentStatus _currentStatus;
    
    PKVideoPlayer *_videoPlayer;
    ADVideoPlayer *_adPlayer;
    ADVideoPlayer *_epPlayer;
    PKMovieView *_videoView;
    NSURL *_contentURL;
    id _timeObserver;
}

// 退出播放后调用，还原播放器状态。
- (void)clearPlayer;
 
// 解决AVPlayer黑屏问题,出问题了,调用一次即可。
- (void)resetPlayer;

// 强制重试用,切换视频源码流无法播放,通过销毁播放器方式,重新播放
- (void)forceRetryPlayCurrentVideo;

// 设置播放地址和广告地址，广告地址可为nil(兼容老接口)
- (void)setContentURL:(NSURL *)contentURL adUrlList:(NSArray *)adUrlList;

// 设置播放地址和广告地址，广告地址可为nil
- (void)setContentURL:(NSURL *)contentURL adUrlList:(NSArray *)adUrlList epUrlList:(NSArray*)epUrlList;

// 用于在播放过程中，关闭广告播放器，直接开始正片播放（场景描述：vip登录去广告、广告加载报错）
- (void)closeADPlayer;

- (void)useLocalVideo:(BOOL)flag;

- (BOOL)getLocalVideo;


@property(nonatomic, strong) NSURL *contentURL;   // 当前正片的播放地址

@property(nonatomic, readonly) NSArray *adUrlList;  // 存放NSURL *adUrl的array  一个list的视频格式必须相同,支持mp4、mov、m3u8，不支持混排

@property(nonatomic, readonly) NSArray *epUrlList;  //当前片尾地址

@property(nonatomic, readonly) BOOL isADVideoPlaying; // 当前播放的是广告还是正片 YES -> 广告  NO -> 正片

@property(nonatomic, assign) PKMovieCurrentPlayer runingPlayer; //当前播放器 片头，正片，片尾

@property(nonatomic, assign) PKMovieCurrentStatus currentStatus; //当前播放器状态 播放中， 暂停中，停止

// The view in which the media and playback controls are displayed.
@property(nonatomic, readonly) UIView *view; // <PKMovieView>

@property (nonatomic, assign) CGFloat rateSpeed; // 播放倍率 default 1.0

// iOS 9 iPad 画中画
@property(nonatomic, strong, readonly) AVPictureInPictureController *pictureControl NS_AVAILABLE_IOS(9.0);


@property(nonatomic, weak) id<AVPictureInPictureControllerDelegate> pipControlDelegate;


// Indicates if a movie should automatically start playback when it is likely to finish uninterrupted based on e.g. network conditions. Defaults to YES.
@property(nonatomic) BOOL shouldAutoplay;

// Returns YES if the first video frame has been made ready for display for the current item.
// Will remain NO for items that do not have video tracks associated.
@property(nonatomic, readonly) BOOL readyForDisplay;

/*!
	@property	pictureInPicturePossible
	@abstract	Whether or not Picture in Picture is currently possible.
 */
@property(nonatomic, readonly) BOOL pictureInPicturePossible NS_CLASS_AVAILABLE_IOS(9_0);

// Determines how the content scales to fit the view. Defaults to PKMovieScalingModeAspectFit.
@property(nonatomic) PKMovieScalingMode scalingMode;



@property(nonatomic, strong) NSMutableArray *downloadSpeedArray; // 用于计算平均每秒的下载速度

@property(nonatomic, assign) NSInteger maxRertyTimes; // 设置最大重试次数 default 1次



@end



@interface PKMoviePlayerController (PKMovieProperties)

// The types of media in the movie, or PKMovieMediaTypeNone if not known.
//@property(nonatomic, readonly) PKMovieMediaTypeMask movieMediaTypes;

// The playback type of the movie. Defaults to PKMovieSourceTypeUnknown.
// Specifying a playback type before playing the movie can result in faster load times.
//@property(nonatomic) PKMovieSourceType movieSourceType;

// Returns the current playback state of the movie player.
@property(nonatomic, readonly) PKMoviePlaybackState playbackState;

// Returns the network load state of the movie player.
@property(nonatomic, readonly) PKMovieLoadState loadState;

//@property(nonatomic, readonly) PKMovieSourceType sourceType;

// The duration of the movie, or 0.0 if not known.
@property(nonatomic, readonly) NSTimeInterval duration;

// The currently playable duration of the movie, for progressively downloaded network content.
@property(nonatomic, readonly) NSTimeInterval playableDuration;

@property(nonatomic, readonly) long long bitDownloadSpeed; // 平均每秒的下载速度

// The natural size of the movie, or CGSizeZero if not known/applicable.
@property(nonatomic, readonly) CGSize naturalSize;

// The start time of movie playback. Defaults to NaN, indicating the natural start time of the movie.
@property(nonatomic) NSTimeInterval initialPlaybackTime;

// The end time of movie playback. Defaults to NaN, which indicates natural end time of the movie.
@property(nonatomic) NSTimeInterval endPlaybackTime;

// Indicates whether the movie player allows AirPlay video playback. Defaults to YES on iOS 5.0 and later.
@property(nonatomic) BOOL allowsAirPlay NS_AVAILABLE_IOS(4_3);

// Indicates whether the movie player is currently playing video via AirPlay.
@property(nonatomic, readonly, getter=isAirPlayVideoActive) BOOL airPlayVideoActive NS_AVAILABLE_IOS(5_0);

@end


