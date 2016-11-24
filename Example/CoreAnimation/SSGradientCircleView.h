//
//  SSGradientCircleView.h
//  Example
//
//  Created by 张鹏 on 16/5/27.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSGradientCircleView : UIView

-(id)initWithFrame:(CGRect)frame fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor defaultColor:(UIColor *)defaultColor lineWith:(NSInteger )lineWith progress:(CGFloat )progress;

-(void)refreshViewWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor defaultColor:(UIColor *)defaultColor lineWith:(NSInteger )lineWith progress:(CGFloat )progress;

@end
