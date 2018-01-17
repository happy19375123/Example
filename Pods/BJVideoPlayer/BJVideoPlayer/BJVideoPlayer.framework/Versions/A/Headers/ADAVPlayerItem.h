//
//  ADAVPlayerItem.h
//  BJVideoPlayer
//
//  Created by xuke01 on 15/11/28.
//  Copyright © 2015年 xuke01. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface ADAVPlayerItem : AVPlayerItem

@property (nonatomic, weak) id observer;

- (id)initWithURL:(NSURL *)URL observer:(id)observer;

@end
