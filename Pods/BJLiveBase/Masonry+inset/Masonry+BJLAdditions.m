//
//  Masonry+BJLAdditions.m
//  M9Dev
//
//  Created by MingLQ on 2017-04-05.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <objc/runtime.h>

#import "Masonry+BJLAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MASConstraint (BJLAdditions)

- (MASConstraint * (^)(void))bjl_priorityRequired {
    return ^id{
        self.priority(MASLayoutPriorityRequired);
        return self;
    };
}

@end

#pragma mark -

@interface MASViewConstraint (BJLAdditions)

@property (nonatomic, strong, readwrite) MASViewAttribute *secondViewAttribute;

@end

@implementation MASViewConstraint (BJLAdditions)

/**
 用于支持 bjl_safeAreaLayoutGuide 的 NSLayoutAttributeNotAnAttribute
 @see https://github.com/SnapKit/Masonry/pull/473
 */
+ (void)load {
    Class theClass = [self class];
    Method originalMethod = class_getInstanceMethod(theClass, @selector(setSecondViewAttribute:));
    Method swizzledMethod = class_getInstanceMethod(theClass, @selector(bjl_setSecondViewAttribute:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@dynamic secondViewAttribute;
- (void)bjl_setSecondViewAttribute:(id)secondViewAttribute {
    if ([secondViewAttribute isKindOfClass:MASViewAttribute.class]) {
        MASViewAttribute *attr = secondViewAttribute;
        if (attr.layoutAttribute == NSLayoutAttributeNotAnAttribute) {
            secondViewAttribute = [[MASViewAttribute alloc] initWithView:attr.view item:attr.item layoutAttribute:self.firstViewAttribute.layoutAttribute];;
        }
    }
    [self bjl_setSecondViewAttribute:secondViewAttribute];
}

@end

#pragma mark -

@implementation MAS_VIEW (BJLAdditions)

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuide {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeNotAnAttribute];
    }
#endif
    return nil;
}

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuideLeading {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeading];
    }
#endif
    return nil;
}

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuideTrailing {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTrailing];
    }
#endif
    return nil;
}

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuideLeft {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
    }
#endif
    return nil;
}

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuideRight {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
    }
#endif
    return nil;
}

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuideTop {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
    }
#endif
    return nil;
}

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuideBottom {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
    }
#endif
    return nil;
}

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuideWidth {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeWidth];
    }
#endif
    return nil;
}

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuideHeight {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeHeight];
    }
#endif
    return nil;
}

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuideCenterX {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeCenterX];
    }
#endif
    return nil;
}

- (nullable MASViewAttribute *)bjl_safeAreaLayoutGuideCenterY {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeCenterY];
    }
#endif
    return nil;
}

@end

NS_ASSUME_NONNULL_END
