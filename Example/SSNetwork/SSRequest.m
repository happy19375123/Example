//
//  SSRequest.m
//  Example
//
//  Created by Sseakom on 2018/5/9.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import "SSRequest.h"

@interface SSRequest(){
    NSString * _requestUrl;
}

@end

@implementation SSRequest

#pragma mark - Request
- (void)startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success
                                    failure:(YTKRequestCompletionBlock)failure {
    [super startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if(success){
            success(request);
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if(failure){
            failure(request);
        }
    }];
}

#pragma mark -
/// 请求成功的回调
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    if(_requestCompleteFilterBlock){
        _requestCompleteFilterBlock();
    }
}

/// 请求失败的回调
- (void)requestFailedFilter{
    [super requestFailedFilter];
    if(_requestFailedFilterBlock){
        _requestFailedFilterBlock();
    }
}

/// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument{
    if(_cacheFileNameFilterBlock){
        return _cacheFileNameFilterBlock;
    }else{
        return argument;
    }
}

-(void)setRequestUrl:(NSString *)requestUrl{
    _requestUrl=[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/// for subclasses to overwrite

- (NSString *)requestUrl {
    if(_requestUrl){
        return _requestUrl;
    }else{
        return @"";
    }
}

- (NSString *)cdnUrl {
    if(_cdnUrl){
        return _cdnUrl;
    }else{
        return @"";
    }
}

- (NSString *)baseUrl {
    if(_baseUrl){
        return _baseUrl;
    }else{
        return @"";
    }
}

- (NSTimeInterval)requestTimeoutInterval {
    if(_requestTimeoutInterval){
        return _requestTimeoutInterval;
    }else{
        return 20;
    }
}

- (id)requestArgument {
    if(_requestArgument){
        return _requestArgument;
    }else{
        return nil;
    }
}

- (YTKRequestMethod)requestMethod {
    if(_requestMethod){
        return _requestMethod;
    }else{
        return YTKRequestMethodGET;
    }
}

- (YTKRequestSerializerType)requestSerializerType {
    if(_requestSerializerType){
        return _requestSerializerType;
    }else{
        return YTKRequestSerializerTypeJSON;
    }
}

-(YTKResponseSerializerType)responseSerializerType{
    if(_responseSerializerType){
        return _responseSerializerType;
    }else{
        return YTKResponseSerializerTypeJSON;
    }

}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    if(_requestAuthorizationHeaderFieldArray){
        return _requestAuthorizationHeaderFieldArray;
    }else{
        return nil;
    }
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    if(_requestHeaderFieldValueDictionary){
        return _requestHeaderFieldValueDictionary;
    }else{
        return nil;
    }
}

- (NSURLRequest *)buildCustomUrlRequest {
    if(_buildCustomUrlRequest){
        return _buildCustomUrlRequest;
    }else{
        return nil;
    }
}

- (id)jsonValidator {
    if(_jsonValidator){
        return _jsonValidator;
    }else{
        return nil;
    }
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <= 299) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)cacheTimeInSeconds{
    if(_cacheTimeInSecond){
        return _cacheTimeInSecond;
    }else{
        return [super cacheTimeInSeconds];
    }
}

- (long long)cacheVersion{
    if(_cacheVersion){
        return _cacheVersion;
    }else{
        return [super cacheVersion];
    }
}

- (id)cacheSensitiveData{
    if(_cacheSensitiveData){
        return _cacheSensitiveData;
    }else{
        return [super cacheSensitiveData];
    }
}

@end
