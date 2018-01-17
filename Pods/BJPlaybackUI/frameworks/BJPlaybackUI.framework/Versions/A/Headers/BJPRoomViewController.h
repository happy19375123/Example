//
//  BJPRoomViewController.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/22.
//
//

#import <UIKit/UIKit.h>
#import <BJPlaybackCore/BJPlaybackCore.h>

#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPRoomViewController : UIViewController

/** 回放教室
 参考 `BJPlaybackCore` */
@property (nonatomic, readonly, nullable) BJPRoom *room;

/**
 创建回放的room
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
+ (__kindof instancetype)onlineVideoCreateRoomWithClassId:(NSString *)classId
                                                sessionId:(nullable NSString *)sessionId
                                                    token:(NSString *)token
                                                 userName:(nullable NSString *)userName
                                               userNumber:(NSInteger)userNumber;

+ (__kindof instancetype)onlineVideoCreateRoomWithClassId:(NSString *)classId
                                                sessionId:(nullable NSString *)sessionId
                                                    token:(NSString *)token BJP_Will_DEPRECATED("onlineVideoCreateRoomWithClassId:token:userName:userNumber:");

/**
 创建播放本地视频  
 
 @param videoPath 本地视频的路径
 @param signalPath 本地信令, 根据isZip的值, 传信令文件的路径
 @param isZip 所传信令文件是否为压缩文件, YES:传压缩的信令文件的路径
 NO: 传解压后的信令文件, 且所传的路径的下一级目录即为all.json等数据
 @param handle 用于在iOS10以上的系统用户授权进入本地资料库, 如果版本低iOS10,不需要授权,
 即status = BJPMediaLibraryAuthorizationStatusAuthorized
 */

+ (__kindof instancetype)localVideoCreatRoomWithVideoPath:(NSString *)videoPath
                                      signalPath:(NSString *)signalPath
                                      definition:(PMVideoDefinitionType)definition
                                           isZip:(BOOL)isZip
                                          status:(void (^)(BJPMediaLibraryAuthorizationStatus status))handle BJP_Will_DEPRECATED("+localVideoCreatRoomWithVideoPath:signalPath:definition:isZip:");;
+ (__kindof instancetype)localVideoCreatRoomWithVideoPath:(NSString *)videoPath
                                               signalPath:(NSString *)signalPath
                                               definition:(PMVideoDefinitionType)definition
                                                    isZip:(BOOL)isZip;
/** 退出教室 */
- (void)exit;

@end

NS_ASSUME_NONNULL_END
