//
//  NSURL+BJL_M9Dev.h
//  M9Dev
//
//  Created by MingLQ on 2015-06-23.
//  Copyright (c) 2015 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (BJL_M9Dev)

// take the first if the query contains multiple values on an identical name
@property (nonatomic, readonly, copy, nullable) NSDictionary<NSString *, id> *bjl_queryDictionary;

+ (nullable NSString *)bjl_queryStringFromDictionary:(NSDictionary<NSString *, id> *)dictionary;

@end

NS_ASSUME_NONNULL_END
