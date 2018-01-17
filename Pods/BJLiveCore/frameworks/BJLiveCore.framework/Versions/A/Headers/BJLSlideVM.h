//
//  BJLSlideVM.h
//  BJLiveCore
//
//  Created by MingLQ on 2016-12-07.
//  Copyright © 2016 BaijiaYun. All rights reserved.
//

#import "BJLBaseVM.h"

#import "BJLDocument.h"

NS_ASSUME_NONNULL_BEGIN

/** 课件管理 */
@interface BJLSlideVM : BJLBaseVM

/** 翻页课件
 #param documentID 课件 ID
 #param pageIndex 目标页在课件中的序号
 #return BJLError：
 BJLErrorCode_invalidArguments  错误参数
 */
- (nullable BJLError *)requestTurnToDocumentID:(NSString *)documentID
                                     pageIndex:(NSInteger)pageIndex;

/** 添加课件
 #discussion 添加成功将调用 `BJLSlideshowVM` 的 `didAddDocument:`
 #param document 课件
 #return BJLError：
 BJLErrorCode_invalidArguments  错误参数
 */
- (nullable BJLError *)addDocument:(BJLDocument *)document;

/** 删除课件
 #discussion 删除成功将调用 `BJLSlideshowVM` 的 `didDeleteDocument:`
 #param documentID 课件 ID
 #return BJLError：
 BJLErrorCode_invalidArguments  错误参数
 */
- (nullable BJLError *)deleteDocumentWithID:(NSString *)documentID;

/**
 上传图片，用于添加课件
 #param fileURL     图片文件路径
 #param progress    上传进度，非主线程回调、可能过于频繁
 - progress         0.0 ~ 1.0
 #param finish      结束回调：
 - document         非 nil 即为成功，用于 `addDocument:`
 - error            错误
 #return            upload task
 */
- (NSURLSessionUploadTask *)uploadImageFile:(NSURL *)fileURL
                                   progress:(nullable void (^)(CGFloat progress))progress
                                     finish:(void (^)(BJLDocument * _Nullable document, BJLError * _Nullable error))finish;

@end

NS_ASSUME_NONNULL_END
