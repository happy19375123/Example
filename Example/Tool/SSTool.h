//
//  SSTool.h
//  Example
//
//  Created by 张鹏 on 15/11/13.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+SSExtension.h"
#import "UIView+LayoutFrame.h"
#import "UIView+BelongViewController.h"
#import "UITableView+EdgeInset.h"
#import "UITableViewCell+EdgeInset.h"
#import "UIViewController+ESSeparatorInset.h"
#import "BJL_EXTScope.h"

@interface SSTool : NSObject

/**
 数字转汉字
 
 @param arebic 阿拉伯数字
 
 @return 汉字
 */
+(NSString *)translation:(NSString *)arebic;

//测试 AFBase64EncodedStringFromString 
+(NSString *)AFBase64EncodedStringFromString:(NSString *)string;

//测试 AES加密
+(NSString *)AESEncryptWith256Key:(NSString *)string encryptKey:(NSString *)key iv:(NSString *)iv;
@end
