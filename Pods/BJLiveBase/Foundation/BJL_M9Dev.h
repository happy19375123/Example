//
//  BJL_M9Dev.h
//  M9Dev
//
//  Created by MingLQ on 2016-04-20.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <Foundation/Foundation.h>

// @see M9Dev - https://github.com/iwill/

NS_ASSUME_NONNULL_BEGIN

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
    #define $available(VER, CONDITION) @available(iOS VER, *)
#else
    #define $available(VER, CONDITION) CONDITION
#endif

// for compound statement
#define bjl_return \

// value to string
#define bjl_NSObjectFromValue(VALUE, DEFAULT_VALUE) ({ VALUE ? @(VALUE) : DEFAULT_VALUE; })
#define bjl_NSStringFromValue(VALUE, DEFAULT_VALUE) ({ VALUE ? [@(VALUE) description] : DEFAULT_VALUE; })

#define bjl_NSStringFromLiteral(LITERAL)    @#LITERAL // #LITERAL - LITERAL to CString

// !!!: use DEFAULT_VALUE if PREPROCESSOR is undefined or its value is same to itself
#define bjl_NSStringFromPreprocessor(PREPROCESSOR, DEFAULT_VALUE) ({ \
    NSString *string = bjl_NSStringFromLiteral(PREPROCESSOR); \
    bjl_return [string isEqualToString:@#PREPROCESSOR] ? DEFAULT_VALUE : string; \
})

// #define NSNULL [NSNull null]

// version comparison
// bjl_NSVersionLT(@"10", @"10.0"));    // YES - X
// bjl_NSVersionLT(@"10", @"10"));      // NO  - √
#define bjl_NSVersionEQ(A, B) ({ [A compare:B options:NSNumericSearch] == NSOrderedSame; })
#define bjl_NSVersionLT(A, B) ({ [A compare:B options:NSNumericSearch] <  NSOrderedSame; })
#define bjl_NSVersionGT(A, B) ({ [A compare:B options:NSNumericSearch] >  NSOrderedSame; })
#define bjl_NSVersionLE(A, B) ({ [A compare:B options:NSNumericSearch] <= NSOrderedSame; })
#define bjl_NSVersionGE(A, B) ({ [A compare:B options:NSNumericSearch] >= NSOrderedSame; })

// cast
#define bjl_cast(CLASS, OBJECT) ({ (CLASS *)([OBJECT isKindOfClass:[CLASS class]] ? (OBJECT) : nil); })

// struct
// cast to ignore const: bjl_structSet((CGRect)CGRectZero, { set.size = [self intrinsicContentSize]; })
#define bjl_structSet(_STRUCT, STATEMENTS) ({ \
    __typeof__(_STRUCT) set = _STRUCT; \
    STATEMENTS \
    set; \
})

// variable arguments
#define bjl_va_each(TYPE, FIRST, BLOCK) { \
    va_list args; \
    va_start(args, FIRST); \
    for (TYPE arg = FIRST; !!arg; arg = va_arg(args, TYPE)) { \
        BLOCK(arg); \
    } \
    va_end(args); \
}

// strongify if nil
// bjl_strongify_ifNil(self) return;
#define bjl_strongify_ifNil(...) \
    bjl_strongify(__VA_ARGS__); \
    if ([NSArray arrayWithObjects:__VA_ARGS__, nil].count != metamacro_argcount(__VA_ARGS__))

// milliseconds
typedef long long BJLMilliseconds;
#define BJL_MSEC_PER_SEC            1000ull
#define BJLMillisecondsSince1970    BJLMillisecondsFromTimeInterval(NSTimeIntervalSince1970)
static inline BJLMilliseconds BJLMillisecondsFromTimeInterval(NSTimeInterval timeInterval) {
    return (BJLMilliseconds)(timeInterval * BJL_MSEC_PER_SEC);
}
static inline NSTimeInterval BJLTimeIntervalFromMilliseconds(BJLMilliseconds milliseconds) {
    return (NSTimeInterval)milliseconds / BJL_MSEC_PER_SEC;
}

// dispatch
/*
static inline dispatch_time_t bjl_dispatch_time_in_seconds(NSTimeInterval seconds) {
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC));
}
static inline void bjl_dispatch_after_seconds(NSTimeInterval seconds, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_after(bjl_dispatch_time_in_seconds(seconds), queue ?: dispatch_get_main_queue(), block);
}
*/
static inline void bjl_dispatch_sync_main_queue(dispatch_block_t block) {
    if ([NSThread isMainThread]) block();
    else dispatch_sync(dispatch_get_main_queue(), block);
}
static inline void bjl_dispatch_async_main_queue(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), block);
}
static inline void bjl_dispatch_async_background_queue(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}    

// safe range
static inline NSRange BJL_NSMakeSafeRange(NSUInteger loc, NSUInteger len, NSUInteger length) {
    loc = MIN(loc, length);
    len = MIN(len, length - loc);
    return NSMakeRange(loc, len);
}
static inline NSRange BJL_NSSafeRangeForLength(NSRange range, NSUInteger length) {
    return BJL_NSMakeSafeRange(range.location, range.length, length);
}

// this class
#define BJL_THIS_CLASS_NAME ({ \
    static NSString *ClassName = nil; \
    if (!ClassName) {\
        NSString *prettyFunction = [NSString stringWithUTF8String:__PRETTY_FUNCTION__]; \
        NSUInteger loc = [prettyFunction rangeOfString:@"["].location + 1; \
        NSUInteger len = [prettyFunction rangeOfString:@" "].location - loc; \
        NSRange range = BJL_NSMakeSafeRange(loc, len, prettyFunction.length); \
        ClassName = [prettyFunction substringWithRange:range]; \
    } \
    ClassName; \
})
#define BJL_THIS_CLASS NSClassFromString(BJL_THIS_CLASS_NAME)

/**
 *  M9TuplePack & M9TupleUnpack
 *  define:
 *      - (BJLTuple<void (^)(BOOL state1, BOOL state2> *)states;
 *  pack:
 *      BOOL state1 = self.state1, state2 = self.state2;
 *      return BJLTuplePack((BOOL, BOOL), state1, state2);
 *  unpack:
 *      BJLTupleUnpack(tuple) = ^(BOOL state1, BOOL state2) {
 *          // ...
 *      };
 */
/* !!!: BJLTuplePack(void (^)(BOOL), self.state)
 *  1. BJLTuplePack 中使用到的对象将被 tuple 持有、直到 tuple 被释放，例如上面的 self；
 *  2. self.state 的值将在拆包时读取、而不是打包时；
 *      BJLTuple *tuple = BJLTuplePack(void (^)(BOOL, BOOL), self.state1, self.state2);
 *  因此【强烈建议】定义临时变量提前读取属性值，以避免出现不可预期的结果！
 *      BOOL state1 = self.state1, state2 = self.state2;
 *      BJLTuple *tuple = BJLTuplePack(void (^)(BOOL, BOOL), state1, state2);
 */
#define BJLTuplePack(TYPE, ...) _BJLTuplePack(void (^)TYPE, __VA_ARGS__)
#define _BJLTuplePack(TYPE, ...) \
({[BJLTuple tupleWithPack:^(BJLTupleUnpackBlock unpack) { \
    if (unpack) ((TYPE)unpack)(__VA_ARGS__); \
}];})
/**
 *  这里不需要 weakify&strongify，unpack block 会被立即执行
 *  !!!: 用 ([BJLTuple defaultTuple], TUPLE) 而不是 (TUPLE ?: [BJLTuple defaultTuple])，因为后者会导致 TUPLE 被编译器认为是 nullable 的
 */
#define BJLTupleUnpack(TUPLE)   ([BJLTuple defaultTuple], TUPLE).unpack
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
typedef void (^BJLTupleUnpackBlock)(/* ... */);
#pragma clang diagnostic pop
typedef void (^BJLTuplePackBlock)(BJLTupleUnpackBlock unpack);
// - (BJLTuple<BJLTupleGeneric(NSString *string, NSInteger integer, ...)> *)aTuple;
#define BJLTupleGeneric         void (^)
// - (BJLTupleType(NSString *string, NSInteger integer))aTuple;
#define BJLTupleType(...)       BJLTuple<void (^)(__VA_ARGS__)> *
@interface BJLTuple<BJLTupleUnpackTypeGeneric> : NSObject
@property (nonatomic/* , writeonly */, assign, setter=unpack:) id/* <BJLTupleUnpackTypeGeneric> */ unpack;
+ (instancetype)tupleWithPack:(BJLTuplePackBlock)pack;
+ (instancetype)defaultTuple;
@end

// RACTupleUnpack without unused warning
#define BJL_RACTupleUnpack(...) \
_Pragma("GCC diagnostic push") \
_Pragma("GCC diagnostic ignored \"-Wunused-variable\"") \
RACTupleUnpack(__VA_ARGS__) \
_Pragma("GCC diagnostic pop")

NS_ASSUME_NONNULL_END
