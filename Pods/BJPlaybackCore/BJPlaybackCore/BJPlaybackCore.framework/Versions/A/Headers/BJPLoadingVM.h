//
//  BJPLoadingVM.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/1/9.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPLoadingVM : NSObject

- (BJLObservable)downloadTextFileWithError:(nullable BJLError*)error;

@end

NS_ASSUME_NONNULL_END
