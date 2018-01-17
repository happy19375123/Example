//
//  BJLWebImageLoader.m
//  Pods
//
//  Created by MingLQ on 2017-08-15.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJLWebImageLoader.h"

#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@implementation UIImageView (_BJLWebImage)

- (nullable NSURL *)bjl_currentImageURL {
    return (NSURL *)objc_getAssociatedObject(self, @selector(bjl_imageURL));
}

- (void)bjl_setCurrentImageURL:(nullable NSURL *)imageURL {
    objc_setAssociatedObject(self, @selector(bjl_imageURL), imageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIButton (_BJLWebImage)

- (NSMutableDictionary<NSNumber *, NSURL *> *)bjl_imageURLStorage {
    NSMutableDictionary<NSNumber *, NSURL *> *storage = objc_getAssociatedObject(self, @selector(bjl_imageURLStorage));
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(bjl_imageURLStorage), storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

- (NSMutableDictionary<NSNumber *, NSURL *> *)bjl_backgroundImageURLStorage {
    NSMutableDictionary<NSNumber *, NSURL *> *storage = objc_getAssociatedObject(self, @selector(bjl_backgroundImageURLStorage));
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(bjl_backgroundImageURLStorage), storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

- (nullable NSURL *)bjl_currentImageURLForState:(UIControlState)state {
    return (NSURL *)[self bjl_imageURLStorage][@(state)];
}

- (void)bjl_setCurrentImageURL:(nullable NSURL *)imageURL forState:(UIControlState)state {
    [self bjl_imageURLStorage][@(state)] = imageURL;
}

- (nullable NSURL *)bjl_currentBackgroundImageURLForState:(UIControlState)state {
    return (NSURL *)[self bjl_backgroundImageURLStorage][@(state)];
}

- (void)bjl_setCurrentBackgroundImageURL:(nullable NSURL *)imageURL forState:(UIControlState)state {
    [self bjl_backgroundImageURLStorage][@(state)] = imageURL;
}

@end

#pragma mark -

@implementation UIView (BJLWebImage)

static id<BJLWebImageLoader> _bjl_imageLoader;

+ (id<BJLWebImageLoader>)bjl_imageLoader {
    _bjl_imageLoader = _bjl_imageLoader ?: ({
        Class clazz = (NSClassFromString(@"BJLWebImageLoader_YY")
                       ?: NSClassFromString(@"BJLWebImageLoader_SD")
                       ?: NSClassFromString(@"BJLWebImageLoader_AF"));
        [clazz new];
    });
    return _bjl_imageLoader;
}

+ (void)bjl_setImageLoader:(nullable id<BJLWebImageLoader>)bjl_imageLoader {
    _bjl_imageLoader = bjl_imageLoader;
}

@end

NS_ASSUME_NONNULL_END
