//
//  BJLWebImage.m
//  M9Dev
//
//  Created by MingLQ on 2017-03-31.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJLWebImage.h"
#import "BJLWebImageLoader.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIImageView (BJLWebImage)

@dynamic bjl_imageURL;
- (nullable NSURL *)bjl_imageURL {
    return [UIView.bjl_imageLoader bjl_imageURLForImageView:self];
}

- (void)bjl_setImageWithURL:(nullable NSURL *)imageURL {
    [self bjl_setImageWithURL:imageURL
                  placeholder:nil
                   completion:nil];
}

- (void)bjl_setImageWithURL:(nullable NSURL *)url
                placeholder:(nullable UIImage *)placeholder
                 completion:(nullable BJLWebImageCompletionBlock)completion {
    [UIView.bjl_imageLoader bjl_setImageWithURL:url
                                    placeholder:placeholder
                                     completion:completion
                                      imageView:self];
}

- (void)bjl_cancelCurrentImageLoading {
    [UIView.bjl_imageLoader bjl_cancelCurrentImageLoadingForImageView:self];
}

@end

#pragma mark -

@implementation UIButton (BJLWebImage)

#pragma mark image

- (nullable NSURL *)bjl_imageURLForState:(UIControlState)state {
    return [UIView.bjl_imageLoader bjl_imageURLForState:state button:self];
}

- (void)bjl_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state {
    [self bjl_setImageWithURL:url
                     forState:state
                  placeholder:nil
                   completion:nil];
}

- (void)bjl_setImageWithURL:(nullable NSURL *)url
                   forState:(UIControlState)state
                placeholder:(nullable UIImage *)placeholder
                 completion:(nullable BJLWebImageCompletionBlock)completion {
    [UIView.bjl_imageLoader bjl_setImageWithURL:url
                                       forState:state
                                    placeholder:placeholder
                                     completion:completion
                                         button:self];
}

- (void)bjl_cancelCurrentImageLoadingForState:(UIControlState)state {
    [UIView.bjl_imageLoader bjl_cancelCurrentImageLoadingForState:state button:self];
}

#pragma mark backgroundImage

- (nullable NSURL *)bjl_backgroundImageURLForState:(UIControlState)state {
    return [UIView.bjl_imageLoader bjl_backgroundImageURLForState:state button:self];
}

- (void)bjl_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state {
    [self bjl_setBackgroundImageWithURL:url
                               forState:state
                            placeholder:nil
                             completion:nil];
}

- (void)bjl_setBackgroundImageWithURL:(nullable NSURL *)url
                             forState:(UIControlState)state
                          placeholder:(nullable UIImage *)placeholder
                           completion:(nullable BJLWebImageCompletionBlock)completion {
    [UIView.bjl_imageLoader bjl_setBackgroundImageWithURL:url
                                                 forState:state
                                              placeholder:placeholder
                                               completion:completion
                                                   button:self];
}

- (void)bjl_cancelCurrentBackgroundImageLoadingForState:(UIControlState)state {
    [UIView.bjl_imageLoader bjl_cancelCurrentBackgroundImageLoadingForState:state button:self];
}

@end

NS_ASSUME_NONNULL_END
