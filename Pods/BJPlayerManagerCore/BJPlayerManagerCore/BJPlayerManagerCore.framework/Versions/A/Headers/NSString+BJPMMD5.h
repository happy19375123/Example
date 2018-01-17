//
//  NSString+MD5.h
//  Pods
//
//  Created by DLM on 2017/4/28.
//
//

#import <Foundation/Foundation.h>

@interface NSString (BJPMMD5)

@property (readonly) NSString *md5String;

- (NSString *) BJPM_stringFromMD5;

@end
