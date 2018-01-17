//
//  NSInvocation+M9.m
//  M9Dev
//
//  Created by MingLQ on 2011-06-01.
//  Copyright (c) 2011 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "NSInvocation+BJL_M9Dev.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSObject (BJL_NSInvocation)

- (NSInvocation *)bjl_invocationWithSelector:(SEL)selector {
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation retainArguments];
    return invocation;
}

// @see http://www.cocoawithlove.com/2009/05/variable-argument-lists-in-cocoa.html
- (NSInvocation *)bjl_invocationWithSelector:(SEL)selector argList:(va_list)argList start:(void *)start {
    NSInvocation *invocation = [self bjl_invocationWithSelector:selector];
    NSUInteger index = 2, numberOfArguments = invocation.methodSignature.numberOfArguments;
    id nilLocation = nil;
    for (void *argumentLocation = start; index < numberOfArguments/* argumentLocation != nil */; argumentLocation = va_arg(argList, void *)) {
        [invocation setArgument:argumentLocation ?: &nilLocation atIndex:index++];
    }
    return invocation;
}

- (NSInvocation *)bjl_invocationWithSelector:(SEL)selector argument:(void *)argument {
    return [self bjl_invocationWithSelector:selector arguments:argument];
}

- (NSInvocation *)bjl_invocationWithSelector:(SEL)selector arguments:(void *)start, ... {
    va_list argList;
    va_start(argList, start);
    NSInvocation *invocation = [self bjl_invocationWithSelector:selector argList:argList start:start];
    va_end(argList);
    return invocation;
}

- (void)bjl_invokeWithSelector:(SEL)selector {
    [[self bjl_invocationWithSelector:selector] invoke];
}

- (void)bjl_invokeWithSelector:(SEL)selector argument:(void *)argument {
    [self bjl_invokeWithSelector:selector arguments:argument];
}

- (void)bjl_invokeWithSelector:(SEL)selector arguments:(void *)start, ... {
    va_list argList;
    va_start(argList, start);
    [[self bjl_invocationWithSelector:selector argList:argList start:start] invoke];
    va_end(argList);
}

- (id)bjl_invokeAndReturnObjectWithSelector:(SEL)selector {
    NSInvocation *invocation = [self bjl_invocationWithSelector:selector];
    [invocation invoke];
    if (strcmp(invocation.methodSignature.methodReturnType, @encode(id)) == 0) {
        void *returnValue = nil;
        [invocation getReturnValue:&returnValue];
        return (__bridge id)returnValue;
    }
    return nil;
}

- (id)bjl_invokeAndReturnObjectWithSelector:(SEL)selector argument:(void *)argument {
    return [self bjl_invokeAndReturnObjectWithSelector:selector arguments:argument];
}

- (id)bjl_invokeAndReturnObjectWithSelector:(SEL)selector arguments:(void *)start, ... {
    va_list argList;
    va_start(argList, start);
    NSInvocation *invocation = [self bjl_invocationWithSelector:selector argList:argList start:start];
    va_end(argList);
    [invocation invoke];
    if (strcmp(invocation.methodSignature.methodReturnType, @encode(id)) == 0) {
        void *returnValue = nil;
        [invocation getReturnValue:&returnValue];
        return (__bridge id)returnValue;
    }
    return nil;
}

- (void)bjl_invokeWithSelector:(SEL)selector returnValue:(void *)returnValue {
    NSInvocation *invocation = [self bjl_invocationWithSelector:selector];
    [invocation invoke];
    if (strcmp(invocation.methodSignature.methodReturnType, @encode(void)) != 0) {
        [invocation getReturnValue:returnValue];
    }
}

- (void)bjl_invokeWithSelector:(SEL)selector returnValue:(void *)returnValue argument:(void *)argument {
    [self bjl_invokeWithSelector:selector returnValue:returnValue arguments:argument];
}

- (void)bjl_invokeWithSelector:(SEL)selector returnValue:(void *)returnValue arguments:(void *)start, ... {
    va_list argList;
    va_start(argList, start);
    NSInvocation *invocation = [self bjl_invocationWithSelector:selector argList:argList start:start];
    va_end(argList);
    [invocation invoke];
    if (strcmp(invocation.methodSignature.methodReturnType, @encode(void)) != 0) {
        [invocation getReturnValue:returnValue];
    }
}

@end

NS_ASSUME_NONNULL_END
