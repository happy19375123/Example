//
//  FenbiLectureModel.h
//  Example
//
//  Created by huatu on 2017/7/5.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenbiLectureModel : NSObject

//课程ID
@property(nonatomic,copy) NSString *lectureid;
//课程标题
@property(nonatomic,copy) NSString *title;
//标签
@property(nonatomic,copy) NSString *tag;
//价格
@property(nonatomic,copy) NSString *price;
//如果是课程集，集合中最低价格
@property(nonatomic,copy) NSString *floorPrice;
//如果是课程集，集合中最高价格
@property(nonatomic,copy) NSString *topPrice;
//限售数量
@property(nonatomic,copy) NSString *studentLimit;
//已购买数量
@property(nonatomic,copy) NSString *studentCount;
//课时
@property(nonatomic,copy) NSString *classHours;
//剩余数量
@property(nonatomic,copy) NSString *availableCount;
//日期 - 精确到分
@property(nonatomic,copy) NSString *date;

-(id)initWithDic:(NSDictionary *)dic;

@end
