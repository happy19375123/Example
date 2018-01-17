//
//  BJLURLAction.m
//  M9Dev
//
//  Created by MingLQ on 2015-06-12.
//  Copyright (c) 2015 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJLURLAction.h"

NS_ASSUME_NONNULL_BEGIN

/** scheme:// */
static inline NSString *_BJLURLActionKey_scheme(NSString * _Nullable scheme) {
    if (!scheme.length) {
        return @"";
    }
    return ([scheme hasSuffix:@"://"] ? scheme : [scheme stringByAppendingString:@"://"]);
}

/** host */
static inline NSString *_BJLURLActionKey_host(NSString * _Nullable host) {
    if (!host.length) {
        return @"";
    }
    return host;
}

/** /path or / */
static inline NSString *_BJLURLActionKey_path(NSString * _Nullable path) {
    if (!path.length) {
        return @"/";
    }
    return [path hasPrefix:@"/"] ? path : [@"/" stringByAppendingString:path];
}

/**
 *  URL components combination:
 *      [ scheme:// host /path ]
 *      [ scheme:// host /     ]
 *      [ scheme://      /path ]
 *      [ scheme://      /     ]
 *      [           host /path ]
 *      [           host /     ]
 *      [                /path ]
 *      [                /     ]
 */
static inline NSString *BJLURLActionKey(NSString * _Nullable scheme, NSString * _Nullable host, NSString * _Nullable path) {
    return [NSString stringWithFormat:@"%@%@%@",
            _BJLURLActionKey_scheme(scheme).lowercaseString ?: @"",
            _BJLURLActionKey_host(host).lowercaseString ?: @"",
            _BJLURLActionKey_path(path)];
}

#pragma mark -

@interface BJLURLActionHandlerWrapper : NSObject

@property (nonatomic, copy) BJLURLActionHandler handler;

@property (nonatomic) id target;
@property (nonatomic) SEL instance, action;

@end

@implementation BJLURLActionHandlerWrapper

+ (instancetype)handlerWithBlock:(BJLURLActionHandler)handler {
    BJLURLActionHandlerWrapper *actionHandler = [self new];
    actionHandler.handler = handler;
    return actionHandler;
}

+ (instancetype)handlerWithTarget:(id)target instance:(SEL)instance action:(SEL)action {
    BJLURLActionHandlerWrapper *actionHandler = [self new];
    actionHandler.target = target;
    actionHandler.instance = instance;
    actionHandler.action = action;
    return actionHandler;
}

- (void)handleAction:(BJLURLAction *)action
            userInfo:(nullable id)userInfo
          completion:(nullable BJLURLActionHandleCompletion)completion {
    if (self.handler) {
        self.handler(action, userInfo, completion);
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id target = self.target;
    SEL instanceSelector = self.instance ?: @selector(self);
    // #import <objc/runtime.h>
    // class_isMetaClass(object_getClass(target))
    if ([target respondsToSelector:instanceSelector]) {
        target = [target performSelector:instanceSelector];
    }
    else if (target == [target class] && [target instancesRespondToSelector:instanceSelector]) {
        target = [[[target class] alloc] performSelector:instanceSelector withObject:nil];
    }
    SEL actionSelector = self.action;
    if ([target respondsToSelector:actionSelector]) {
        [target bjl_invokeWithSelector:actionSelector arguments:&action, &userInfo, &completion];
    }
#pragma clang diagnostic pop
}

@end

#pragma mark -

@interface BJLURLAction ()

// + (BJLURLAction *)actionWithURL:(NSURL *)URL;

@end

@implementation BJLURLAction

+ (BJLURLAction *)actionWithURL:(NSURL *)URL {
    if (!URL) {
        return nil;
    }
    BJLURLAction *action = [BJLURLAction new];
    action->_URL = URL;
    return action;
}

- (NSString *)description {
    return [[super description]
            stringByAppendingFormat:@" : %@ :// %@ %@ ? %@ # %@ = %@",
            self.URL.scheme.lowercaseString,
            self.URL.host.lowercaseString,
            self.URL.path.length ? self.URL.path : @"/", // <N/A>
            self.URL.bjl_queryDictionary,
            self.URL.fragment,
            self.URL];
}

@end

#pragma mark -

@interface BJLURLActionManager ()

@property (nonatomic) NSMutableDictionary<NSString *, BJLURLActionHandlerWrapper *> *actionHandlers;

@end

@implementation BJLURLActionManager

+ (instancetype)globalActionManager {
    static BJLURLActionManager *globalActionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalActionManager = [BJLURLActionManager new];
    });
    return globalActionManager;
}

- (void)setValidSchemes:(nullable NSArray<NSString *> *)schemes {
    NSMutableArray *validSchemes = nil;
    for (NSString *scheme in schemes) {
        validSchemes = validSchemes ?: [NSMutableArray new];
        [validSchemes addObject:scheme.lowercaseString];
    }
    self->_validSchemes = [validSchemes copy];
}

#pragma mark config with block

- (void)configWithScheme:(nullable NSString *)scheme host:(nullable NSString *)host path:(nullable NSString *)path handler:(BJLURLActionHandler)handler {
    self.actionHandlers = self.actionHandlers ?: [NSMutableDictionary new];
    
    BJLURLActionHandlerWrapper *handlerWrapper = [BJLURLActionHandlerWrapper handlerWithBlock:handler];
    [self.actionHandlers setObject:handlerWrapper forKey:BJLURLActionKey(scheme, host, path)];
}

- (void)configWithScheme:(NSString *)scheme handler:(BJLURLActionHandler)handler {
    [self configWithScheme:scheme host:nil path:nil handler:handler];
}

- (void)configWithHost:(nullable NSString *)host path:(nullable NSString *)path handler:(BJLURLActionHandler)handler {
    [self configWithScheme:nil host:host path:path handler:handler];
}

#pragma mark config with target[-instance]-action

- (void)configWithScheme:(nullable NSString *)scheme host:(nullable NSString *)host path:(nullable NSString *)path target:(id)target instance:(SEL)instance action:(SEL)action {
    self.actionHandlers = self.actionHandlers ?: [NSMutableDictionary new];
    
    BJLURLActionHandlerWrapper *handlerWrapper = [BJLURLActionHandlerWrapper handlerWithTarget:target instance:instance action:action];
    [self.actionHandlers setObject:handlerWrapper forKey:BJLURLActionKey(scheme, host, path)];
}

- (void)configWithScheme:(NSString *)scheme target:(id)target instance:(SEL)instance action:(SEL)action {
    [self configWithScheme:scheme host:nil path:nil target:target instance:instance action:action];
}

- (void)configWithHost:(nullable NSString *)host path:(nullable NSString *)path target:(id)target instance:(SEL)instance action:(SEL)action {
    [self configWithScheme:nil host:host path:path target:target instance:instance action:action];
}

#pragma mark remove config

- (void)removeConfigWithScheme:(nullable NSString *)scheme host:(nullable NSString *)host path:(nullable NSString *)path {
    [self.actionHandlers removeObjectForKey:BJLURLActionKey(scheme, host, path)];
}

#pragma mark perform action

- (BOOL)performActionWithURL:(NSURL *)URL userInfo:(nullable id)userInfo completion:(nullable BJLURLActionCompletion)completion {
    if (!URL) {
        return NO;
    }
    
    if (self.validSchemes.count
        && ![self.validSchemes containsObject:URL.scheme.lowercaseString]) {
        return NO;
    }
    
    NSString *key = nil;
    BJLURLActionHandlerWrapper *handler = nil;
    
    if (URL.scheme.length) {
        if (URL.host.length) {
            if (URL.path.length) {
                // [ scheme:// host /path ]
                key = BJLURLActionKey(URL.scheme, URL.host, URL.path);
                handler = [self.actionHandlers objectForKey:key];
            }
            if (!handler) {
                // [ scheme:// host /     ]
                key = BJLURLActionKey(URL.scheme, URL.host, nil);
                handler = [self.actionHandlers objectForKey:key];
            }
        }
        if (!handler) {
            // [ scheme://      /path ]
            key = BJLURLActionKey(URL.scheme, nil, URL.path);
            handler = [self.actionHandlers objectForKey:key];
        }
        if (!handler) {
            // [ scheme://      /     ]
            key = BJLURLActionKey(URL.scheme, nil, nil);
            handler = [self.actionHandlers objectForKey:key];
        }
    }
    
    if (!handler && URL.host.length) {
        if (URL.path.length) {
            // [           host /path ]
            key = BJLURLActionKey(nil, URL.host, URL.path);
            handler = [self.actionHandlers objectForKey:key];
        }
        if (!handler) {
            // [           host /     ]
            key = BJLURLActionKey(nil, URL.host, nil);
            handler = [self.actionHandlers objectForKey:key];
        }
    }
    
    if (!handler) {
        // !!!: use / if !URL.path.length
        // [                /path ]
        // [                /     ]
        key = BJLURLActionKey(nil, nil, URL.path);
        handler = [self.actionHandlers objectForKey:key];
    }
    
    if (!handler) {
        return NO;
    }
    
    BJLURLAction *action = [BJLURLAction actionWithURL:URL];
    [handler handleAction:action userInfo:userInfo completion:^(id result) {
        if (completion) completion(action, result);
    }];
    return YES;
}

- (BOOL)performActionWithURLString:(NSString *)URLString completion:(nullable BJLURLActionCompletion)completion {
    NSURL *url = [NSURL URLWithString:URLString];
    return [self performActionWithURL:url userInfo:nil completion:completion];
}

@end

@implementation BJLURLActionManager (BJLURLChainingActions)

#pragma mark perform chaining action

- (BOOL)performChainingActionWithURL:(NSURL *)URL userInfo:(nullable id)userInfo completion:(nullable BJLURLActionCompletion)completion {
    return [self performActionWithURL:URL userInfo:userInfo completion:^(BJLURLAction *action, id result) {
        NSString *fragment = action.URL.fragment;
        NSURL *nextURL = [NSURL URLWithString:[fragment stringByRemovingPercentEncoding]];
        if (nextURL) {
            [self performChainingActionWithURL:nextURL userInfo:result completion:completion];
        }
        else {
            if (completion) completion(action, result);
        }
    }];
}

@end

NS_ASSUME_NONNULL_END
