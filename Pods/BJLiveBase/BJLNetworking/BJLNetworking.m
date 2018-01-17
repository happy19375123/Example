//
//  BJLNetworking.m
//  M9Dev
//
//  Created by MingLQ on 2016-08-20.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <objc/runtime.h>

#import "BJLNetworking.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const GET = @"GET", * const POST = @"POST";

@implementation BJLAFHTTPSessionManager (BJLNetworkingExt)

+ (instancetype)bjl_manager {
    return [self bjl_managerWithBaseURL:nil];
}

+ (instancetype)bjl_managerWithBaseURL:(nullable NSURL *)url {
    return [self bjl_managerWithBaseURL:url sessionConfiguration:nil];
}

+ (instancetype)bjl_managerWithBaseURL:(nullable NSURL *)url
                  sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration {
    configuration = configuration ?: [NSURLSessionConfiguration defaultSessionConfiguration];
    BJLAFHTTPSessionManager *manager = (url
                                     ? [[self alloc] initWithBaseURL:url
                                                sessionConfiguration:configuration]
                                     : [[self alloc] initWithSessionConfiguration:configuration]);
    // NOTE: Strong TLS is not enough, Certificate ensures that you’re talking to the right server
    /* ATS security policy
    manager.securityPolicy = ({
        AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy]; // AFSSLPinningModeNone
        policy.allowInvalidCertificates = NO; // MUST be NO
        policy.validatesDomainName = YES;
        policy;
    }); */
    return manager;
}

+ (instancetype)bjl_defaultManager {
    static BJLAFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self bjl_manager];
    });
    return manager;
}

#pragma mark -

@dynamic parametersHandler, requestHandler, responseHandler;

static void *BJLNetworking_parametersHandler = &BJLNetworking_parametersHandler;
static void *BJLNetworking_requestHandler = &BJLNetworking_requestHandler;
static void *BJLNetworking_responseHandler = &BJLNetworking_responseHandler;

- (NSDictionary * _Nullable (^ _Nullable)(NSString *urlString, NSDictionary * _Nullable parameters))parametersHandler {
    return objc_getAssociatedObject(self, BJLNetworking_parametersHandler);;
}

- (void)setParametersHandler:(NSDictionary * _Nullable (^ _Nullable)(NSString *urlString, NSDictionary * _Nullable parameters))parametersHandler {
    objc_setAssociatedObject(self, BJLNetworking_parametersHandler, parametersHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSURLRequest * _Nullable (^ _Nullable)(NSString *urlString, NSMutableURLRequest * _Nullable request, NSError * _Nullable __autoreleasing *error))requestHandler {
    return objc_getAssociatedObject(self, BJLNetworking_requestHandler);;
}

- (void)setRequestHandler:(NSURLRequest * _Nullable (^ _Nullable)(NSString *urlString, NSMutableURLRequest * _Nullable request, NSError * _Nullable __autoreleasing *error))requestHandler {
    objc_setAssociatedObject(self, BJLNetworking_requestHandler, requestHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (__kindof NSObject<BJLResponse> * _Nullable (^ _Nullable)(id _Nullable responseObject, NSError * _Nullable error))responseHandler {
    return objc_getAssociatedObject(self, BJLNetworking_responseHandler);;
}

- (void)setResponseHandler:(__kindof NSObject<BJLResponse> * _Nullable (^ _Nullable)(id _Nullable responseObject, NSError * _Nullable error))responseHandler {
    objc_setAssociatedObject(self, BJLNetworking_responseHandler, responseHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark -

- (NSURLSessionDataTask *)bjl_GET:(NSString *)urlString
                       parameters:(nullable NSDictionary *)parameters
                          success:(nullable void (^)(NSURLSessionDataTask *task, __kindof NSObject<BJLResponse> *response))success
                          failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, __kindof NSObject<BJLResponse> *response))failure {
    return [self bjl_requestWithMethod:GET urlString:urlString parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)bjl_POST:(NSString *)urlString
                        parameters:(nullable NSDictionary *)parameters
                           success:(nullable void (^)(NSURLSessionDataTask *task, __kindof NSObject<BJLResponse> *response))success
                           failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, __kindof NSObject<BJLResponse> *response))failure {
    return [self bjl_requestWithMethod:POST urlString:urlString parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)bjl_requestWithMethod:(NSString *)method
                                      urlString:(NSString *)urlString
                                     parameters:(nullable NSDictionary *)parameters
                                        success:(nullable void (^)(NSURLSessionDataTask *task, __kindof NSObject<BJLResponse> *response))success
                                        failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, __kindof NSObject<BJLResponse> *response))failure {
    return [self bjl_makeRequest:^NSMutableURLRequest *(NSString *absoluteURLString, NSDictionary * _Nullable parameters, NSError * _Nullable __autoreleasing *serializationError) {
        return [self.requestSerializer requestWithMethod:method URLString:absoluteURLString parameters:parameters error:serializationError];
    } makeTask:^__kindof NSURLSessionTask *(NSURLRequest *request, void (^ _Nullable completionHandler)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error)) {
        return [self dataTaskWithRequest:request completionHandler:completionHandler];
    } urlString:urlString parameters:parameters success:success failure:failure];
}

- (NSURLSessionUploadTask *)bjl_upload:(NSString *)urlString
                            parameters:(nullable NSDictionary *)parameters
                          constructing:(nullable BOOL (^)(id <BJLAFMultipartFormData> formData, NSError * _Nullable __autoreleasing *error))constructing
                              progress:(nullable void (^)(NSProgress *uploadProgress))progress
                               success:(nullable void (^)(NSURLSessionUploadTask *task, __kindof NSObject<BJLResponse> *response))success
                               failure:(nullable void (^)(NSURLSessionUploadTask * _Nullable task, __kindof NSObject<BJLResponse> *response))failure {
    return [self bjl_makeRequest:^NSMutableURLRequest *(NSString *absoluteURLString, NSDictionary * _Nullable parameters, NSError * _Nullable __autoreleasing *serializationError) {
        __block BOOL constructed = !constructing;
        __block NSError *constructError = nil;
        NSMutableURLRequest *request = [self.requestSerializer
                                        multipartFormRequestWithMethod:POST
                                        URLString:absoluteURLString
                                        parameters:parameters
                                        constructingBodyWithBlock:constructing ? ^(id<BJLAFMultipartFormData> formData) {
                                            constructed = constructing(formData, &constructError);
                                        } : nil
                                        error:serializationError];
        if (request && !constructed) {
            if (serializationError) *serializationError = constructError;
        }
        return constructed ? request : nil;
    } makeTask:^__kindof NSURLSessionTask *(NSURLRequest *request, void (^ _Nullable completionHandler)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error)) {
        return [self uploadTaskWithStreamedRequest:request progress:progress completionHandler:completionHandler];
    } urlString:urlString parameters:parameters success:success failure:failure];
}

- (NSURLSessionDownloadTask *)bjl_download:(NSString *)urlString
                                parameters:(nullable NSDictionary *)parameters
                                  progress:(nullable void (^)(NSProgress *downloadProgress))progress
                               destination:(nullable NSURL *(^)(NSURL *targetPath, NSURLResponse *response))destination
                                   success:(nullable void (^)(NSURLSessionDownloadTask *task, __kindof NSObject<BJLResponse> *response))success
                                   failure:(nullable void (^)(NSURLSessionDownloadTask * _Nullable task, __kindof NSObject<BJLResponse> *response))failure {
    return [self bjl_makeRequest:^NSMutableURLRequest *(NSString *absoluteURLString, NSDictionary * _Nullable parameters, NSError * _Nullable __autoreleasing *serializationError) {
        return [self.requestSerializer requestWithMethod:GET URLString:absoluteURLString parameters:parameters error:serializationError];
    } makeTask:^__kindof NSURLSessionTask *(NSURLRequest *request, void (^ _Nullable completionHandler)(NSURLResponse *response, NSURL * _Nullable fileURL, NSError * _Nullable error)) {
        return [self downloadTaskWithRequest:request progress:progress destination:destination completionHandler:completionHandler];
    } urlString:urlString parameters:parameters success:success failure:failure];
}

- (__kindof NSURLSessionTask *)bjl_makeRequest:(NSMutableURLRequest *(^)(NSString *absoluteURLString, NSDictionary * _Nullable parameters, NSError * _Nullable __autoreleasing *serializationError))makeRequest
                                      makeTask:(__kindof NSURLSessionTask *(^)(NSURLRequest *request, void (^ _Nullable completionHandler)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error)))makeTask
                                     urlString:(NSString *)urlString
                                    parameters:(nullable NSDictionary *)parameters
                                       success:(nullable void (^)(__kindof NSURLSessionTask *task, __kindof NSObject<BJLResponse> *response))success
                                       failure:(nullable void (^)(__kindof NSURLSessionTask * _Nullable task, __kindof NSObject<BJLResponse> *response))failure {
    
    // parameters
    NSDictionary * _Nullable (^parametersHandler)(NSString *urlString, NSDictionary * _Nullable parameters) = self.parametersHandler;
    parameters = (parametersHandler ? parametersHandler(urlString, parameters) : parameters);
    
    // url: base url
    NSString *absoluteURLString = [[NSURL URLWithString:urlString relativeToURL:self.baseURL] absoluteString];
    
    // request: serializationError to BJLResponse
    NSError *serializationError = nil;
    NSURLRequest *request = ({
        NSMutableURLRequest *mutableRequest = makeRequest(absoluteURLString, parameters, &serializationError);
        NSURLRequest * _Nullable (^requestHandler)(NSString *urlString, NSMutableURLRequest * _Nullable request, NSError * _Nullable __autoreleasing *error) = self.requestHandler;
        (requestHandler && mutableRequest && !serializationError
         ? requestHandler(urlString, mutableRequest, &serializationError) : mutableRequest);
    });
    if (!request || serializationError) {
        // serializationError to BJLResponse
        if (failure) dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
            __kindof NSObject<BJLResponse> *response = (self.responseHandler ? self.responseHandler(nil, serializationError)
                                                        : [BJLResponse responseWithError:serializationError]);
            failure(nil, response);
        });
        return nil;
    }
    
    // task: response or error to BJLResponse, and call success or failure with task
    typeof(self) __weak __weak_self__ = self;
    // !!!: task does not retain completionHandler
    __block __kindof NSURLSessionTask *task = makeTask(request, ^(NSURLResponse * __unused urlResponse, id _Nullable responseObject, NSError * _Nullable error) {
        typeof(__weak_self__) __strong self = __weak_self__;
        // canceling & cancelled
        if (task.state == NSURLSessionTaskStateCanceling
            || error.code == NSURLErrorCancelled) {
            return;
        }
        // success & failure
        __kindof NSObject<BJLResponse> *response = (self.responseHandler
                                                    ? self.responseHandler(responseObject, error)
                                                    : (error
                                                       ? [BJLResponse responseWithError:error]
                                                       : [BJLResponse responseWithObject:responseObject]));
        if (response && response.isCancelled) {
            return;
        }
        if (response.isSuccess) {
            if (success) dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                success(task, response);
            });
        }
        else {
            if (failure) dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(task, response);
            });
        }
    });
    
    // fire
    [task resume];
    
    return task;
}

@end

#pragma mark -

@interface BJLResponse ()

@property (nonatomic, readwrite, setter=setSuccess:) BOOL isSuccess;
@property (nonatomic, readwrite, setter=setCancelled:) BOOL isCancelled;
@property (nonatomic, readwrite) id responseObject;
@property (nonatomic, readwrite, nullable) NSError *error;

@end

@implementation BJLResponse

+ (instancetype)responseWithObject:(nullable id)responseObject {
    BJLResponse *response = [BJLResponse new];
    response.isSuccess = YES;
    response.responseObject = responseObject;
    return response;
}

+ (instancetype)responseWithError:(nullable NSError *)error {
    BJLResponse *response = [BJLResponse new];
    response.isSuccess = NO;
    response.error = error;
    return response;
}

+ (instancetype)cancelledResponse {
    BJLResponse *response = [BJLResponse new];
    response.isSuccess = NO;
    response.isCancelled = YES;
    response.error = [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:NSUserCancelledError
                                     userInfo:nil];
    return response;
}

@end

NS_ASSUME_NONNULL_END
