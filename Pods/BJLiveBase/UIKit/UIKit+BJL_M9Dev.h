//
//  UIKit+BJL_M9Dev.h
//  M9Dev
//
//  Created by MingLQ on 2016-04-21.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (BJL_M9Dev)

- (nullable UIResponder *)bjl_closestResponderOfClass:(Class)clazz; // NOT include self
- (nullable UIResponder *)bjl_closestResponderOfClass:(Class)clazz includeSelf:(BOOL)includeSelf;
- (nullable UIResponder *)bjl_findResponderWithBlock:(BOOL (^)(UIResponder *responder, BOOL *stop))enumerateBlock;

@end

#pragma mark -

@interface UIView (BJL_M9Dev)

- (nullable __kindof UIView *)bjl_closestViewOfClass:(Class)clazz; // NOT include self
- (nullable __kindof UIView *)bjl_closestViewOfClass:(Class)clazz includeSelf:(BOOL)includeSelf; // up to UIViewController
- (nullable __kindof UIView *)bjl_closestViewOfClass:(Class)clazz includeSelf:(BOOL)includeSelf upToResponder:(nullable UIResponder *)upToResponder; // NOT include the upToResponder, nil - up to UIViewController
- (nullable __kindof UIViewController *)bjl_closestViewController;

- (void)bjl_eachSubview:(BOOL (^)(__kindof UIView *subview, NSInteger depth))callback;

- (void)bjl_removeAllConstraints;

@end

#pragma mark -

@interface UIViewController (BJL_M9Dev)

- (void)bjl_addChildViewController:(UIViewController *)childViewController;
- (void)bjl_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview;
- (void)bjl_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview atIndex:(NSInteger)index;
- (void)bjl_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview belowSubview:(UIView *)siblingSubview;
- (void)bjl_addChildViewController:(UIViewController *)childViewController superview:(UIView *)superview aboveSubview:(UIView *)siblingSubview;
- (void)bjl_addChildViewController:(UIViewController *)childViewController addSubview:(void (^)(UIView *parentView, UIView *childView))addSubview; // synchronous
- (void)bjl_removeFromParentViewControllerAndSuperiew;

/**
 *  differences from dismissViewControllerAnimated:completion:
 *  1. always call completion although nothing to dismiss
 *  2. only dismiss self, but not parentViewController
 */
- (void)bjl_dismissAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
/**
 *  differences from dismissViewControllerAnimated:completion:
 *  1. always call completion although nothing to dismiss
 *  2. only dismiss presentedViewController, but not self
 */
- (void)bjl_dismissPresentedViewControllerAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
+ (nullable UIViewController *)bjl_gotoRootViewControllerAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion DEPRECATED_MSG_ATTRIBUTE("should be implemented by apps");

+ (nullable UIViewController *)bjl_rootViewController;
+ (nullable UIViewController *)bjl_topViewController;

// @see - [UINavigationController bjl_navigationControllerWithRootViewController:self];
- (UINavigationController *)bjl_wrapWithNavigationController;

@end

#pragma mark -

@interface UINavigationController (BJL_M9Dev)

@property (nonatomic, strong, readonly, nullable) UIViewController *bjl_rootViewController;

// !!!: navigationController.interactivePopGestureRecognizer.delegate == navigationController
+ (UINavigationController *)bjl_navigationControllerWithRootViewController:(nullable UIViewController *)rootViewController;
+ (UINavigationController *)bjl_navigationControllerWithRootViewController:(nullable UIViewController *)rootViewController
                                                        navigationBarClass:(nullable Class)navigationBarClass
                                                              toolbarClass:(nullable Class)toolbarClass;

- (void)bjl_pushViewController:(UIViewController *)viewController
                      animated:(BOOL)animated
                    completion:(void (^ _Nullable)(void))completion;

- (nullable UIViewController *)bjl_popViewControllerAnimated:(BOOL)animated
                                                  completion:(void (^ _Nullable)(void))completion;
- (nullable NSArray *)bjl_popToViewController:(UIViewController *)viewController
                                     animated:(BOOL)animated
                                   completion:(void (^ _Nullable)(void))completion;
- (nullable NSArray *)bjl_popToRootViewControllerAnimated:(BOOL)animated
                                               completion:(void (^ _Nullable)(void))completion;

#pragma mark - <UINavigationControllerDelegate>

- (id<UINavigationControllerDelegate>)bjl_asDelegate;

/**
 *  #return self.topViewController.supportedInterfaceOrientations if has self.topViewController
 *  or UIInterfaceOrientationMaskAllButUpsideDown for iPhone
 *  otherwise UIInterfaceOrientationMaskAll
 */
- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController;

/**
 *  #return self.topViewController.preferredInterfaceOrientationForPresentation if has self.topViewController
 *  otherwise UIInterfaceOrientationPortrait
 */
- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController;

@end

#pragma mark -

@interface UIColor (BJL_M9Dev)

// @"#FFFFFF"
+ (nullable UIColor *)bjl_colorWithHexString:(NSString *)hexString;
+ (nullable UIColor *)bjl_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
// 0xFFFFFF
+ (nullable UIColor *)bjl_colorWithHex:(unsigned)hex;
+ (nullable UIColor *)bjl_colorWithHex:(unsigned)hex alpha:(CGFloat)alpha;

@end

#pragma mark -

@interface UIImage (BJL_M9Dev)

- (UIImage *)bjl_resizableImage;

/**
 #return UIImage with the scale factor of the device’s main screen
 */
- (UIImage *)bjl_imageFillSize:(CGSize)size; // enlarge: NO
- (UIImage *)bjl_imageFillSize:(CGSize)size enlarge:(BOOL)enlarge; // aspect fill & cropped

/**
 #return UIImage with the scale factor of the device’s main screen
 */
+ (nullable UIImage *)bjl_imageWithColor:(UIColor *)color;
+ (nullable UIImage *)bjl_imageWithColor:(UIColor *)color size:(CGSize)size;

@end

#pragma mark -

extern CGFloat BJL1Pixel(void);

static inline CGFloat BJLFloorWithScreenScale(CGFloat size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return floor(size * scale) / scale;
}
static inline CGFloat BJLCeilWithScreenScale(CGFloat size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return ceil(size * scale) / scale;
}

static inline CGSize BJLAspectFillSize(CGSize size, CGFloat aspectRatio) {
    return CGSizeMake(MAX(size.width, BJLCeilWithScreenScale(size.height * aspectRatio)),
                      MAX(size.height, BJLCeilWithScreenScale(size.width / aspectRatio)));
}
static inline CGSize BJLAspectFitSize(CGSize size, CGFloat aspectRatio) {
    return CGSizeMake(MIN(size.width, BJLCeilWithScreenScale(size.height * aspectRatio)),
                      MIN(size.height, BJLCeilWithScreenScale(size.width / aspectRatio)));
}

static inline CGRect BJLAspectFillFrame(CGRect frame, CGFloat aspectRatio) {
    CGSize size = BJLAspectFillSize(frame.size, aspectRatio);
    return CGRectMake(MIN(0.0, BJLFloorWithScreenScale((CGRectGetWidth(frame) - size.width) / 2)),
                      MIN(0.0, BJLFloorWithScreenScale((CGRectGetHeight(frame) - size.height) / 2)),
                      size.width,
                      size.height);
}
static inline CGRect BJLAspectFitFrame(CGRect frame, CGFloat aspectRatio) {
    CGSize size = BJLAspectFitSize(frame.size, aspectRatio);
    return CGRectMake(MAX(0.0, BJLFloorWithScreenScale((CGRectGetWidth(frame) - size.width) / 2)),
                      MAX(0.0, BJLFloorWithScreenScale((CGRectGetHeight(frame) - size.height) / 2)),
                      size.width,
                      size.height);
}

static inline CGSize BJLImageViewSize(CGSize imgSize, CGSize minSize, CGSize maxSize) {
    CGFloat minScale = MAX(imgSize.width / maxSize.width, imgSize.height / maxSize.height);
    CGFloat maxScale = MIN(imgSize.width / minSize.width, imgSize.height / minSize.height);
    CGFloat scale = MIN(MAX(minScale, 1.0), maxScale); // 等比显示、最少缩放
    return CGSizeMake(MIN(imgSize.width / scale, maxSize.width),
                      MIN(imgSize.height / scale, maxSize.height)); // 超出部分裁切
}

#pragma mark -

// iPhone X: iPhone10,3 || iPhone10,6
// Simultor.Any: i386 || x86_64
static inline NSString * BJLHardwareType() {
    struct utsname systemInfo;
    uname(&systemInfo);
    return @(systemInfo.machine);
}

NS_ASSUME_NONNULL_END
