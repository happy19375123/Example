//
//  BJLSurvey.h
//  BJLiveUI
//
//  Created by MingLQ on 2017-03-07.
//  Copyright © 2017 BaijiaYun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BJLSurveyOption;

typedef NS_ENUM(NSInteger, BJLSurveyResult) {
    BJLSurveyResultRight = 0,   // 正确
    BJLSurveyResultWrong = 1,   // 错误
    BJLSurveyResultNA    = - 1  // 没有标准答案
};

/**
 测验题目
 */
@interface BJLSurvey : NSObject

/** 序号 */
@property (nonatomic) NSInteger order;
/** 题干 */
@property (nonatomic, copy) NSString *question;
/** 选项 */
@property (nonatomic, copy) NSArray<BJLSurveyOption *> *options;

@end

/**
 测验选项
 */
@interface BJLSurveyOption : NSObject

/**
 key: 选项 A, B, C, D;
 value: 选项描述 */
@property (nonatomic, copy) NSString *key, *value;
/** 是否是答案选项 */
@property (nonatomic) BOOL isAnswer;

/** 答题结果中选择此选项的人数 */
@property (nonatomic) NSInteger userCount;

@end

NS_ASSUME_NONNULL_END
