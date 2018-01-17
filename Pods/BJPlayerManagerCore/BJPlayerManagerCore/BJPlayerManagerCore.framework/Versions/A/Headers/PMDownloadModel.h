//
//  PMDownloadModel.h
//  demo
//
//  Created by 辛亚鹏 on 2017/12/11.
//  Copyright © 2017年 辛亚鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PMDownloadState) {
    PMDownloadState_Start = 0,     /** 下载中 */
    PMDownloadState_Suspended,     /** 下载暂停 */
    PMDownloadState_Cancel,        /** 下载取消 */
    PMDownloadState_Completed,     /** 下载完成 */
    PMDownloadState_Failed         /** 下载失败 */
};

typedef NS_ENUM(NSInteger, PMDownloadFileType) {
    PMDownloadFileType_Unknown   = 0,
    PMDownloadFileType_Video     = 1, //点播下载
    PMDownloadFileType_Playback  = 2, //回放下载
};

@interface PMDownloadModel : NSObject

@property (nonatomic, nullable) NSString *vid, *classId, *sessionId;

/**
 拼接classid和sessionId, 如:classId = "123", sessionId = "456", 则classIdSessionId = "123456"
 */
@property (nonatomic, nullable) NSString *classIdSessionId;


/** 仅展示用 */
@property (nonatomic, nullable) NSString *showFileName;
@property (nonatomic, nullable) NSString *videoFileName, *signalFileName;

/**
 下载完成的视频文件 和 信令文件的地址
 
 rootPath/PMDownload/xxx
 */
@property (nonatomic, nullable) NSString *videoPath, *signalPath;
@property (nonatomic, nullable) NSString *rootPath;
@property (nonatomic, nullable) NSString *videoTempPath, *signalTempPath;

/** 进度 */
@property (nonatomic) float progress;

/** 状态 */
@property (nonatomic) PMDownloadState state;
@property (nonatomic) PMDownloadFileType downloadFileType;
@property (nonatomic) NSString *token;
@property (nonatomic) NSArray *definitioArray;

/**
 总长度
 
 下载点播:此参数为视频的长度;
 下载回放:此参数为视频的长度 + 信令文件的长度
 */
@property (nonatomic) int64_t totalLength;
@property (nonatomic) int64_t signalTotalSize; //单纯信令文件的大小

/**
 已经接受的长度
 
 下载点播:此参数为视频的长度;
 下载回放:此参数为视频的长度 + 信令文件的长度
 */
@property (nonatomic) int64_t receivedSize;

/**
 视频的url地址
 
 超过一定时限, 会过期
 */
@property (nonatomic, nullable) NSString *videoUrl;

/** 回放信令的url */
@property (nonatomic, nullable) NSString *signalUrl;

/** 获取下载地址url的时间戳 */
@property (nonatomic) long long urlTimestamp;

/** error */
@property (strong, nonatomic) NSError   *error;

@end

/**
 用于在播放之前错误提示
 */
@interface PMBeforeDownloadModel : NSObject

/** 点播视频Id */
@property (nonatomic, copy, readonly) NSString              *vid;
/** 回放classId */
@property (nonatomic, copy, readonly) NSString              *classId;
/** error */
@property (strong, nonatomic, readonly) NSError              *error;
/** 下载的文件类型 */
//@property (nonatomic, assign, readonly) BJDownloadFileType  downloadFileType;
/** 下载的url的检测状态 */
//@property (nonatomic, assign, readonly) BJDownloadURLCheckState  urlCheckState;


+ (instancetype)beforeDownloadModelWithVid:(NSString *)vid classId:(NSString *)classId error:(NSError *)error downloadFileType:(PMDownloadFileType)fileType;
- (void)setUrlCheckState:(PMDownloadFileType)urlCheckState;

@end

NS_ASSUME_NONNULL_END
