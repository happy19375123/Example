//
//  PKMoviePlayback.h
//  PKMoviePlayerProj
//
//  Created by xuke on 14-3-6.
//  Copyright (c) 2014年 xuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PKMoviePlayback

// Prepares the current queue for playback, interrupting any active (non-mixible) audio sessions.
// Automatically invoked when -play is called if the player is not already prepared.
- (void)prepareToPlay;

// Returns YES if prepared for playback.
@property(nonatomic, readonly) BOOL isPreparedToPlay;

// Plays items from the current queue, resuming paused playback if possible.
- (void)play;

- (void)playUseOldItem;

- (void)playADPlayer;

- (void)playEPPlayer;

// Pauses playback if playing.
- (void)pause;

- (void)pauseADPlayer;

- (void)pauseEPPlayer;

// Ends playback. Calling -play again will start from the beginnning of the queue.
- (void)stop;

// The current playback time of the now playing item in seconds.
@property(nonatomic) NSTimeInterval currentPlaybackTime;

// The current playback rate of the now playing item. Default is 1.0 (normal speed).
// Pausing will set the rate to 0.0. Setting the rate to non-zero implies playing.
@property(nonatomic) float currentPlaybackRate;

@end

// Posted when the prepared state changes of an object conforming to the PKMediaPlayback protocol changes.
extern NSString *const PKMediaPlaybackIsPreparedToPlayDidChangeNotification NS_AVAILABLE_IOS(3_2);
