//
//  CCLineFlyView.m
//  Animation
//
//  Created by cuiRobim on 16/4/26.
//  Copyright © 2016年 CuiRobin. All rights reserved.
//

#import "CCLineFlyView.h"
#define kRadius  30
#define kHeight  160
#define kEndPoint  CGPointMake(280, 260)

NSString *const AnimationPathFirst=@"AnimationPathFirst";
NSString *const AnimationPathSecond=@"AnimationPathSecond";
NSString *const AnimationPot=@"AnimationPot";

@interface CCLineFlyView ()
@property(nonatomic,strong) CAShapeLayer *layerShape;
@end
@implementation CCLineFlyView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor grayColor]];
        [self setupLayers];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}
- (void)setupLayers {

    CGPathRef path =[self pathMakerAtStartPoint:CGPointMake(40, 100) endPoint:kEndPoint];
    CAShapeLayer *layer = [self shapeLayerWithPath:path];
    self.layerShape = layer;
    [layer setFrame:CGRectMake(0, 0, 320, 320)];
    layer.position = self.center;
    [self.layer addSublayer:layer];
    CAAnimation *animation=[self animationFrom:0 to:1] ;
    [animation setValue:AnimationPathFirst  forKey:@"animationName"];
    [layer addAnimation:animation forKey:AnimationPathFirst];
}


- (CAShapeLayer *)shapeLayerWithPath:(CGPathRef)path {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor redColor].CGColor ;
    layer.lineWidth = 2;
    layer.path = path;
    layer.fillColor = [UIColor clearColor].CGColor;
    return layer;
}

- (CAAnimation *)animationForBack {
    CABasicAnimation *start = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    start.fromValue = @(1);
    start.toValue = @(0);
    start.delegate = self;
    start.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    start.duration = 3;
    return start;
}
- (CAAnimation *)animationFrom:(int)from to:(int)to {
    CABasicAnimation *start = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    start.fromValue = @(from);
    start.toValue = @(to);
    
    CABasicAnimation *end = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    end.fromValue = @(from);
    end.toValue = @(to);
    if (from<to)
        start.beginTime = 1;
    else
        end.beginTime = 1;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[start,end];
    group.duration = 3;
    group.fillMode = kCAFillModeBoth;
    group.delegate = self;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return  group;
}


- (CGPathRef)pathMakerAtStartPoint:(CGPoint)start  endPoint :(CGPoint)end {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:start];
    [self pathAppenderAtStartPoint:start count:2 withPath:path];
    [path addLineToPoint:end];
    return path.CGPath;
    
}

- (UIBezierPath*)pathAppenderAtStartPoint:(CGPoint)point count:(NSInteger)count  withPath:(UIBezierPath*)path {
    for (int i = 0; i<count; i++) {
         point = CGPointMake(point.x, point.y+kHeight);
        [path addLineToPoint:point];
        
        point = CGPointMake(point.x+kRadius, point.y);
        [path addArcWithCenter:point radius:kRadius startAngle:M_PI endAngle:0 clockwise:NO];
        
        point = CGPointMake(point.x+kRadius, point.y-kHeight);
        [path addLineToPoint:point];
        point = CGPointMake(point.x+kRadius, point.y);

        [path addArcWithCenter:point radius:kRadius startAngle:M_PI endAngle:0 clockwise:YES];
        point = CGPointMake(point.x+kRadius, point.y);

    }
    return path;
}

- (CALayer *)pointAnimationAtPoint:(CGPoint)point {
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [layer setFrame:CGRectMake(0, 0, 10, 10)];
    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
    layer.position = point;
        return layer;
}

- (CAAnimation *)animationForPot {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 10, 10)];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    animation.autoreverses = YES;
    animation.duration = 0.9;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    [animation setValue:AnimationPot  forKey:@"animationName"];
    return animation;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer *layerPot;
    NSString *key =[anim valueForKey:@"animationName"];
    if ([key isEqualToString:AnimationPathFirst]) {
        CGPoint point = [self.layerShape convertPoint:kEndPoint toLayer:self.layer];

        [self.layerShape removeAllAnimations];
        [self.layerShape removeFromSuperlayer];
    layerPot =   [self pointAnimationAtPoint:point];
        [self.layer addSublayer:layerPot];
        [layerPot addAnimation:[self animationForPot] forKey:AnimationPot];
    } else if ([[anim valueForKey:@"animationName"] isEqualToString:AnimationPot]) {
        [layerPot removeFromSuperlayer];
        layerPot = nil;
        [self.layer addSublayer:self.layerShape];
        CAAnimation *animation=[self animationForBack] ;
        animation.delegate = self;
        [animation setValue:AnimationPathSecond  forKey:@"animationName"];
        [self.layerShape addAnimation:animation forKey:AnimationPathSecond];
    }
}
@end
