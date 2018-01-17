//
//  BJLUpdate.h
//  Pods
//
//  Created by Mac_ZL on 16/8/26.
//
//

#import <Foundation/Foundation.h>
#import "BJLUpdateManager.h"

@interface BJLUpdate : NSObject

/**
 *  @author LiangZhao, 16-08-26 11:08:45
 *
 *  检测升级
 *
 *  @param appType App类型，见BJLUpdateType枚举
 *  @param channel 渠道号
 *  @param handle  更新回调
 */
+(void)checkUpdate:(BJLUpdateType)appType
           channel:(NSString *)channel
      updateHandle:(BJLUpdateHandle)handle;
@end
