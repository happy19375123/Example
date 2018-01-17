//
//  PKAVPlayerItem.h
//  BJEducation_student
//
//  Created by xuke01 on 15/10/9.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#define keyPathForRate            @"rate"
#define keyPathForStatus          @"status"
#define keyPathForBufferEmpty     @"playbackBufferEmpty"
#define keyPlaybackLikelyToKeepUp @"playbackLikelyToKeepUp"
#define keyLoadedTimeRanges       @"loadedTimeRanges"

@interface PKAVPlayerItem : AVPlayerItem

@property (nonatomic, weak) id observer;

- (id)initWithURL:(NSURL *)URL observer:(id)observer;

@end
