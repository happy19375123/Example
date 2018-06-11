//
//  BJDownloadManager.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/9/19.
//
//

#import <Foundation/Foundation.h>
#import "BJCommonHelper.h"
#import "BJDownloadDelegate.h"
#import "BJFileModel.h"
#import "BJHttpRequest.h"
#import "PMVideoInfoModel.h"
#import "PMPlayerMacro.h"

#define kMaxRequestCount  @"kMaxRequestCount"

NS_ASSUME_NONNULL_BEGIN

@interface BJDownloadManager : NSObject <BJHttpRequestDelegate>

/** 获得下载事件的vc，用在比如多选图片后批量下载的情况，这时需配合 allowNextRequest 协议方法使用 */
@property (nonatomic, weak ) id<BJDownloadDelegate> VCdelegate PM_Will_DEPRECATED("");
/** 下载列表delegate */
@property (nonatomic, weak  ) id<BJDownloadDelegate> downloadDelegate;
/** 设置最大的并发下载个数 */
@property (nonatomic, assign) NSInteger              maxCount;
/** 已下载完成的文件列表（BJFileModel文件对象） */
@property (atomic, strong, readonly) NSMutableArray  *finishedlist;
/** 正在下载的文件列表(ASIHttpRequest对象) */
@property (atomic, strong, readonly) NSMutableArray  *downinglist;
/** 未下载完成的临时文件数组（文件对象) */
@property (atomic, strong, readonly) NSMutableArray  *filelist;
/** 下载文件的模型 */
@property (nonatomic, strong, readonly) BJFileModel  *fileInfo;

/** 创建单例 */
+ (BJDownloadManager *)sharedDownloadManager;

/** 释放单例, 可用于多账户下载管理 */
+(void)downloadManagerDealloc PM_Will_DEPRECATED("downloadManagerDestroy");
+(void)downloadManagerDestroy;

/**
 清除所有正在下载的请求

 @return 是否清除成功
 */
- (BOOL)clearAllRquests;

/**
 清除所有下载完的文件

 @return 是否成功
 */
- (BOOL)clearAllFinished;
/**
 * 恢复下载
 */
- (void)resumeRequest:(BJHttpRequest *)request;
/**
 * 删除这个下载请求
 */
- (void)deleteRequest:(BJHttpRequest *)request;
/**
 * 停止这个下载请求
 */
- (void)stopRequest:(BJHttpRequest *)request;
/**
 * 保存下载完成的文件信息到plist
 * @return 是否成功
 */
- (BOOL)saveFinishedFile;

/**
 删除某一个下载完成的文件
 
 @return 是否成功
 */
- (BOOL)deleteFinishFile:(BJFileModel *)selectFile;

/**
 点播视频下载
 
 此方法中的错误回调是一下代理中的beforeDownloadError,
 - (void)requestFailBeforeDowndownError:(NSError *)beforeDownloadError  downloadingError:(BJHttpRequest *)request;
 
 @param vid 视频ID
 @param token token
 @param definitionType 清晰度
 @param showFileName 仅仅用来展示, 外界自己设定
 */
- (void)downloadWithVid:(NSString *)vid
                  token:(NSString *)token
         definitionType:(PMVideoDefinitionType)definitionType
           showFileName:(NSString *)showFileName;

/**
 回放下载
 
 此方法中的错误回调是一下代理中的beforeDownloadError,
 - (void)requestFailBeforeDowndownError:(NSError *)beforeDownloadError  downloadingError:(BJHttpRequest *)request;
 
 @param classId classId
 @param sessionId sessionId 可以为空
 @param token token
 @param definitionType 清晰度
 @param showFileName 仅仅用来展示, 外界自己设定
 */
- (void)downloadWithClassId:(NSString *)classId
                  sessionId:(nullable NSString *)sessionId
                      token:(NSString *)token
             definitionType:(PMVideoDefinitionType)definitionType
               showFileName:(NSString *)showFileName;
/**
 * 开始任务
 */
- (void)startLoad;
/**
 * 全部开始（等于最大下载个数，超过的还是等待下载状态）
 * 建议使用resumeRequest, 因为下载的url可能会失效, startAllDownloads不会判断
 */
- (void)startAllDownloads PM_Will_DEPRECATED("-resumeRequest:");
/**
 * 全部暂停
 */
- (void)pauseAllDownloads;

/**
 当前下载的url失效后, 需要重新传当前视频的token
 
 url失效,需要拿到vid & token (回放:classId & token)重新获取下载的url, 因为token也可能会失效, 所以内部不保存token

 @param request request
 @param token 新的token
 @param downloadType 当前下载的类型, 点播下载:BJDownloadFileType_Video  回放下载:BJDownloadFileType_LivePlayback
 */
- (void)resetDownloadWithRequest:(BJHttpRequest *)request token:(NSString *)token downloadTyope:(BJDownloadFileType)downloadType;

@end

#pragma mark - Deprecated

@interface BJDownloadManager(Deprecated)

- (void)downloadWithVid:(NSString *)vid
                  token:(NSString *)token
         definitionType:(PMVideoDefinitionType)definitionType
           showFileName:(NSString *)showFileName
             completion:(void (^)(NSError  * _Nullable error))completion PM_Will_DEPRECATED("- downloadWithVid:token:definitionType:showFileName:");

- (void)downloadWithClassId:(NSString *)classId
                  sessionId:(nullable NSString *)sessionId
                      token:(NSString *)token
             definitionType:(PMVideoDefinitionType)definitionType
               showFileName:(NSString *)showFileName
                 completion:(void (^)(NSError  * _Nullable error))completion PM_Will_DEPRECATED("- downloadWithClassId:sessionId:token:definitionType:showFileName:");

- (void)downloadWithVid:(NSString *)vid
                  token:(NSString *)token
         definitionType:(PMVideoDefinitionType)definitionType
             completion:(void (^)(NSError  * _Nullable error))completion PM_Will_DEPRECATED("- downloadWithVid:token:definitionType:showFileName:");

- (void)downloadWithClassId:(NSString *)classId
                  sessionId:(nullable NSString *)sessionId
                      token:(NSString *)token
             definitionType:(PMVideoDefinitionType)definitionType
                 completion:(void (^)(NSError  * _Nullable error))completion PM_Will_DEPRECATED("- downloadWithClassId:sessionId:token:definitionType:showFileName:");

@end

NS_ASSUME_NONNULL_END

