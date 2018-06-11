//
//  BJCommonHelper.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/9/19.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMPlayerMacro.h"

// 缓存主目录
#define CACHES_DIRECTORY     [BJCommonHelper sharedCommonHelper].rootPath

// 下载文件的总文件夹
#define BASE       @"BJDownLoad"
// 完整文件路径
#define TARGET     @"CacheList"
// 临时文件夹名称
#define TEMP       @"Temp"
// 临时文件夹的路径
#define TEMP_FOLDER          [NSString stringWithFormat:@"%@/%@/%@",CACHES_DIRECTORY,BASE,TEMP]
// 临时文件的路径
#define TEMP_PATH(name)      [NSString stringWithFormat:@"%@/%@",[BJCommonHelper createFolder:TEMP_FOLDER],name]
// 下载文件夹路径
#define FILE_FOLDER          [NSString stringWithFormat:@"%@/%@/%@",CACHES_DIRECTORY,BASE,TARGET]
// 下载文件的路径
#define FILE_PATH(name)      [NSString stringWithFormat:@"%@/%@",[BJCommonHelper createFolder:FILE_FOLDER],name]
// 文件信息的Plist路径
#define PLIST_PATH           [NSString stringWithFormat:@"%@/%@/FinishedPlist.plist",CACHES_DIRECTORY,BASE]

@interface BJCommonHelper : NSObject

/** 下载根路径, 需要传一个 存在的 文件夹 */
@property (nonatomic, strong) NSString *rootPath;

+ (BJCommonHelper *)sharedBJCommonHelper PM_Will_DEPRECATED("sharedCommonHelper");
+ (BJCommonHelper *)sharedCommonHelper;

/** 将文件大小转化成M单位或者B单位 */
+ (NSString *)getFileSizeString:(NSString *)size;
/** 经文件大小转化成不带单位的数字 */
+ (float)getFileSizeNumber:(NSString *)size;
/** 字符串格式化成日期 */
+ (NSDate *)makeDate:(NSString *)birthday;
/** 日期格式化成字符串 */
+ (NSString *)dateToString:(NSDate*)date;
/** 检查文件名是否存在 */
+ (BOOL)isExistFile:(NSString *)fileName;
+ (NSString *)createFolder:(NSString *)path;

+ (CGFloat)calculateFileSizeInUnit:(unsigned long long)contentLength;
+ (NSString *)calculateUnit:(unsigned long long)contentLength;

@end
