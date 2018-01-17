//
//  BJPMProtocol.h
//  Pods
//
//  Created by DLM on 2016/10/25.
//
//

#import <Foundation/Foundation.h>

@class BJPlayerManager;

@protocol BJPMProtocol <NSObject>

@required
/**
 播放过程中出错
 
 @param playerManager 播放器实例
 @param error 错误
 */
- (void)videoplayer:(BJPlayerManager *)playerManager throwPlayError:(NSError *)error;

@optional

/**
 即将播放视频的回调方法

 @param playerManager 播放器实例
 @param videoId 视频id
 @return return YES 视频自动播放，return NO 需手动播放
 */
- (BOOL)videoPlayer:(BJPlayerManager *)playerManager shouldPlayVideo:(long long)videoId;

/**
 视频播放完成的回调方法
 
 如果有片尾广告, 片尾结束回调此方法, 没有片尾广告, 正片结束回调此方法
 @param playerManager 播放器实例
 */
- (void)videoDidFinishPlayInVideoPlayer:(BJPlayerManager *)playerManager;

/**
 播放器暂停的回调方法

 @param playerManager 播放器实例
 */
- (void)videoPlayPauseInVideoPlayer:(BJPlayerManager *)playerManager;

@end
