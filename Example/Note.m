//
//  Note.m
//  Example
//
//  Created by 张鹏 on 15/11/4.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "Note.h"

@implementation Note

-(void)run{
    id obj = [[NSObject alloc] init];
    void *p = (__bridge void *)obj;
    id o = (__bridge id)(p);

}

#pragma mark - __bridge 用于 ARC 类型转换：显示转换 id 和 void *
/*
 ARC 类型转换：显示转换 id 和 void *
 http://blog.csdn.net/chinahaerbin/article/details/9471419
 
 id obj = [[NSObject alloc] init];
 void *p = (__bridge void *)obj;
 id o = (__bridge id)(p);

 */

#pragma mark - iOS开发笔记--使用blend改变图片颜色
/*
 http://blog.csdn.net/hopedark/article/details/17761177
 
 #import "UIImage+Tint.h"
 
 @implementation UIImage (Tint)
 - (UIImage *) imageWithTintColor:(UIColor *)tintColor
 {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
 }
 
 - (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
 {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
 }
 
 - (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
 {
     //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
     UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
     [tintColor setFill];
     CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
     UIRectFill(bounds);
     
     //Draw the tinted image in context
     [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
     
     if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
     }
     
     UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     return tintedImage;
 }
 
 @end
 
 */

@end
