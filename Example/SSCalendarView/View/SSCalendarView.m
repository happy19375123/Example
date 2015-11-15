//
//  SSCalendarView.m
//  Example
//
//  Created by 张鹏 on 15/11/11.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "SSCalendarView.h"

#define CalendarViewCellHeight 45

@interface SSCalendarView()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, copy) NSDate *nowDate;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UITableView *monthCoverTableView;
@property (nonatomic) UIView *weekDayView;

@property (nonatomic,strong) NSIndexPath *selectIndexPath;
@property (nonatomic,assign) NSInteger dayCount;
@property (nonatomic,strong) NSMutableArray *fifteenDateArray;
@property (nonatomic,strong) NSMutableArray *fifteenRowNumberArray;
@property (nonatomic,assign) BOOL canResponse;
@end


@implementation SSCalendarView

- (id)initWithFrame:(CGRect)frame startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    self = [super initWithFrame:frame];
    if (self) {
        self.calendar = [SSCalendarTool calendar];
        self.startDate = startDate;
        self.endDate = endDate;
        self.nowDate = [NSDate date];
        self.dayCount = [SSCalendarTool daysBetween:self.startDate and:self.endDate] + 1;
        [self reloadMonthDataSource];
        [self makeView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

-(void)makeView{
    self.clipsToBounds = YES;
    
    NSArray *weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    _weekDayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kWidthScale(20))];
    [self addSubview:_weekDayView];
    for(int i =0; i < weekDayArray.count ; i++){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake([self cellWidth]*i, 0, [self cellWidth], kWidthScale(20))];
        label.backgroundColor = UIColorFromRGB(0xeff0f1);
        label.textColor = UIColorFromRGB(0x323232);
        label.font = [UIFont systemFontOfSize:11];
        label.text = [weekDayArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        [_weekDayView addSubview:label];
    }
    
    
    SSCalendarCollectionViewFlowLayout *flowLayout = [[SSCalendarCollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,kWidthScale(20),self.frame.size.width,self.frame.size.height) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[SSCalendarDayCollectionViewCell class] forCellWithReuseIdentifier:@"SSCalendarDayCollectionViewCell"];
    [self addSubview:_collectionView];
    
    _monthCoverTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kWidthScale(20), self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _monthCoverTableView.dataSource = self;
    _monthCoverTableView.delegate = self;
    _monthCoverTableView.hidden = YES;
    _monthCoverTableView.separatorColor = [UIColor clearColor];
    _monthCoverTableView.userInteractionEnabled = NO;
    _monthCoverTableView.backgroundColor = UIColorFromRGBWithAlpha(0xffffff, 0.6);
    [self addSubview:_monthCoverTableView];
    
    NSLog(@"%@",[SSCalendarTool dateByAddingDays:13 toDate:self.startDate]);
//    NSIndexPath *nowIndexPath = [self indexPathForDate:[SSCalendarTool dateByAddingDays:130 toDate:self.startDate]];
//    [_collectionView scrollToItemAtIndexPath:nowIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    CALayer *layer = [[CALayer alloc]init];
}

-(NSMutableArray *)getAllDayIsEqualToFifteen{
    NSMutableArray *dateArray = [[NSMutableArray alloc]init];
    NSDate *firstFifteenDate = [SSCalendarTool dateDayIsEqualToDayNumber:15 toDate:self.startDate];
    NSDate *tempDate = firstFifteenDate;
    while ([[SSCalendarTool maxForDate:tempDate andDate:self.endDate] isEqualToDate:self.endDate]) {
        [dateArray addObject:tempDate];
        tempDate = [SSCalendarTool dateByAddingMonths:1 toDate:tempDate];
    }
    
    return dateArray;
}

-(NSMutableArray *)getAllRowNumberDayIsEqualToFifteen{
    NSMutableArray *rowNumberArray = [[NSMutableArray alloc]init];
    for(NSDate *date in self.fifteenDateArray){
        [rowNumberArray addObject:[NSNumber numberWithInteger:[[self indexPathForDate:date] row]/7]];
    }
    return rowNumberArray;
}

-(void)reloadMonthDataSource{
    self.fifteenDateArray = [self getAllDayIsEqualToFifteen];
    self.fifteenRowNumberArray = [self getAllRowNumberDayIsEqualToFifteen];
}

# pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return [SSCalendarTool daysBetween:self.startDate and:self.endDate] + 1;
    return self.dayCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSCalendarDayCollectionViewCell *cell = (SSCalendarDayCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SSCalendarDayCollectionViewCell" forIndexPath:indexPath];
    NSDate *date = [self dateForCellAtIndexPath:indexPath];
    [cell refreshCellWithDate:date isShowSelectView:[self.selectIndexPath isEqual:indexPath]];
    return cell;
}

- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath{
    return [SSCalendarTool dateByAddingDays:indexPath.item toDate:self.startDate];
}

-(NSIndexPath *)indexPathForDate:(NSDate *)date{
    NSInteger daysCount = [SSCalendarTool daysBetween:self.startDate and:date];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:daysCount inSection:0];
    return indexPath;
}

# pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.belongViewController isKindOfClass:[SSCalendarViewController class]]){
        ((SSCalendarViewController *)self.belongViewController).responderString = kResponderSSCalendarView;
    }

    [self selectCollectionViewCellWithIndexPath:indexPath];
    if([self.delegate respondsToSelector:@selector(clickIndexPath:)]){
        [self.delegate clickIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    SSCalendarDayCollectionViewCell *deselectedCell = (SSCalendarDayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [deselectedCell isShowSelectView:NO];
    deselectedCell.selected = NO;
//    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

# pragma mark - UICollectionView layout

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([self cellWidth], [SSCalendarDayCollectionViewCell heightForCell]);
}

- (CGFloat)cellWidth{
    return self.frame.size.width/ 7;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dayCount%7){
        return self.dayCount/7+1;
    }else{
        return self.dayCount/7;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ExampleDemoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:19];
    }
    if([self.fifteenRowNumberArray containsObject:[NSNumber numberWithInteger:indexPath.row]]){
        NSDateComponents *showComponents = [[SSCalendarTool calendar] components:CALENDAR_COMPONENTS fromDate:[self.fifteenDateArray objectAtIndex:[self.fifteenRowNumberArray indexOfObject:[NSNumber numberWithInteger:indexPath.row]]]];
        NSDateComponents *nowComponents = [[SSCalendarTool calendar] components:CALENDAR_COMPONENTS fromDate:self.nowDate];
        NSString *month = [NSString translation:[NSString stringWithFormat:@"%ld",(long)showComponents.month]];
        if(showComponents.year == nowComponents.year){
            cell.textLabel.text = [NSString stringWithFormat:@"%@月",month];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@月 %ld",month,(long)showComponents.year];
        }
    }else{
        cell.textLabel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWidthScale(45);
}


# pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.canResponse = NO;
    if([self.belongViewController isKindOfClass:[SSCalendarViewController class]]){
        ((SSCalendarViewController *)self.belongViewController).responderString = kResponderSSCalendarView;
    }
    self.monthCoverTableView.contentSize = self.collectionView.contentSize;
    self.monthCoverTableView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.monthCoverTableView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    self.canResponse = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _monthCoverTableView){
        static float newy = 0;
        static float oldy = 0;
        newy = _monthCoverTableView.contentOffset.y ;
        if (newy != oldy ) {
            if (newy > oldy){
                
            }else if(newy < oldy){
                if([self.belongViewController isKindOfClass:[SSCalendarViewController class]] && [((SSCalendarViewController *)self.belongViewController).responderString isEqualToString:kResponderSSCalendarView]){
                    [self showLineCount:5];
                }

            }
            oldy = newy;
        }
    }
    self.monthCoverTableView.contentOffset = self.collectionView.contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.monthCoverTableView.alpha = 0;
        } completion:^(BOOL finished) {
            self.monthCoverTableView.hidden = YES;
        }];
}

#pragma mark - select CollectionViewCell
-(void)selectCollectionViewCellWithIndexPath:(NSIndexPath *)indexPath{
    self.selectIndexPath = indexPath;
    SSCalendarDayCollectionViewCell *selectedCell = (SSCalendarDayCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell isShowSelectView:YES];
    selectedCell.selected = YES;
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - public
-(void)scrollToToday{
    [self scrollToDate:_nowDate];
}

-(void)scrollToDate:(NSDate *)date{
    if([self.belongViewController isKindOfClass:[SSCalendarViewController class]] && [((SSCalendarViewController *)self.belongViewController).responderString isEqualToString:kResponderEventTableView]){
        NSLog(@"response eventtableview");
        NSArray *array = [self.collectionView indexPathsForSelectedItems];
        for(NSIndexPath *index in array){
            [self collectionView:self.collectionView didDeselectItemAtIndexPath:index];
        }

        NSIndexPath *indexPath = [self indexPathForDate:date];
        [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        
        [self selectCollectionViewCellWithIndexPath:indexPath];
    }
}

-(void)showLineCount:(NSInteger )count{
    _collectionView.height = kWidthScale(45*count);
    _monthCoverTableView.height = kWidthScale(45*count);
    self.height = kWidthScale(45*count)+kWidthScale(20);
}

@end


