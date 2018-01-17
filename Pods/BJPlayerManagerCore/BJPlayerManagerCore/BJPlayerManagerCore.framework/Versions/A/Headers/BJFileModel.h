//
//  BJFileModel.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/9/19.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMVideoInfoModel.h"

typedef NS_ENUM(NSInteger,BJDownLoadState) {
    BJDownloading,      //下载中
    BJWillDownload,     //等待下载
    BJStopDownload      //停止下载
};

typedef NS_ENUM(NSInteger, BJDownloadFileType){
    BJDownloadFileType_Video       = 1,        //点播视频
    BJDownloadFileType_Text        = 1 << 1,   //回放信令文件
    BJDownloadFileType_LiveVideo   = 1 << 2 ,  //回放视频文件
    BJDownloadFileType_LivePlayback   = (BJDownloadFileType_Text | BJDownloadFileType_LiveVideo), //回放的视频和信令文件
};

typedef NS_ENUM(NSInteger, BJDownloadURLCheckState){
    BJDownloadURLCheckState_Checking       = 1,        //正在检测下载的url是否有效
    BJDownloadURLCheckState_Complete       = 1 << 1,   //检测结束或者不需要检测
};

@interface BJFileModel : NSObject

/** 展示用的的文件名 */
@property (nonatomic, copy) NSString        *showFileName;
/** 内部下载用的文件名 */
@property (nonatomic, copy) NSString        *fileName;
/** 文件的总长度 */
@property (nonatomic, copy) NSString        *fileSize;
/** 文件的类型(文件后缀,比如:mp4)*/
@property (nonatomic, copy) NSString        *fileType;
/** 是否是第一次接受数据，如果是则不累加第一次返回的数据长度，之后变累加 */
@property (nonatomic, assign) BOOL          isFirstReceived;
/** 文件已下载的长度 */
@property (nonatomic, copy) NSString        *fileReceivedSize;
/** 接受的数据 */
@property (nonatomic, strong) NSMutableData *fileReceivedData;
/** 下载文件的URL */
@property (nonatomic, copy) NSString        *fileURL;
/** 下载时间 */
@property (nonatomic, copy) NSString        *time;
/** 临时文件路径 */
@property (nonatomic, copy) NSString        *tempPath;
/** 文件下载后的路径 */
@property (nonatomic, copy) NSString        *filePath;
/** 下载速度 */
@property (nonatomic, copy) NSString        *speed;
/** 开始下载的时间 */
@property (nonatomic, strong) NSDate        *startTime;
/** 剩余下载时间 */
@property (nonatomic, copy) NSString        *remainingTime;
/** 点播视频Id */
@property (nonatomic, copy) NSString        *vid;
/** 回放classId */
@property (nonatomic, copy) NSString        *classId;
/** 回放sessionId */
@property (nonatomic, copy) NSString        *sessionId;
/** token token会失效, 所以这个参数没啥用 */
@property (nonatomic, copy) NSString        *token;
/** token */
@property (nonatomic, assign) PMVideoDefinitionType   definionType;
/** 下载的文件类型 */
@property (nonatomic, assign) BJDownloadFileType  downloadFileType;
/** 获取下载地址url的时间戳 */
@property (nonatomic) long long urlTimestamp;

/*下载状态的逻辑是这样的：三种状态，下载中，等待下载，停止下载
 *当超过最大下载数时，继续添加的下载会进入等待状态，当同时下载数少于最大限制时会自动开始下载等待状态的任务。
 *可以主动切换下载状态
 *所有任务以添加时间排序。
 */
@property (nonatomic, assign) BJDownLoadState downloadState;
/** 是否下载出错 */
@property (nonatomic, assign) BOOL            error;
/** md5 */
@property (nonatomic, copy) NSString          *MD5;
/** 文件的附属图片 */
//@property (nonatomic,strong) UIImage          *fileimage;

@end


/**
 用于在播放之前错误提示
 */
@interface BJBeforeDownloadModel : NSObject

/** 点播视频Id */
@property (nonatomic, copy, readonly) NSString              *vid;
/** 回放classId */
@property (nonatomic, copy, readonly) NSString              *classId;
/** error */
@property (strong, nonatomic, readonly) NSError              *error;
/** 下载的文件类型 */
@property (nonatomic, assign, readonly) BJDownloadFileType  downloadFileType;
/** 下载的url的检测状态 */
@property (nonatomic, assign, readonly) BJDownloadURLCheckState  urlCheckState;


+ (instancetype)beforeDownloadModelWithVid:(NSString *)vid classId:(NSString *)classId error:(NSError *)error downloadFileType:(BJDownloadFileType)fileType;
- (void)setUrlCheckState:(BJDownloadURLCheckState)urlCheckState;

@end

