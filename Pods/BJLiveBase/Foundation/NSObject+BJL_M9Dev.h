//
//  NSObject+BJL_M9Dev.h
//  M9Dev
//
//  Created by MingLQ on 2016-04-20.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <Foundation/Foundation.h>

// @see M9Dev - https://github.com/iwill/

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BJL_M9Dev)

- (nullable id)bjl_if:(BOOL)condition;

- (nullable id)bjl_as:(Class)clazz;
- (nullable id)bjl_asMemberOfClass:(Class)clazz;
- (nullable id)bjl_asProtocol:(Protocol *)protocol;
- (nullable id)bjl_ifRespondsToSelector:(SEL)selector;

- (nullable NSArray *)bjl_asArray;
- (nullable NSDictionary *)bjl_asDictionary;

- (nullable id)bjl_performIfRespondsToSelector:(SEL)selector;
- (nullable id)bjl_performIfRespondsToSelector:(SEL)selector withObject:(nullable id)object;
- (nullable id)bjl_performIfRespondsToSelector:(SEL)selector withObject:(nullable id)object1 withObject:(nullable id)object2;

@end

#pragma mark -

@interface NSArray (BJL_M9Dev)

// indexOfObject:/containsObject:/removeObject: + compareSelector:/comparator:

- (nullable id)bjl_objectOrNilAtIndex:(NSUInteger)index;
- (BOOL)bjl_containsIndex:(NSUInteger)index;

@end

@interface NSMutableArray (BJL_M9Dev)

- (BOOL)bjl_addObjectOrNil:(nullable id)anObject;
- (BOOL)bjl_insertObjectOrNil:(nullable id)anObject atIndex:(NSUInteger)index;
- (BOOL)bjl_removeObjectOrNilAtIndex:(NSUInteger)index;
- (BOOL)bjl_replaceObjectAtIndex:(NSUInteger)index withObjectOrNil:(nullable id)anObject;

@end

#pragma mark -

@interface NSDictionary (BJL_M9Dev)

/**
 * ???: add int, remove unsignedXxxx
 *  @see NSString+NSStringExtensionMethods @ xxxValue
 *
 * NOTE: detect CGFloat is float or double:
 *  #if defined(__LP64__) && __LP64__
 *      CGFloat is double
 *  #elif
 #      CGFloat is float
 *  #endif
 */

/* C */
- (float)bjl_floatForKey:(id)aKey;
- (float)bjl_floatForKey:(id)aKey defaultValue:(float)defaultValue;
- (double)bjl_doubleForKey:(id)aKey;
- (double)bjl_doubleForKey:(id)aKey defaultValue:(double)defaultValue;
/* C More */
- (long long)bjl_longLongForKey:(id)aKey;
- (long long)bjl_longLongForKey:(id)aKey defaultValue:(long long)defaultValue;
- (unsigned long long)bjl_unsignedLongLongForKey:(id)aKey;
- (unsigned long long)bjl_unsignedLongLongForKey:(id)aKey defaultValue:(unsigned long long)defaultValue;

/* OC */
- (BOOL)bjl_boolForKey:(id)aKey;
- (BOOL)bjl_boolForKey:(id)aKey defaultValue:(BOOL)defaultValue;
- (NSInteger)bjl_integerForKey:(id)aKey;
- (NSInteger)bjl_integerOrNotFoundForKey:(id)aKey;
- (NSInteger)bjl_integerForKey:(id)aKey defaultValue:(NSInteger)defaultValue;

/* OC More */
- (NSUInteger)bjl_unsignedIntegerForKey:(id)aKey;
- (NSUInteger)bjl_unsignedIntegerOrNotFoundForKey:(id)aKey;
- (NSUInteger)bjl_unsignedIntegerForKey:(id)aKey defaultValue:(NSUInteger)defaultValue;

/* OC Object */
- (nullable NSNumber *)bjl_numberForKey:(id)aKey;
- (nullable NSNumber *)bjl_numberForKey:(id)aKey defaultValue:(nullable NSNumber *)defaultValue;
- (nullable NSString *)bjl_stringForKey:(id)aKey;
- (nullable NSString *)bjl_stringOrEmptyStringForKey:(id)akey;
- (nullable NSString *)bjl_stringForKey:(id)akey defaultValue:(nullable NSString *)defaultValue;
- (nullable NSArray *)bjl_arrayForKey:(id)aKey;
- (nullable NSArray *)bjl_arrayForKey:(id)aKey defaultValue:(nullable NSArray *)defaultValue;
- (nullable NSDictionary *)bjl_dictionaryForKey:(id)aKey;
- (nullable NSDictionary *)bjl_dictionaryForKey:(id)aKey defaultValue:(nullable NSDictionary *)defaultValue;
- (nullable NSData *)bjl_dataForKey:(id)aKey;
- (nullable NSData *)bjl_dataForKey:(id)aKey defaultValue:(nullable NSData *)defaultValue;
- (nullable NSDate *)bjl_dateForKey:(id)aKey;
- (nullable NSDate *)bjl_dateForKey:(id)aKey defaultValue:(nullable NSDate *)defaultValue;
- (nullable NSURL *)bjl_URLForKey:(id)aKey;
- (nullable NSURL *)bjl_URLForKey:(id)aKey defaultValue:(nullable NSURL *)defaultValue;

/* OC Object More */
/* !!!:
 *  #param clazz: Be careful when using this method on objects represented by a class cluster...
 *
 *      // DO NOT DO THIS! Use - objectForKey:callback: instead
 *      if ([myArray isKindOfClass:[NSMutableArray class]]) {
 *          // Modify the object
 *      }
 *
 *      @see NSObject - isKindOfClass:
 */
- (nullable id)bjl_objectForKey:(id)aKey class:(nullable Class)clazz;
- (nullable id)bjl_objectForKey:(id)aKey class:(nullable Class)clazz defaultValue:(nullable id)defaultValue;
- (nullable id)bjl_objectForKey:(id)aKey protocol:(nullable Protocol *)protocol;
- (nullable id)bjl_objectForKey:(id)aKey protocol:(nullable Protocol *)protocol defaultValue:(nullable id)defaultValue;
- (nullable id)bjl_objectForKey:(id)aKey class:(nullable Class)clazz protocol:(nullable Protocol *)protocol;
- (nullable id)bjl_objectForKey:(id)aKey class:(nullable Class)clazz protocol:(nullable Protocol *)protocol defaultValue:(nullable id)defaultValue;
- (nullable id)bjl_objectForKey:(id)aKey callback:(_Nullable id (^)(id object))callback;

@end

@interface NSMutableDictionary (BJL_M9Dev)

- (void)bjl_setObjectOrNil:(nullable id)anObject forKey:(nullable id<NSCopying>)aKey;
- (void)bjl_removeObjectForKeyOrNil:(nullable id<NSCopying>)aKey;

@end

#pragma mark -

@interface NSTimer (BJL_M9Dev)

+ (NSTimer *)bjl_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
+ (NSTimer *)bjl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end

/*
#pragma mark - YYModel

@interface NSObject (BJL_M9Dev_YYModel)

+ (nullable NSArray *)bjl_modelArrayWithJSON:(id)json;
+ (nullable NSDictionary *)bjl_modelDictionaryWithJSON:(id)json;

@end */

NS_ASSUME_NONNULL_END
