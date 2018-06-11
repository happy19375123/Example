//
//  SSRequest.h
//  Example
//
//  Created by Sseakom on 2018/5/9.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSRequest : YTKRequest

typedef void(^RequestCompleteFilterBlock)(void);
typedef void(^RequestFailedFilterBlock)(void);
typedef void(^CacheFileNameFilterForRequestArgumentBlock)(id _Nullable argument);

@property (nonatomic,strong,readwrite,nullable)NSDictionary * ZTKErrorDic;

@property(nonatomic,assign,nullable) RequestCompleteFilterBlock requestCompleteFilterBlock;
@property(nonatomic,assign,nullable) RequestFailedFilterBlock requestFailedFilterBlock;
@property(nonatomic,copy) NSString *requestUrl;
@property(nonatomic,copy) NSString *cdnUrl;
@property(nonatomic,copy) NSString *baseUrl;
@property(nonatomic,assign) NSTimeInterval requestTimeoutInterval;
@property(nonatomic,strong,nullable) id requestArgument;
@property(nonatomic,assign,nullable) CacheFileNameFilterForRequestArgumentBlock cacheFileNameFilterBlock;
@property(nonatomic,assign) YTKRequestMethod requestMethod;
@property(nonatomic,assign) YTKRequestSerializerType requestSerializerType;
@property(nonatomic,strong,nullable) NSArray *requestAuthorizationHeaderFieldArray;
@property(nonatomic,strong,nullable) NSDictionary *requestHeaderFieldValueDictionary;
@property(nonatomic,strong,nullable) NSURLRequest *buildCustomUrlRequest;
@property(nonatomic,assign) BOOL useCDN;
@property(nonatomic,strong,nullable) id jsonValidator;
@property(nonatomic,assign) BOOL statusCodeValidator;
@property(nonatomic,assign) NSInteger cacheTimeInSecond;
@property(nonatomic,assign) long long cacheVersion;
@property(nonatomic,strong,nullable) id cacheSensitiveData;

/// 请求成功的回调
- (void)requestCompleteFilter;

/// 请求失败的回调
- (void)requestFailedFilter;

/// 请求的URL
- (NSString *)requestUrl;

/// 请求的CdnURL
- (NSString *)cdnUrl;

/// 请求的BaseURL
- (NSString *)baseUrl;

/// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的参数列表
- (id _Nullable )requestArgument;

/// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument;

/// Http请求的方法
- (YTKRequestMethod)requestMethod;

/// 请求的SerializerType
- (YTKRequestSerializerType)requestSerializerType;

/// 请求的Server用户名和密码
- (NSArray *_Nullable)requestAuthorizationHeaderFieldArray;

/// 在HTTP报头添加的自定义参数
- (NSDictionary *_Nullable)requestHeaderFieldValueDictionary;

/// 构建自定义的UrlRequest，
/// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType
- (NSURLRequest *_Nullable)buildCustomUrlRequest;

/// 是否使用CDN的host地址
- (BOOL)useCDN;

/// 用于检查JSON是否合法的对象
- (id _Nullable )jsonValidator;

/// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator;

/// For subclass to overwrite
- (NSInteger)cacheTimeInSeconds;

- (long long)cacheVersion;

- (id _Nullable )cacheSensitiveData;

@end

NS_ASSUME_NONNULL_END
