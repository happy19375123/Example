//
//  PMPlayerMacro.h
//  Pods
//
//  Created by DLM on 2016/10/31.
//
//

#ifndef PMPlayerMacro_h
#define PMPlayerMacro_h

#define PM_Will_DEPRECATED(function) __attribute__((deprecated("This method will deprecated, replace with" function )))
#define PM_DID_DEPRECATED(function) __attribute__((deprecated("This Method Has DEPRECATED !!!" function )))

#ifdef DEBUG
#define PMLog( s, ...) NSLog(@"<%@ :%d> %@",[[NSString stringWithUTF8String:__FILE__]lastPathComponent],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__]);
#else
#define PMLog(...)
#endif

#define YPWeakObj(objc) autoreleasepool{} __weak typeof(objc) objc##Weak = objc;
#define YPStrongObj(objc) autoreleasepool{} __strong typeof(objc) objc = objc##Weak;

typedef NS_ENUM(NSUInteger, PMPlayState) {
    PMPlayStateStopped,
    PMPlayStatePlaying,
    PMPlayStatePaused,
    PMPlayStateSeeking,
};


#endif /* PMPlayerMacro_h */

