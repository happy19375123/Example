//
//  SSCalendarViewController.m
//  Example
//
//  Created by 张鹏 on 15/11/10.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "SSCalendarViewController.h"

@interface SSCalendarViewController ()<UITableViewDataSource,UITableViewDelegate,SSCalendarViewDelegate>
{
    SSCalendarView *_calendarView;
    UITableView *_eventTableView;
}

@property(nonatomic,strong) NSDate *nowDate;
@property(nonatomic,strong) NSDate *startDate;
@property(nonatomic,strong) NSDate *endDate;
@property(nonatomic,strong) NSMutableArray *dateArray;
@property(nonatomic,assign) BOOL canResponse;

@end

@implementation SSCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
    self.dateArray = [[NSMutableArray alloc]init];
    self.nowDate = [NSDate date];
    _startDate = [SSCalendarTool dateByAddingDays:-300 toDate:_nowDate];
    _startDate = [SSCalendarTool weekFirstDate:_startDate];
    _endDate = [SSCalendarTool dateByAddingDays:300 toDate:_nowDate];
    
    NSDate *tempDate = [_startDate copy];
    while ([SSCalendarTool daysBetween:tempDate and:_endDate] > -1) {
        [_dateArray addObject:tempDate];
        tempDate = [SSCalendarTool dateByAddingDays:1 toDate:tempDate];
    }

    [self initViews];
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollToToday) userInfo:nil repeats:YES];
}

-(void)initViews{
    self.view.backgroundColor = [UIColor whiteColor];
    _calendarView = [[SSCalendarView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kWidthScale(45)*5+kWidthScale(20)) startDate:_startDate endDate:_endDate];
    _calendarView.delegate = self;
    [self.view addSubview:_calendarView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToToday)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    _eventTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _calendarView.height, self.view.frame.size.width, self.view.frame.size.height-_calendarView.height) style:UITableViewStylePlain];
    _eventTableView.dataSource = self;
    _eventTableView.delegate = self;
    [self.view addSubview:_eventTableView];
    [_eventTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(0);
        make.right.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(_calendarView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.view).offset(0);
    }];

    
    UIView *layer = [[UIView alloc]init];
    layer.frame = CGRectMake(0, 1, self.view.frame.size.height, 1);
    layer.backgroundColor = _eventTableView.separatorColor;
    [_eventTableView addSubview:layer];
}

-(void)scrollToToday{
    [_calendarView scrollToDate:[SSCalendarTool dateByAddingDays:arc4random()%100 toDate:_nowDate]];
    [_calendarView showLineCount:2];
    
//    [_calendarView scrollToToday];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [SSCalendarTool daysBetween:_startDate and:_endDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ExampleDemoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = @"没有签到记录";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWidthScale(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kWidthScale(30);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kWidthScale(30))];
    view.backgroundColor = UIColorFromRGB(0xf8f8f9);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kWidthScale(30))];
    [view addSubview:label];
    label.layer.borderColor = [UIColorFromRGB(0xdcdcdc) CGColor];
    label.layer.borderWidth = 0.5;
    label.textColor = UIColorFromRGB(0x323232);
    label.font = [UIFont systemFontOfSize:13];
    NSDate *date = [_dateArray objectAtIndex:section];
    label.text = [self getDateString:date];
    return view;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self getDateString:[_dateArray objectAtIndex:section]];
}

//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0){
////    UITableViewCell *cell = [[_eventTableView visibleCells] objectAtIndex:0];
////    NSIndexPath *indexPath = [_eventTableView indexPathForCell:cell];
//
//    NSDate *date = [_dateArray objectAtIndex:section];
//    NSLog(@"%@",date);
//    [_calendarView scrollToDate:date];
//}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self calendarViewScrollToDate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView == _eventTableView){
        self.responderString = kResponderEventTableView;
        [_calendarView showLineCount:2];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [_eventTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_calendarView.mas_bottom).offset(0);
            }];
            [_eventTableView layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    self.canResponse = YES;
    [self calendarViewScrollToDate];
}

-(void)calendarViewScrollToDate{
    if([[_eventTableView indexPathsForVisibleRows] count] > 0){
        
        //判断是否滑到底部
        CGPoint offset = _eventTableView.contentOffset;
        CGRect bounds = _eventTableView.bounds;
        CGSize size = _eventTableView.contentSize;
        UIEdgeInsets inset = _eventTableView.contentInset;
        CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
        CGFloat maximumOffset = size.height;
        if(currentOffset >= maximumOffset){
            return;
        }
        
        NSIndexPath *indexPath = [[_eventTableView indexPathsForVisibleRows] objectAtIndex:0];
        NSDate *date = [_dateArray objectAtIndex:indexPath.section];
        [_calendarView scrollToDate:date];
    }
}

-(NSString *)getDateString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"    yyyy-MM-dd EEEE";
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

#pragma mark - SSCalendarView Delegate
-(void)clickIndexPath:(NSIndexPath *)indexPath{
    if([self.responderString isEqualToString:kResponderSSCalendarView]){
        NSLog(@"response calendar");
        [_eventTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.item] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
