//
//  BJPlayerRateView.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/27.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPlayerRateView : UIView

@property (nonatomic, copy, nullable) void (^rateCallback)(CGFloat rate);
@property (nonatomic, copy, nullable) void (^rateCancelCallback)();

- (instancetype)initWithCurrentRate:(CGFloat)rate isHorizontal:(BOOL)isHorizontal;

- (void)updateConstraintsForHorizontal:(BOOL)isHorizontal;

@end

NS_ASSUME_NONNULL_END
