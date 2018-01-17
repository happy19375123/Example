//
//  BJPMediaPublishModel.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/5/17.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import <BJLiveCore/BJliveCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPMediaPublish : NSObject

@property (nonatomic) BOOL audio_on, video_on, audio_mixed;
@property (nonatomic) NSString *data, *class_id;
@property (nonatomic) BJLUser *user;
@property (nonatomic) NSInteger offsetTimestamp;
@property (nonatomic) NSInteger publish_index;

@end

NS_ASSUME_NONNULL_END
