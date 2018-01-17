//
//  BJLHitTestView.h
//  M9Dev
//
//  Created by MingLQ on 2017-04-05.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIView * _Nullable (^ _Nullable BJLHitTestBlock)(UIView * _Nullable hitView, CGPoint point, UIEvent * _Nullable event);

@interface BJLHitTestView : UIView

+ (instancetype)viewWithFrame:(CGRect)frame hitTestBlock:(UIView * _Nullable (^)(UIView * _Nullable hitView, CGPoint point, UIEvent * _Nullable event))hitTestBlock;

@property (nonatomic, readwrite, copy) BJLHitTestBlock hitTestBlock;
- (void)setHitTestBlock:(UIView * _Nullable (^)(UIView * _Nullable hitView, CGPoint point, UIEvent * _Nullable event))hitTestBlock;

@end

NS_ASSUME_NONNULL_END
