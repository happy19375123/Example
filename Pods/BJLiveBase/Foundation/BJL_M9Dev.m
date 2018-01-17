//
//  BJL_M9Dev.m
//  M9Dev
//
//  Created by MingLQ on 2016-04-20.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJL_M9Dev.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJLTuple ()

@property (nonatomic, copy) BJLTuplePackBlock pack;

@end

@implementation BJLTuple

+ (instancetype)defaultTuple {
    static BJLTuple *DefaultTuple = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DefaultTuple = [self new];
    });
    return DefaultTuple;
}

+ (instancetype)tupleWithPack:(BJLTuplePackBlock)pack {
    BJLTuple *tuple = [self new];
    tuple.pack = pack;
    return tuple;
}

@dynamic unpack; // writeonly: no getter
- (void)unpack:(id/* BJLTupleUnpackBlock */)unpack {
    (self.pack ?: ^(BJLTupleUnpackBlock unpack) {
        if (unpack) unpack(0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                           0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // 0/nil
    })(unpack);
}

@end

NS_ASSUME_NONNULL_END
