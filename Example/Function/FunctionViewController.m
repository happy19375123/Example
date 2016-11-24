//
//  FunctionViewController.m
//  Example
//
//  Created by 张鹏 on 15/10/22.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "FunctionViewController.h"

@interface FunctionViewController ()

@end

@implementation FunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self run];
    [self testRegular];
}

-(void)run{
    NSLog(@"run");
    [self RunCFAbsoluteTimeGetCurrent];
}

#pragma mark - 调试函数耗时的利器CFAbsoluteTimeGetCurrent
-(void)RunCFAbsoluteTimeGetCurrent{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    for(int i =0;i<100;i++){
        NSLog(@"%d",i);
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"time cost: %0.10f", end - start);
}

#pragma mark - 正则
-(void)testRegular{
    NSArray *array = @[@"k/v1/errors/questions/13784758695",
                       @"p/v1/practices/13784758695",
                       @"dfgdgagaddadfk/v1/collects/123123123123",
                       @"k/v1/errors/questions/[0-9]",
                       @"p/v1/practices/3425543/",
                       @"p/v1/practices/3123123123/answers"];
    for(NSString *url in array){
        NSLog(@"%@",[self cacheKeyWithUrl:url]);
    }
}

-(NSString *)cacheKeyWithUrl:(NSString *)url{
    NSString *cacheKey = @"";
    NSArray *regexArray = @[@"^.*k/v1/errors/questions/+[0-9]+$",
                            @"^.*p/v1/practices/+[0-9]+$",
                            @"^.*k/v1/collects/+[0-9]+$",
                            @"^.*p/v1/practices/+[0-9]+$",
                            @"^.*p/v1/practices/+[0-9]+/answers$"];
    for(NSString *regex in regexArray){
        BOOL result = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:url];
        if(result){
            return regex;
        }
    }
    return cacheKey;
}

-(NSString *)cacheKeygetZTKDeleteErrorQuestions:(NSString *)url{
    NSString *regexString = @"k/v1/errors/questions/+[0-9]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    if([test evaluateWithObject:url]){
        return regexString;
    }else{
        return nil;
    }
}

-(BOOL)isgetZTKWatchPracticeUrl:(NSString *)url{
    NSString *regexString = @"p/v1/practices/+[0-9]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [test evaluateWithObject:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
