//
//  BJPTopbarView.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/22.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPTopBarView : UIView

@property (nonatomic, copy, nullable) void (^exitCallback)(id _Nullable sender);

@property (nonatomic, readonly) UIView *customContainerView;

@end

NS_ASSUME_NONNULL_END
