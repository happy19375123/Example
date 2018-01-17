//
//  PKVideoPlayerError.h
//  PKMoviePlayerProj
//
//  Created by xuke on 13-8-25.
//  Copyright (c) 2013年 xuke. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const PKVideoPlayerErrorDomain;

@interface PKVideoPlayerError : NSError
+ (PKVideoPlayerError *)errorWithNSError:(NSError *)error;
@end

typedef NS_ENUM(NSInteger, PKVideoPlayerErrorCode){
    PKVideoPlayerErrorUnknow  = 0,
    PKVideoPlayerErrorPlayerItemFailedToPlayToEndTime,       // 结束播放失败
    PKVideoPlayerErrorOther,                                 // 用与扩展
};
