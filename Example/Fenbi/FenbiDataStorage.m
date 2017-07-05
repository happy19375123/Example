//
//  FenbiDataStorage.m
//  Example
//
//  Created by huatu on 2017/7/5.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import "FenbiDataStorage.h"

@implementation FenbiDataStorage

+(FenbiDataStorage *) instance{
    static FenbiDataStorage *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        obj = [[FenbiDataStorage alloc] init];
    });
    return obj;
}

-(int) insert_schoolinfo:(FenbiLectureModel *)sm{
    //打开
    BOOL res = [self open];
    if (res == NO) {
        NSLog(@"打开失败");
        return -1;
    }
    
    //如果没有表，创建表
    res = [[self fmdb_instance] executeUpdate:@"create table if not exists FenbiLecture(id integer primary key autoincrement,lectureid text,title text,tag text,price text,floorPrice text,topPrice text,studentLimit text,studentCount text,classHours text,availableCount text,date text)"];
    if (res == NO) {
        NSLog(@"创建失败");
        [self close];
        return -1;
    }

    res = [[self fmdb_instance] executeUpdate:@"insert into FenbiLecture(lectureid,title,tag,price,floorPrice,topPrice,studentLimit,studentCount,classHours,availableCount,date) values(?,?,?,?,?,?,?,?,?,?,?)",sm.lectureid,sm.title,sm.tag,sm.price,sm.floorPrice,sm.topPrice,sm.studentLimit,sm.studentCount,sm.classHours,sm.availableCount,sm.date];
    if (res == NO) {
        NSLog(@"添加失败");
    }
    //关闭数据库
    [self close];
    return 0;
}


@end
