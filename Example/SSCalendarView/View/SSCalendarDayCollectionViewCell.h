//
//  SSCalendarDayCollectionViewCell.h
//  Example
//
//  Created by 张鹏 on 15/11/10.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCalendarTool.h"

@interface SSCalendarDayCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly) NSDate *showDate;

-(void)refreshCellWithDate:(NSDate *)date isShowSelectView:(BOOL )isShow;

-(void)isShowSelectView:(BOOL )isShow;

+(CGFloat )heightForCell;

@end
