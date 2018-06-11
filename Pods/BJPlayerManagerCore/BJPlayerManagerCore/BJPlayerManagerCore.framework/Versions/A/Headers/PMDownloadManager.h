//
//  PMDownloadManager.h
//  demo
//
//  Created by 辛亚鹏 on 2017/12/12.
//  Copyright © 2017年 辛亚鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PMDownloadDelegate <NSObject>

@optional

- (void)startDownload:(PMDownloader *)downloader;
- (void)updateProgress:(PMDownloader *)downloader;
- (void)finishedDownload:(PMDownloader *)downloader;


/**
 beforeDownloadModel包括:
 1. 非第一次下载, 需要检测之前获取的视频下载的url的有效性, 正式环境下,视频url的有效期为6个小时,
    note:回放下载中,下载信令的url一直有效
 2. (可选)检测url的时候, 外面可以通过检测beforeDownloadModel.urlCheckState == PMDownloadURLCheckState_Checking 时添加加loading,
         beforeDownloadModel.urlCheckState == PMDownloadURLCheckState_Complete 时移除loading
 3. 视频的url失效, 则beforeDownloadModel.error.code == BJPMErrorCodeDownloadInvalid (详见 NSError+BJPlayerError.h),
    此时需要调用 -resetDownloadWithDownloader:token, 传入新的token, 用以内部获取新的视频下载的url
 4. 如果下载任务已经存在 || 文件已经下载完成, 则beforeDownloadModel.error有值, 可以读取beforeDownloadModel.error.localizedDescription
 5. 调用调用点播/回放下载api时, 内部会先发送请求获取视频下载的url, 如果此时服务器返回了error(如外面传参vid/classid/token错误等),
    请读取beforeDownloadModel.error
 
 downloader:
 1. downloader是单个下载任务的实例, 具体错误请读取downloader.downloadModel.error
 2. downloader.downloadModel.error是下载过程中session或者服务器返回的错误
 */

/**
 下载时的错误回调, 包括开始下载之前和下载过程中的错误

 @param downloader 下载过程中的下载器实例, 可能为空
 @param beforeDownloadModel 下载开始前的错误model, 可能为空
 */
- (void)downloadFail:(nullable PMDownloader *)downloader beforeDownloadError:(nullable PMBeforeDownloadModel *)beforeDownloadModel;

@end

@interface PMDownloadManager : NSObject

//2种实例化的方式, 任选其一

/** 创建下载单例时调用 */
+ (PMDownloadManager *)downloadManagerWithRootPath:(NSString *)rootPath;

/** 使用下载单例的时候调用这个方法 */
+ (PMDownloadManager *)downloadManager;

/** 释放单例, 可用于多账户下载管理 */
+(void)downloadManagerDestory;

//代理
@property (nonatomic, weak) id<PMDownloadDelegate> delegate;

//下载过程中的文件夹 和 已经完成的文件夹
@property (nonatomic, readonly) NSMutableArray <PMDownloader *> *downloadingList;
@property (nonatomic, readonly) NSMutableArray <PMDownloadModel *> *finishedList;


/**
 添加点播下载任务
 
 @param vid vid
 @param token token
 @param definionArray 清晰度数组, 优先取传入数组中前面的清晰度下载, 必传
 @param showFileName  仅展示用
 */
- (void)addDownloadWithVid:(NSString *)vid token:(NSString *)token
             definionArray:(NSArray <NSNumber *>*)definionArray
              showFileName:(nullable NSString *)showFileName;

/**
 添加回放下载的任务
 
 @param classId classid
 @param sessionId sessionId 可以为空
 @param token token
 @param definionArray 清晰度数组, 优先取传入数组中前面的清晰度下载, 必传
 @param showFileName  仅展示用
 @param creatTime  creatTime, 可以为空
 */
- (void)addDownloadWithClass:(NSString *)classId seesionID:(nullable NSString *)sessionId token:(NSString *)token
               definionArray:(NSArray <NSNumber *>*)definionArray showFileName:(nullable NSString *)showFileName creatTime:(nullable NSString *)creatTime;

/**
  下载中的任务发生了下载的url失效的错误,需要调用此方法,内部重新请求下载地址

 @param downloader 下载的任务
 @param token 新的token
 */
- (void)resetDownloadWithDownloader:(PMDownloader *)downloader token:(NSString *)token;

/** 暂停点播 */
- (void)pause:(NSString *)vid;
/** 暂停回放 */
- (void)pause:(NSString *)classId sessionId:(nullable NSString *)sessionId;

/** 继续 */
- (void)resume:(NSString *)vid;
/** 继续回放 */
- (void)resume:(NSString *)classId sessionId:(nullable NSString *)sessionId;

/** 删除点播任务 */
- (void)cancelTask:(NSString *)vid;
//删除回放
- (void)cancelTask:(NSString *)classId sessionId:(nullable NSString *)sessionId;

/** 点播:是否已经下载 */
- (BOOL)isHaveDownloaded:(NSString *)vid;
/** 点播: 是否正在下载 */
- (BOOL)isDownloading:(NSString *)vid;

/** 回放:是否已经下载 */
- (BOOL)isHaveDownloaded:(NSString *)classId sessionId:(nullable NSString *)sessionId;
/** 回放:是否正在下载 */
- (BOOL)isDownloading:(NSString *)classId sessionId:(nullable NSString *)sessionId ;

/** 删除文件 */
- (BOOL)deleteFile:(NSString *)vid;
- (BOOL)deleteFile:(NSString *)classId sessionId:(nullable NSString *)sessionId;

@end

NS_ASSUME_NONNULL_END
