//
//  SSCalendarDayCollectionViewCell.m
//  Example
//
//  Created by 张鹏 on 15/11/10.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "SSCalendarDayCollectionViewCell.h"

@implementation SSCalendarDayCollectionViewCell
{
    UILabel *_coverLabel;
    UILabel *_dayLabel;
    
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    _coverLabel = [[UILabel alloc]init];
    _coverLabel.backgroundColor = UIColorFromRGB(0xf7c3c2);
    _coverLabel.hidden = YES;
    _coverLabel.font = [UIFont systemFontOfSize:18];
    _coverLabel.textColor = [UIColor whiteColor];
    _coverLabel.textAlignment = NSTextAlignmentCenter;
    _coverLabel.numberOfLines = 0;
    _coverLabel.layer.cornerRadius = kWidthScale(15);
    _coverLabel.clipsToBounds = YES;
    [self addSubview:_coverLabel];
    [_coverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kWidthScale(9));
        make.top.mas_equalTo(self).offset(kWidthScale(7));
        make.size.mas_equalTo(CGSizeMake(kWidthScale(30), kWidthScale(30)));
    }];

    _dayLabel = [[UILabel alloc]init];
    _dayLabel.font = [UIFont systemFontOfSize:18];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.numberOfLines = 0;
    [self addSubview:_dayLabel];
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(0);
        make.right.mas_equalTo(self).offset(0);
        make.top.mas_equalTo(self).offset(0);
        make.bottom.mas_equalTo(self).offset(0);
    }];

}

-(void)refreshCellWithDate:(NSDate *)date isShowSelectView:(BOOL )isShow{
    [self isShowSelectView:isShow];
    
    _showDate = [date copy];
    NSDate *nowDate = [NSDate date];
    
    NSDateComponents *showComponents = [[SSCalendarTool calendar] components:CALENDAR_COMPONENTS fromDate:self.showDate];
    NSInteger showDay = showComponents.day;
    NSInteger showMonth = showComponents.month;
    NSInteger showYear = showComponents.year;

    
    NSDateComponents *nowComponents = [[SSCalendarTool calendar] components:CALENDAR_COMPONENTS fromDate:nowDate];
    NSInteger nowDay = nowComponents.day;
    NSInteger nowMonth = nowComponents.month;
    NSInteger nowYear = nowComponents.year;
    
    _dayLabel.text = [NSString stringWithFormat:@"%ld",(long)showDay];
    _coverLabel.text = [NSString stringWithFormat:@"%ld",(long)showDay];
    _dayLabel.font = [UIFont systemFontOfSize:18];
    
    if([SSCalendarTool daysBetween:nowDate and:_showDate] <= -1){
        self.backgroundColor = UIColorFromRGB(0xeff0f1);
        _dayLabel.textColor = UIColorFromRGB(0x787878);
    }else{
        self.backgroundColor = [UIColor whiteColor];
        _dayLabel.textColor = UIColorFromRGB(0xdcdcdc);
    }
    
    if(showYear > nowYear){
        
    }
    
    if(showDay == 1){
        if(showMonth != nowMonth){
            _dayLabel.font = [UIFont systemFontOfSize:12];
            _dayLabel.text = [NSString stringWithFormat:@"%ld月\n%ld",(long)showMonth,(long)showDay];
            _dayLabel.textAlignment = NSTextAlignmentCenter;
//            [_dayLabel sizeToFit];
        }
        
        if(showYear != nowYear){
            _dayLabel.font = [UIFont systemFontOfSize:12];
            _dayLabel.text = [NSString stringWithFormat:@"%ld月\n%ld\n%ld",(long)showMonth,(long)showDay,(long)showYear];
            _dayLabel.textAlignment = NSTextAlignmentCenter;
//            [_dayLabel sizeToFit];
        }
    }
    
    

}

-(void)isShowSelectView:(BOOL )isShow{
//    _coverLabel.hidden = !isShow;
    if(isShow){
        _coverLabel.hidden = NO;
        _dayLabel.hidden = YES;
    }else{
        _coverLabel.hidden = YES;
        _dayLabel.hidden = NO;
    }
    
}

+(CGFloat )heightForCell{
    return kWidthScale(45);
}

@end
