//
//  BJLOverlayContainerController.h
//  BJLiveUI
//
//  Created by MingLQ on 2017-02-14.
//  Copyright © 2017 BaijiaYun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 `title`、`buttons`、`footerView`
 在 `didMoveToParentViewController:` 中调用对应 update 方法进行初始化
 在 `title`、`buttons`、`footerView` 有变化时调用对应 update 方法进行更新
 */
@interface BJLOverlayContainerController : UIViewController

@property (nonatomic, nullable) UIViewController *contentViewController;

/**
 固定在顶部的 `headerView`，`title` 和 `buttons` 都是 `nil` 时不显示
 #param title   标题
 #param buttons 按钮，从右向左排列
 */
- (void)updateTitle:(nullable NSString *)title;
- (void)updateRightButton:(nullable UIButton *)rightButton;
- (void)updateRightButtons:(nullable NSArray<UIButton *> *)rightButtons;

/**
 固定在底部的 `footerView`，`nil` 时不显示
 #param footerView  需自行设置高度
 */
- (void)updateFooterView:(nullable UIView *)footerView;

/**
 关闭
 */
- (void)hide;

@end

#pragma mark -

@interface UIViewController (BJLOverlayContentViewController)

/**
 在 `didMoveToParentViewController:` 之后不为空
 */
@property (nonatomic, readonly, nullable) BJLOverlayContainerController *bjl_overlayContainerController;

@end

NS_ASSUME_NONNULL_END
