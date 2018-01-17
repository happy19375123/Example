//
//  NSDictionary+BJPM.h
//  Pods
//
//  Created by DLM on 2017/4/28.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BJPM)

- (int)BJPM_intForKey:(NSString *)key;
- (NSInteger)BJPM_integerForKey:(NSString *)key;
- (long)BJPM_longForKey:(NSString *)key;
- (long long)BJPM_longLongForKey:(NSString *)key;
- (float)BJPM_floatForKey:(NSString *)key;
- (double)BJPM_doubleForKey:(NSString *)key;
- (BOOL)BJPM_boolForKey:(NSString *)key;
- (NSString *)BJPM_stringForKey:(NSString *)key;
- (NSArray *)BJPM_arrayForKey:(NSString *)key;
- (NSDictionary *)BJPM_dictionaryForKey:(NSString *)key;
- (NSDate *)BJPM_dateForKey:(NSString *)key;
- (NSURL *)BJPM_urlForKey:(NSString *)key;
- (NSURL *)BJPM_urlForKeyFromUrlOrString:(NSString *)key;

#pragma mark -defaultValue
- (int)BJPM_intForKey:(NSString *)key defaultValue:(int)defaultValue;
- (NSInteger)BJPM_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (long)BJPM_longForKey:(NSString *)key defaultValue:(long)defaultValue;
- (long long)BJPM_longLongForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (float)BJPM_floatForKey:(NSString *)key defaultValue:(float)defaultValue;
- (double)BJPM_doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
- (BOOL)BJPM_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (NSString *)BJPM_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSDate *)BJPM_dateForKey:(NSString *)key defaultValue:(NSDate *)defaultValue;
- (NSURL *)BJPM_urlForKey:(NSString *)key defaultValue:(NSURL *)defaultValue;
- (NSURL *)BJPM_urlForKeyFromUrlOrString:(NSString *)key defaultValue:(NSURL *)defaultValue;

@end
