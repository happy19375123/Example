//
//  PMDownloadTool.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/6/6.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMDownloadModel.h"
#import "BJPlayerManager.h"

NS_ASSUME_NONNULL_BEGIN

@class PMDownloader;

@protocol PMRequestDelegate <NSObject>

@optional

- (void)requestStartDownload:(PMDownloader *)downloader;
- (void)requestUpdateProgress:(PMDownloader *)downloader;
- (void)requestFinishedDownload:(PMDownloader *)downloader;

/**
 第一次加入下载之后,如果发生了下载前的错误是需要检查一下是否需要被删除的
 */
- (void)requestFailBeforeDowndownError:(nullable PMBeforeDownloadModel *)beforeDownload
                      downloadingError:(nullable PMDownloader *)downloader
                      shouldCheckDelete:(BOOL)shouldCheckDelete;

@end

/**
 临时文件存在: rootPath/PMDwnload/Temp
 下载完成的文件存在: rootPath/PMDwnload/Cache
 */
extern NSString *const PMDownloadTemp;  //@"PMDownload/Temp"
extern NSString *const PMDownloadCache; //@"PMDownload/Cache"
extern NSString *const PMDownloadFinshPlist; //@"PMDownload/finishedPlist.plist"

@interface PMDownloader : NSObject

@property (nonatomic, weak) id<PMRequestDelegate> requestDelegate;

@property (nonatomic) PMDownloadModel *downloadModel;

- (instancetype)initWithModel:(nullable PMDownloadModel *)model;

/**
 添加点播下载任务

 @param vid vid
 @param token token
 @param definionArray 清晰度数组, 优先取传入数组中前面的清晰度下载, 必传
 @param showFileName  仅展示用
 @param rootPath rootPath
 @param autoDownload 是否自动开始下载
 */
- (void)addDownloadWithVid:(NSString *)vid
                     token:(NSString *)token
             definionArray:(NSArray<NSNumber *> *)definionArray
              showFileName:(nullable NSString *)showFileName
                  rootPath:(NSString *)rootPath
              autoDownload:(BOOL)autoDownload;

/**
 添加回放下载的任务

 @param classId classid
 @param sessionId sessionId 可以为空
 @param token token
 @param definionArray 清晰度数组, 优先取传入数组中前面的清晰度下载, 必传
 @param showFileName  仅展示用
 @param creatTime      创建时间
 @param rootPath rootPath
 @param autoDownload 是否自动开始下载
 */
- (void)addDownloadWithClass:(NSString *)classId
                   seesionID:(nullable NSString *)sessionId
                       token:(NSString *)token
               definionArray:(NSArray <NSNumber *> *)definionArray
                showFileName:(nullable NSString *)showFileName
                   creatTime:(nullable NSString*)creatTime
                    rootPath:(NSString *)rootPath
                autoDownload:(BOOL)autoDownload;;

- (void)resetDownloadWithToken:(NSString *)token;

#pragma mark - action

/** 暂停 */
- (void)pause;

/** 继续 */
- (void)resume;

/** 取消任务, 并删除该资源 */
- (void)cancelTask;


@end

NS_ASSUME_NONNULL_END
