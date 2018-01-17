//
//  BJLWebImageLoader_AF.m
//  Pods
//
//  Created by MingLQ on 2017-08-15.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJLWebImageLoader_AF.h"

#import "BJLAFImageDownloader.h"
#import "UIImageView+BJLAFNetworking.h"
#import "UIButton+BJLAFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@implementation BJLWebImageLoader_AF

- (BOOL)supportsWebP {
    return NO;
}

- (NSURLRequest *)requestWithURL:(nullable NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    return request;
}

#pragma mark - UIImageView

- (nullable NSURL *)bjl_imageURLForImageView:(UIImageView *)imageView {
    return [imageView bjl_currentImageURL];
}

- (void)bjl_setImageWithURL:(nullable NSURL *)url
                placeholder:(nullable UIImage *)placeholder
                 completion:(nullable BJLWebImageCompletionBlock)completion
                  imageView:(UIImageView *)imageView {
    [imageView bjl_setCurrentImageURL:url];
    typeof(imageView) __weak __weak_imageView__ = imageView;
    [imageView bjlaf_setImageWithURLRequest:[self requestWithURL:url]
                     placeholderImage:placeholder
                              success:completion ? ^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                  typeof(__weak_imageView__) __strong imageView = __weak_imageView__;
                                  imageView.image = image;
                                  completion(image, nil, request.URL);
                              } : nil
                              failure:completion ?^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                  completion(nil, error, request.URL);
                              } : nil];
}

- (void)bjl_cancelCurrentImageLoadingForImageView:(UIImageView *)imageView {
    [imageView bjlaf_cancelImageDownloadTask];
    [imageView bjl_setCurrentImageURL:nil];
}

#pragma mark - UIButton

- (nullable NSURL *)bjl_imageURLForState:(UIControlState)state button:(UIButton *)button {
    return [button bjl_currentImageURLForState:state];
}

- (nullable NSURL *)bjl_backgroundImageURLForState:(UIControlState)state button:(UIButton *)button {
    return [button bjl_currentBackgroundImageURLForState:state];
}

- (void)bjl_setImageWithURL:(nullable NSURL *)url
                   forState:(UIControlState)state
                placeholder:(nullable UIImage *)placeholder
                 completion:(nullable BJLWebImageCompletionBlock)completion
                     button:(UIButton *)button {
    [button bjl_setCurrentImageURL:url forState:state];
    typeof(button) __weak __weak_button__ = button;
    [button bjlaf_setImageForState:state
              withURLRequest:[self requestWithURL:url]
            placeholderImage:placeholder
                     success:completion ? ^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                         typeof(__weak_button__) __strong button = __weak_button__;
                         [button setImage:image forState:state];
                         completion(image, nil, request.URL);
                     } : nil
                     failure:completion ? ^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                         completion(nil, error, request.URL);
                     } : nil];
}

- (void)bjl_cancelCurrentImageLoadingForState:(UIControlState)state button:(UIButton *)button {
    [button bjlaf_cancelImageDownloadTaskForState:state];
    [button bjl_setCurrentImageURL:nil forState:state];
}

- (void)bjl_setBackgroundImageWithURL:(nullable NSURL *)url
                             forState:(UIControlState)state
                          placeholder:(nullable UIImage *)placeholder
                           completion:(nullable BJLWebImageCompletionBlock)completion
                               button:(UIButton *)button {
    [button bjl_setCurrentBackgroundImageURL:url forState:state];
    typeof(button) __weak __weak_button__ = button;
    [button bjlaf_setBackgroundImageForState:state
                        withURLRequest:[self requestWithURL:url]
                      placeholderImage:placeholder
                               success:completion ? ^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                   typeof(__weak_button__) __strong button = __weak_button__;
                                   [button setImage:image forState:state];
                                   completion(image, nil, request.URL);
                               } : nil
                               failure:completion ? ^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                   completion(nil, error, request.URL);
                               } : nil];
}

- (void)bjl_cancelCurrentBackgroundImageLoadingForState:(UIControlState)state button:(UIButton *)button {
    [button bjlaf_cancelBackgroundImageDownloadTaskForState:state];
    [button bjl_setCurrentBackgroundImageURL:nil forState:state];
}

@end

NS_ASSUME_NONNULL_END
