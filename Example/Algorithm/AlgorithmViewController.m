//
//  AlgorithmViewController.m
//  Example
//
//  Created by 张鹏 on 16/8/18.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import "AlgorithmViewController.h"

@interface AlgorithmViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *_demoNameArray;
    NSArray *_viewControllerArray;
}

@end

@implementation AlgorithmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Example";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _demoNameArray = [[NSArray alloc]initWithObjects:
                      @"AlgorithmLeetCode_TwoSum",
                      nil];
    
    _viewControllerArray = [_demoNameArray copy];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    UIButton *bt = [[UIButton alloc]init];
    [bt setTitle:@"123" forState:UIControlStateNormal];
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
    NSObject *object = [[NSClassFromString([_viewControllerArray objectAtIndex:indexPath.row]) alloc] init];
    if([object respondsToSelector:@selector(run)]){
        [object performSelector:@selector(run) withObject:nil afterDelay:0];
    }
}


@end
