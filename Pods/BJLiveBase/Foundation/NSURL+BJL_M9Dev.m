//
//  NSURL+BJL_M9Dev.m
//  M9Dev
//
//  Created by MingLQ on 2015-06-23.
//  Copyright (c) 2015 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "NSURL+BJL_M9Dev.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Plan A: NSURLComponents
 *  Encoding and Decoding URL Data - https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/URLLoadingSystem/WorkingwithURLEncoding/WorkingwithURLEncoding.html 
 *  Don’t use stringByAddingPercentEncodingWithAllowedCharacters: to encode an entire URL string, because each URL component or subcomponent has different rules for what characters are valid.
 *  If you want to decode a percent-encoded URL component, use NSURLComponents to split the URL into its constituent parts and access the corresponding property.
 *      @property (nullable, readonly, copy) NSURL *URL; // Returns a URL created from the NSURLComponents.
 *      @property (nullable, readonly, copy) NSString *string; // Returns a URL string created from the NSURLComponents.
 *      @property (nullable, copy) NSArray<NSURLQueryItem *> *queryItems; // readwrite
 *
 *  Plan B: Copied from AFNetworking
 *  @see AFNetworking/AFURLRequestSerialization.m
 *      static inline NSString * AFPercentEscapedStringFromString(NSString *string)
 *      static NSString * AFBase64EncodedStringFromString(NSString *string)
 *  decode:
 *      return [self stringByRemovingPercentEncoding];
 *
 *  Plan C: NSString+URLEncode
 *  http://madebymany.com/blog/url-encoding-an-nsstring-on-ios
 *  http://johan.svbtle.com/encodeuricomponent-in-objectivec
 *  https://stackoverflow.com/a/8086845/456536
 *      return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
 *                                                                                   (__bridge CFStringRef)self,
 *                                                                                   NULL,
 *                                                                                   CFSTR("!*'();:@&=+$,/?%#[]\" "), // @see https://stackoverflow.com/a/8086845/456536
 *                                                                                   CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
 *
 */

@implementation NSURL (BJL_M9Dev)

- (nullable NSDictionary<NSString *, id> *)bjl_queryDictionary {
    if (!self.query.length) {
        return nil;
    }
    NSMutableDictionary<NSString *, id> *dictionary = [NSMutableDictionary dictionary];
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    for (NSURLQueryItem *queryItem in components.queryItems) {
        if (![dictionary objectForKey:queryItem.name]) {
            [dictionary setObject:queryItem.value ?: @"" forKey:queryItem.name];
        }
    }
    return dictionary.count ? [dictionary copy] : nil;
}

+ (nullable NSString *)bjl_queryStringFromDictionary:(NSDictionary<NSString *, id> *)dictionary {
    NSURLComponents *components = [NSURLComponents new];
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id _Nonnull obj, BOOL * _Nonnull stop) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:[obj description]]];
    }];
    components.queryItems = queryItems;
    return components.query;
}

@end

NS_ASSUME_NONNULL_END
