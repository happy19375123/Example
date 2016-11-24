//
//  UITableView+EdgeInset.m
//  Example
//
//  Created by 张鹏 on 16/7/26.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import "UITableView+EdgeInset.h"

@implementation UITableView (EdgeInset)

-(id)init{
    self = [self init];
    if(self){
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

@end
