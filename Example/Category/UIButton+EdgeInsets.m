//
//  UIButton+imageTitleLayout.m
//  
//
//  Created by 韩保玉 on 15/6/28.
//  Copyright (c) 2015年 韩保玉. All rights reserved.
//

#import "UIButton+EdgeInsets.h"

@implementation UIButton (EdgeInsets)

//- (void)layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style imageTitlespace:(CGFloat)space {
//    CGFloat imageViewWidth = CGRectGetWidth(self.imageView.frame);
//    CGFloat labelWidth = CGRectGetWidth(self.titleLabel.frame);
//
//    if (labelWidth == 0) {
//        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
//        labelWidth  = titleSize.width;
//    }
//
//    CGFloat imageInsetsTop = 0.0f;
//    CGFloat imageInsetsLeft = 0.0f;
//    CGFloat imageInsetsBottom = 0.0f;
//    CGFloat imageInsetsRight = 0.0f;
//
//    CGFloat titleInsetsTop = 0.0f;
//    CGFloat titleInsetsLeft = 0.0f;
//    CGFloat titleInsetsBottom = 0.0f;
//    CGFloat titleInsetsRight = 0.0f;
//
//    switch (style) {
//        case ButtonEdgeInsetsStyleImageRight:
//        {
//            space = space * 0.5;
//
//            imageInsetsLeft = labelWidth + space;
//            imageInsetsRight = -imageInsetsLeft;
//
//            titleInsetsLeft = - (imageViewWidth + space);
//            titleInsetsRight = -titleInsetsLeft;
//        }
//            break;
//
//        case ButtonEdgeInsetsStyleImageLeft:
//        {
//            space = space * 0.5;
//
//            imageInsetsLeft = -space;
//            imageInsetsRight = -imageInsetsLeft;
//
//            titleInsetsLeft = space;
//            titleInsetsRight = -titleInsetsLeft;
//        }
//            break;
//        case ButtonEdgeInsetsStyleImageBottom:
//        {
//            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
//            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
//            CGFloat buttonHeight = CGRectGetHeight(self.frame);
//            CGFloat boundsCentery = (imageHeight + space + labelHeight) * 0.5;
//
//            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
//            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
//            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
//
//            CGFloat imageBottomY = CGRectGetMaxY(self.imageView.frame);
//            CGFloat titleTopY = CGRectGetMinY(self.titleLabel.frame);
//
//            imageInsetsTop = buttonHeight - (buttonHeight * 0.5 - boundsCentery) - imageBottomY;
//            imageInsetsLeft = centerX_button - centerX_image;
//            imageInsetsRight = - imageInsetsLeft;
//            imageInsetsBottom = - imageInsetsTop;
//
//            titleInsetsTop = (buttonHeight * 0.5 - boundsCentery) - titleTopY;
//            titleInsetsLeft = -(centerX_titleLabel - centerX_button);
//            titleInsetsRight = - titleInsetsLeft;
//            titleInsetsBottom = - titleInsetsTop;
//
//        }
//            break;
//            case ButtonEdgeInsetsStyleImageTop:
//        {
//            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
//            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
//            CGFloat buttonHeight = CGRectGetHeight(self.frame);
//            CGFloat boundsCentery = (imageHeight + space + labelHeight) * 0.5;
//
//            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
//            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
//            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
//
//            CGFloat imageTopY = CGRectGetMinY(self.imageView.frame);
//            CGFloat titleBottom = CGRectGetMaxY(self.titleLabel.frame);
//
//            imageInsetsTop = (buttonHeight * 0.5 - boundsCentery) - imageTopY;
//            imageInsetsLeft = centerX_button - centerX_image;
//            imageInsetsRight = - imageInsetsLeft;
//            imageInsetsBottom = - imageInsetsTop;
//
//            titleInsetsTop = buttonHeight - (buttonHeight * 0.5 - boundsCentery) - titleBottom;
//            titleInsetsLeft = -(centerX_titleLabel - centerX_button);
//            titleInsetsRight = - titleInsetsLeft;
//            titleInsetsBottom = - titleInsetsTop;
//        }
//            break;
//
//        default:
//            break;
//    }
//
//    self.imageEdgeInsets = UIEdgeInsetsMake(imageInsetsTop, imageInsetsLeft, imageInsetsBottom, imageInsetsRight);
//    self.titleEdgeInsets = UIEdgeInsetsMake(titleInsetsTop, titleInsetsLeft, titleInsetsBottom, titleInsetsRight);
//}

- (void)layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style imageTitlespace:(CGFloat)space {
    CGSize imageViewSize = self.imageView.frame.size;
    CGSize titleLabelSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleLabelSize.width + 0.5 < frameSize.width) {
        titleLabelSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageViewSize.height + titleLabelSize.height + space);
    
    switch (style) {
        case ButtonEdgeInsetsStyleImageRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0, - (titleLabelSize.width * 2  + space));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - (imageViewSize.width * 2  +space), 0, 0);
            break;
        case ButtonEdgeInsetsStyleImageLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -space, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -space);
            break;
        case ButtonEdgeInsetsStyleImageBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, - (totalHeight - imageViewSize.height), - titleLabelSize.width);
            self.titleEdgeInsets = UIEdgeInsetsMake(- (totalHeight - titleLabelSize.height), - imageViewSize.width, 0, 0);
            break;
        case ButtonEdgeInsetsStyleImageTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageViewSize.height), 0.0, 0.0, - titleLabelSize.width);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageViewSize.width, - (totalHeight - titleLabelSize.height), 0);
            break;
        default:
            break;
    }
}

@end
