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
    [self run];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
