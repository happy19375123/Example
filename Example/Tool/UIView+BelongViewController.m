//
//  UIView+BelongViewController.m
//  Example
//
//  Created by 张鹏 on 15/11/15.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "UIView+BelongViewController.h"

@implementation UIView (BelongViewController)

- (UIViewController*)belongViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
