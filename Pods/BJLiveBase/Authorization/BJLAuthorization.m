//
//  BJLAuthorization.m
//  M9Dev
//
//  Created by MingLQ on 2016-06-04.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "BJLAuthorization.h"

#define appName             ({ \
    NSDictionary *localizedInfoDictionary = [[NSBundle mainBundle] localizedInfoDictionary]; \
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary]; \
    (localizedInfoDictionary[(NSString *)kCFBundleNameKey] \
     ?: infoDictionary[(NSString *)kCFBundleNameKey] \
     ?: localizedInfoDictionary[@"CFBundleDisplayName"] \
     ?: infoDictionary[@"CFBundleDisplayName"] \
     ?: @"APP"); \
})
#define titleFormat         @"%@被禁用"
#define restrictedFormat    @"请在“[设置]-[通用]-[访问限制]”里允许%@使用"
#define deniedFormat        @"请在“[设置]-[隐私]-[%@]”里允许%@使用"

NS_ASSUME_NONNULL_BEGIN

@implementation BJLAuthorization

+ (UIAlertController *)askToOpenSettingsWithName:(NSString *)name
                                        isDenied:(BOOL)isDenied {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:[NSString stringWithFormat:titleFormat, name]
                                message:(isDenied
                                         ? [NSString stringWithFormat:deniedFormat, name, appName]
                                         : [NSString stringWithFormat:restrictedFormat, appName])
                                preferredStyle:UIAlertControllerStyleAlert];
    
    if (isDenied) {
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"设置"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * _Nonnull action) {
                              NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                              UIApplication *application = [UIApplication sharedApplication];
                              if (bjl_available(iOS 10.0, [application respondsToSelector:@selector(openURL:options:completionHandler:)])) {
                                  [application openURL:appSettings
                                               options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO}
                                     completionHandler:nil];
                              }
                              else if ([application canOpenURL:appSettings]) {
                                  [application openURL:appSettings];
                              }
                          }]];
    }
    [alert addAction:[UIAlertAction
                      actionWithTitle:isDenied ? @"取消" : @"确定"
                      style:UIAlertActionStyleCancel
                      handler:nil]];
    
    return alert;
}

+ (void)checkCameraAccessAndRequest:(BOOL)request callback:(BJLAuthorizationCallback)callback {
    NSString *name = @"相机";
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            if (request) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (callback) callback(granted, nil);
                    });
                }];
            }
            else {
                if (callback) callback(YES, nil);
            }
            break;
        }
        case AVAuthorizationStatusRestricted: {
            if (callback) callback(NO, [self askToOpenSettingsWithName:name isDenied:NO]);
            break;
        }
        case AVAuthorizationStatusDenied: {
            if (callback) callback(NO, [self askToOpenSettingsWithName:name isDenied:YES]);
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            if (callback) callback(YES, nil);
            break;
        }
    }
}

+ (void)checkMicrophoneAccessAndRequest:(BOOL)request callback:(BJLAuthorizationCallback)callback {
    NSString *name = @"麦克风";
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            if (request) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (callback) callback(granted, nil);
                    });
                }];
            }
            else {
                if (callback) callback(YES, nil);
            }
            break;
        }
        case AVAuthorizationStatusRestricted: {
            if (callback) callback(NO, [self askToOpenSettingsWithName:name isDenied:NO]);
            break;
        }
        case AVAuthorizationStatusDenied: {
            if (callback) callback(NO, [self askToOpenSettingsWithName:name isDenied:YES]);
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            if (callback) callback(YES, nil);
            break;
        }
    }
}

+ (void)checkPhotosAccessAndRequest:(BOOL)request callback:(BJLAuthorizationCallback)callback {
    NSString *name = @"照片";
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    switch (authStatus) {
        case PHAuthorizationStatusNotDetermined: {
            if (request) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        BOOL granted = (status == PHAuthorizationStatusAuthorized);
                        if (callback) callback(granted, nil);
                    });
                }];
            }
            else {
                if (callback) callback(YES, nil);
            }
            break;
        }
        case PHAuthorizationStatusRestricted: {
            if (callback) callback(NO, [self askToOpenSettingsWithName:name isDenied:NO]);
            break;
        }
        case PHAuthorizationStatusDenied: {
            if (callback) callback(NO, [self askToOpenSettingsWithName:name isDenied:YES]);
            break;
        }
        case PHAuthorizationStatusAuthorized: {
            if (callback) callback(YES, nil);
            break;
        }
    }
}

+ (void)checkAccessTypes:(BJLAuthorizationType)types request:(BOOL)request callback:(BJLAuthorizationCallback)callback {
    NSEnumerator *typesEnumerator = ({
        NSMutableArray *typesArray = [NSMutableArray new];
        if (types & BJLAuthorizationType_photos) {
            [typesArray addObject:@(BJLAuthorizationType_photos)];
        }
        if (types & BJLAuthorizationType_microphone) {
            [typesArray addObject:@(BJLAuthorizationType_microphone)];
        }
        if (types & BJLAuthorizationType_camera) {
            [typesArray addObject:@(BJLAuthorizationType_camera)];
        }
        [typesArray objectEnumerator];
    });
    
    __block BJLAuthorizationCallback authorizationCallback = ^(BOOL granted, UIAlertController * _Nullable alert) {
        NSNumber *typeNumber = [typesEnumerator nextObject];
        if (granted && typeNumber) {
            switch (typeNumber.integerValue) {
                case BJLAuthorizationType_photos:
                    [self checkPhotosAccessAndRequest:request callback:authorizationCallback];
                    break;
                case BJLAuthorizationType_microphone:
                    [self checkMicrophoneAccessAndRequest:request callback:authorizationCallback];
                    break;
                default: // BJLAuthorizationType_camera
                    [self checkCameraAccessAndRequest:request callback:authorizationCallback];
                    break;
            }
        }
        else {
            authorizationCallback = nil;
            callback(granted, alert);
        }
    };
    
    // fire
    authorizationCallback(YES, nil);
}

@end

NS_ASSUME_NONNULL_END
