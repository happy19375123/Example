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
- (void)downloadFail:(nullable PMDownloader *)downloader beforeDownloadError:(nullable NSError *)error;

@end

@interface PMDownloadManager : NSObject

/**
 初始化设置根路径

 @param rootPath rootPath description
 @return return value description
 */
- (instancetype)initWithRootPath:(NSString *)rootPath;

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
             definionArray:(NSArray <NSNumber *>*)definionArray showFileName:(nullable NSString *)showFileName;

/**
 添加回放下载的任务
 
 @param classId classid
 @param sessionId sessionId 可以为空
 @param token token
 @param definionArray 清晰度数组, 优先取传入数组中前面的清晰度下载, 必传
 @param showFileName  仅展示用
 */
- (void)addDownloadWithClass:(NSString *)classId seesionID:(nullable NSString *)sessionId token:(NSString *)token
               definionArray:(NSArray <NSNumber *>*)definionArray showFileName:(nullable NSString *)showFileName;

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

///** 删除文件 */
//- (BOOL)deleteFile:(NSString *)vid;
//- (BOOL)deleteFile:(NSString *)classId sessionId:(nullable NSString *)sessionId;

@end

NS_ASSUME_NONNULL_END
