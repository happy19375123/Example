//
//  UIControl+BJLManagedState.m
//  M9Dev
//
//  Created by MingLQ on 2015-08-11.
//  Copyright (c) 2015 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <objc/runtime.h>

#import "UIControl+BJLManagedState.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIControl (BJLManagedState)

+ (NSSet<NSString *> *)keyPathsForValuesAffectingState {
    return [NSSet setWithObjects:@"enabled", @"selected", @"highlighted", nil];
}

#pragma mark -

static void *BJLDisableCallback = &BJLDisableCallback;

- (void)bjl_disableForSeconds:(NSTimeInterval)seconds {
    [self bjl_disableForSeconds:seconds thenCallback:^(__kindof UIControl * _Nullable sender) {
        sender.enabled = YES;
    }];
}

- (void)bjl_disableForSeconds:(NSTimeInterval)seconds thenCallback:(void (^)(__kindof UIControl * _Nullable sender))callback {
    if (seconds <= 0.0) {
        return;
    }
    
    self.enabled = NO;
    
    __weak typeof(self) __weak_self = self;
    
    // state changed
    [self bjl_kvo:BJLMakeProperty(self, enabled)
          options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
         observer:^BOOL(id _Nullable old, NSNumber * _Nullable now) {
             __strong typeof(__weak_self) self = __weak_self;
             [self bjl_removePreviousCallback];
             return NO;
         }];
    
    // timeout
    objc_setAssociatedObject(self, BJLDisableCallback, callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(__weak_self) self = __weak_self;
        void (^savedCallback)(__kindof UIControl * _Nullable sender) = objc_getAssociatedObject(self, BJLDisableCallback);
        if (savedCallback && savedCallback == callback) {
            [self bjl_removePreviousCallback];
            if (savedCallback) savedCallback(self);
        }
    });
}

- (void)bjl_removePreviousCallback {
    objc_setAssociatedObject(self, BJLDisableCallback, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

NS_ASSUME_NONNULL_END
