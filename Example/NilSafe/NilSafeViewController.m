//
//  NilSafeViewController.m
//  Example
//
//  Created by huatu on 2017/12/13.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import "NilSafeViewController.h"
#import "NilSafetyManager.h"
#import "NSArray+NilSafety.h"

@interface NilSafeViewController ()

@end

@implementation NilSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testAddNilValue];
}

-(void)testAddNilValue{
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    [mArray addObject:nil];
    NSLog(@"success");
}

@end
