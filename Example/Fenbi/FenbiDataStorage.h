//
//  FenbiDataStorage.h
//  Example
//
//  Created by huatu on 2017/7/5.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStorageBase.h"
#import "FenbiLectureModel.h"

@interface FenbiDataStorage : DataStorageBase

+(FenbiDataStorage *) instance;

-(int) insert_schoolinfo:(FenbiLectureModel *)sm;

@end
