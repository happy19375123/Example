//
//  PMWebImage.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/9.
//
//

#import <UIKit/UIKit.h>
#import <BJLiveBase/UIImageView+BJLAFNetworking.h>
#import <BJLiveBase/UIButton+BJLAFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PMWebImageLoader;
typedef void (^PMWebImageCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL);

#pragma mark -

@interface UIView (PMWebImage)

/**
 import PMWebImageLoader_SD or PMWebImageLoader_YY via subspec
 set nil to reset, PMWebImageLoader_YY > PMWebImageLoader_SD > PMWebImageLoader_AFN
 */
@property (class,
           nonatomic,
           null_resettable,
           setter=pm_setImageLoader:) id<PMWebImageLoader> pm_imageLoader;

@end

#pragma mark -

/**
 load image if failed: SDWebImageRetryFailed, YYWebImageOptionIgnoreFailedURL
 afn avoid auto set image if has completion, like SDWebImageAvoidAutoSetImage or YYWebImageOptionAvoidSetImage
 */
@protocol PMWebImageLoader <NSObject>

/* UIImageView */

- (void)pm_setImageWithURL:(nullable NSURL *)url
                placeholder:(nullable UIImage *)placeholder
                 completion:(nullable PMWebImageCompletionBlock)completion
                  imageView:(UIImageView *)imageView;
- (void)pm_cancelCurrentImageLoadForImageView:(UIImageView *)imageView;

/* UIButton */

- (void)pm_setImageWithURL:(nullable NSURL *)url
                   forState:(UIControlState)state
                placeholder:(nullable UIImage *)placeholder
                 completion:(nullable PMWebImageCompletionBlock)completion
                     button:(UIButton *)button;
- (void)pm_cancelCurrentImageLoadForState:(UIControlState)state button:(UIButton *)button;

- (void)pm_setBackgroundImageWithURL:(nullable NSURL *)url
                             forState:(UIControlState)state
                          placeholder:(nullable UIImage *)placeholder
                           completion:(nullable PMWebImageCompletionBlock)completion
                               button:(UIButton *)button;
- (void)pm_cancelCurrentBackgroundImageLoadForState:(UIControlState)state button:(UIButton *)button;

/* download */
// TODO: <#task#>
/*
 [SDWebImageManager.sharedManager loadImageWithURL:options:progress:completed:]
 */
/*
 YYWebImageManager *manager = [YYWebImageManager sharedManager];
 imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:YYImageCacheTypeMemory];
 [manager requestImageWithURL:options:progress:transform:completion:] // also load image form disk cache
 */
/*
 [AFImageDownloader sharedImageDownloader]
 
 id <AFImageRequestCache> imageCache = downloader.imageCache;
 UIImage *cachedImage = [imageCache imageforRequest:urlRequest withAdditionalIdentifier:nil];
 
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 [request addValue:@"image/<#*#>" forHTTPHeaderField:@"Accept"]; // TODO: replace <#*#> with *
 AFImageDownloadReceipt *receipt = [downloader downloadImageForURLRequest:request withReceiptID:[NSUUID UUID] success: failure:];
 */

@end

@interface PMWebImageLoader_AFN : NSObject <PMWebImageLoader>
@end

#pragma mark -

@interface UIImageView (PMWebImage)

// always return nil
@property (nonatomic/*, writeonly */, nullable, setter=pm_setImageURL:) NSURL *pm_imageURL;
@property (nonatomic/*, writeonly */, nullable, setter=pm_setImageURLString:) NSString *pm_imageURLString;

- (void)pm_setImageWithURL:(nullable NSURL *)url
                placeholder:(nullable UIImage *)placeholder
                 completion:(nullable PMWebImageCompletionBlock)completion;
- (void)pm_setImageWithURLString:(nullable NSString *)urlString
                      placeholder:(nullable UIImage *)placeholder
                       completion:(nullable PMWebImageCompletionBlock)completion;
- (void)pm_cancelCurrentImageLoad;

@end

@interface UIButton (PMWebImage)

- (void)pm_setImageWithURL:(nullable NSURL *)url
                   forState:(UIControlState)state
                placeholder:(nullable UIImage *)placeholder
                 completion:(nullable PMWebImageCompletionBlock)completion;
- (void)pm_setImageWithURLString:(nullable NSString *)urlString
                         forState:(UIControlState)state
                      placeholder:(nullable UIImage *)placeholder
                       completion:(nullable PMWebImageCompletionBlock)completion;
- (void)pm_cancelCurrentImageLoadForState:(UIControlState)state;

- (void)pm_setBackgroundImageWithURL:(nullable NSURL *)url
                             forState:(UIControlState)state
                          placeholder:(nullable UIImage *)placeholder
                           completion:(nullable PMWebImageCompletionBlock)completion;
- (void)pm_setBackgroundImageWithURLString:(nullable NSString *)urlString
                                   forState:(UIControlState)state
                                placeholder:(nullable UIImage *)placeholder
                                 completion:(nullable PMWebImageCompletionBlock)completion;
- (void)pm_cancelCurrentBackgroundImageLoadForState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END

