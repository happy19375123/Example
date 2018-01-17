//
//  PMADPlayerView.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/31.
//
//

#import <UIKit/UIKit.h>
#import "PMVideoInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMADPlayerView : UIView

@property (copy) void(^detailCallBack)(PMVideoADInfoModel *adInfoModel);
@property (copy) void(^skipCallBack)(void);
@property (nullable, nonatomic, readonly) NSTimer *timer;

- (instancetype)initWithADModel:(PMVideoADInfoModel *)adModel isHeaderAD:(BOOL)isHeaderAD;

- (void)destory;

@end

NS_ASSUME_NONNULL_END
