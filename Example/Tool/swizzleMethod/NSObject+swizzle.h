//
//  NSObject+swizzle.h
//  swizzleMethod
//
//  Created by Oborn.Jung on 16/10/10.
//  Copyright © 2016年 ATG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (swizzle)

+ (BOOL)sm_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;

+ (BOOL)sm_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel;

@end
