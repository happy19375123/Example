//
//  BJLUpdate.h
//  Pods
//
//  Created by Mac_ZL on 16/8/26.
//
//

#import <Foundation/Foundation.h>

typedef void(^BJLUpdateHandle)(BOOL isForce,NSString *version,NSString *downloadUrl,NSString *updateLog);

typedef NS_ENUM(NSUInteger, BJLUpdateType) {
    BJLUpdateTypeTeacher = 1,
    BJLUpdateTypeStudent = 2,
    BJLUpdateTypeOrg = 4,
    BJLUpdateTypePubMed = 9,
    BJLUpdateTypeTianxiao = 10,
    BJLUpdateTypeJinyou = 13,
    BJLUpdateTypeBaiJiaLive = 14, // 云端课堂
    BJLUpdateTypeBaiJiaApp = 15, // 百家 APP
    BJLUpdateTypeBaiJiaLiveMeeting = 16 // 云端直播
};

@interface BJLUpdateManager : NSObject

+ (instancetype)shareInstance;

/**
 *  @author LiangZhao, 16-08-26 11:08:45
 *
 *  检测升级
 *
 *  @param appType App类型，见BJLUpdateType枚举
 *  @param channel 渠道号
 *  @param handle  更新回调
 */
- (void)checkUpdate:(BJLUpdateType)appType
            channel:(NSString */* _Nullable */)channel
       updateHandle:(BJLUpdateHandle)handle;
@end
