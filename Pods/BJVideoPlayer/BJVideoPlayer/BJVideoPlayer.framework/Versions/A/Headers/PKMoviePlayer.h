//
//  PKMoviePlayer.h
//  PKMoviePlayer
//
//  Created by xuke on 14-8-22.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import "PKVideoPlayerKit.h"
#import "PKMoviePlayerController.h"


// ADPlayer Notifications  片头广告的通知
extern NSString *const ADPlayerPlaybackDidFinishNotification;  // 如多个视频，只在最后一个视频播放成功时回调
extern NSString *const ADPlayerPlaybackDidFailedNotification;  // 如多个视频，每个视频播放播放失败时都会回调
extern NSString *const ADPlayerPlayWillLoadNotification; // 如多个视频，只在第一个视频加载时回调
extern NSString *const ADPlayerPlayWillPlayNotification; // 如多个视频，每个视频将播放时回调

//片尾广告的通知
extern NSString *const EPPlayerPlaybackDidFinishNotification;
extern NSString *const EPPlayerPlaybackDidFailedNotification;
extern NSString *const EPPlayerPlayWillLoadNotification;
extern NSString *const EPPlayerPlayWillPlayNotification;


extern NSString *const PKMoviePlayerHasNotEnoughCacheSpace; // 开启server预加载后，本地空间不足

//Preload progress Notification
extern NSString *const kVideoLoadedRange;

// -----------------------------------------------------------------------------
// Movie Player Notifications

// Posted when the scaling mode changes.
extern NSString *const PKMoviePlayerScalingModeDidChangeNotification;

// Posted when movie playback ends or a user exits playback.
extern NSString *const PKMoviePlayerPlaybackDidFinishNotification;

extern NSString *const PKMoviePlayerPlaybackDidFinishReasonUserInfoKey NS_AVAILABLE_IOS(3_2); // NSNumber (PKMovieFinishReason)

// Posted when the playback state changes, either programatically or by the user.
extern NSString *const PKMoviePlayerPlaybackStateDidChangeNotification NS_AVAILABLE_IOS(3_2);

// Posted when the network load state changes.
extern NSString *const PKMoviePlayerLoadStateDidChangeNotification NS_AVAILABLE_IOS(3_2);

// Posted when the currently playing movie changes.
extern NSString *const PKMoviePlayerNowPlayingMovieDidChangeNotification NS_AVAILABLE_IOS(3_2);

// Posted when the movie player enters or exits fullscreen mode.
//extern NSString *const PKMoviePlayerWillEnterFullScreenNotification NS_AVAILABLE_IOS(3_2);
//extern NSString *const PKMoviePlayerDidEnterFullScreenNotification NS_AVAILABLE_IOS(3_2);
//extern NSString *const PKMoviePlayerWillExitFullScreenNotification NS_AVAILABLE_IOS(3_2);
//extern NSString *const PKMoviePlayerDidExitFullScreenNotification NS_AVAILABLE_IOS(3_2);
//extern NSString *const PKMoviePlayerFullScreenAnimationDurationUserInfoKey NS_AVAILABLE_IOS(3_2); // NSNumber of double (NSTimeInterval)
//extern NSString *const PKMoviePlayerFullScreenAnimationCurveUserInfoKey NS_AVAILABLE_IOS(3_2);     // NSNumber of NSUInteger (UIViewAnimationCurve)

// Posted when the movie player begins or ends playing video via AirPlay.
extern NSString *const PKMoviePlayerIsAirPlayVideoActiveDidChangeNotification NS_AVAILABLE_IOS(5_0);

// Posted when the ready for display state changes.
extern NSString *const PKMoviePlayerReadyForDisplayDidChangeNotification NS_AVAILABLE_IOS(6_0);

// Whether or not Picture in Picture is currently possible.
extern NSString *const PKMoviePlayerPictureInPicturePossibleDidChangeNotification NS_AVAILABLE_IOS(9_0);

// -----------------------------------------------------------------------------
// Movie Property Notifications

// Calling -prepareToPlay on the movie player will begin determining movie properties asynchronously.
// These notifications are posted when the associated movie property becomes available.
//extern NSString *const PKMovieMediaTypesAvailableNotification NS_AVAILABLE_IOS(3_2);
//extern NSString *const PKMovieSourceTypeAvailableNotification NS_AVAILABLE_IOS(3_2); // Posted if the movieSourceType is PKMovieSourceTypeUnknown when preparing for playback.
extern NSString *const PKMovieDurationAvailableNotification NS_AVAILABLE_IOS(3_2);
//extern NSString *const PKMovieNaturalSizeAvailableNotification NS_AVAILABLE_IOS(3_2);

