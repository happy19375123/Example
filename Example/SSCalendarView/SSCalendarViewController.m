//
//  SSCalendarViewController.m
//  Example
//
//  Created by 张鹏 on 15/11/10.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "SSCalendarViewController.h"

@interface SSCalendarViewController ()
{
    SSCalendarView *_calendarView;
}

@property(nonatomic,strong) NSDate *nowDate;

@end

@implementation SSCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
    self.nowDate = [NSDate date];
    [self initViews];
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollToToday) userInfo:nil repeats:YES];
}

-(void)initViews{
    self.view.backgroundColor = [UIColor whiteColor];
    NSDate *startDate = [SSCalendarTool dateByAddingDays:-300 toDate:_nowDate];
    startDate = [SSCalendarTool weekFirstDate:startDate];
    NSDate *endDate = [SSCalendarTool dateByAddingDays:300 toDate:_nowDate];
    _calendarView = [[SSCalendarView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 568) startDate:startDate endDate:endDate];
    [self.view addSubview:_calendarView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToToday)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)scrollToToday{
    [_calendarView scrollToToday];
//    [_calendarView scrollToDate:[SSCalendarTool dateByAddingDays:arc4random()%100 toDate:_nowDate]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
