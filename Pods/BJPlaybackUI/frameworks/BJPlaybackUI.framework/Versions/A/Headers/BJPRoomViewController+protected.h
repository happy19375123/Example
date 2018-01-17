//
//  BJPRoomViewController+protected.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/23.
//
//

#import <BJPlaybackUI/BJPlaybackUI.h>

#import "BJPRoomViewController+action.h"
#import "BJPRoomViewController+constraints.h"
#import "BJPRoomViewController+signal.h"

#import "BJPAppearance.h"

#import "BJPTopBarView.h"
#import "BJPlaybackPlayerView.h"
#import "BJPChatMessageViewController.h"
#import "BJPBigImageViewController.h"

#import "BJPlayerDefinitionView.h"
#import "BJPlayerRateView.h"

#import "UIKit+bjp.h"
#import "UIColor+hex.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJPRoomViewController (){
    BOOL _chatMessageHidden;
}

@property (nonatomic, readonly) BJPTopBarView *topBarView;
@property (nonatomic, readonly) BJPlaybackPlayerView *playerView;
@property (nonatomic, readonly) BJPChatMessageViewController *messageViewContrller;
@property (nonatomic, readonly) BJPBigImageViewController *imageViewController;

@property (nonatomic, nullable) BJPlayerDefinitionView *definitionView;
@property (nonatomic, nullable) BJPlayerRateView *rateView;

@property (nonatomic, nullable) UIImageView *videoOffImageView;

@property (nonatomic) NSTimeInterval duration;

- (void)askToExit;

@end

NS_ASSUME_NONNULL_END
