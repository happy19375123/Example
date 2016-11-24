//
//  SSBrokenLineView.m
//  Example
//
//  Created by 张鹏 on 16/5/27.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import "SSBrokenLineView.h"

@implementation SSBrokenLineView

-(id)initWithFrame:(CGRect)frame withYValueArray:(NSArray *)array{
    self = [super initWithFrame:frame];
    if(self){
        self.yValueArray = [NSArray arrayWithArray:array];
        [self drawXYLine];
        [self drawDottedLine];
        [self drawBrokenLine];
        [self drawPointImage];
    }
    return self;
}

-(void)testBezierPath{
    UIBezierPath *bPath = [[UIBezierPath alloc]init];
    [bPath moveToPoint:CGPointMake(self.center.x+100, self.center.y)];
    [bPath addArcWithCenter:self.center radius:100.0 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
    [bPath closePath];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.lineWidth = 3;
    layer.lineJoin = kCALineJoinMiter;
    layer.lineCap = kCALineCapRound;
    layer.path = bPath.CGPath;
    layer.fillColor = [[UIColor whiteColor] CGColor];
    layer.strokeColor = [[UIColor blueColor] CGColor];
    [self.layer addSublayer:layer];
}

-(void)drawXYLine{
    UIBezierPath *bPath = [[UIBezierPath alloc]init];
    [bPath moveToPoint:CGPointMake(0, self.bounds.size.height)];
    [bPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [bPath moveToPoint:CGPointMake(0, self.bounds.size.height)];
    [bPath addLineToPoint:CGPointMake(0, 0)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.lineWidth = 1;
    layer.lineJoin = kCALineJoinMiter;
    layer.lineCap = kCALineCapRound;
    layer.path = bPath.CGPath;
    layer.fillColor = [[UIColor whiteColor] CGColor];
    layer.strokeColor = [UIColorFromRGB(0xd2d8df) CGColor];
    [self.layer addSublayer:layer];
}

-(void)drawDottedLine{
    NSMutableArray *xPointArray = [[NSMutableArray alloc]init];
    for(int i=1;i<=5;i++){
        [xPointArray addObject:@(self.bounds.size.height - 29*i)];
    }
    UIBezierPath *bPath = [[UIBezierPath alloc]init];
    for(NSNumber *num in xPointArray){
        [bPath moveToPoint:CGPointMake(0, [num floatValue])];
        [bPath addLineToPoint:CGPointMake(self.bounds.size.width, [num floatValue])];
    }
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.lineWidth = 1;
    layer.lineJoin = kCALineJoinMiter;
    layer.lineCap = kCALineCapRound;
    layer.path = bPath.CGPath;
    layer.fillColor = [[UIColor whiteColor] CGColor];
    layer.strokeColor = [UIColorFromRGB(0xd2d8df) CGColor];
    [layer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                               [NSNumber numberWithInt:3],nil]];
    [self.layer addSublayer:layer];
}

-(void)drawBrokenLine{
    UIBezierPath *bPath = [[UIBezierPath alloc]init];
    [bPath moveToPoint:CGPointMake(0, self.bounds.size.height)];
    CGFloat width = self.bounds.size.width/_yValueArray.count;
    CGFloat height ;
    for(int i=0;i<_yValueArray.count;i++){
        CGFloat y = [[_yValueArray objectAtIndex:i] floatValue];
        height = self.bounds.size.height-y*29;
        [bPath addLineToPoint:CGPointMake(width*(i+1), height)];
    }
    CGFloat dash[] = {3,1};
    [bPath setLineDash:dash count:20 phase:0];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.lineWidth = 1;
    layer.lineJoin = kCALineJoinMiter;
    layer.lineCap = kCALineCapRound;
    layer.path = bPath.CGPath;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.strokeColor = [UIColorFromRGB(0x219dd0) CGColor];
    [self.layer addSublayer:layer];
}

-(void)drawPointImage{
    CGFloat width = self.bounds.size.width/_yValueArray.count;
    CGFloat height ;
    for(int i=0;i<_yValueArray.count;i++){
        CGFloat y = [[_yValueArray objectAtIndex:i] floatValue];
        height = self.bounds.size.height-y*29;
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = CGRectMake(width*(i+1) - 11/2, height-11/2, 11, 11);
        
        imageLayer.contents = (id)[UIImage imageNamed:@"mineteacher_point"].CGImage;
        [self.layer addSublayer:imageLayer];
    }
}

@end
