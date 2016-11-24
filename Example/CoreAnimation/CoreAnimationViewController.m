//
//  CoreAnimationViewController.m
//  Example
//
//  Created by 张鹏 on 16/7/1.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import "CoreAnimationViewController.h"
#import "SSArcProcessView.h"
#import "SSRadarView.h"
#import "SSBrokenLineView.h"

@interface CoreAnimationViewController ()
{
    SSRadarView *_ssRadarView;
}
@end

@implementation CoreAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"点我" style:UIBarButtonItemStylePlain target:self action:@selector(clickMe)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self testSSBrokenLineView];
//    [self testSSArcProcessView];
//    [self testSSRadarView];
}

-(void)clickMe{
    [_ssRadarView refreshView];
}

-(void)testSSBrokenLineView{
    SSBrokenLineView *view = [[SSBrokenLineView alloc]initWithFrame:CGRectMake(10, 50, 200, 100) withYValueArray:@[@1.2,@2]];
    [self.view addSubview:view];
}

-(void)testSSArcProcessView{
    SSArcProcessView *view = [[SSArcProcessView alloc]initWithFrame:CGRectMake(10, 50, 200, 100)];
    [self.view addSubview:view];
}

-(void)testSSRadarView{
    _ssRadarView = [[SSRadarView alloc]initWithFrame:CGRectMake(10, 50, 200, 100)];
    [self.view addSubview:_ssRadarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
