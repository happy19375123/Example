//
//  BJPRoom.h
//  Pods
//
//  Created by 辛亚鹏 on 2016/12/14.
//  Copyright (c) 2016 Baijia Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BJLiveCore/BJLiveCore.h>

#import "BJPOnlineUserVM.h"
#import "BJPLoadingVM.h"
#import "BJPPlaybackVM.h"

#import "BJPMessage.h"
#import "BJPMediaPublish.h"

#import "BJPPlaybackCoreMacro.h"

/**
 播放本地视频访问媒体资料库时, 用户选择的状态, 只在iOS10以上的系统有效
 */
typedef NS_ENUM(NSInteger, BJPMediaLibraryAuthorizationStatus) {
    BJPMediaLibraryAuthorizationStatusNotDetermined = 0,
    BJPMediaLibraryAuthorizationStatusDenied,
    BJPMediaLibraryAuthorizationStatusRestricted,
    BJPMediaLibraryAuthorizationStatusAuthorized,
};

NS_ASSUME_NONNULL_BEGIN

/**
 教室
 可同时存在多个实例，但最多只有一个教室处于进入状态，后执行 enter 的教室会把之前的教室踢掉
 */
@interface BJPRoom : NSObject

/**
 创建在线回放的room
 创建在线视频, 参数不可传空
 创建本地room的话, 两个参数传nil
 
 @param classId classId
 @param sessionId sessionId, 长期房间回放参数. 如果classId对应的课程不是长期房间,可不传;
                  如果classId对应的课程是长期房间, 不传则默认返回长期房间的第一个课程
 @param token token
 @param userName 第三方用户名, 不上报则传nil
 @param userNumber 第三方用户number号, 不上报则传0
 @return room
 */
+ (instancetype)onlineVideoCreateRoomWithClassId:(NSString *)classId
                                       sessionId:(nullable NSString *)sessionId
                                           token:(NSString *)token
                                        userName:(nullable NSString *)userName
                                      userNumber:(NSInteger)userNumber;

/**
 创建本地视频  进入房间
 
 @param videoPath 本地视频的路径
 @param signalPath 本地信令, 根据isZip的值, 传信令文件的路径
 @param isZip 所传信令文件是否为压缩文件, YES:传压缩的信令文件的路径
 NO: 传解压后的信令文件, 且所传的路径的下一级目录即为all.json等数据
 */
+ (instancetype)localVideoCreatRoomWithVideoPath:(NSString *)videoPath
                                      signalPath:(NSString *)signalPath
                                      definition:(PMVideoDefinitionType)definition
                                           isZip:(BOOL)isZip;


/**
 Unavailable. Please use method: onlineCreateRoomWithClassId:token: | localVideoCreatRoomWithVideoPath:signalPath:definition:isZip:
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 进入教室
 */
- (void)enter;


/** 退出教室 */
- (void)exit;

/** 
 进入教室
 @param error 成功进入房间, error为空, 如果有失败, error不为空
 case: 在线播放, 获取playbackVM的播放信息
 case: 本地视频, 信令文件解压完毕,并载入内存
 */
- (BJLObservable)roomDidEnterWithError:(BJLError *)error;

/**
 退出教室事件，参考 BJLErrorDomain
 */
- (BJLObservable)roomWillExitWithError:(BJLError *)error;
- (BJLObservable)roomDidExitWithError:(BJLError *)error;

/**
 聊天信息的list
 */
- (BJLObservable)didReceiveMessageList:(NSArray <BJPMessage *> *)messageList;

/**
 抛出主讲人的音视频信息 media_publish
 */
- (BJLObservable)latestMediaPublish:(BJPMediaPublish *)mediaPublish;

/** 回放的管理VM */
@property (nonatomic, readonly, nullable) BJPPlaybackVM *playbackVM;

/**
 聊天的数组
 */
//@property (nonatomic, nullable) NSArray <PBChatModel *>*chatMessageList;

/** loadingVM */
@property (nonatomic, readonly, nullable) BJPLoadingVM *loadingVM;

/** 教室id */
@property (readonly, nonatomic, nonnull) NSString *classId;

/** 教室信息、状态，用户信息，公告等 */
@property (nonatomic, readonly, nullable) BJLRoomVM *roomVM;

/** 最新公告, 可能为空 */
@property (nonatomic, nullable) BJLNotice *notice;


/** 是否是本地视频 */
@property (nonatomic, readonly) BOOL isLocalVideo;

/** 禁用 PPT 动画, yes为禁止, 默认禁止 */
@property (nonatomic, readonly) BOOL disablePPTAnimation;

/** 在线用户 */
@property (nonatomic, readonly, nullable) BJPOnlineUserVM *onlineUsersVM;

/** 课件显示 */
@property (nonatomic, readonly, nullable) UIViewController<BJLSlideshowUI> *slideshowViewController;

@end

@interface BJPRoom(internal)

/** 部署环境
 调用 enter 之后设置无效
 仅 内网 & Debug 模式下有效 
 */
+ (void)setBJPDeployType:(PMDeployType)deployType;

@end

#pragma mark - 废弃的方法

@interface BJPRoom(deprecated)

+ (instancetype)onlineVideoCreateRoomWithClassId:(NSString *)classId token:(NSString *)token BJP_Will_DEPRECATED("+onlineVideoCreateRoomWithClassId:sessionId:token:");

+ (instancetype)onlineVideoCreateRoomWithClassId:(NSString *)classId
                                       sessionId:(nullable NSString *)sessionId
                                           token:(NSString *)token BJP_Will_DEPRECATED("onlineVideoCreateRoomWithClassId:token:userName:userNumber:");

+ (instancetype)localVideoCreateRoom BJP_Will_DEPRECATED("+localVideoCreatRoomWithVideoPath:signalPath:definition:isZip:status:");

- (void)enterRoomWithVideoPath:(NSString *)videoPath
                    signalPath:(NSString *)signalPath
                    definition:(PMVideoDefinitionType)definition
                         isZip:(BOOL)isZip
                        status:(void (^)(BJPMediaLibraryAuthorizationStatus status))handle BJP_Will_DEPRECATED("enter");
+ (instancetype)localVideoCreatRoomWithVideoPath:(NSString *)videoPath
                                      signalPath:(NSString *)signalPath
                                      definition:(PMVideoDefinitionType)definition
                                           isZip:(BOOL)isZip
                                          status:(void (^)(BJPMediaLibraryAuthorizationStatus status))handle BJP_Will_DEPRECATED("-localVideoCreatRoomWithVideoPath:signalPath:definition:isZip:");;

@end

NS_ASSUME_NONNULL_END
