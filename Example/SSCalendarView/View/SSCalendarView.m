//
//  SSCalendarView.m
//  Example
//
//  Created by 张鹏 on 15/11/11.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "SSCalendarView.h"

@interface SSCalendarView()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, copy) NSDate *nowDate;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UITableView *monthCoverTableView;

@property (weak, nonatomic) UIView *magnifierContainer;
@property (weak, nonatomic) UIImageView *maginifierContentView;

@property (nonatomic,strong) NSIndexPath *selectIndexPath;
@property (nonatomic,assign) NSInteger dayCount;
@property (nonatomic,strong) NSMutableArray *fifteenDateArray;
@property (nonatomic,strong) NSMutableArray *fifteenRowNumberArray;
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

-(void)makeView{
    SSCalendarCollectionViewFlowLayout *flowLayout = [[SSCalendarCollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[SSCalendarDayCollectionViewCell class] forCellWithReuseIdentifier:@"SSCalendarDayCollectionViewCell"];
    [self addSubview:_collectionView];
    
    _monthCoverTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _monthCoverTableView.dataSource = self;
    _monthCoverTableView.delegate = self;
    _monthCoverTableView.hidden = NO;
//    _monthCoverTableView.separatorColor = [UIColor clearColor];
    _monthCoverTableView.alpha = 0;
    [self addSubview:_monthCoverTableView];
    
    NSLog(@"%@",[SSCalendarTool dateByAddingDays:13 toDate:self.startDate]);
//    NSIndexPath *nowIndexPath = [self indexPathForDate:[SSCalendarTool dateByAddingDays:130 toDate:self.startDate]];
//    [_collectionView scrollToItemAtIndexPath:nowIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
    
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

#pragma mark - public
-(void)scrollToToday{
    [self scrollToDate:_nowDate];
}

-(void)scrollToDate:(NSDate *)date{
    NSIndexPath *indexPath = [self indexPathForDate:date];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//    [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
    [self collectionView:_collectionView didSelectItemAtIndexPath:indexPath];
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
//    NSDate *date = [self dateForCellAtIndexPath:indexPath];
    self.selectIndexPath = indexPath;
    [collectionView reloadData];
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
    return self.frame.size.width/ 7.0;
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
    }
    if([self.fifteenRowNumberArray containsObject:[NSNumber numberWithInteger:indexPath.row]]){
        NSDateComponents *showComponents = [[SSCalendarTool calendar] components:CALENDAR_COMPONENTS fromDate:[self.fifteenDateArray objectAtIndex:[self.fifteenRowNumberArray indexOfObject:[NSNumber numberWithInteger:indexPath.row]]]];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld月 %ld",(long)showComponents.month,(long)showComponents.year];
    }else{
        cell.textLabel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


# pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.monthCoverTableView.contentSize = self.collectionView.contentSize;
    self.monthCoverTableView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.monthCoverTableView.alpha = 1;
        self.collectionView.alpha = 0.3;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // update month cover
    self.monthCoverTableView.contentOffset = self.collectionView.contentOffset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.monthCoverTableView.alpha = 0;
        self.collectionView.alpha = 1;
    } completion:^(BOOL finished) {
        self.monthCoverTableView.hidden = YES;
    }];
}


@end


