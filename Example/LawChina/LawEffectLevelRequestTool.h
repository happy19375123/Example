//
//  LawEffectLevelRequestTool.h
//  Example
//
//  Created by Sseakom on 2018/7/25.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LawModel.h"

/**
 *  resultDic
        errorcode
            100000 - 成功
            其他 - 失败
        msg - 提示信息
        law - 返回lawModel
 */
typedef void(^CompletionBlock)(NSDictionary *resultDic,NSError * _Nullable error);

@interface LawEffectLevelRequestTool : NSObject

-(void)requestLawInfoWithPageIndex:(NSInteger )pageIndex resultBlock:(CompletionBlock )completionBlock;


@end
