//
//  BJPlaybackPlayerView.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/23.
//
//

#import <UIKit/UIKit.h>
#import "BJPlayerBottomView.h"
#import "BJPlayerSmallView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJPlaybackPlayerView : UIView

@property (nonatomic, readonly) UIButton *videoButton, *pptButton, *messageButton;
@property (nonatomic, readonly) BJPlayerBottomView *bottmView;
@property (nonatomic, readonly) BJPlayerSmallView *smallView;

//- (void)addPanForHorizontal;

@end

NS_ASSUME_NONNULL_END
