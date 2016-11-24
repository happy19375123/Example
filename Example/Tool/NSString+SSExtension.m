//
//  NSString+SSExtension.m
//  Example
//
//  Created by 张鹏 on 15/11/13.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "NSString+SSExtension.h"

@implementation NSString (SSExtension)

#pragma mark - 数字转中文数字
+ (NSString *)translation:(NSString *)arebic{
    NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    if(chinese.length >= 2 && [[chinese substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"十"] && [[chinese substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"一"]){
        chinese = [chinese stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    return chinese;
}


@end
