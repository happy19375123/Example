//
//  LawModel.m
//  Example
//
//  Created by Sseakom on 2018/7/18.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import "LawModel.h"

@implementation LawModel

-(instancetype)init{
    self = [super init];
    if(self){
        self.directoryArray = [[NSMutableArray alloc]init];
        self.contentArray = [[NSMutableArray alloc]init];
        self.maxLevel = 1000;
    }
    return self;
}


@end
