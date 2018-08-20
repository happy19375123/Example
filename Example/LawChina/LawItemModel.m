//
//  LawItemModel.m
//  Example
//
//  Created by Sseakom on 2018/7/24.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import "LawItemModel.h"

@implementation LawItemModel

-(instancetype)init{
    self = [super init];
    if(self){
        self.itemArray = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
