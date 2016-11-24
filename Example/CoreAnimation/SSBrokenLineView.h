//
//  SSBrokenLineView.h
//  Example
//
//  Created by 张鹏 on 16/5/27.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSBrokenLineView : UIView

@property(nonatomic,strong) NSArray *yValueArray;

-(id)initWithFrame:(CGRect)frame withYValueArray:(NSArray *)array;

@end
