//
//  NSInvocation+M9.h
//  M9Dev
//
//  Created by MingLQ on 2011-06-01.
//  Copyright (c) 2011 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* about returnValue:
 
 // if (strcmp(invocation.methodSignature.methodReturnType, @encode(id)) == 0)
 void *returnValue = nil;
 [self bjl_invokeWithSelector:selector returnValue:&returnValue];
 return (__bridge id)returnValue;
 
 // else, include Class, @see `Type Encodings`
 <#Type#> returnValue = <#default#>;
 [self bjl_invokeWithSelector:selector returnValue:&returnValue];
 return returnValue;
 
 @see https://stackoverflow.com/a/22034059/456536
 @see https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 */

@interface NSObject (BJL_NSInvocation)

/* invocation */
- (NSInvocation *)bjl_invocationWithSelector:(SEL)selector;
- (NSInvocation *)bjl_invocationWithSelector:(SEL)selector argument:(void *)argument;
- (NSInvocation *)bjl_invocationWithSelector:(SEL)selector arguments:(void *)argument, ...;

/* invoke */
- (void)bjl_invokeWithSelector:(SEL)selector;
- (void)bjl_invokeWithSelector:(SEL)selector argument:(void *)argument;
- (void)bjl_invokeWithSelector:(SEL)selector arguments:(void *)argument, ...;

/* invoke and return object */
- (id)bjl_invokeAndReturnObjectWithSelector:(SEL)selector;
- (id)bjl_invokeAndReturnObjectWithSelector:(SEL)selector argument:(void *)argument;
- (id)bjl_invokeAndReturnObjectWithSelector:(SEL)selector arguments:(void *)argument, ...;

/* invoke and get `returnValue` */
- (void)bjl_invokeWithSelector:(SEL)selector returnValue:(void *)returnValue;
- (void)bjl_invokeWithSelector:(SEL)selector returnValue:(void *)returnValue argument:(void *)argument;
- (void)bjl_invokeWithSelector:(SEL)selector returnValue:(void *)returnValue arguments:(void *)argument, ...;

@end

NS_ASSUME_NONNULL_END
