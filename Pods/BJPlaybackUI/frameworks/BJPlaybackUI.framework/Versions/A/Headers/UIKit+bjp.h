//
//  UIKit+bjp.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/22.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static inline CGSize BJPImageViewSize(CGSize imgSize, CGSize minSize, CGSize maxSize) {
    CGFloat minScale = MAX(imgSize.width / maxSize.width, imgSize.height / maxSize.height);
    CGFloat maxScale = MIN(imgSize.width / minSize.width, imgSize.height / minSize.height);
    CGFloat scale = MIN(MAX(minScale, 1.0), maxScale); // 等比显示、最少缩放
    return CGSizeMake(MIN(imgSize.width / scale, maxSize.width),
                      MIN(imgSize.height / scale, maxSize.height)); // 超出部分裁切
}


@interface UIControl (handler)

- (id)bjp_addHandler:(void (^)(__kindof UIControl * _Nullable sender))handler
    forControlEvents:(UIControlEvents)controlEvents;

- (void)bjp_removeHandlerForTarget:(id)target forControlEvents:(UIControlEvents)controlEvents;

- (void)bjp_removeHandlerForControlEvents:(UIControlEvents)controlEvents;

@end

#pragma mark -

@interface UIGestureRecognizer (handler)

+ (instancetype)bjp_gestureWithHandler:(void (^)(__kindof UIGestureRecognizer * _Nullable gesture))handler;

- (id)bjp_addHandler:(void (^)(__kindof UIGestureRecognizer * _Nullable gesture))handler;

- (void)bjp_removeHandlerForTarget:(id)target;

@end

@interface UIResponder (bjp)

- (nullable UIResponder *)bjp_closestResponderOfClass:(Class)clazz; // NOT include self
- (nullable UIResponder *)bjp_closestResponderOfClass:(Class)clazz includeSelf:(BOOL)includeSelf;
- (nullable UIResponder *)bjp_findResponderWithBlock:(BOOL (^)(UIResponder *responder, BOOL *stop))enumerateBlock;

@end

@interface UIView (bjp)

- (nullable __kindof UIView *)bjp_closestViewOfClass:(Class)clazz; // NOT include self
- (nullable __kindof UIView *)bjp_closestViewOfClass:(Class)clazz includeSelf:(BOOL)includeSelf; // up to UIViewController
- (nullable __kindof UIView *)bjp_closestViewOfClass:(Class)clazz includeSelf:(BOOL)includeSelf upToResponder:(nullable UIResponder *)upToResponder; // NOT include the upToResponder, nil - up to UIViewController
- (nullable __kindof UIViewController *)bjp_closestViewController;

@end

#pragma mark -

@interface UIViewController (bjp)

- (void)bjp_addChildViewController:(UIViewController *)childViewController;
- (void)bjp_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview;
- (void)bjp_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview atIndex:(NSInteger)index;
- (void)bjp_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview belowSubview:(UIView *)siblingSubview;
- (void)bjp_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview aboveSubview:(UIView *)siblingSubview;
- (void)bjp_addChildViewController:(UIViewController *)childViewController addSubview:(void (^)(UIView *parentView, UIView *childView))addSubview;
- (void)bjp_removeFromParentViewControllerAndSuperiew;

/**
 *  differences from dismissViewControllerAnimated:completion:
 *  1. always call completion although no presentedViewController
 *  2. only dismiss the presentedViewController, but not self
 */
- (void)bjp_dismissPresentedViewControllerAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

+ (nullable UIViewController *)bjp_rootViewController;

@end

NS_ASSUME_NONNULL_END

