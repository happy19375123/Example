//
//  LawChapterModel.m
//  Example
//
//  Created by Sseakom on 2018/7/24.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import "LawChapterModel.h"

@implementation LawChapterModel

-(instancetype)init{
    self = [super init];
    if(self){
        self.itemModelArray = [[NSMutableArray alloc]init];
        self.chapterModelArray = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
