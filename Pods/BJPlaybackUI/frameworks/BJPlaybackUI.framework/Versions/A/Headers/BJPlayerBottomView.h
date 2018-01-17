//
//  BJPlayerBottomView.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/23.
//
//

#import <UIKit/UIKit.h>

#import "BJPlayerProgressView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJPlayerBottomView : UIView

@property (nonatomic, readonly) UIButton *playButton, *definitionButton, *rateButton, *rotateButton;
@property (nonatomic, readonly) BJPlayerProgressView *progressView;
@property (nonatomic) UILabel *timeLabel;

- (void)makeConstraintsForHorizontal:(BOOL)isHorizontal;

@end

NS_ASSUME_NONNULL_END
