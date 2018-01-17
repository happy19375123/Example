//
//  BJLRoomViewController.h
//  BJLiveUI
//
//  Created by MingLQ on 2017-01-17.
//  Copyright © 2017 BaijiaYun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BJLiveBase/NSObject+BJLObserving.h>

#import <BJLiveCore/BJLRoom.h>
#import <BJLiveCore/BJLUser.h>
#import <BJLiveCore/NSError+BJLError.h>

#import "BJLOverlayContainerController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BJLRoomViewControllerDelegate;

/**
 直播教室:
 
 通过两个 `+ instanceWith...` 方法创建实例，第一次 `viewDidAppear:` 时进入教室
 可同时存在多个实例，但最多只有一个教室处于进入状态，后执行进入的教室会把之前的教室踢掉
 
 支持任意方式显示 view-controller，如 push、present、childViewController
 退出教室参考 `exit`
 */
@interface BJLRoomViewController : UIViewController <UIGestureRecognizerDelegate>

/** 直播教室
 参考 `BJLiveCore` */
@property (nonatomic, readonly, nullable) BJLRoom *room;

/** 事件回调 `delegate` */
@property (nonatomic, weak) id<BJLRoomViewControllerDelegate> delegate;

/**
 通过 ID 创建教室
 #param roomID          教室 ID
 #param user            用户
 #param apiSign         API sign
 #return                教室
 */
+ (__kindof instancetype)instanceWithID:(NSString *)roomID
                                apiSign:(NSString *)apiSign
                                   user:(BJLUser *)user;

/**
 通过参加码创建教室
 #param roomSecret      教室参加码，目前只支持老师、学生角色
 #param userName        用户名
 #param userAvatar      用户头像 URL
 #return                教室
 */
+ (__kindof instancetype)instanceWithSecret:(NSString *)roomSecret
                                   userName:(NSString *)userName
                                 userAvatar:(nullable NSString *)userAvatar;

/** 退出教室
 push、present 方式显示 view-controller 在退出时可自动 pop、dismiss
 其它方式（如 `addChildViewController:`）需要在 `<BJLRoomViewControllerDelegate>` 的 `roomViewController:didExitWithError:` 方法中实现
 */
- (void)exit;

/** 设置教室右上方自定义按钮，贴近关闭按钮、从右到左显示
 点击按钮的事件可自行处理，如果需要想用户列表一样显示一个 view-controller，可在 `<BJLRoomViewControllerDelegate>` 的 `roomViewController:viewControllerForCustomButton:` 方法中返回该 view-controller
 */
- (void)setCustomButtons:(NSArray<UIButton *> *)buttons;

/**
 设置视频小窗口背景图是否隐藏
 #param hidden
 */
- (void)setPreviewBackgroundImageHidden:(BOOL)hidden;

@end

#pragma mark - observing

@interface BJLRoomViewController (BJLObservable)

- (BJLObservable)roomViewControllerEnterRoomSuccess:(BJLRoomViewController *)roomViewController;
- (BJLObservable)roomViewController:(BJLRoomViewController *)roomViewController
          enterRoomFailureWithError:(BJLError *)error;

- (BJLObservable)roomViewController:(BJLRoomViewController *)roomViewController
                  willExitWithError:(nullable BJLError *)error;
- (BJLObservable)roomViewController:(BJLRoomViewController *)roomViewController
                   didExitWithError:(nullable BJLError *)error;

@end

#pragma mark - delegate

@protocol BJLRoomViewControllerDelegate <NSObject>

@optional

/** 进入教室 - 成功/失败 */
- (void)roomViewControllerEnterRoomSuccess:(BJLRoomViewController *)roomViewController;
- (void)roomViewController:(BJLRoomViewController *)roomViewController
 enterRoomFailureWithError:(BJLError *)error;

/**
 退出教室 - 正常/异常
 正常退出 `error` 为 `nil`，否则为异常退出
 参考 `BJLErrorCode` */
- (void)roomViewController:(BJLRoomViewController *)roomViewController
         willExitWithError:(nullable BJLError *)error;
- (void)roomViewController:(BJLRoomViewController *)roomViewController
          didExitWithError:(nullable BJLError *)error;

/**
 点击教室右上方自定义按钮回调
 此方法返回的 view-controller 可以像用户列表一样显示在教室内
 `didMoveToParentViewController:` 后 view-controller 的 `bjl_overlayContainerController` 属性可用
 通过该属性可以设置统一样式的标题、导航栏按钮、底部按钮、以及关闭等，参考 `BJLOverlayContainerController`
 */
- (nullable UIViewController *)roomViewController:(BJLRoomViewController *)roomViewController
              viewControllerToShowForCustomButton:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
