//
//  NSError+BJPlayerError.h
//  Pods
//
//  Created by DLM on 2017/2/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BJPMErrorCode) {
    BJPMErrorCodeLoading           = 1000,    //加载中
    BJPMErrorCodeLoadingEnd        = 1001,    //加载完成
    BJPMErrorCodeParse             = 1002,    //视频解析错误
    BJPMErrorCodeNetwork           = 1003,    //网络错误, 没有网络或是未知网络
    BJPMErrorCodeWWAN              = 1004,    //非WIFI环境，这时要暂停，并提示
    BJPMErrorCodeWIFI              = 1005,    //wifi
    BJPMErrorCodeServer            = 1006,    //server端返回的错误
    BJPMErrorCodeApp               = 1007,    //app端的错误
    BJPMErrorCodeDownloadInvalid   = 1010,    //下载的url失效
};

#define BJPMErrorDomain  @"BJPMErrorDomain"

@interface NSError (BJPlayerError)

+ (NSError *)errorWithErrorCode:(BJPMErrorCode)code;

+ (NSError *)errorWithErrorCode:(BJPMErrorCode)code message:(NSString *)msg;

+ (NSError *)errorWithErrorCode:(BJPMErrorCode)code andError:(NSError *)error;

@end
