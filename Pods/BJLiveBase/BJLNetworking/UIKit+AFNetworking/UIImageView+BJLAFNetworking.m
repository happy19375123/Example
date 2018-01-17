// UIImageView+AFNetworking.m
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

#import "UIImageView+BJLAFNetworking.h"

#import <objc/runtime.h>

#if TARGET_OS_IOS || TARGET_OS_TV

#import "BJLAFImageDownloader.h"

@interface UIImageView (_BJLAFNetworking)
@property (readwrite, nonatomic, strong, setter = bjlaf_setActiveImageDownloadReceipt:) BJLAFImageDownloadReceipt *bjlaf_activeImageDownloadReceipt;
@end

@implementation UIImageView (_BJLAFNetworking)

- (BJLAFImageDownloadReceipt *)bjlaf_activeImageDownloadReceipt {
    return (BJLAFImageDownloadReceipt *)objc_getAssociatedObject(self, @selector(bjlaf_activeImageDownloadReceipt));
}

- (void)bjlaf_setActiveImageDownloadReceipt:(BJLAFImageDownloadReceipt *)imageDownloadReceipt {
    objc_setAssociatedObject(self, @selector(bjlaf_activeImageDownloadReceipt), imageDownloadReceipt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark -

@implementation UIImageView (BJLAFNetworking)

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

- (void)bjlaf_setImageWithURL:(NSURL *)url {
    [self bjlaf_setImageWithURL:url placeholderImage:nil];
}

- (void)bjlaf_setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self bjlaf_setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)bjlaf_setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure
{

    if ([urlRequest URL] == nil) {
        [self bjlaf_cancelImageDownloadTask];
        self.image = placeholderImage;
        return;
    }

    if ([self bjlaf_isActiveTaskURLEqualToURLRequest:urlRequest]){
        return;
    }

    [self bjlaf_cancelImageDownloadTask];

    BJLAFImageDownloader *downloader = [[self class] bjlaf_sharedImageDownloader];
    id <BJLAFImageRequestCache> imageCache = downloader.imageCache;

    //Use the image from the image cache if it exists
    UIImage *cachedImage = [imageCache imageforRequest:urlRequest withAdditionalIdentifier:nil];
    if (cachedImage) {
        if (success) {
            success(urlRequest, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
        [self bjlaf_clearActiveDownloadInformation];
    } else {
        if (placeholderImage) {
            self.image = placeholderImage;
        }

        __weak __typeof(self)weakSelf = self;
        NSUUID *downloadID = [NSUUID UUID];
        BJLAFImageDownloadReceipt *receipt;
        receipt = [downloader
                   downloadImageForURLRequest:urlRequest
                   withReceiptID:downloadID
                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([strongSelf.bjlaf_activeImageDownloadReceipt.receiptID isEqual:downloadID]) {
                           if (success) {
                               success(request, response, responseObject);
                           } else if(responseObject) {
                               strongSelf.image = responseObject;
                           }
                           [strongSelf bjlaf_clearActiveDownloadInformation];
                       }

                   }
                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                        if ([strongSelf.bjlaf_activeImageDownloadReceipt.receiptID isEqual:downloadID]) {
                            if (failure) {
                                failure(request, response, error);
                            }
                            [strongSelf bjlaf_clearActiveDownloadInformation];
                        }
                   }];

        self.bjlaf_activeImageDownloadReceipt = receipt;
    }
}

- (void)bjlaf_cancelImageDownloadTask {
    if (self.bjlaf_activeImageDownloadReceipt != nil) {
        [[self.class bjlaf_sharedImageDownloader] cancelTaskForImageDownloadReceipt:self.bjlaf_activeImageDownloadReceipt];
        [self bjlaf_clearActiveDownloadInformation];
     }
}

- (void)bjlaf_clearActiveDownloadInformation {
    self.bjlaf_activeImageDownloadReceipt = nil;
}

- (BOOL)bjlaf_isActiveTaskURLEqualToURLRequest:(NSURLRequest *)urlRequest {
    return [self.bjlaf_activeImageDownloadReceipt.task.originalRequest.URL.absoluteString isEqualToString:urlRequest.URL.absoluteString];
}

@end

#endif
