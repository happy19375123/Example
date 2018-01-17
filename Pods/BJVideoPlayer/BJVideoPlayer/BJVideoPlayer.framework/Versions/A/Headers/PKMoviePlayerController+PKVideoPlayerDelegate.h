//
//  PKMoviePlayerController+PKVideoPlayerDelegate.h
//  PKMoviePlayerProj
//
//  Created by xuke on 14-3-6.
//  Copyright (c) 2014年 xuke. All rights reserved.
//

#import "PKMoviePlayerController.h"
#import "PKVideoPlayerKit.h"
#import "PKVideoPlayer.h"



@interface PKMoviePlayerController (PKVideoPlayerDelegate) <PKVideoPlayerDelegate>

@property (nonatomic, assign) BOOL prepareLoadAndPlay;

@property (nonatomic, assign) NSInteger retryTimes;

@property (nonatomic, assign) BOOL lastIsAirPlayVideoActive;

@end





