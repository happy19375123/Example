//
//  NSObject+M9Observing.m
//  M9Dev
//
//  Created by MingLQ on 2017-01-04.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <objc/runtime.h>

#import "NSObject+BJLObserving.h"
#import "NSObject+BJLWillDeallocBlock.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - meta

typedef void (^BJLCleaner)(__kindof BJLObservingMeta *meta, NSObject * _Nullable source, NSObject * _Nullable target);

static void *BJLProperty_context = &BJLProperty_context;

@interface BJLObservingMeta () <BJLObservation>
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, nullable) BJLCleaner cleaner;
- (void)clearObserver;
@end

@interface BJLPropertyMeta ()
@property (nonatomic, copy, nullable) BJLPropertyObserver observer;
- (void)setObserver:(BJLPropertyObserver)observer cleaner:(BJLCleaner)cleaner;
@end

@interface BJLMethodMeta ()
@property (nonatomic, copy, nullable) BJLMethodFilter filter;
@property (nonatomic, copy, nullable) BJLMethodObserver observer;
@property (nonatomic) BOOL ignoreReturnValue;
- (void)setFilter:(BJLMethodFilter)filter observer:(BJLMethodObserver)observer cleaner:(BJLCleaner)cleaner;
@end

@interface NSSet (BJLObservation) <BJLObservation>
@end

#pragma mark -

@implementation BJLObservingMeta

+ (instancetype)instanceWithTarget:(id)target name:(NSString *)name {
    BJLObservingMeta *meta = [self new];
    meta.target = target;
    meta.name = name;
    return meta;
}

- (void)stopObserving {
    [self stopObservingWithDeallocatingSource:nil target:nil];
}

- (void)stopObservingWithDeallocatingSource:(nullable NSObject *)source target:(nullable id)target {
    [self clearObserver];
    if (source || target) {
        if (self.cleaner) self.cleaner(self, source, target);
    }
    else {
        // !!!: make sure clean (removeObserver:forKeyPath:context:) is called AFTER setup (addObserver:forKeyPath:options:context:)
        // Whether a notification should be sent to the observer immediately, before the observer registration method even returns.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.cleaner) self.cleaner(self, source, target);
        });
    }
}

// subclasses MUST override
- (void)clearObserver {
    [self doesNotRecognizeSelector:_cmd];
}

@end

@implementation BJLPropertyMeta

- (void)setObserver:(BJLPropertyObserver)observer cleaner:(BJLCleaner)cleaner {
    self.observer = observer;
    self.cleaner = cleaner;
}

- (void)clearObserver {
    self.observer = nil; // stop notify
    /* !!!: do NOT clear these properties, becouse this method may be called TWO times
     self.stop, self.target, self.name */
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    /* The change dictionary in the notification will always contain NSKeyValueChangeNewKey and
     *  NSKeyValueChangeOldKey entry if NSKeyValueObservingOptionNew and NSKeyValueObservingOptionOld
     *  are specified.
     * But ...
     *  !!!: NOT contain NSKeyValueChangeOldKey when `initial`.
     * But if options has NSKeyValueObservingOptionInitial, NO NSKeyValueObservingOptionOld ...
     */
    id now = change[NSKeyValueChangeNewKey];
    id old = change[NSKeyValueChangeOldKey];
    BOOL goon = (self.observer
                 ? self.observer(old == [NSNull null] ? nil : old,
                                 now == [NSNull null] ? nil : now)
                 : YES);
    if (!goon) {
        [self stopObserving];
    }
}

@end

@implementation BJLMethodMeta

- (void)setFilter:(BJLMethodFilter)filter observer:(BJLMethodObserver)observer cleaner:(BJLCleaner)cleaner {
    self.filter = filter;
    self.observer = observer;
    self.cleaner = cleaner;
}

- (void)clearObserver {
    self.filter = nil;
    self.observer = nil; // stop notify
    /* !!!: do NOT clear these properties, becouse this method may be called TWO times
     self.stop, self.target, self.name */
}

@end

#pragma mark -

@implementation NSSet (BJLObservation)

- (void)stopObserving {
    [self makeObjectsPerformSelector:_cmd];
}

@end

#pragma mark - observing

static void *BJLObserver_i_observing = &BJLObserver_i_observing;
static void *BJLObserver_observing_me = &BJLObserver_observing_me;

@interface NSObject (BJLObservingMeta)

@end

@implementation NSObject (BJLObservingMeta)

- (nullable NSMutableArray<__kindof BJLObservingMeta *> *)bjl_allMetasForKey:(const void *)key { @synchronized(self) {
    return objc_getAssociatedObject(self, key);
}}

- (void)bjl_addMeta:(__kindof BJLObservingMeta *)meta forKey:(const void *)key { @synchronized(self) {
    [self bjl_removeAllMetasWhenWillDealloc];
    
    NSMutableArray<__kindof BJLObservingMeta *> *metas = [self bjl_allMetasForKey:key];
    if (!metas) {
        metas = [NSMutableArray new];
        objc_setAssociatedObject(self, key, metas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [metas addObject:meta];
}}

- (BOOL)bjl_containsMeta:(__kindof BJLObservingMeta *)meta forKey:(const void *)key { @synchronized(self) {
    NSMutableArray<__kindof BJLObservingMeta *> *metas = [self bjl_allMetasForKey:key];
    return [metas containsObject:meta];
}}

- (void)bjl_removeMeta:(__kindof BJLObservingMeta *)meta forKey:(const void *)key { @synchronized(self) {
    NSMutableArray<__kindof BJLObservingMeta *> *metas = [self bjl_allMetasForKey:key];
    [metas removeObject:meta];
}}

- (void)bjl_removeAllMetasWhenWillDealloc { @synchronized(self) {
    if (![self bjl_allMetasForKey:BJLObserver_i_observing]
        && ![self bjl_allMetasForKey:BJLObserver_observing_me]) {
        BJLWillDeallocBlock willDeallocBlock = self.bjl_willDeallocBlock;
        [self bjl_setWillDeallocBlock:^(id self) { @synchronized(self) {
            for (__kindof BJLObservingMeta *meta in [[self bjl_allMetasForKey:BJLObserver_i_observing] copy]) {
                [meta stopObservingWithDeallocatingSource:self target:nil];
            }
            for (__kindof BJLObservingMeta *meta in [[self bjl_allMetasForKey:BJLObserver_observing_me] copy]) {
                [meta stopObservingWithDeallocatingSource:nil target:self];
            }
            if (willDeallocBlock) willDeallocBlock(self);
        }}];
    }
}}

@end

#pragma mark -

const NSKeyValueObservingOptions BJLKVODefaultOptions = (NSKeyValueObservingOptionNew
                                                         | NSKeyValueObservingOptionOld
                                                         | NSKeyValueObservingOptionInitial);

@implementation NSObject (BJLKeyValueObserving)

- (id<BJLObservation>)bjl_kvo:(BJLPropertyMeta *)meta observer:(BJLPropertyObserver)observer { @synchronized(self) {
    return [self bjl_kvo:meta filter:nil observer:observer];
}}

- (id<BJLObservation>)bjl_kvo:(BJLPropertyMeta *)meta filter:(nullable BJLPropertyFilter)filter observer:(BJLPropertyObserver)observer { @synchronized(self) {
    return [self bjl_kvo:meta options:BJLKVODefaultOptions filter:filter observer:observer];
}}

- (id<BJLObservation>)bjl_kvo:(BJLPropertyMeta *)meta options:(NSKeyValueObservingOptions)options observer:(BJLPropertyObserver)observer { @synchronized(self) {
    NSParameterAssert(meta.target);
    NSParameterAssert(meta.name);
    NSParameterAssert(observer);
    
    __weak typeof(self) __weak_self__ = self;
    [meta setObserver:observer cleaner:^(__kindof BJLObservingMeta *meta, NSObject * _Nullable source, NSObject * _Nullable target) {
        __strong typeof(__weak_self__) self = __weak_self__;
        source = self ?: source;
        if (source && [source bjl_containsMeta:meta forKey:BJLObserver_i_observing]) {
            [source bjl_removeMeta:meta forKey:BJLObserver_i_observing];
        }
        target = meta.target ?: target;
        if (target && [target bjl_containsMeta:meta forKey:BJLObserver_observing_me]) {
            [target bjl_removeMeta:meta forKey:BJLObserver_observing_me];
#if !DEBUG
            @try {
#endif
                [target removeObserver:meta forKeyPath:meta.name context:BJLProperty_context];
#if !DEBUG
            }
            @catch (NSException *exception) {}
#endif
        }
    }];
    
    [self bjl_addMeta:meta forKey:BJLObserver_i_observing];
    [meta.target bjl_addMeta:meta forKey:BJLObserver_observing_me];
    
    // !!!: fire at last
    [meta.target addObserver:meta forKeyPath:meta.name options:options context:BJLProperty_context];
    
    return meta;
}}

- (id<BJLObservation>)bjl_kvo:(BJLPropertyMeta *)meta options:(NSKeyValueObservingOptions)options filter:(nullable BJLPropertyFilter)filter observer:(BJLPropertyObserver)observer { @synchronized(self) {
    return [self bjl_kvo:meta options:options observer:filter ? ^BOOL(id _Nullable old, id _Nullable now) {
        return filter(old, now) ? observer(old, now) : YES;
    } : observer];
}}

- (nullable id<BJLObservation>)bjl_kvoMerge:(NSArray<BJLPropertyMeta *> *)metas
                                   observer:(BJLPropertiesObserver)observer { @synchronized(self) {
    return [self bjl_kvoMerge:metas filter:nil observer:observer];
}}

- (nullable id<BJLObservation>)bjl_kvoMerge:(NSArray<BJLPropertyMeta *> *)metas
                                     filter:(nullable BJLPropertyFilter)filter
                                   observer:(BJLPropertiesObserver)observer { @synchronized(self) {
    return [self bjl_kvoMerge:metas options:BJLKVODefaultOptions filter:filter observer:observer];
}}

- (nullable id<BJLObservation>)bjl_kvoMerge:(NSArray<BJLPropertyMeta *> *)metas
                                    options:(NSKeyValueObservingOptions)options
                                   observer:(BJLPropertiesObserver)observer { @synchronized(self) {
    return [self bjl_kvoMerge:metas options:options filter:nil observer:observer];
}}

- (nullable id<BJLObservation>)bjl_kvoMerge:(NSArray<BJLPropertyMeta *> *)metas
                                    options:(NSKeyValueObservingOptions)options
                                     filter:(nullable BJLPropertyFilter)filter
                                   observer:(BJLPropertiesObserver)observer { @synchronized(self) {
    if (!metas.count) {
        return nil;
    }
    NSMutableSet<id<BJLObservation>> *observations = [NSMutableSet new];
    for (BJLPropertyMeta *meta in metas/* copy? */) {
        [observations addObject:[self bjl_kvo:meta options:options filter:filter observer:^BOOL(id _Nullable old, id _Nullable now) {
            if (observer) observer(old, now);
            return YES;
        }]];
    }
    return [observations copy];
}}

- (void)bjl_stopAllKeyValueObservingOfTarget:(nullable id)target { @synchronized(self) {
    for (__kindof BJLObservingMeta *_meta in [[self bjl_allMetasForKey:BJLObserver_i_observing] copy]) {
        BJLPropertyMeta *meta = [_meta isKindOfClass:[BJLPropertyMeta class]] ? (BJLPropertyMeta *)_meta : nil;
        if (meta
            && (!target || meta.target == target)) {
            [meta stopObserving];
        }
    }
}}

- (void)bjl_stopAllKeyValueObserving { @synchronized(self) {
    [self bjl_stopAllKeyValueObservingOfTarget:nil];
}}

@end

#pragma mark -

@implementation NSObject (BJLMethodArgumentsObserving)

- (id<BJLObservation>)bjl_observe:(BJLMethodMeta *)meta observer:(BJLMethodObserver)observer { @synchronized(self) {
    return [self bjl_observe:meta filter:nil observer:observer];
}}

- (id<BJLObservation>)bjl_observe:(BJLMethodMeta *)meta filter:(nullable BJLMethodFilter)filter observer:(BJLMethodObserver)observer { @synchronized(self) {
    NSParameterAssert(meta.target);
    NSParameterAssert(meta.name);
    NSParameterAssert(observer);
    
    __weak typeof(self) __weak_self__ = self;
    [meta setFilter:filter observer:observer cleaner:^(__kindof BJLObservingMeta *meta, NSObject * _Nullable source, NSObject * _Nullable target) {
        __strong typeof(__weak_self__) self = __weak_self__;
        source = self ?: source;
        if (source) {
            [source bjl_removeMeta:meta forKey:BJLObserver_i_observing];
        }
        target = meta.target ?: target;
        if (target) {
            [target bjl_removeMeta:meta forKey:BJLObserver_observing_me];
        }
    }];
    
    [self bjl_addMeta:meta forKey:BJLObserver_i_observing];
    [meta.target bjl_addMeta:meta forKey:BJLObserver_observing_me];
    
    return meta;
}}

- (nullable id<BJLObservation>)bjl_observeMerge:(NSArray<BJLMethodMeta *> *)metas
                                       observer:(BJLMethodsObserver)observer { @synchronized(self) {
    return [self bjl_observeMerge:metas filter:nil observer:observer];
}}

- (nullable id<BJLObservation>)bjl_observeMerge:(NSArray<BJLMethodMeta *> *)metas
                                         filter:(nullable BJLMethodFilter)filter
                                       observer:(BJLMethodsObserver)observer { @synchronized(self) {
    if (!metas.count) {
        return nil;
    }
    NSMutableSet<id<BJLObservation>> *observations = [NSMutableSet new];
    for (BJLMethodMeta *meta in metas/* copy? */) {
        meta.ignoreReturnValue = YES;
        // cast BJLMethodsObserver to BJLMethodObserver, it returns nil/NO
        [observations addObject:[self bjl_observe:meta filter:filter observer:(BJLMethodObserver)observer]];
    }
    return [observations copy];
}}

- (void)bjl_notifyMethodForSelector:(SEL)selector callback:(BOOL (^)(BJLMethodFilter filter, BJLMethodObserver observer, BOOL ignoreReturnValue))callback { @synchronized(self) {
    NSParameterAssert(callback);
    
    for (__kindof BJLObservingMeta *_meta in [[self bjl_allMetasForKey:BJLObserver_observing_me] copy]) {
        BJLMethodMeta *meta = [_meta isKindOfClass:[BJLMethodMeta class]] ? (BJLMethodMeta *)_meta : nil;
        if (meta
            && meta.target == self
            && [meta.name isEqualToString:NSStringFromSelector(selector)]
            && meta.observer) {
            BOOL goon = callback(meta.filter, meta.observer, meta.ignoreReturnValue);
            if (!goon) {
                [meta stopObserving];
            }
        }
    }
}}

- (void)bjl_stopAllMethodArgumentsObservingOfTarget:(nullable id)target { @synchronized(self) {
    for (__kindof BJLObservingMeta *_meta in [[self bjl_allMetasForKey:BJLObserver_i_observing] copy]) {
        BJLMethodMeta *meta = [_meta isKindOfClass:[BJLMethodMeta class]] ? (BJLMethodMeta *)_meta : nil;
        if (meta
            && (!target || meta.target == target)) {
            [meta stopObserving];
        }
    }
}}

- (void)bjl_stopAllMethodArgumentsObserving { @synchronized(self) {
    [self bjl_stopAllMethodArgumentsObservingOfTarget:nil];
}}

@end

NS_ASSUME_NONNULL_END
