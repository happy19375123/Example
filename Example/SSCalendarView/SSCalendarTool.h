//
//  SSCalendarTool.h
//  Example
//
//  Created by 张鹏 on 15/11/10.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CALENDAR_COMPONENTS NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay

@interface SSCalendarTool : NSObject

//+ (NSDate *)getCurrentTimeZoneDate:(NSDate *)date;
+ (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2;
+ (NSDate *)dateByAddingDays:(NSInteger )days toDate:(NSDate *)date;
+ (NSDate *)dateDayIsEqualToDayNumber:(NSInteger )dayNumber toDate:(NSDate *)date;
+ (NSDate *)dateByAddingMonths:(NSInteger )months toDate:(NSDate *)date;
+ (NSInteger)daysBetween:(NSDate *)beginDate and:(NSDate *)endDate;
+ (NSDate *)cutDate:(NSDate *)date;
+ (NSString *)descriptionForDate:(NSDate *)date;
+ (NSDate *)weekFirstDate:(NSDate *)date;
+ (NSDate *)weekLastDate:(NSDate *)date;
+ (NSDate *)monthFirstDate:(NSDate *)date;
+ (NSCalendar *)calendar;
+ (NSDate *)maxForDate:(NSDate *)date1 andDate:(NSDate *)date2;
+ (NSDate *)minForDate:(NSDate *)date1 andDate:(NSDate *)date2;
+ (NSString *)monthText:(NSInteger)month;

@end
