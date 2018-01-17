//
//  BJPUserVM.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/1/12.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BJLiveCore/BJliveCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPOnlineUserVM : NSObject

/** 在线人数 */
@property (nonatomic, readonly) NSInteger onlineUsersTotalCount;

/** 有用户进入房间
 同时更新 `onlineUsers` */
- (BJLObservable)onlineUserDidEnter:(BJLOnlineUser *)user;
/** 有用户退出房间
 同时更新 `onlineUsers` */
- (BJLObservable)onlineUserDidExit:(BJLOnlineUser *)user;


/**
 监听可以获取userCount
*/
- (BJLObservable)onlineUserCount:(nullable NSNumber *)count;

/**
 监听可以获取用户列表
*/
- (BJLObservable)onlineUserList:(nullable NSArray <BJLOnlineUser *> *)userList;

@end

NS_ASSUME_NONNULL_END
