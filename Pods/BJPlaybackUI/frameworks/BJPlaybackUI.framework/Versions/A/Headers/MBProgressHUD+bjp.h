//
//  MBProgressHUD+bjp.h
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/3/17.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (bjp)

+ (void)bjp_showMessageThenHide:(NSString *)msg toView:(UIView *)view onHide:(void (^)())onHide;

+ (void)bjp_showMessageThenHide:(NSString *)msg
                         toView:(UIView *)view  yOffset:(CGFloat)offset
                         onHide:(void (^)())onHide;

/**
 *  显示加载中，以及文本消息
 *
 *  @param msg  消息内容，如果为nil，则只显示loading图
 *  @param view 所在的superview
 *
 *  @return 返回当前hud，方便之后hide
 */
+ (MBProgressHUD*)bjp_showLoading:(NSString *)msg
                           toView:(UIView *)view;

+ (void)bjp_closeLoadingView:(UIView *)toView;

@end
