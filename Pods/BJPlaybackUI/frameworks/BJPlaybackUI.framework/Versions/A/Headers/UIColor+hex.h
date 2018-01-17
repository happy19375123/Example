//
//  UIColor+hex.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/22.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (hex)

// @"#FFFFFF"
+ (nullable UIColor *)bjp_colorWithHexString:(NSString *)hexString;
+ (nullable UIColor *)bjp_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
// 0xFFFFFF
+ (nullable UIColor *)bjp_colorWithHex:(unsigned)hex;
+ (nullable UIColor *)bjp_colorWithHex:(unsigned)hex alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
