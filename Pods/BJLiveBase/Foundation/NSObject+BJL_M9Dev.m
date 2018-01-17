//
//  NSObject+BJL_M9Dev.m
//  M9Dev
//
//  Created by MingLQ on 2016-04-20.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "NSObject+BJL_M9Dev.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSObject (BJL_M9Dev)

- (nullable id)bjl_if:(BOOL)condition {
    return condition ? self : nil;
}

- (nullable instancetype)bjl_as:(Class)clazz {
    return [self bjl_if:[self isKindOfClass:clazz]];
}

- (nullable id)bjl_asMemberOfClass:(Class)clazz {
    return [self bjl_if:[self isMemberOfClass:clazz]];
}

- (nullable id)bjl_asProtocol:(Protocol *)protocol {
    return [self bjl_if:[self conformsToProtocol:protocol]];
}

- (nullable id)bjl_ifRespondsToSelector:(SEL)selector {
    return [self bjl_if:[self respondsToSelector:selector]];
}

- (nullable NSArray *)bjl_asArray {
    return [self bjl_as:[NSArray class]];
}

- (nullable NSDictionary *)bjl_asDictionary {
    return [self bjl_as:[NSDictionary class]];
}

- (nullable id)bjl_performIfRespondsToSelector:(SEL)selector {
    _Pragma("clang diagnostic push")
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
    return [[self bjl_ifRespondsToSelector:selector] performSelector:selector];
    _Pragma("clang diagnostic pop")
}

- (nullable id)bjl_performIfRespondsToSelector:(SEL)selector withObject:(nullable id)object {
    _Pragma("clang diagnostic push")
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
    return [[self bjl_ifRespondsToSelector:selector] performSelector:selector withObject:object];
    _Pragma("clang diagnostic pop")
}

- (nullable id)bjl_performIfRespondsToSelector:(SEL)selector withObject:(nullable id)object1 withObject:(nullable id)object2 {
    _Pragma("clang diagnostic push")
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
    return [[self bjl_ifRespondsToSelector:selector] performSelector:selector withObject:object1 withObject:object2];
    _Pragma("clang diagnostic pop")
}

@end

#pragma mark -

@implementation NSArray (BJL_M9Dev)

- (nullable id)bjl_objectOrNilAtIndex:(NSUInteger)index {
    return [self bjl_containsIndex:index] ? [self objectAtIndex:index] : nil;
}

- (BOOL)bjl_containsIndex:(NSUInteger)index {
    return index < [self count];
}

@end

@implementation NSMutableArray (BJL_M9Dev)

- (BOOL)bjl_addObjectOrNil:(nullable id)anObject {
    if (!anObject) {
        return NO;
    }
    [self addObject:anObject];
    return YES;
}

- (BOOL)bjl_insertObjectOrNil:(nullable id)anObject atIndex:(NSUInteger)index {
    if (!anObject || index > [self count]) {
        return NO;
    }
    [self insertObject:anObject atIndex:index];
    return YES;
}

- (BOOL)bjl_removeObjectOrNilAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return NO;
    }
    [self removeObjectAtIndex:index];
    return YES;
}

- (BOOL)bjl_replaceObjectAtIndex:(NSUInteger)index withObjectOrNil:(nullable id)anObject {
    if (!anObject || index >= [self count]) {
        return NO;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
    return YES;
}

@end

#pragma mark -

@implementation NSDictionary (BJL_M9Dev)

- (float)bjl_floatForKey:(id)aKey {
    return [self bjl_floatForKey:aKey defaultValue:0.0f];
}
- (float)bjl_floatForKey:(id)aKey defaultValue:(float)defaultValue {
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(floatValue)]) {
        return [object floatValue];
    }
    return defaultValue;
}

- (double)bjl_doubleForKey:(id)aKey {
    return [self bjl_doubleForKey:aKey defaultValue:0.0];
}
- (double)bjl_doubleForKey:(id)aKey defaultValue:(double)defaultValue {
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(doubleValue)]) {
        return [object doubleValue];
    }
    return defaultValue;
}

- (long long)bjl_longLongForKey:(id)aKey {
    return [self bjl_longLongForKey:aKey defaultValue:0];
}
- (long long)bjl_longLongForKey:(id)aKey defaultValue:(long long)defaultValue {
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(longLongValue)]) {
        return [object longLongValue];
    }
    return defaultValue;
}

- (unsigned long long)bjl_unsignedLongLongForKey:(id)aKey {
    return [self bjl_unsignedLongLongForKey:aKey defaultValue:0];
}
- (unsigned long long)bjl_unsignedLongLongForKey:(id)aKey defaultValue:(unsigned long long)defaultValue {
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(unsignedLongLongValue)]) {
        return [object unsignedLongLongValue];
    }
    return defaultValue;
}

- (BOOL)bjl_boolForKey:(id)aKey {
    return [self bjl_boolForKey:aKey defaultValue:NO];
}

- (BOOL)bjl_boolForKey:(id)aKey defaultValue:(BOOL)defaultValue {
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(boolValue)]) {
        return [object boolValue];
    }
    return defaultValue;
}

- (NSInteger)bjl_integerForKey:(id)aKey {
    return [self bjl_integerForKey:aKey defaultValue:0];
}
- (NSInteger)bjl_integerOrNotFoundForKey:(id)aKey {
    return [self bjl_integerForKey:aKey defaultValue:NSNotFound];
}
- (NSInteger)bjl_integerForKey:(id)aKey defaultValue:(NSInteger)defaultValue {
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    }
    return defaultValue;
}

- (NSUInteger)bjl_unsignedIntegerForKey:(id)aKey {
    return [self bjl_unsignedIntegerForKey:aKey defaultValue:0];
}
- (NSUInteger)bjl_unsignedIntegerOrNotFoundForKey:(id)aKey {
    return [self bjl_unsignedIntegerForKey:aKey defaultValue:NSNotFound];
}
- (NSUInteger)bjl_unsignedIntegerForKey:(id)aKey defaultValue:(NSUInteger)defaultValue {
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(unsignedIntegerValue)]) {
        return [object unsignedIntegerValue];
    }
    return defaultValue;
}

- (nullable NSNumber *)bjl_numberForKey:(id)aKey {
    return [self bjl_numberForKey:aKey defaultValue:nil];
}
- (nullable NSNumber *)bjl_numberForKey:(id)aKey defaultValue:(nullable NSNumber *)defaultValue {
    return (NSNumber *)[self bjl_objectForKey:aKey class:[NSNumber class] defaultValue:defaultValue];
}

- (nullable NSString *)bjl_stringForKey:(id)aKey {
    return [self bjl_stringForKey:aKey defaultValue:nil];
}
- (nullable NSString *)bjl_stringOrEmptyStringForKey:(id)akey {
    return [self bjl_stringForKey:akey defaultValue:@""];
}
- (nullable NSString *)bjl_stringForKey:(id)aKey defaultValue:(nullable NSString *)defaultValue {
    id object = [self objectForKey:aKey];
    if ([object isKindOfClass:[NSString class]]) {
        return (NSString *)object;
    }
    if ([object respondsToSelector:@selector(stringValue)]) {
        return [object stringValue];
    }
    return defaultValue;
}

- (nullable NSArray *)bjl_arrayForKey:(id)aKey {
    return [self bjl_arrayForKey:aKey defaultValue:nil];
}
- (nullable NSArray *)bjl_arrayForKey:(id)aKey defaultValue:(nullable NSArray *)defaultValue {
    return (NSArray *)[self bjl_objectForKey:aKey class:[NSArray class] defaultValue:defaultValue];
}

- (nullable NSDictionary *)bjl_dictionaryForKey:(id)aKey {
    return [self bjl_dictionaryForKey:aKey defaultValue:nil];
}
- (nullable NSDictionary *)bjl_dictionaryForKey:(id)aKey defaultValue:(nullable NSDictionary *)defaultValue {
    return (NSDictionary *)[self bjl_objectForKey:aKey class:[NSDictionary class] defaultValue:defaultValue];
}

- (nullable NSData *)bjl_dataForKey:(id)aKey {
    return [self bjl_dataForKey:aKey defaultValue:nil];
}
- (nullable NSData *)bjl_dataForKey:(id)aKey defaultValue:(nullable NSData *)defaultValue {
    return (NSData *)[self bjl_objectForKey:aKey class:[NSData class] defaultValue:defaultValue];
}

- (nullable NSDate *)bjl_dateForKey:(id)aKey {
    return [self bjl_dateForKey:aKey defaultValue:nil];
}
- (nullable NSDate *)bjl_dateForKey:(id)aKey defaultValue:(nullable NSDate *)defaultValue {
    return (NSDate *)[self bjl_objectForKey:aKey class:[NSDate class] defaultValue:defaultValue];
}

- (nullable NSURL *)bjl_URLForKey:(id)aKey {
    return [self bjl_URLForKey:aKey defaultValue:nil];
}
- (nullable NSURL *)bjl_URLForKey:(id)aKey defaultValue:(nullable NSURL *)defaultValue {
    return (NSURL *)[self bjl_objectForKey:aKey class:[NSURL class] defaultValue:defaultValue];
}

- (nullable id)bjl_objectForKey:(id)aKey class:(nullable Class)clazz {
    return [self bjl_objectForKey:aKey class:clazz defaultValue:nil];
}
- (nullable id)bjl_objectForKey:(id)aKey class:(nullable Class)clazz defaultValue:(nullable id)defaultValue {
    return [self bjl_objectForKey:aKey class:clazz protocol:nil defaultValue:defaultValue];
}

- (nullable id)bjl_objectForKey:(id)aKey protocol:(nullable Protocol *)protocol {
    return [self bjl_objectForKey:aKey protocol:protocol defaultValue:nil];
}
- (nullable id)bjl_objectForKey:(id)aKey protocol:(nullable Protocol *)protocol defaultValue:(nullable id)defaultValue {
    return [self bjl_objectForKey:aKey class:nil protocol:protocol defaultValue:defaultValue];
}

- (nullable id)bjl_objectForKey:(id)aKey class:(nullable Class)clazz protocol:(nullable Protocol *)protocol {
    return [self bjl_objectForKey:aKey class:clazz protocol:protocol defaultValue:nil];
}
- (nullable id)bjl_objectForKey:(id)aKey class:(nullable Class)clazz protocol:(nullable Protocol *)protocol defaultValue:(nullable id)defaultValue {
    id object = [self objectForKey:aKey];
    if ((!clazz || [object isKindOfClass:clazz])
        && (!protocol || [object conformsToProtocol:protocol])) {
        return object;
    }
    return defaultValue;
    
    /* DEMO: use block
    return [self objectForKey:aKey callback:^id(id object) {
        if ((!clazz || [object isKindOfClass:clazz])
            && (!protocol || [object conformsToProtocol:protocol])) {
            return object;
        }
        return defaultValue;
    }]; // */
}

- (nullable id)bjl_objectForKey:(id)aKey callback:(_Nullable id (^)(id object))callback {
    id object = [self objectForKey:aKey];
    return callback ? callback(object) : object;
}

@end

@implementation NSMutableDictionary (BJL_M9Dev)

- (void)bjl_setObjectOrNil:(nullable id)anObject forKey:(nullable id<NSCopying>)aKey {
    if (!aKey) {
        return;
    }
    if (!anObject) {
        [self removeObjectForKey:aKey];
        return;
    }
    [self setObject:anObject forKey:aKey];
}

- (void)bjl_removeObjectForKeyOrNil:(nullable id<NSCopying>)aKey {
    if (aKey) {
        [self removeObjectForKey:aKey];
    }
}

@end

#pragma mark -

@interface _BJLTimerBlockTarget : NSObject
@property (nonatomic, copy) void (^block)(NSTimer *timer);
@end
@implementation _BJLTimerBlockTarget
+ (instancetype)targetWithBlock:(void (^)(NSTimer *timer))block {
    _BJLTimerBlockTarget *target = [self new];
    target.block = block;
    return target;
}
- (void)timerFired:(NSTimer *)timer {
    if (self.block) self.block(timer);
}
@end

@implementation NSTimer (BJL_M9Dev)

+ (NSTimer *)bjl_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    if (bjl_available(iOS 10.0, [self respondsToSelector:@selector(timerWithTimeInterval:repeats:block:)])) {
        return [self timerWithTimeInterval:interval
                                   repeats:repeats
                                     block:block];
    }
    else {
        return [NSTimer timerWithTimeInterval:interval
                                       target:[_BJLTimerBlockTarget targetWithBlock:block]
                                     selector:@selector(timerFired:)
                                     userInfo:nil
                                      repeats:repeats];
    }
}

+ (NSTimer *)bjl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    if (bjl_available(iOS 10.0, [NSTimer respondsToSelector:@selector(scheduledTimerWithTimeInterval:repeats:block:)])) {
        return [NSTimer scheduledTimerWithTimeInterval:interval
                                               repeats:repeats
                                                 block:block];
    }
    else {
        return [NSTimer scheduledTimerWithTimeInterval:interval
                                                target:[_BJLTimerBlockTarget targetWithBlock:block]
                                              selector:@selector(timerFired:)
                                              userInfo:nil
                                               repeats:repeats];
    }
}

@end

/*
#pragma mark - YYModel

@implementation NSObject (BJL_M9Dev_YYModel)

+ (nullable NSArray *)bjl_modelArrayWithJSON:(id)json {
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}

+ (nullable NSDictionary *)bjl_modelDictionaryWithJSON:(id)json {
    return [NSDictionary yy_modelDictionaryWithClass:[self class] json:json];
}

@end */

NS_ASSUME_NONNULL_END
