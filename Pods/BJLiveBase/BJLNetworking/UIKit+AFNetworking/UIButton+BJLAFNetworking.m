// UIButton+AFNetworking.m
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIButton+BJLAFNetworking.h"

#import <objc/runtime.h>

#if TARGET_OS_IOS || TARGET_OS_TV

#import "UIImageView+BJLAFNetworking.h"
#import "BJLAFImageDownloader.h"

@interface UIButton (_BJLAFNetworking)
@end

@implementation UIButton (_BJLAFNetworking)

#pragma mark -

static char BJLAFImageDownloadReceiptNormal;
static char BJLAFImageDownloadReceiptHighlighted;
static char BJLAFImageDownloadReceiptSelected;
static char BJLAFImageDownloadReceiptDisabled;

static const char * bjlaf_imageDownloadReceiptKeyForState(UIControlState state) {
    switch (state) {
        case UIControlStateHighlighted:
            return &BJLAFImageDownloadReceiptHighlighted;
        case UIControlStateSelected:
            return &BJLAFImageDownloadReceiptSelected;
        case UIControlStateDisabled:
            return &BJLAFImageDownloadReceiptDisabled;
        case UIControlStateNormal:
        default:
            return &BJLAFImageDownloadReceiptNormal;
    }
}

- (BJLAFImageDownloadReceipt *)bjlaf_imageDownloadReceiptForState:(UIControlState)state {
    return (BJLAFImageDownloadReceipt *)objc_getAssociatedObject(self, bjlaf_imageDownloadReceiptKeyForState(state));
}

- (void)bjlaf_setImageDownloadReceipt:(BJLAFImageDownloadReceipt *)imageDownloadReceipt
                           forState:(UIControlState)state
{
    objc_setAssociatedObject(self, bjlaf_imageDownloadReceiptKeyForState(state), imageDownloadReceipt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

static char BJLAFBackgroundImageDownloadReceiptNormal;
static char BJLAFBackgroundImageDownloadReceiptHighlighted;
static char BJLAFBackgroundImageDownloadReceiptSelected;
static char BJLAFBackgroundImageDownloadReceiptDisabled;

static const char * bjlaf_backgroundImageDownloadReceiptKeyForState(UIControlState state) {
    switch (state) {
        case UIControlStateHighlighted:
            return &BJLAFBackgroundImageDownloadReceiptHighlighted;
        case UIControlStateSelected:
            return &BJLAFBackgroundImageDownloadReceiptSelected;
        case UIControlStateDisabled:
            return &BJLAFBackgroundImageDownloadReceiptDisabled;
        case UIControlStateNormal:
        default:
            return &BJLAFBackgroundImageDownloadReceiptNormal;
    }
}

- (BJLAFImageDownloadReceipt *)bjlaf_backgroundImageDownloadReceiptForState:(UIControlState)state {
    return (BJLAFImageDownloadReceipt *)objc_getAssociatedObject(self, bjlaf_backgroundImageDownloadReceiptKeyForState(state));
}

- (void)bjlaf_setBackgroundImageDownloadReceipt:(BJLAFImageDownloadReceipt *)imageDownloadReceipt
                                     forState:(UIControlState)state
{
    objc_setAssociatedObject(self, bjlaf_backgroundImageDownloadReceiptKeyForState(state), imageDownloadReceipt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark -

@implementation UIButton (BJLAFNetworking)

+ (BJLAFImageDownloader *)bjlaf_sharedImageDownloader {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(bjlaf_sharedImageDownloader)) ?: [BJLAFImageDownloader defaultInstance];
#pragma clang diagnostic pop
}

+ (void)bjlaf_setSharedImageDownloader:(BJLAFImageDownloader *)imageDownloader {
    objc_setAssociatedObject(self, @selector(bjlaf_sharedImageDownloader), imageDownloader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

- (void)bjlaf_setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
{
    [self bjlaf_setImageForState:state withURL:url placeholderImage:nil];
}

- (void)bjlaf_setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self bjlaf_setImageForState:state withURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)bjlaf_setImageForState:(UIControlState)state
          withURLRequest:(NSURLRequest *)urlRequest
        placeholderImage:(nullable UIImage *)placeholderImage
                 success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image))success
                 failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure
{
    if ([self bjlaf_isActiveTaskURLEqualToURLRequest:urlRequest forState:state]) {
        return;
    }

    [self bjlaf_cancelImageDownloadTaskForState:state];

    BJLAFImageDownloader *downloader = [[self class] bjlaf_sharedImageDownloader];
    id <BJLAFImageRequestCache> imageCache = downloader.imageCache;

    //Use the image from the image cache if it exists
    UIImage *cachedImage = [imageCache imageforRequest:urlRequest withAdditionalIdentifier:nil];
    if (cachedImage) {
        if (success) {
            success(urlRequest, nil, cachedImage);
        } else {
            [self setImage:cachedImage forState:state];
        }
        [self bjlaf_setImageDownloadReceipt:nil forState:state];
    } else {
        if (placeholderImage) {
            [self setImage:placeholderImage forState:state];
        }

        __weak __typeof(self)weakSelf = self;
        NSUUID *downloadID = [NSUUID UUID];
        BJLAFImageDownloadReceipt *receipt;
        receipt = [downloader
                   downloadImageForURLRequest:urlRequest
                   withReceiptID:downloadID
                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([[strongSelf bjlaf_imageDownloadReceiptForState:state].receiptID isEqual:downloadID]) {
                           if (success) {
                               success(request, response, responseObject);
                           } else if(responseObject) {
                               [strongSelf setImage:responseObject forState:state];
                           }
                           [strongSelf bjlaf_setImageDownloadReceipt:nil forState:state];
                       }

                   }
                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([[strongSelf bjlaf_imageDownloadReceiptForState:state].receiptID isEqual:downloadID]) {
                           if (failure) {
                               failure(request, response, error);
                           }
                           [strongSelf  bjlaf_setImageDownloadReceipt:nil forState:state];
                       }
                   }];

        [self bjlaf_setImageDownloadReceipt:receipt forState:state];
    }
}

#pragma mark -

- (void)bjlaf_setBackgroundImageForState:(UIControlState)state
                           withURL:(NSURL *)url
{
    [self bjlaf_setBackgroundImageForState:state withURL:url placeholderImage:nil];
}

- (void)bjlaf_setBackgroundImageForState:(UIControlState)state
                           withURL:(NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self bjlaf_setBackgroundImageForState:state withURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)bjlaf_setBackgroundImageForState:(UIControlState)state
                    withURLRequest:(NSURLRequest *)urlRequest
                  placeholderImage:(nullable UIImage *)placeholderImage
                           success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image))success
                           failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure
{
    if ([self bjlaf_isActiveBackgroundTaskURLEqualToURLRequest:urlRequest forState:state]) {
        return;
    }

    [self bjlaf_cancelBackgroundImageDownloadTaskForState:state];

    BJLAFImageDownloader *downloader = [[self class] bjlaf_sharedImageDownloader];
    id <BJLAFImageRequestCache> imageCache = downloader.imageCache;

    //Use the image from the image cache if it exists
    UIImage *cachedImage = [imageCache imageforRequest:urlRequest withAdditionalIdentifier:nil];
    if (cachedImage) {
        if (success) {
            success(urlRequest, nil, cachedImage);
        } else {
            [self setBackgroundImage:cachedImage forState:state];
        }
        [self bjlaf_setBackgroundImageDownloadReceipt:nil forState:state];
    } else {
        if (placeholderImage) {
            [self setBackgroundImage:placeholderImage forState:state];
        }

        __weak __typeof(self)weakSelf = self;
        NSUUID *downloadID = [NSUUID UUID];
        BJLAFImageDownloadReceipt *receipt;
        receipt = [downloader
                   downloadImageForURLRequest:urlRequest
                   withReceiptID:downloadID
                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([[strongSelf bjlaf_backgroundImageDownloadReceiptForState:state].receiptID isEqual:downloadID]) {
                           if (success) {
                               success(request, response, responseObject);
                           } else if(responseObject) {
                               [strongSelf setBackgroundImage:responseObject forState:state];
                           }
                           [strongSelf bjlaf_setBackgroundImageDownloadReceipt:nil forState:state];
                       }

                   }
                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([[strongSelf bjlaf_backgroundImageDownloadReceiptForState:state].receiptID isEqual:downloadID]) {
                           if (failure) {
                               failure(request, response, error);
                           }
                           [strongSelf  bjlaf_setBackgroundImageDownloadReceipt:nil forState:state];
                       }
                   }];

        [self bjlaf_setBackgroundImageDownloadReceipt:receipt forState:state];
    }
}

#pragma mark -

- (void)bjlaf_cancelImageDownloadTaskForState:(UIControlState)state {
    BJLAFImageDownloadReceipt *receipt = [self bjlaf_imageDownloadReceiptForState:state];
    if (receipt != nil) {
        [[self.class bjlaf_sharedImageDownloader] cancelTaskForImageDownloadReceipt:receipt];
        [self bjlaf_setImageDownloadReceipt:nil forState:state];
    }
}

- (void)bjlaf_cancelBackgroundImageDownloadTaskForState:(UIControlState)state {
    BJLAFImageDownloadReceipt *receipt = [self bjlaf_backgroundImageDownloadReceiptForState:state];
    if (receipt != nil) {
        [[self.class bjlaf_sharedImageDownloader] cancelTaskForImageDownloadReceipt:receipt];
        [self bjlaf_setBackgroundImageDownloadReceipt:nil forState:state];
    }
}

- (BOOL)bjlaf_isActiveTaskURLEqualToURLRequest:(NSURLRequest *)urlRequest forState:(UIControlState)state {
    BJLAFImageDownloadReceipt *receipt = [self bjlaf_imageDownloadReceiptForState:state];
    return [receipt.task.originalRequest.URL.absoluteString isEqualToString:urlRequest.URL.absoluteString];
}

- (BOOL)bjlaf_isActiveBackgroundTaskURLEqualToURLRequest:(NSURLRequest *)urlRequest forState:(UIControlState)state {
    BJLAFImageDownloadReceipt *receipt = [self bjlaf_backgroundImageDownloadReceiptForState:state];
    return [receipt.task.originalRequest.URL.absoluteString isEqualToString:urlRequest.URL.absoluteString];
}


@end

#endif
