//
//  BJPPlaybackCoreMacro.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/2/7.
//  Copyright (c) 2017 Baijia Cloud. All rights reserved.
//

#ifndef BJPPlaybackCoreMacro_h
#define BJPPlaybackCoreMacro_h

#define BJP_Will_DEPRECATED(function) __attribute__((deprecated("This method will deprecated, replace with" function )))

#ifdef DEBUG

#define PDLog(fmt, ...) {NSLog((@"" fmt),##__VA_ARGS__);}//{NSLog((@"%s [Line %d]\n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define PDLog(...)
#endif

#endif /* BJPPlaybackCoreMacro_h */
