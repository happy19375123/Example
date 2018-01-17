//
//  BJLHitTestView.m
//  M9Dev
//
//  Created by MingLQ on 2017-04-05.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJLHitTestView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation BJLHitTestView

+ (instancetype)viewWithFrame:(CGRect)frame hitTestBlock:(UIView * _Nullable (^)(UIView * _Nullable hitView, CGPoint point, UIEvent * _Nullable event))hitTestBlock {
    BJLHitTestView *hitTestView = [[self alloc] initWithFrame:frame];
    [hitTestView setHitTestBlock:hitTestBlock];
    return hitTestView;
}

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    return self.hitTestBlock ? self.hitTestBlock(hitView, point, event) : nil;
}

@end

NS_ASSUME_NONNULL_END
