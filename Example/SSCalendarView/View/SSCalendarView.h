//
//  SSCalendarView.h
//  Example
//
//  Created by 张鹏 on 15/11/11.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCalendarTool.h"
#import "SSCalendarDayCollectionViewCell.h"
#import "SSCalendarCollectionViewFlowLayout.h"
#import "SSCalendarViewController.h"

@protocol SSCalendarViewDelegate <NSObject>

-(void)clickIndexPath:(NSIndexPath *)indexPath;

@end

@interface SSCalendarView : UIView

@property(nonatomic,assign) id<SSCalendarViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

-(void)scrollToToday;
-(void)scrollToDate:(NSDate *)date;
-(void)showLineCount:(NSInteger )count;

@end
