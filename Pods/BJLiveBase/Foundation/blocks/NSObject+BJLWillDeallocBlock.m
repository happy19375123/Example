//
//  NSObject+BJLWillDeallocBlock.m
//  M9Dev
//
//  Created by MingLQ on 2016-11-28.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <objc/message.h>
#import <objc/runtime.h>

#import "NSObject+BJLWillDeallocBlock.h"

NS_ASSUME_NONNULL_BEGIN

/**** copied from rac ... ****/

static NSMutableSet *bjl_rac_swizzledClasses() {
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    
    return swizzledClasses;
}

static void bjl_rac_swizzleDeallocIfNeeded(Class classToSwizzle) {
    @synchronized (bjl_rac_swizzledClasses()) {
        NSString *className = NSStringFromClass(classToSwizzle);
        if ([bjl_rac_swizzledClasses() containsObject:className]) return;
        
        SEL deallocSelector = sel_registerName("dealloc");
        
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        
        id newDealloc = ^(__unsafe_unretained id self) {
            /** bjl custom ... **/
            BJLWillDeallocBlock willDeallocBlock = [self bjl_willDeallocBlock];
            if (willDeallocBlock) willDeallocBlock(self);
            /** bjl custom end **/
            
            if (originalDealloc == NULL) {
                struct objc_super superInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(classToSwizzle)
                };
                
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            }
            else {
                originalDealloc(self, deallocSelector);
            }
        };
        
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        
        if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, "v@:")) {
            // The class already contains a method implementation.
            Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
            
            // We need to store original implementation before setting new implementation
            // in case method is called at the time of setting.
            originalDealloc = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
            
            // We need to store original implementation again, in case it just changed.
            originalDealloc = (__typeof__(originalDealloc))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        
        [bjl_rac_swizzledClasses() addObject:className];
    }
}

/**** copied from rac end ****/

@implementation NSObject (BJLWillDeallocBlock)

static void *BJL_willDeallocBlock = &BJL_willDeallocBlock;

- (nullable BJLWillDeallocBlock)bjl_willDeallocBlock {
    return objc_getAssociatedObject(self, BJL_willDeallocBlock);
}

- (void)bjl_setWillDeallocBlock:(void (^ _Nullable)(id instance))willDeallocBlock {
    if (willDeallocBlock) {
        bjl_rac_swizzleDeallocIfNeeded([self class]);
    }
    objc_setAssociatedObject(self, BJL_willDeallocBlock, willDeallocBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

NS_ASSUME_NONNULL_END
