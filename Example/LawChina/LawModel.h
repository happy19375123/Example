//
//  LawModel.h
//  Example
//
//  Created by Sseakom on 2018/7/18.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LawChapterModel.h"
#import "LawItemModel.h"

@interface LawModel : NSObject

//ID
@property(nonatomic,copy) NSString *lawID;
//标题
@property(nonatomic,copy) NSString *title;
//公布机关
@property(nonatomic,copy) NSString *publicOffice;
//公布日期
@property(nonatomic,copy) NSString *publicDate;
//施行日期
@property(nonatomic,copy) NSString *runDate;
//效力
@property(nonatomic,copy) NSString *effective;
//门类
@property(nonatomic,copy) NSString *category;
//题注说明
@property(nonatomic,copy) NSString *explanation;
//页数
@property(nonatomic,assign) NSInteger pageCount;
//题注
@property(nonatomic,strong) NSMutableArray *directoryArray;
//章节内容
@property(nonatomic,strong) NSMutableArray *contentArray;
//法条结构类型,1-正常发条，2-决定，3-司法解释
@property(nonatomic,assign) NSInteger buildType;
//法条内容类型，
@property(nonatomic,assign) NSInteger contentType;
//如果法律为多级，1000为默认，2-编，3为章
@property(nonatomic,assign) NSInteger maxLevel;
@end
