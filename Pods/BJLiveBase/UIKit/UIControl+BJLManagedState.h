//
//  UIControl+BJLManagedState.h
//  M9Dev
//
//  Created by MingLQ on 2015-08-11.
//  Copyright (c) 2015 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <UIKit/UIKit.h>

#import "NSObject+BJLObserving.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (BJLManagedState)

/**
 enable KVO-ing `state` via enabled, selected, highlighted
 */
+ (NSSet<NSString *> *)keyPathsForValuesAffectingState;

#pragma mark -

/**
 disable for seconds then auto enable or callback
 - timer will NOT start if enabled state is already NO
 - timer will be CANCELLED if enabled state changed before timeout
 */
- (void)bjl_disableForSeconds:(NSTimeInterval)seconds;
- (void)bjl_disableForSeconds:(NSTimeInterval)seconds thenCallback:(void (^)(__kindof UIControl * _Nullable sender))callback;
- (void)bjl_removePreviousCallback;

@end

NS_ASSUME_NONNULL_END
