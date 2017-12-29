//
//  ViewController.m
//  Example
//
//  Created by 张鹏 on 15/10/22.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *_demoNameArray;
    NSArray *_viewControllerArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@",stringPath);
    self.title = @"Example";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _demoNameArray = [[NSArray alloc]initWithObjects:
                      @"FunctionViewController",
                      @"SSCalendarViewController",
                      @"GpuImageFirstViewController",
                      @"TextKitViewController",
                      @"CoreAnimationViewController",
                      @"AlgorithmViewController",
                      @"GameCenterViewController",
                      @"FenbiViewController",
                      @"TestRequestViewController",
                      @"PlistToJsonViewController",
                      @"DownloadViewController",
                      @"NilSafeViewController",
                      nil];
    
    _viewControllerArray = [[NSArray alloc]initWithObjects:
                            @"FunctionViewController",
                            @"SSCalendarViewController",
                            @"GpuImageFirstViewController",
                            @"TextKitViewController",
                            @"CoreAnimationViewController",
                            @"AlgorithmViewController",
                            @"GameCenterViewController",
                            @"FenbiViewController",
                            @"TestRequestViewController",
                            @"PlistToJsonViewController",
                            @"DownloadViewController",
                            @"NilSafeViewController",
                            nil];

    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    UIButton *bt = [[UIButton alloc]init];
    [bt setTitle:@"123" forState:UIControlStateNormal];
    
//    [[[UIAlertView alloc]initWithTitle:@"测试" message:@"我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    NSNumber *step = [NSNumber numberWithInteger:123];
}


#pragma mark -
#pragma mark Table view data source


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _demoNameArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ExampleDemoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_demoNameArray objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController* viewController = [[NSClassFromString([_viewControllerArray objectAtIndex:indexPath.row]) alloc] init];
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    [self.navigationController pushViewController:viewController animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
