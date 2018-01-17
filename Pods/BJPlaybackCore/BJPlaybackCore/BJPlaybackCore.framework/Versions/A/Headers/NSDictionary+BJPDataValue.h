//
//  NSDictionary+BJPDataValue.h
//  Pods
//
//  Created by Randy on 16/02/19.
//  Copyright © 2016 Baijia Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BJPDataValue)

- (int)BJP_intForKey:(NSString *)key;
- (NSInteger)BJP_integerForKey:(NSString *)key;
- (long)BJP_longForKey:(NSString *)key;
- (long long)BJP_longLongForKey:(NSString *)key;
- (float)BJP_floatForKey:(NSString *)key;
- (double)BJP_doubleForKey:(NSString *)key;
- (BOOL)BJP_boolForKey:(NSString *)key;
- (NSArray *)BJP_arrayForKey:(NSString *)key;
- (NSDictionary *)BJP_dictionaryForKey:(NSString *)key;
- (NSDate *)BJP_dateForKey:(NSString *)key;
- (NSURL *)BJP_urlForKey:(NSString *)key;

- (int)BJP_intForKey:(NSString *)key defaultValue:(int)defaultValue;
- (NSInteger)BJP_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (long)BJP_longForKey:(NSString *)key defaultValue:(long)defaultValue;
- (long long)BJP_longLongForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (float)BJP_floatForKey:(NSString *)key defaultValue:(float)defaultValue;
- (double)BJP_doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
- (BOOL)BJP_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (NSString *)BJP_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSDate *)BJP_dateForKey:(NSString *)key defaultValue:(NSDate *)defaultValue;
- (NSURL *)BJP_urlForKey:(NSString *)key defaultValue:(NSURL *)defaultValue;
- (NSURL *)BJP_urlForKeyFromUrlOrString:(NSString *)key defaultValue:(NSURL *)defaultValue;

@end
