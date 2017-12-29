//
//  DataStorageBase.m
//  HuaTuApp
//
//  Created by snaptech on 14-2-24.
//  Copyright (c) 2014年 com.huatu. All rights reserved.
//

#import "DataStorageBase.h"

@implementation DataStorageBase

-(FMDatabase *) fmdb_instance{
    static FMDatabase *obj = nil;
    static dispatch_once_t onceToken;
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [stringPath stringByAppendingPathComponent:ht_db];
    dispatch_once(&onceToken,^{
        obj = [FMDatabase databaseWithPath:path];
    });
    return obj;
}

-(BOOL) open{
    return [[self fmdb_instance] open];
}

-(BOOL) close{
    return [[self fmdb_instance] close];
}

-(BOOL)beginTransaction{
    return  [[self fmdb_instance] beginTransaction];
}

-(BOOL)commit{
    return [[self fmdb_instance] commit];
}

-(BOOL)rollback{
    return [[self fmdb_instance] rollback];
}

-(BOOL)inTransaction{
    return [[self fmdb_instance] inTransaction];
}

-(BOOL)beginDeferredTransaction{
    return [[self fmdb_instance] beginDeferredTransaction];
}

#pragma mark - 配置数据库单聊
-(FMDatabaseQueue *)getSharedDatabaseQueue{
    static FMDatabaseQueue *obj = nil;
    static dispatch_once_t onceToken;
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [stringPath stringByAppendingPathComponent:ht_db];
    dispatch_once(&onceToken,^{
        obj=[FMDatabaseQueue databaseQueueWithPath:path];
    });
    return obj;
}

@end
