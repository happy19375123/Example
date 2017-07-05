//
//  FenbiLectureModel.m
//  Example
//
//  Created by huatu on 2017/7/5.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import "FenbiLectureModel.h"

@implementation FenbiLectureModel

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if(self) {
        self.lectureid = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.title = dic[@"title"];
        self.tag = dic[@"tag"];
        self.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
        self.floorPrice = [NSString stringWithFormat:@"%@",dic[@"floorPrice"]];
        self.topPrice = [NSString stringWithFormat:@"%@",dic[@"topPrice"]];
        self.studentLimit = [NSString stringWithFormat:@"%@",dic[@"studentLimit"]];
        self.studentCount = [NSString stringWithFormat:@"%@",dic[@"studentCount"]];
        self.classHours = [NSString stringWithFormat:@"%@",dic[@"classHours"]];
        self.availableCount = [NSString stringWithFormat:@"%@",dic[@"availableCount"]];
    }
    return self;
}

@end
