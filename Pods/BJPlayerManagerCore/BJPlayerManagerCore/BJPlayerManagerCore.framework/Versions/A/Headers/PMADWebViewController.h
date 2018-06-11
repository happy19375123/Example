//
//  PMADWebViewController.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/31.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMADWebViewController : UIViewController

@property (copy) void(^dissmissCallBack)(void);

- (instancetype)initWithuRLString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
