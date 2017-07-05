//
//  DataStorageBase.h
//  HuaTuApp
//
//  Created by snaptech on 14-2-24.
//  Copyright (c) 2014年 com.huatu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DataStorageBase : NSObject

-(FMDatabase *) fmdb_instance;
-(BOOL) open;
-(BOOL) close;


-(BOOL) commit;

-(BOOL)beginTransaction;
-(BOOL)rollback;
-(BOOL)inTransaction;
-(BOOL)beginDeferredTransaction;

-(FMDatabaseQueue *)getSharedDatabaseQueue;

@end
