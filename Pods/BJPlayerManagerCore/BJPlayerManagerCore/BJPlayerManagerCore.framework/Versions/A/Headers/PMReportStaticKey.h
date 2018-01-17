//
//  PMReportStaticKey.h
//  Pods
//
//  Created by XYP on 2016/11/4.
//
//

#import <Foundation/Foundation.h>

/*
 type 固定为video_vod
 */
extern NSString * const PMReportKeyType;

/*
 * guid
 */
extern NSString * const PMReportKeyGUID;

/*
 * uuid
 */
extern NSString * const PMReportKeyUUID;

/*
 clientype, 1：iphone 2:ipad 3：Android 4：手机M站 5：PC 网页 6：app M站
 */
extern NSString * const PMReportKeyClientType;

/*
 视频文件的唯一标识
 */
extern NSString * const PMReportKeyFileId;

/*
 起始时间点
 */
extern NSString * const PMReportKeyPlayBeginTime;

/*
 结束时间点
 */
extern NSString * const PMReportKeyPlayEndTime;

/*
 时长  endTime - beginTime
 */
extern NSString * const PMReportKeyDuration;

/*
 缓冲buffer开始时间
 */
extern NSString * const PMReportKeyBufferBeginTime;

/*
 缓冲buffer结束时间
 */
extern NSString * const PMReportKeyBufferEndTime;

/*
 cdn渠道 al：阿里; ts：腾讯; bd：百度; ws：网宿; dl：帝联; lx：蓝汛; yd:云端
 */
extern NSString * const PMReportKeyCDN;

/*
 触发事件 pause：暂停，block: 卡顿，seek: 拖放，speedup: 倍速，playerror播放出错，changecdn切换CDN，
        resolution :切换清晰度(上报切换之前的清晰度)，正常(移动端没有)，play:每次开始播放时上报，endplay:播到音视频文件末尾时触发
 */
extern NSString * const PMReportKeyEvent;

/*
 net, 网络类型 0:发生网络异常; 1:pc; 2 :wifi; 3:2G; 4:3G; 5:4G
 */
extern NSString * const PMReportKeyNetType;

/*
 resolution, 视频清晰度 1:流畅； 2：清晰；3：高清
 */
extern NSString * const PMReportKeyDefinition;

/*
 playfiletype, 播放文件的类型， mp4, flv, m3u8
 */
extern NSString * const PMReportKeyPlayFileType;

/*
 browser, 浏览器类型 1opera, 2msie, 3chrome, 4applewebkit, 5firefox, 6mozilla
 */
extern NSString * const PMReportKeyPlayBrowserType;

/*
 version, 版本号 包括：PC版本号、前端版本号、app版本号、ipad版本号 string
 */
extern NSString * const PMReportKeyVersion;

/*
 partnerid, 合作方ID
 */
extern NSString * const PMReportKeyPartnerId;

/*
 totaltime, 音视频文件时长
 */
extern NSString * const PMReportKeyTotalTime;

/*
 extern, 1. 卡顿时，该值为卡顿时间  2. 倍速时，该值为倍速数
 */
extern NSString * const PMReportKeyExtern;

/*
 filesize, 音视频文件大小
 */
extern NSString * const PMReportKeyFilesize;

/*
 userinfo, 用户自定义消息
 */
extern NSString * const PMReportKeyUserInfo;

/*
 env, 连接服务端环境
 */
extern NSString * const PMReportKeyEnv;

/*
 user_name, 点播和回放上报的自定义的用户名字
 */
extern NSString * const PMReportKeyUserName;

/*
 user_number, 点播和回放上报的自定义的用户number
 */
extern NSString * const PMReportKeyUserNumber;

#pragma mark - 广告上报

//点播广告上报相关:
//see: http://ewiki.baijiahulian.com/%E7%99%BE%E5%AE%B6%E4%BA%91/%E7%82%B9%E6%92%AD/%E5%B9%BF%E5%91%8A%E7%B3%BB%E7%BB%9F/%E6%92%AD%E6%94%BE%E5%99%A8%E5%B9%BF%E5%91%8A%E6%8E%A5%E5%8F%A3.md#page-nav-5

/*
 type, 广告上报, 广告上报该字段固定为 "baijiayun_ad", 区别于正常视频上的字段 "video_vod"
 */
extern NSString * const PMReportKeyADType;

/*
 ad_id, 广告id
 */
extern NSString * const PMReportKeyADID;

/*
 ad_pos, 广告位, start / end / pause == 片头广告 / 片尾广告 / 暂停广告
 */
extern NSString * const PMReportKeyADPos;

/*
 ad_report_type, 0:展示  1:点击
 */
extern NSString * const PMReportKeyADReportType;

