//
//  BJPMessage.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/1/18.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//  聊天信息

#import <Foundation/Foundation.h>
#import <BJLiveCore/BJliveCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPMessage : BJLMessage

@property (assign, nonatomic) NSInteger offsetTimestamp;

@end

NS_ASSUME_NONNULL_END
