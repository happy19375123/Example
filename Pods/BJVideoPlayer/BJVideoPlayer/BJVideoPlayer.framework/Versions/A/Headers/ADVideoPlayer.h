//
//  ADVideoPlayer.h
//  PKMoviePlayer
//
//  Created by xuke on 14-8-29.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ADAVPlayerItem.h"

@protocol ADVideoPlayerDelegate;

@interface ADVideoPlayer : AVQueuePlayer

@property (nonatomic, weak, readonly) id<ADVideoPlayerDelegate> playerDelegate;
@property (nonatomic, readwrite) BOOL isHeader; //判断是片头还是片尾

- (id)initWithAdUrlList:(NSArray *)adUrlList delegate:(id<ADVideoPlayerDelegate>)delegate isHeader:(BOOL) isHeader;

- (void)removeCurrentItemObserver;

@end



@protocol ADVideoPlayerDelegate <NSObject>

@optional

// 如多个视频，只在第一个视频加载时回调
- (void)adPlayer:(ADVideoPlayer *)player willLoadAVPlayerItem:(AVPlayerItem *)item;

// 如多个视频，每个视频将播放时回调
- (void)adPlayer:(ADVideoPlayer *)player willPlayAVPlayerItem:(AVPlayerItem *)item;

// 如多个视频，只在最后一个视频播放成功时回调
- (void)adPlayer:(ADVideoPlayer *)player playbackFinishWithAVPlayerItem:(AVPlayerItem *)item isTheLast:(BOOL)theLast;

// 如多个视频，每个视频播放播放失败时都会回调
- (void)adPlayer:(ADVideoPlayer *)player playbackFailedWithAVPlayerItem:(AVPlayerItem *)item isTheLast:(BOOL)theLast;




@end
