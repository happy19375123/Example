//
//  BJPAppearance.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/22.
//
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

NS_ASSUME_NONNULL_BEGIN

#define YPWeakObj(objc) autoreleasepool{} __weak typeof(objc) objc##Weak = objc;
#define YPStrongObj(objc) autoreleasepool{} __strong typeof(objc) objc = objc##Weak;

/**
 用于判断  是否横屏模式
 */
static inline BOOL BJPIsHorizontalUI(id<UITraitEnvironment> traitEnvironment) {
    return !(traitEnvironment.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact
             && traitEnvironment.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular);
}


/**
 判断iPhone X
 */
static inline BOOL bjp_iPhoneX() {
    static BOOL iPhoneX = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if TARGET_OS_EMBEDDED
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *machine = @(systemInfo.machine);
        iPhoneX = ([machine isEqualToString:@"iPhone10,3"]
                   || [machine isEqualToString:@"iPhone10,6"]);
#else // TARGET_OS_SIMULATOR
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        iPhoneX = ABS(MAX(screenSize.width, screenSize.height) - 812.0) <= CGFLOAT_MIN;
#endif
    });
    return iPhoneX;
}

extern const CGFloat BJPViewSpaceS, BJPViewSpaceM, BJPViewSpaceL;
extern const CGFloat BJPIPhoneXSpaceS, BJPIPhoneXSpaceM, BJPIPhoneXSpaceL;
extern const CGFloat BJPControlSize;

extern const CGFloat BJPSmallViewHeight, BJPSmallViewWidth;

extern const CGFloat BJPButtonHeight, BJPButtonWidth;

extern const CGFloat BJPButtonSizeS, BJPButtonSizeM, BJPButtonSizeL, BJPButtonCornerRadius;
extern const CGFloat BJPBadgeSize;
extern const CGFloat BJPScrollIndicatorSize;

extern const CGFloat BJPAnimateDurationS, BJPAnimateDurationM;
extern const CGFloat BJPRobotDelayS, BJPRobotDelayM;

@interface UIColor (BJPColorLegend)

// common
@property (class, nonatomic, readonly) UIColor
*bjp_darkGrayBackgroundColor,
*bjp_lightGrayBackgroundColor,

*bjp_darkGrayTextColor,
*bjp_grayTextColor,
*bjp_lightGrayTextColor,

*bjp_grayBorderColor,
*bjp_grayLineColor,
*bjp_grayImagePlaceholderColor, // == bjp_grayLineColor

*bjp_blueBrandColor,
*bjp_orangeBrandColor,
*bjp_redColor;

// dim
@property (class, nonatomic, readonly) UIColor
*bjp_lightMostDimColor, // black-0.2
*bjp_lightDimColor, // black-0.5
*bjp_dimColor,      // black-0.6
*bjp_darkDimColor;  // black-0.7

@end

NS_ASSUME_NONNULL_END
