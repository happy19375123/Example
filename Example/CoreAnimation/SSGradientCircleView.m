//
//  SSGradientCircleView.m
//  Example
//
//  Created by 张鹏 on 16/5/27.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import "SSGradientCircleView.h"

@implementation SSGradientCircleView
{
    CAShapeLayer *_arcLayer;
    UIColor *_fromColor;         //渐变开始颜色
    UIColor *_toColor;           //渐变结束颜色
    UIColor *_defaultColor;      //背景颜色
    NSInteger _lineWith;         //圆环宽度
    CGFloat _progress;           //进度   0-1
}

-(id)initWithFrame:(CGRect)frame fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor defaultColor:(UIColor *)defaultColor lineWith:(NSInteger )lineWith progress:(CGFloat )progress{
    self = [super initWithFrame:frame];
    if(self){
        _fromColor = fromColor;
        _toColor = toColor;
        _defaultColor = defaultColor;
        _lineWith = lineWith;
        _progress = progress;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)refreshViewWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor defaultColor:(UIColor *)defaultColor lineWith:(NSInteger )lineWith progress:(CGFloat )progress{
    _fromColor = fromColor;
    _toColor = toColor;
    _defaultColor = defaultColor;
    _lineWith = lineWith;
    _progress = progress;
    self.backgroundColor = [UIColor clearColor];
}

-(void)drawRect:(CGRect)rect{
    [self drawGradualLayer];
}

-(void)drawGradualLayer{
    NSInteger colorCount = 100;
    NSArray *colorArray = [self graintFromColor:_fromColor ToColor:_toColor defaultColor:_defaultColor Count:colorCount Progress:_progress];
    
    CALayer *colorLayer = [CALayer layer];
    colorLayer.bounds = self.bounds;
    colorLayer.position = CGPointMake(0, 0);
    colorLayer.anchorPoint = CGPointMake(0, 0);
    
    CGFloat min = MIN(self.bounds.size.width, self.bounds.size.height)/2;
    _arcLayer = [CAShapeLayer layer];
    _arcLayer.frame = CGRectMake(0, 0, min*2, min*2);
    _arcLayer.position = CGPointMake(min, min);
    _arcLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(min, min) radius:min-_lineWith/2 startAngle:M_PI_2*3 endAngle:M_PI*2 + M_PI_2*3 clockwise:YES] CGPath];
    _arcLayer.fillColor = [[UIColor clearColor] CGColor];
    _arcLayer.strokeColor = [[UIColor redColor] CGColor];
    _arcLayer.lineWidth = _lineWith;
    
    NSArray *leftTopColors = [colorArray subarrayWithRange:NSMakeRange(colorCount/4*3-1, colorCount/4)];
    NSArray *leftBottomColors = [colorArray subarrayWithRange:NSMakeRange(colorCount/4*2-1, colorCount/4)];
    NSArray *rightTopColors = [colorArray subarrayWithRange:NSMakeRange(0, colorCount/4)];
    NSArray *rightBottomColors = [colorArray subarrayWithRange:NSMakeRange(colorCount/4-1, colorCount/4)];
    
    CAGradientLayer *leftTopGradientLayer = [CAGradientLayer layer];
    leftTopGradientLayer.bounds = CGRectMake(0,0,min,min);
    leftTopGradientLayer.position = CGPointMake(min/2, min/2);
    
    leftTopGradientLayer.colors = leftTopColors;
    leftTopGradientLayer.startPoint = CGPointMake(0, 1);
    leftTopGradientLayer.endPoint = CGPointMake(1, 0);
    
    CAGradientLayer *leftBottomGradientLayer = [CAGradientLayer layer];
    leftBottomGradientLayer.bounds = CGRectMake(0,0,min,min);
    leftBottomGradientLayer.position = CGPointMake(min/2, min/2*3);
    
    leftBottomGradientLayer.colors = leftBottomColors;
    leftBottomGradientLayer.startPoint = CGPointMake(1, 1);
    leftBottomGradientLayer.endPoint = CGPointMake(0, 0);
    
    CAGradientLayer *rightTopGradientLayer = [CAGradientLayer layer];
    rightTopGradientLayer.bounds = CGRectMake(0,0,min,min);
    rightTopGradientLayer.position = CGPointMake(min/2*3, min/2);
    
    rightTopGradientLayer.colors = rightTopColors;
    rightTopGradientLayer.startPoint = CGPointMake(0, 0);
    rightTopGradientLayer.endPoint = CGPointMake(1, 1);
    
    CAGradientLayer *rightBottomGradientLayer = [CAGradientLayer layer];
    rightBottomGradientLayer.bounds = CGRectMake(0,0,min,min);
    rightBottomGradientLayer.position = CGPointMake(min/2*3, min/2*3);
    
    rightBottomGradientLayer.colors = rightBottomColors;
    rightBottomGradientLayer.startPoint = CGPointMake(1, 0);
    rightBottomGradientLayer.endPoint = CGPointMake(0, 1);
    
    [colorLayer addSublayer:leftTopGradientLayer];
    [colorLayer addSublayer:leftBottomGradientLayer];
    [colorLayer addSublayer:rightTopGradientLayer];
    [colorLayer addSublayer:rightBottomGradientLayer];
    [self .layer addSublayer:colorLayer];
    colorLayer.mask = _arcLayer;
}

-(NSArray *)graintFromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor defaultColor:(UIColor *)defaultColor Count:(NSInteger)count Progress:(CGFloat)progress{
    NSInteger fromColorCount = progress * count;
    NSMutableArray *colorArray = [[NSMutableArray alloc]init];
    for(NSInteger i = 0;i < fromColorCount;i++){
        [colorArray addObject:fromColor];
    }
    [colorArray addObjectsFromArray:[self graintFromColor:fromColor ToColor:toColor Count:count-fromColorCount]];
    NSMutableArray *cgColorArray = [NSMutableArray array];
    for(UIColor *color in colorArray){
        [cgColorArray addObject:(__bridge id)color.CGColor];
    }
    return cgColorArray;
}

-(NSArray *)graintFromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor Count:(NSInteger)count{
    CGFloat fromR = 0.0,fromG = 0.0,fromB = 0.0,fromAlpha = 0.0;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromAlpha];
    CGFloat toR = 0.0,toG = 0.0,toB = 0.0,toAlpha = 0.0;
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toAlpha];
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        CGFloat oneR = fromR + (toR - fromR)/count * i;
        CGFloat oneG = fromG + (toG - fromG)/count * i;
        CGFloat oneB = fromB + (toB - fromB)/count * i;
        CGFloat oneAlpha = fromAlpha + (toAlpha - fromAlpha)/count * i;
        UIColor * onecolor = [UIColor colorWithRed:oneR green:oneG blue:oneB alpha:oneAlpha];
        [result addObject:onecolor];
    }
    return result;
}

-(UIColor *)midColorWithFromColor:(UIColor *)fromColor ToColor:(UIColor*)toColor Progress:(CGFloat)progress{
    CGFloat fromR = 0.0,fromG = 0.0,fromB = 0.0,fromAlpha = 0.0;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromAlpha];
    CGFloat toR = 0.0,toG = 0.0,toB = 0.0,toAlpha = 0.0;
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toAlpha];
    CGFloat oneR = fromR + (toR - fromR) * progress;
    CGFloat oneG = fromG + (toG - fromG) * progress;
    CGFloat oneB = fromB + (toB - fromB) * progress;
    CGFloat oneAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
    UIColor * onecolor = [UIColor colorWithRed:oneR green:oneG blue:oneB alpha:oneAlpha];
    return onecolor;
}

-(void)setPercent:(NSInteger)percent animated:(BOOL)animated{
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    basic.duration = 2*percent;
    basic.fromValue = @(0);
    basic.toValue = @(1);
    basic.removedOnCompletion = NO;//动画执行完成后不删除动画
    basic.fillMode = @"forwards";
    [_arcLayer addAnimation:basic forKey:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self setPercent:1 animated:YES];
//    [self.view setNeedsLayout];
}


@end
