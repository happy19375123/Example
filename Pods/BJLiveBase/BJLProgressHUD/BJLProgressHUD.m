//
//  BJLProgressHUD.m
//  M9Dev
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJLProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@implementation BJLProgressHUD

@synthesize bjl_passThroughTouches = _bjl_passThroughTouches;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // NOTE: associated object
        self.bjl_passThroughTouches = NO;
    }
    return self;
}

// NOTE: swizzled method
- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if (self.bjl_passThroughTouches) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

@end

#pragma mark -

@implementation MBProgressHUD (BJLiveBase)

@dynamic bjl_passThroughTouches;

- (BOOL)bjl_passThroughTouches {
    return NO;
}

- (void)bjl_setPassThroughTouches:(BOOL)passThroughTouches {
}

+ (instancetype)bjl_hudWithSuperview:(UIView *)superview {
    MBProgressHUD *hud = [[self alloc] initWithView:superview];
    hud.removeFromSuperViewOnHide = YES;
    // hud.minShowTime = 0.5;
    [superview addSubview:hud];
    return hud;
}

+ (instancetype)bjl_hudForTextWithSuperview:(UIView *)superview {
    MBProgressHUD *hud = [self bjl_hudWithSuperview:superview];
    [hud bjl_setPassThroughTouches:YES];
    hud.mode = MBProgressHUDModeText;
    return hud;
}

+ (instancetype)bjl_hudForLoadingWithSuperview:(UIView *)superview {
    MBProgressHUD *hud = [self bjl_hudWithSuperview:superview];
    hud.mode = MBProgressHUDModeIndeterminate;
    return hud;
}

@end

#pragma mark -

@implementation MBProgressHUD (BJLiveBaseShowing)

- (void)bjl_makeVersion0Style {
    self.contentColor = [UIColor whiteColor]; // text color
    self.bezelView.style = MBProgressHUDBackgroundStyleBlur; // text background style
    self.bezelView.color = [UIColor blackColor]; // text background color or blur tint color
}

- (void)bjl_makeDetailsLabelWithLabelStyle {
    self.detailsLabel.font = self.label.font;
    self.detailsLabel.textColor = self.label.textColor;
}

+ (instancetype)bjl_showHUDForText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self bjl_hudForTextWithSuperview:superview];
    // hud.labelText = text;
    [hud bjl_makeDetailsLabelWithLabelStyle];
    hud.detailsLabel.text = text;
    [hud showAnimated:animated];
    [hud hideAnimated:animated afterDelay:BJLProgressHUDTimeInterval];
    return hud;
}

+ (instancetype)bjl_showHUDForText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self bjl_hudForTextWithSuperview:superview];
    hud.label.text = text;
    hud.detailsLabel.text = details;
    [hud showAnimated:animated];
    [hud hideAnimated:animated afterDelay:BJLProgressHUDTimeInterval];
    return hud;
}

+ (instancetype)bjl_showHUDForTextWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self bjl_hudForTextWithSuperview:superview];
    NSTimeInterval timeInterval = config ? config(hud) : BJLProgressHUDTimeInterval;
    if (timeInterval > 0.0) {
        [hud showAnimated:animated];
        [hud hideAnimated:animated afterDelay:timeInterval];
    }
    else {
        [hud showAnimated:animated];
    }
    return hud;
}

+ (instancetype)bjl_showHUDForLoadingWithSuperview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self bjl_hudForLoadingWithSuperview:superview];
    [hud showAnimated:animated];
    return hud;
}

+ (instancetype)bjl_showHUDForLoadingWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self bjl_hudForLoadingWithSuperview:superview];
    if (config) config(hud);
    [hud showAnimated:animated];
    return hud;
}

@end

NS_ASSUME_NONNULL_END
