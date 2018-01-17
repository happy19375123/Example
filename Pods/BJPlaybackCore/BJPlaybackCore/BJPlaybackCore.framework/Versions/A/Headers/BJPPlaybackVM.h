//
//  BJPPlayVM.h
//  Pods
//
//  Created by 辛亚鹏 on 2016/12/21.
//  Copyright © 2016年 Baijia Cloud. All rights reserved.
//

#import <BJLiveCore/BJLBaseVM.h>
#import <BJPlayerManagerCore/BJPlayerManagerCore.h>

@class BJPSignalModel;

NS_ASSUME_NONNULL_BEGIN

@interface BJPPlaybackVM : NSObject

/**
 设置回放用户的标识符
 */
@property (nonatomic, nullable) NSString *userInfo;

/**
 当前的播放时间  支持KVO
 */
@property (nonatomic, readonly) NSTimeInterval currentTime;

/**
 视频的总时长
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 已经缓存的时长
 */
@property (nonatomic, readonly) NSTimeInterval playableDuration;

/**
 初始化播放时间, 用于记忆播放, 需要在进入房间之前设置
 */
@property (nonatomic) NSTimeInterval initialPlaybackTime;

/**
 用于设置播放结束的时间
 */
@property (nonatomic) NSTimeInterval endPlaybackTime;

/**
 播放控制器
 */
@property (nonatomic, readonly, nullable) BJPlayerManager *playerControl;

/**
 当前的播放速度
 */
@property (nonatomic, readonly) CGFloat currentPlayRate;

/**
 播放状态
 */
@property (nonatomic, readonly) PKMoviePlaybackState playbackState;

/**
 信令文件的url
 */
@property (nonatomic, readonly, nullable) BJPSignalModel *signalModel;

/**
 播放器的view
 */
@property (nonatomic, readonly) UIView *playView;

/**
 播放信息
 */
@property (nonatomic, readonly, nullable) PMVideoInfoModel *videoInfoModel;

/**
 当前播放清晰度
 */
@property (nonatomic, readonly, nullable) PMVideoDefinitionInfoModel *currDefinitionInfoModel;

/**
 当前播放的CDN
 */
@property (nonatomic, readonly, nullable) PMVideoCDNInfoModel *currCDNInfoModel;

/**
 play
 */
- (void)playerPlay;

/**
 pause
 */
- (void)playerPause;

/**
 stop
 */
- (void)playerStop;

/**
 seek
 @param seekTotime time
 */
- (void)playerSeekToTime:(NSTimeInterval)seekTotime;

/**
 change rate

 @param rate rate, default: 1.0
 */
- (void)changeRate:(CGFloat)rate;

/**
 play by vid

 @param vid vid
 */
//- (void)playVideoById:(NSInteger)vid;

/**
 切换清晰度

 @param dt 清晰度
 */
- (void)changeDefinition:(PMVideoDefinitionType)dt;

/**
 设置水印
 */
- (void)resetWaterMark;

@end

NS_ASSUME_NONNULL_END
