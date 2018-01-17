//
//  PMNotification.h
//  Pods
//
//  Created by DLM on 2016/11/8.
//
//

#import <Foundation/Foundation.h>
#import "PMPlayerMacro.h"

#define NotificationCenter [NSNotificationCenter defaultCenter]

@interface PMNotification : NSObject

#pragma mark - Notification 对外通知

//播放状态改变通知
extern NSString *const PMPlayStateChangeNotification;

//播放器实例被创建，即将播放视频
extern NSString *const PMPlayerCreateNotification;

//播放器实例被销毁，用户退出
//extern NSString *const PMPlayerDestroyNotification;

//获取到播放信息后的通知
extern NSString *const PMPlayerWillPlayNotification;

//播放地址无效的通知
extern NSString *const PMPlayerFileInvalidNotification;

//播放文件不存在的播通知
extern NSString *const PMPlayerFileNotExistNotification;

//即将seek的事件，此时播放器的状态还未改变，
//若获取seek后的事件，请监听PKMoviePlaybackStateSeekingForward,PKMoviePlaybackStateSeekingBackward
extern NSString *const PMPlayerWillSeekNotification;

//即将切换清晰度的通知，此时数据中的清晰度是以前的清晰度
extern NSString *const PMPlayerWillChangeDefinitionNotification;

//获取播放信息失败的通知
extern NSString *const PMPlayerGetPlayInfoFailedNotification;

//前贴片或者后贴片广告即将播放的通知
extern NSString *const PMPlayerADHeaderOrTailWilPlayNotification;

//前贴片或者后贴片广告 点击详情的通知
extern NSString *const PMPlayerADHeaderOrTailClickDetailNotification;

//前贴片 / 后贴片 广告的key, PMPlayerADHeaderOrTailkey
extern NSString *const PMPlayerADHeaderOrTailKey;

//前贴片 / 后贴片 广告ID的key, PMPlayerADHeaderOrTailModelkey
extern NSString *const PMPlayerADIdKey;

//后贴片即将播放的通知
extern NSString *const PMPlayerTailADWilPlayNotification;

//后贴片播放结束的通知
extern NSString *const PMPlayerTailADPlayFinishNotification;

#pragma mark - UserInfoKey 对外通知的userInfoKey


//#pragma mark - Control Notification 用于向播放器发送播放、暂停、切CDN等
////控制播放状态,点击播放、暂停等按钮时发送
//extern NSString *const PMControlChangeStatusNotification;
//
////控制下一课程，点击下一课程时发送
//extern NSString *const PMControlSwitchNextNotification;
//
////控制切换大小屏模式，点击切换大小屏时发送
//extern NSString *const PMControlSwitchScreenNotification;
//
////控制切换播放倍速，点击切换倍率时发送
//extern NSString *const PMControlChangeRateNotification;
//
////控制切换清晰度，点击更改清晰度时发送
//extern NSString *const PMControlChangeDefinitionNotification;
//
//控制切换CDN发出的通知
extern NSString *const PMControlChangeCDNNotification;
//
////seek通知，拖拽进度条时发送
//extern NSString *const PMControlSeekNotification;
//
////选集
//extern NSString *const PMControlPlayVideoNotification;
//
//#pragma mark - Control UserInfoKey 用于向播放器发送播放、暂停、切CDN等
////切换播放状态的UserInfoKey
//extern NSString *const PMControlChangeStatusUserInfoKey;
//
////切换大小屏幕的UserInfoKey
//extern NSString *const PMControlSwitchScreenUserInfoKey;
//
////切换播放速率的UserInfoKey
//extern NSString *const PMControlChangeRateUserInfoKey;
//
////切换播放清晰度的UserInfoKey
//extern NSString *const PMControlChangeDefinitionUserInfoKey;
//
////seek的UserInfoKey，值为秒
//extern NSString *const PMControlSeekUserInfoKey;
//
////选集，值为剧集videoId
//extern NSString *const PMControlPlayVideoUserInfoKey;

#pragma mark
/*
//播放进度更新通知，播放进度有更新时提醒，由播放器定时发送
extern NSString *const PMUpdateProgressNotification;

//设置播放器播放进度，值为百分比
extern NSString *const PMUpdateChangeProgressUserInfoKey;
*/
//获取倍速变化的通知
extern NSString *const PMPlayerRateChangeNotification;

@end
