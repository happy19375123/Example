//
//  UIView+LayoutFrame.h
//  Example
//
//  Created by 张鹏 on 15/11/13.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayoutFrame)

- (CGFloat)x;
- (CGFloat)y;

- (CGFloat)height;

- (CGFloat)width;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

@end
