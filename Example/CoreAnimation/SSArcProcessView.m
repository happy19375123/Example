//
//  SSArcProcessView.m
//  Example
//
//  Created by 张鹏 on 16/7/1.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import "SSArcProcessView.h"

@implementation SSArcProcessView
{
    CAShapeLayer *_arcLayer;
    NSInteger _lineWith;         //圆环宽度
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        _lineWith = 10;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [self drawBackgroundArcLayer];
    [self drawArcLayer];
}

-(void)drawArcLayer{
    CGFloat min = MIN(self.bounds.size.width, self.bounds.size.height)/2;
    _arcLayer = [CAShapeLayer layer];
    _arcLayer.frame = CGRectMake(0, 0, min*2, min*2);
    _arcLayer.position = CGPointMake(min, min);
    _arcLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(min, min) radius:min-_lineWith/2 startAngle:M_PI_2*2.5 endAngle:M_PI_2*3.5 clockwise:YES] CGPath];
    _arcLayer.fillColor = [[UIColor clearColor] CGColor];
    _arcLayer.strokeColor = [[UIColor redColor] CGColor];
    _arcLayer.lineWidth = _lineWith;
    [self .layer addSublayer:_arcLayer];

}

-(void)drawBackgroundArcLayer{
    CGFloat min = MIN(self.bounds.size.width, self.bounds.size.height)/2;
    _arcLayer = [CAShapeLayer layer];
    _arcLayer.frame = CGRectMake(0, 0, min*2, min*2);
    _arcLayer.position = CGPointMake(min, min);
    _arcLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(min, min) radius:min-_lineWith/2 startAngle:M_PI_2*2.5 endAngle:M_PI_2*4 clockwise:YES] CGPath];
    _arcLayer.fillColor = [[UIColor clearColor] CGColor];
    _arcLayer.strokeColor = [[UIColor blueColor] CGColor];
    _arcLayer.lineWidth = _lineWith;
    [self .layer addSublayer:_arcLayer];
}

@end
