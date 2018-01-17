//
//  BJLMotionWindow.m
//  M9Dev
//
//  Created by MingLQ on 2016-08-19.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJLMotionWindow.h"

NSString * const BJLEventSubtypeMotionShakeNotification = @"BJLEventSubtypeMotionShakeNotification";
NSString * const BJLEventSubtypeMotionShakeStateKey = @"BJLEventSubtypeMotionShakeState";

@implementation BJLMotionWindow

#pragma mark -

// @see https://stackoverflow.com/a/1344634/456536

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [super motionBegan:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:BJLEventSubtypeMotionShakeNotification
         object:self
         userInfo:@{ BJLEventSubtypeMotionShakeStateKey: @(BJLEventSubtypeMotionShakeStateBegan) }];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [super motionEnded:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:BJLEventSubtypeMotionShakeNotification
         object:self
         userInfo:@{ BJLEventSubtypeMotionShakeStateKey: @(BJLEventSubtypeMotionShakeStateEnded) }];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [super motionCancelled:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:BJLEventSubtypeMotionShakeNotification
         object:self
         userInfo:@{ BJLEventSubtypeMotionShakeStateKey: @(BJLEventSubtypeMotionShakeStateCancelled) }];
    }
}

@end
