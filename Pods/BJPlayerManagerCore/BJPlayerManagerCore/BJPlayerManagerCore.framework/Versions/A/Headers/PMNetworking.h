//
//  PMNetworking.h
//  VideoPlayerApp
//
//  Created by MingLQ on 2016-08-20.
//  Copyright © 2016年 GSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BJLiveBase/BJLAFNetworking.h>
//#import <AFNetworking/AFNetworking.h>

@class PMResponse;

#define PMNetworking    [BJLAFHTTPSessionManager pm_manager]

#pragma mark -

@interface BJLAFHTTPSessionManager (PMNetworkingExt)

+ (BJLAFHTTPSessionManager *)pm_manager;
/*
 - (NSURLSessionDataTask *)pm_GET:(NSString *)urlString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(NSURLSessionDataTask *task, PMResponse *response))success
                          failure:(void (^)(NSURLSessionDataTask *task, PMResponse *response))failure;
 */

- (NSURLSessionDataTask *)pm_POST:(NSString *)urlString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(NSURLSessionDataTask *task, PMResponse *response))success
                          failure:(void (^)(NSURLSessionDataTask *task, PMResponse *response))failure;

- (NSURLSessionDataTask *)pm_POST:(NSString *)urlString
                       parameters:(id)parameters
                         progress:(void (^)(NSProgress *uploadProgress))progress
        constructingBodyWithBlock:(void (^)(id<BJLAFMultipartFormData> formData))constructingBodyBlock
                          success:(void (^)(NSURLSessionDataTask *task, PMResponse *response))success
                          failure:(void (^)(NSURLSessionDataTask *task, PMResponse *response))failure;

- (NSURLSessionDownloadTask *)pm_download:(NSString *)urlString
                               parameters:(NSDictionary *)parameters
                                 progress:(void (^)(NSProgress *uploadProgress))progress
                              destination:(NSURL *(^)(NSURL *targetPath, NSURLResponse *response))destination
                                  success:(void (^)(NSURLSessionDownloadTask *task, PMResponse *response))success
                                  failure:(void (^)(NSURLSessionDownloadTask *task, PMResponse *response))failure;

@end

#pragma mark -

typedef NS_ENUM(NSInteger, PMResponseCode) {
    PMResponseCodeSuccess = 0,
    PMResponseCodeFailure = 1,
    PMResponseCodeLoginConflict = 900006,
    PMResponseCodeLoginNeedRelogin = 2019000001
};

@interface PMResponse : NSObject

+ (instancetype)responseWithObject:(id)responseObject;
+ (instancetype)successResponseWithData:(NSDictionary *)data;
+ (instancetype)failureResponseWithMessage:(NSString *)message;

@property (nonatomic, readonly) PMResponseCode code;
@property (nonatomic, readonly) BOOL isSuccess;

@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSTimeInterval timestamp;
@property (nonatomic, readonly) NSDictionary *data;
@property (nonatomic, readonly) NSArray *dataArray;

@end

@interface PMMutableResponse : PMResponse

@property (nonatomic, readwrite) PMResponseCode code;
@property (nonatomic, readwrite) NSString *message;
@property (nonatomic, readwrite) NSTimeInterval timestamp;
@property (nonatomic, readwrite) NSDictionary *data;
@property (nonatomic, readwrite) NSArray *dataArray;

@end
