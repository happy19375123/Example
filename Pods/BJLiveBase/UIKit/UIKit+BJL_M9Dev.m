//
//  UIKit+BJL_M9Dev.m
//  M9Dev
//
//  Created by MingLQ on 2016-04-21.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <objc/runtime.h>

#import "BJL_M9Dev.h"

#import "UIKit+BJL_M9Dev.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIResponder (BJL_M9Dev)

- (nullable UIResponder *)bjl_closestResponderOfClass:(Class)clazz {
    return [self bjl_closestResponderOfClass:clazz includeSelf:NO];
}

- (nullable UIResponder *)bjl_closestResponderOfClass:(Class)clazz includeSelf:(BOOL)includeSelf {
    if (![clazz isSubclassOfClass:[UIResponder class]]) {
        return nil;
    }
    return [self bjl_findResponderWithBlock:^BOOL(UIResponder *responder, BOOL *stop) {
        return ((includeSelf || responder != self)
                && [responder isKindOfClass:clazz]);
    }];
}

- (nullable UIResponder *)bjl_findResponderWithBlock:(BOOL (^)(UIResponder *responder, BOOL *stop))findingBlock {
    BOOL stop = NO;
    UIResponder *responder = self;
    do {
        if (findingBlock(responder, &stop)) {
            return responder;
        }
    } while (!stop && (responder = responder.nextResponder));
    return nil;
}

@end

#pragma mark -

@implementation UIView (BJL_M9Dev)

- (nullable __kindof UIView *)bjl_closestViewOfClass:(Class)clazz {
    return [self bjl_closestViewOfClass:clazz includeSelf:NO];
}

- (nullable __kindof UIView *)bjl_closestViewOfClass:(Class)clazz includeSelf:(BOOL)includeSelf {
    return [self bjl_closestViewOfClass:clazz includeSelf:includeSelf upToResponder:nil];
}

- (nullable __kindof UIView *)bjl_closestViewOfClass:(Class)clazz includeSelf:(BOOL)includeSelf upToResponder:(nullable UIResponder *)upToResponder {
    if (clazz == [UIView class]) {
        return includeSelf ? self : self.superview;
    }
    if (![clazz isSubclassOfClass:[UIView class]]) {
        return nil;
    }
    return (UIView *)[self bjl_findResponderWithBlock:^BOOL(UIResponder *responder, BOOL *stop) {
        *stop = (upToResponder
                 ? (responder == upToResponder)
                 : [responder isKindOfClass:[UIViewController class]]);
        if (*stop) {
            return NO;
        }
        BOOL found = ((includeSelf || responder != self)
                      && [responder isKindOfClass:clazz]);
        return found;
    }];
}

- (nullable __kindof UIViewController *)bjl_closestViewController {
    return (UIViewController *)[self bjl_closestResponderOfClass:[UIViewController class]];
}

- (void)bjl_eachSubview:(BOOL (^)(__kindof UIView *subview, NSInteger depth))callback {
    if (!callback) {
        return;
    }
    [self bjl_eachView:self depth:0 callback:callback];
}

- (void)bjl_eachView:(__kindof UIView *)view
               depth:(NSInteger)depth
            callback:(BOOL (^)(UIView *subview, NSInteger depth))callback {
    BOOL goon = callback(view, depth);
    if (!goon) {
        return;
    }
    for (__kindof UIView *subview in view.subviews) {
        [self bjl_eachView:subview depth:depth + 1 callback:callback];
    }
}

// @see https://stackoverflow.com/a/30491911/456536
- (void)bjl_removeAllConstraints {
    UIView *superview = self;
    while ((superview = superview.superview)) {
        for (NSLayoutConstraint *constraint in superview.constraints) {
            if (constraint.firstItem == self || constraint.secondItem == self) {
                [superview removeConstraint:constraint];
            }
        }
    }
    [self removeConstraints:self.constraints];
}

@end

#pragma mark -

@implementation UIViewController (BJL_M9Dev)

- (void)bjl_addChildViewController:(UIViewController *)childViewController {
    [self bjl_addChildViewController:childViewController superview:self.view];
}

- (void)bjl_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview {
    if (!childViewController || !childViewController.view) return;
    /* The addChildViewController: method automatically calls the willMoveToParentViewController: method
     * of the view controller to be added as a child before adding it.
     */
    [self addChildViewController:childViewController]; // 1
    [superview addSubview:childViewController.view]; // 2
    [childViewController didMoveToParentViewController:self]; // 3
}

- (void)bjl_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview atIndex:(NSInteger)index {
    if (!childViewController || !childViewController.view) return;
    [self addChildViewController:childViewController]; // 1
    [superview insertSubview:childViewController.view atIndex:index]; // 2
    [childViewController didMoveToParentViewController:self]; // 3
}

- (void)bjl_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview belowSubview:(UIView *)siblingSubview {
    if (!childViewController || !childViewController.view) return;
    [self addChildViewController:childViewController]; // 1
    [superview insertSubview:childViewController.view belowSubview:siblingSubview]; // 2
    [childViewController didMoveToParentViewController:self]; // 3
}

- (void)bjl_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview aboveSubview:(UIView *)siblingSubview {
    if (!childViewController || !childViewController.view) return;
    [self addChildViewController:childViewController]; // 1
    [superview insertSubview:childViewController.view aboveSubview:siblingSubview]; // 2
    [childViewController didMoveToParentViewController:self]; // 3
}

- (void)bjl_addChildViewController:(UIViewController *)childViewController addSubview:(void (^)(UIView *parentView, UIView *childView))addSubview {
    if (!childViewController || !childViewController.view) return;
    [self addChildViewController:childViewController]; // 1
    addSubview(self.view, childViewController.view); // 2
    [childViewController didMoveToParentViewController:self]; // 3
}

- (void)bjl_removeFromParentViewControllerAndSuperiew {
    [self willMoveToParentViewController:nil]; // 1
    /* The removeFromParentViewController method automatically calls the didMoveToParentViewController: method
     * of the child view controller after it removes the child.
     */
    [self.view removeFromSuperview]; // 2
    [self removeFromParentViewController]; // 3
}

- (void)bjl_dismissAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    if (!self.presentingViewController || self.beingDismissed) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion) completion();
        });
        return;
    }
    
    // !!!: completion will NOT be called if no presentedViewController
    [self dismissViewControllerAnimated:animated completion:completion];
}

- (void)bjl_dismissPresentedViewControllerAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    if (!self.presentedViewController || self.presentedViewController.beingDismissed) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion) completion();
        });
        return;
    }
    
    // !!!: completion will NOT be called if no presentedViewController
    [self dismissViewControllerAnimated:animated completion:completion];
}

+ (nullable UIViewController *)bjl_gotoRootViewControllerAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    UIViewController *rootViewController = [self bjl_rootViewController];
    [rootViewController bjl_dismissPresentedViewControllerAnimated:animated completion:^{
        UITabBarController *tabBarController = bjl_cast(UITabBarController, rootViewController);
        UINavigationController *navigationController = bjl_cast(UINavigationController, tabBarController.selectedViewController ?: rootViewController);
        if (navigationController) {
            [navigationController bjl_popToRootViewControllerAnimated:animated completion:completion];
        }
        else {
            if (completion) completion();
        }
    }];
    return rootViewController;
}

+ (nullable UIViewController *)bjl_rootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

+ (nullable UIViewController *)bjl_topViewController {
    UIViewController *topViewController = [self bjl_rootViewController];
    UITabBarController *tabBarController = bjl_cast(UITabBarController, topViewController);
    if (tabBarController.selectedViewController) {
        topViewController = tabBarController.selectedViewController;
    }
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    UINavigationController *navigationController = bjl_cast(UINavigationController, topViewController);
    if ([navigationController.viewControllers count]) {
        topViewController = navigationController.viewControllers.lastObject;
    }
    return topViewController;
}

- (UINavigationController *)bjl_wrapWithNavigationController {
    return [UINavigationController bjl_navigationControllerWithRootViewController:self];
}

@end

#pragma mark -

/**
 *  解决自定义 NavBar、backBarButtonItem 导致的返回手势、动画相关的问题
 *  原因：
 *      XXViewController 定制了返回按钮或隐藏了导航栏，导致从屏幕左侧的返回手势失效；
 *      清除默认 navigationController.interactivePopGestureRecognizer.delegate 可解决问题；
 *      @see http://stuartkhall.com/posts/ios-7-development-tips-tricks-hacks
 *      但是这个办法并不完美，有 BUG！
 *  BUG：
 *      当 self.viewControllers 只有一个 rootViewController，此时从屏幕左侧滑入，然后快速点击控件 push 进新的 XXViewController；
 *      此时 rootViewController 页面不响应点击、拖动时间，再次从屏幕左侧滑入后显示新的 viewController，但点击返回按钮无响应、并可能发生崩溃；
 *  解决：
 *      navigationController.interactivePopGestureRecognizer.delegate 需实现此方法
 *          UIGestureRecognizerDelegate - gestureRecognizerShouldBegin:
 *      当 gestureRecognizer 是 navigationController.interactivePopGestureRecognizer、并且 [navigationController.viewControllers count] 小于等于 1 时返回 NO；
 *      @see https://stackoverflow.com/a/20672693/456536
 */
@interface BJLNavigationController : UINavigationController <UIGestureRecognizerDelegate>

@property (nonatomic) BOOL bjl_isPushAnimating;

@end

@implementation BJLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
     // !!!: init 时 self.interactivePopGestureRecognizer 为空，所以要写在这里
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        if (self.bjl_isPushAnimating) {
            return;
        }
        self.bjl_isPushAnimating = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.bjl_isPushAnimating = NO;
        });
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return !self.bjl_isPushAnimating && [self.viewControllers count] > 1;
    }
    return YES;
}

@end

@implementation UINavigationController (BJL_M9Dev)

+ (UINavigationController *)bjl_navigationControllerWithRootViewController:(nullable UIViewController *)rootViewController {
    return [self bjl_navigationControllerWithRootViewController:rootViewController
                                             navigationBarClass:nil
                                                   toolbarClass:nil];
}

+ (UINavigationController *)bjl_navigationControllerWithRootViewController:(nullable UIViewController *)rootViewController
                                                        navigationBarClass:(nullable Class)navigationBarClass
                                                              toolbarClass:(nullable Class)toolbarClass {
    UINavigationController *navigationController = [[BJLNavigationController alloc]
                                                    initWithNavigationBarClass:navigationBarClass ? : [UINavigationBar class]
                                                    toolbarClass:toolbarClass ? : [UIToolbar class]];
    [navigationController pushViewController:rootViewController animated:NO];
    return navigationController;
}

@dynamic bjl_rootViewController;
- (nullable UIViewController *)bjl_rootViewController {
    return self.viewControllers.firstObject;
}

- (void)bjl_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self pushViewController:viewController animated:animated];
    [CATransaction commit];
}

- (nullable UIViewController *)bjl_popViewControllerAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    UIViewController *poppedViewController = [self popViewControllerAnimated:animated];
    [CATransaction commit];
    return poppedViewController;
}

- (nullable NSArray *)bjl_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    NSArray *poppedViewControllers = [self popToViewController:viewController animated:animated];
    [CATransaction commit];
    return poppedViewControllers;
}

- (nullable NSArray *)bjl_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    NSArray *poppedViewControllers = [self popToRootViewControllerAnimated:animated];
    [CATransaction commit];
    return poppedViewControllers;
}

#pragma mark - <UINavigationControllerDelegate>

- (id<UINavigationControllerDelegate>)bjl_asDelegate {
    return (id<UINavigationControllerDelegate>)self;
}

/* !!!: 旋转方向由 topViewController 决定
 */
- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return (self.topViewController
            ? self.topViewController.supportedInterfaceOrientations
            : (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
               ? UIInterfaceOrientationMaskAllButUpsideDown
               : UIInterfaceOrientationMaskAll));
}

/* !!!: 旋转方向由 topViewController 决定
 */
- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    return (self.topViewController
            ? self.topViewController.preferredInterfaceOrientationForPresentation
            : UIInterfaceOrientationPortrait);
}

@end

#pragma mark -

@implementation UIColor (BJL_M9Dev)

+ (nullable UIColor *)bjl_colorWithHexString:(NSString *)hexString {
    return [self bjl_colorWithHexString:hexString alpha:1.0];
}

+ (nullable UIColor *)bjl_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    if ([[hexString lowercaseString] hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    if ([hexString length] != 6) {
        return nil;
    }
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexString];
    unsigned hexValue = 0;
    if ([scanner scanHexInt:&hexValue] && [scanner isAtEnd]) {
        return [self bjl_colorWithHex:hexValue alpha:alpha];
    }
    
    return nil;
}

+ (nullable UIColor *)bjl_colorWithHex:(unsigned)hex {
    return [self bjl_colorWithHex:hex alpha:1.0];
}

+ (nullable UIColor *)bjl_colorWithHex:(unsigned)hex alpha:(CGFloat)alpha {
    int r = ((hex & 0xFF0000) >> 16);
    int g = ((hex & 0x00FF00) >>  8);
    int b = ( hex & 0x0000FF)       ;
    return [self colorWithRed:((CGFloat)r / 255)
                        green:((CGFloat)g / 255)
                         blue:((CGFloat)b / 255)
                        alpha:alpha];
}

@end

#pragma mark -

static const CGFloat BJL_UIGraphicsUseScreenScale = 0.0;

@implementation UIImage (BJL_M9Dev)

- (UIImage *)bjl_resizableImage {
    CGFloat x = MAX(self.size.width / 2 - 1.0, 0.0), y = MAX(self.size.height / 2 - 1.0, 0.0);
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(y, x, y, x)];
}

- (UIImage *)bjl_imageFillSize:(CGSize)size {
    return [self bjl_imageFillSize:size enlarge:NO];
}

- (UIImage *)bjl_imageFillSize:(CGSize)size enlarge:(BOOL)enlarge {
    if (CGSizeEqualToSize(size, self.size)
        || (!enlarge && (self.size.width < size.width || self.size.height < size.height))) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, BJL_UIGraphicsUseScreenScale);
    [self drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (nullable UIImage *)bjl_imageWithColor:(UIColor *)color {
    return [[self bjl_imageWithColor:color size:CGSizeMake(1.0, 1.0)] bjl_resizableImage];
}

+ (nullable UIImage *)bjl_imageWithColor:(UIColor *)color size:(CGSize)size {
    color = color ? color : [UIColor clearColor];
    UIGraphicsBeginImageContextWithOptions(size, NO, BJL_UIGraphicsUseScreenScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
 aspect fit the size dimension*dimension
 @see FLEX - https://github.com/Flipboard/FLEX
+ (UIImage *)bjl_thumbnailedImageWithMaxDimension:(NSInteger)dimension fromImageData:(NSData *)data {
    UIImage *thumbnail = nil;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (imageSource) {
        CGFloat scale = [UIScreen mainScreen].scale;
        NSDictionary *options = @{ (__bridge id)kCGImageSourceCreateThumbnailWithTransform: @YES,
                                   (__bridge id)kCGImageSourceCreateThumbnailFromImageAlways: @YES,
                                   (__bridge id)kCGImageSourceThumbnailMaxPixelSize: @(dimension * scale) };
        
        CGImageRef scaledImageRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (__bridge CFDictionaryRef)options);
        if (scaledImageRef) {
            thumbnail = [UIImage imageWithCGImage:scaledImageRef scale:scale orientation:UIImageOrientationUp];
            CFRelease(scaledImageRef);
        }
        CFRelease(imageSource);
    }
    return thumbnail;
} */

@end

#pragma mark -

CGFloat BJL1Pixel(void) {
    static CGFloat _BJL1Pixel_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _BJL1Pixel_ = 1.0 / [UIScreen mainScreen].scale;
    });
    return _BJL1Pixel_;
}

NS_ASSUME_NONNULL_END
