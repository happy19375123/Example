//
//  PBSignalModel.h
//  BJHL-VideoPlayer-Manager
//
//  Created by 辛亚鹏 on 2017/1/7.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//  信令文件

#import <BJLiveBase/BJLYYModel.h>
#import <Foundation/Foundation.h>

static NSString *signalKeyAll = @"all", *signalKeyCommand = @"command",
                *signalKeyDoc = @"doc", *signalKeyChatFileInfo = @"chatFileInfo";

@interface BJPSignal : NSObject<BJLYYModel>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *signalKey;

@end

@interface BJPSignalModel : NSObject<BJLYYModel>

@property (nonatomic) NSArray<BJPSignal *> *chatList;
@property (nonatomic) NSArray<BJPSignal *> *signalList;

@end
