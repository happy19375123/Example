//
//  BJLProgressHUD.h
//  M9Dev
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

static const NSTimeInterval BJLProgressHUDTimeInterval = 2.0;

/**
 *  MBProgressHUDConfig     MBProgressHUD config block
 *  #param hud              hud instance to config
 *  #return return          hud display time interval
 */
typedef NSTimeInterval (^MBProgressHUDConfig)(__kindof MBProgressHUD *hud);

/**
 *  MBProgressHUD extention
 */
@interface MBProgressHUD (BJLiveBase)

/**
 *  Always NO, @see BJLProgressHUD
 */
@property (nonatomic, readonly) BOOL bjl_passThroughTouches;

/**
 *  Create hud:
 *  removeFromSuperViewOnHide   YES
 *  bjl_passThroughTouches      NO
 */
+ (instancetype)bjl_hudWithSuperview:(UIView *)superview;

/**
 *  Create hud for text:
 *  mode                        MBProgressHUDModeText
 *  removeFromSuperViewOnHide   YES
 *  bjl_passThroughTouches      NO/YES(BJLProgressHUD)
 */
+ (instancetype)bjl_hudForTextWithSuperview:(UIView *)superview;

/**
 *  Create hud for loading:
 *  mode                        MBProgressHUDModeIndeterminate - UIActivityIndicatorView
 *  removeFromSuperViewOnHide   YES
 *  bjl_passThroughTouches      NO
 */
+ (instancetype)bjl_hudForLoadingWithSuperview:(UIView *)superview;

@end

#pragma mark -

@interface MBProgressHUD (BJLiveBaseShowing)

- (void)bjl_makeDetailsLabelWithLabelStyle;
- (void)bjl_makeVersion0Style; // version 0.x

/**
 *  Create hud for text with method `bjl_hudForTextWithSuperview:`.
 *  Support multiple line text - by displaying `text` in `detailsLabel`.
 *  Auto-hide after `BJLProgressHUDTimeInterval`.
 */
+ (instancetype)bjl_showHUDForText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated;

/**
 *  Create hud for text with method `bjl_hudForTextWithSuperview:`.
 *  Not support multiple line text.
 *  Auto-hide after `BJLProgressHUDTimeInterval`.
 */
+ (instancetype)bjl_showHUDForText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated;

/**
 *  Create hud for text with method `bjl_hudForTextWithSuperview:`.
 *  Auto-hide if `timeInterval` greater than 0.0, not otherwise, `timeInterval` returned from config block.
 */
+ (instancetype)bjl_showHUDForTextWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated;

/**
 *  Create hud for loading with method `hudForLoadingWithSuperview:`.
 *  The value of `bjl_passThroughTouches` is NO.
 */
+ (instancetype)bjl_showHUDForLoadingWithSuperview:(UIView *)superview animated:(BOOL)animated;

/**
 *  Create hud for loading with method `hudForLoadingWithSuperview:`.
 *  NOT to auto-hide, alwanys ignore `timeInterval` returned from config block.
 *  The value of `bjl_passThroughTouches` is NO by default.
 */
+ (instancetype)bjl_showHUDForLoadingWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated;

@end

#pragma mark -

/**
 *  Support pass through touches if `bjl_passThroughTouches` is YES.
 */
@interface BJLProgressHUD : MBProgressHUD <MBProgressHUDDelegate>

@property (nonatomic, readwrite, setter=bjl_setPassThroughTouches:) BOOL bjl_passThroughTouches; // default: NO

@end

NS_ASSUME_NONNULL_END
