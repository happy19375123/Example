//
//  BJLUserAgent.m
//  M9Dev
//
//  Created by MingLQ on 2017-08-28.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJLUserAgent.h"
#import <sys/utsname.h>

NS_ASSUME_NONNULL_BEGIN

NSString * hardwareType() {
    struct utsname systemInfo;
    uname(&systemInfo);
    return @(systemInfo.machine);
}

NSString * sysInfo() {
    UIDevice *currentDevice = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@/%@ (%@)",
            currentDevice.systemName,
            currentDevice.systemVersion,
            hardwareType() ?: currentDevice.model];
}

NSString * appInfo() {
    NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
    return [NSString stringWithFormat:@"%@/%@ (%@/%@)",
            infoDictionary[(__bridge NSString *)kCFBundleIdentifierKey] ?: @"-",
            infoDictionary[(__bridge NSString *)kCFBundleVersionKey] ?: @"-",
            infoDictionary[(__bridge NSString *)kCFBundleNameKey] ?: infoDictionary[(__bridge NSString *)kCFBundleExecutableKey] ?: @"-",
            infoDictionary[@"CFBundleShortVersionString"] ?: @"-"];
}

#pragma mark -

@interface BJLUserAgent ()

@property (nonatomic, readwrite, null_resettable) NSString *sdkUserAgent;
@property (nonatomic) NSMutableDictionary<NSString *, NSString *> *sdks;

@end

@implementation BJLUserAgent

- (NSString *)sdkUserAgent {
    if (!_sdkUserAgent) {
        _sdkUserAgent = [self serialize]; // lazy load
    }
    return _sdkUserAgent;
}

- (NSString *)userAgentWithDefault:(nullable NSString *)defaultUserAgent {
    return (defaultUserAgent.length
            ? [defaultUserAgent stringByAppendingFormat:@" %@", self.sdkUserAgent]
            : self.sdkUserAgent);
}

- (NSString *)serialize {
    NSMutableString *sdkUserAgent = [NSMutableString stringWithFormat:@"%@ %@", sysInfo(), appInfo()];
    for (NSString *name in [self.sdks allKeys]) {
        NSString *info = [self.sdks objectForKey:name];
        [sdkUserAgent appendFormat:@" %@/%@", name, info];
    }
    return [sdkUserAgent copy];
}

- (void)regitsterSDK:(NSString *)name version:(NSString *)version {
    [self regitsterSDK:name version:version description:nil];
}

- (void)regitsterSDK:(NSString *)name version:(NSString *)version description:(nullable NSString *)description {
    if (!self.sdks) {
        self.sdks = [NSMutableDictionary new];
    }
    NSString *info = (description.length
                      ? [version stringByAppendingFormat:@" (%@)", description]
                      : version);
    [self.sdks setObject:info forKey:name];
    self.sdkUserAgent = nil; // reset
}

+ (instancetype)defaultInstance {
    static BJLUserAgent *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [self new];
    });
    return defaultInstance;
}

@end

NS_ASSUME_NONNULL_END
