//
//  BJStatLogger.h
//  BJEducation_student
//
//  Created by binluo on 15/11/3.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJLLogMessage.h"
#import "BJLLogStat.h"

@interface BJLLogReportManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, assign) BJLLogReportPolicy reportPolicy;
@property (nonatomic, assign) BOOL allNetworkTypes; // default: NO - wifi only
@property (nonatomic, assign) NSUInteger batchSize;
@property (nonatomic, assign) NSTimeInterval reportTimeInterval;

- (void)reportMessage:(BJLLogMessage *)message;

@property (nonatomic, readonly) BOOL started;
- (void)startNotifier;

@end
