//
//  BJPBigImageViewController.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/28.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPBigImageViewController : UIViewController

@property (nonatomic, readonly) UIImageView *imageView;

@property (nonatomic, copy, nullable) void (^hideCallback)(id _Nullable sender);

- (void)hide;

@end

NS_ASSUME_NONNULL_END
