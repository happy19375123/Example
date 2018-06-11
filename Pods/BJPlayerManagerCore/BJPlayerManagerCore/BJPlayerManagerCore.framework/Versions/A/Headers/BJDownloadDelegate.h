//
//  BJDownloadDelegate.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/9/19.
//
//

#import <Foundation/Foundation.h>
#import "BJHttpRequest.h"
#import "BJFileModel.h"

@protocol BJDownloadDelegate <NSObject>

@optional
- (void)startDownload:(BJHttpRequest *)request;
- (void)updateCellProgress:(BJHttpRequest *)request;
- (void)finishedDownload:(BJHttpRequest *)request;
- (void)allowNextRequest;//处理一个窗口内连续下载多个文件且重复下载的情况

/**
 成功获取下载资源的url, 添加到下载数组时的回调

 @param fileModel fileModel
 */
- (void)downloadDidAddFileModel:(BJFileModel *)fileModel;
/**
 错误返回

 @param beforeDownload 开始下载之前发生的错误model
 @param request 下载中发生的错误
 */
- (void)requestFailBeforeDowndownError:(BJBeforeDownloadModel *)beforeDownload
                      downloadingError:(BJHttpRequest *)request;

@end
