//
//  SSRadarView.m
//  Example
//
//  Created by 张鹏 on 16/7/1.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import "SSRadarView.h"

@implementation SSRadarView
{
    CAShapeLayer *_arcLayer;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.pecentArray = @[@100,@100,@100,@100,@100];
    }
    return self;
}

-(void)refreshView{
    self.pecentArray = @[@100,@10,@100,@10,@100];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    [self drawRadarLayer];
}

-(void)drawRadarLayer{
    [_arcLayer removeFromSuperlayer];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _arcLayer = [CAShapeLayer layer];
    _arcLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _arcLayer.position = center;
    _arcLayer.path = [self drawPentagonWithCenter:center LengthArray:self.pecentArray];
    _arcLayer.fillColor = [[UIColor redColor] CGColor];
    _arcLayer.strokeColor = [[UIColor redColor] CGColor];
    _arcLayer.lineWidth = 0.5;
    [self .layer addSublayer:_arcLayer];
}

- (CGPathRef)drawPentagonWithCenter:(CGPoint)center LengthArray:(NSArray *)lengths{
    NSArray *coordinates = [self converCoordinateFromLength:lengths Center:center];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    for (int i = 0; i < [coordinates count]; i++) {
        CGPoint point = [[coordinates objectAtIndex:i] CGPointValue];
        if (i == 0) {
            [bezierPath moveToPoint:point];
        } else {
            [bezierPath addLineToPoint:point];
        }
    }
    [bezierPath closePath];
    return bezierPath.CGPath;
}

- (NSArray *)converCoordinateFromLength:(NSArray *)lengthArray Center:(CGPoint)center{
    NSMutableArray *coordinateArray = [NSMutableArray array];
    for (int i = 0; i < [lengthArray count] ; i++) {
        double length = [[lengthArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointZero;
        if (i == 0) {
            point =  CGPointMake(center.x - length * sin(M_PI / 5.0),
                                 center.y - length * cos(M_PI / 5.0));
        } else if (i == 1) {
            point = CGPointMake(center.x + length * sin(M_PI / 5.0),
                                center.y - length * cos(M_PI / 5.0));
        } else if (i == 2) {
            point = CGPointMake(center.x + length * cos(M_PI / 10.0),
                                center.y + length * sin(M_PI / 10.0));
        } else if (i == 3) {
            point = CGPointMake(center.x,
                                center.y +length);
        } else {
            point = CGPointMake(center.x - length * cos(M_PI / 10.0),
                                center.y + length * sin(M_PI / 10.0));
        }
        [coordinateArray addObject:[NSValue valueWithCGPoint:point]];
    }
    return coordinateArray;
}

@end
