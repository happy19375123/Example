//
//  BJPHitTestView.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/24.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIView * _Nullable (^ _Nullable BJPHitTestBlock)(UIView * _Nullable hitView, CGPoint point, UIEvent * _Nullable event);

@interface BJPHitTestView : UIView

+ (instancetype)viewWithFrame:(CGRect)frame hitTestBlock:(UIView * _Nullable (^)(UIView * _Nullable hitView, CGPoint point, UIEvent * _Nullable event))hitTestBlock;

@property (nonatomic, readwrite, copy) BJPHitTestBlock hitTestBlock;
- (void)setHitTestBlock:(UIView * _Nullable (^)(UIView * _Nullable hitView, CGPoint point, UIEvent * _Nullable event))hitTestBlock;

@end

NS_ASSUME_NONNULL_END
