//
//  BJPAuthorization.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/28.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, BJPAuthorizationType) {
    BJPAuthorizationType_photos     = 1 << 0,
    BJPAuthorizationType_microphone = 1 << 1,
    BJPAuthorizationType_camera     = 1 << 2
};

typedef void (^BJPAuthorizationCallback)(BOOL granted, UIAlertController * _Nullable alert);

@interface BJPAuthorization : NSObject

+ (void)checkPhotosAccessAndRequest:(BOOL)request callback:(BJPAuthorizationCallback)callback;
+ (void)checkMicrophoneAccessAndRequest:(BOOL)request callback:(BJPAuthorizationCallback)callback;
+ (void)checkCameraAccessAndRequest:(BOOL)request callback:(BJPAuthorizationCallback)callback;

+ (void)checkAccessTypes:(BJPAuthorizationType)types request:(BOOL)request callback:(BJPAuthorizationCallback)callback;

@end

NS_ASSUME_NONNULL_END
