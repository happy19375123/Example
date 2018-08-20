//
//  LawChapterModel.h
//  Example
//
//  Created by Sseakom on 2018/7/24.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LawChapterModel : NSObject

@property(nonatomic,copy) NSString *chapterTitle;
@property(nonatomic,strong) NSMutableArray *itemModelArray;
//如果该法律存在多级，用chapterModelArray存储
@property(nonatomic,strong) NSMutableArray *chapterModelArray;
//如果法律是多层级，-1为错误，0为默认，2为编，3为章，4为节
@property(nonatomic,assign) NSInteger level;

@end
