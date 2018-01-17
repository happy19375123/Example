//
//  BJLOverlayViewController.h
//  BJLiveUI
//
//  Created by MingLQ on 2017-02-11.
//  Copyright © 2017 BaijiaYun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BJLOverlayContainerController.h"

@class MASConstraintMaker;

NS_ASSUME_NONNULL_BEGIN

typedef UIRectEdge BJLContentPosition;

@interface BJLOverlayViewController : UIViewController

/**
 关闭回调
 空白区域被遮挡时 hideCallback 不会被调用，需自行添加关闭按钮/手势
 调用 hide 方法也会回调 hideCallback
 */
@property (nonatomic, copy, nullable) void (^showCallback)(id _Nullable sender);
@property (nonatomic, copy, nullable) void (^hideCallback)(id _Nullable sender);

/**
 `show` 之前设置，`hide` 时自动重置
 */
@property (nonatomic, readwrite) UIStatusBarStyle preferredStatusBarStyle; // 默认 UIStatusBarStyleLightContent
@property (nonatomic, readwrite) BOOL prefersStatusBarHidden; // 默认 YES
@property (nonatomic) UIColor *backgroundColor; // 默认 [UIColor bjl_lightDimColor]

/**
 显示状态
 */
@property (nonatomic, readonly, getter=isHidden) BOOL hidden;

/**
 显示
 
 viewController 将被设置到 BJLOverlayContainerController 的 contentViewController
 参考 BJLOverlayContainerController.h
 
 hor/verEdges 和 hor/verSize 用于设置横竖屏幕时 viewController 的 containerView 的约束
 支持上、下、左、右、居中等对齐方式，支持设置尺寸，少数无法满足的需求嵌套全屏 viewController 实现
 
 #param viewController  内容 contentViewController
 #param hor/verEdges    不设置 left&right 水平居中、不设置 top&bottom 竖直居中、设置 none 水平、竖直同时居中
 #param hor/verSize     取值 0.0 时不设置约束、edges 可约束尺寸时忽略对应 size，size 不超过屏幕边界
 */
- (void)showWithContentViewController:(UIViewController *)contentViewController
               remakeConstraintsBlock:(void (^)(MASConstraintMaker *make, UIView *superView, BOOL isHorizontal))remakeConstraintsBlock;
- (void)showWithContentViewController:(UIViewController *)contentViewController
                             horEdges:(UIRectEdge)horEdges horSize:(CGSize)horSize
                             verEdges:(UIRectEdge)verEdges verSize:(CGSize)verSize;

/**
 默认
 
 横屏时在右边、纵向撑满
 horEdges: UIRectEdgeRight | UIRectEdgeTop | UIRectEdgeBottom
 
 竖屏时在底边、水平撑满
 verEdges: UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight
 
 最大宽高相等、等于竖屏时屏幕宽度
 horSize & verSize: MIN(screenSize.width, screenSize.height)
 */
- (void)showWithContentViewController:(UIViewController *)contentViewController;

/** 关闭 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
