//
//  PKVideoPlayerItem.h
//  PKMoviePlayerProj
//
//  Created by xuke on 13-9-2.
//  Copyright (c) 2013年 xuke. All rights reserved.
//

#import "PKVideoPlayerKit.h"
#import "PKVideoPlayer.h"

@interface PKVideoPlayerItem : NSObject <PKVideoPlayerItem>

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign) CGFloat beginTime;  

+ (PKVideoPlayerItem *)itemWithURL:(NSURL *)URL;

+ (PKVideoPlayerItem *)itemWithURL:(NSURL *)URL beginTime:(CGFloat)time;

@end
