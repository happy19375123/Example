//
//  PKVideoPlayerKit.h
//  PKVideoPlayer
//
//  Created by xuke on 13-4-9.
//  Copyright (c) 2013年 icePhone. All rights reserved.
//
#import <Availability.h>
#import <stdio.h>
#ifndef PKVideoPlayerKit_h
#define PKVideoPlayerKit_h

    #ifndef __IPHONE_5_0
        #error "PKVideoPlayerKit uses features only available in iOS SDK 5.0 and later."
    #endif

    #ifdef DEBUG
        #define VDLog(fmt, ...) {NSLog((@"" fmt),##__VA_ARGS__);}//{NSLog((@"%s [Line %d]\n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
    #else
        #define VDLog(...)
    #endif

    #import <AVFoundation/AVFoundation.h>
    #import <CoreMedia/CoreMedia.h>
    #import <MediaPlayer/MediaPlayer.h>
    #import "PKVideoPlayerError.h"
    #import "PKVideoPlayer.h"
    #import "ADVideoPlayer.h"

    #define PKVideoLoadRetryMaxTimes (1)

#endif

