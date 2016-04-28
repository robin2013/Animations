//
//  CCNautiloidAnimationView.m
//  Animation
//
//  Created by CuiRobin on 16/4/22.
//  Copyright © 2016年 CuiRobin. All rights reserved.
//

#import "CCNautiloidAnimationView.h"
#define kWidth  200
#define kHeight 200*1.618


@interface CCNautiloidAnimationView ()
{
    CGPathRef _path;
}
@property(nonatomic,strong)CALayer *bgLayer;
@property(nonatomic,strong)CAAnimation *animation;
@end

@implementation CCNautiloidAnimationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self setupLayers];
    }
    return self;
}

- (void)setupLayers {
    CGRect rect  = CGRectMake((self.frame.size.width-kWidth)/2, (self.frame.size.height-kHeight)/2, kWidth, kHeight);
     _path = [[self createPathInRect:rect] CGPath];
    self.bgLayer = [CALayer layer];
    [self.bgLayer setBackgroundColor:[UIColor blackColor].CGColor];
    [self.bgLayer setFrame:CGRectMake(0, 0, 20, 20)];
    [self.layer addSublayer:self.bgLayer];
    self.bgLayer.position = self.layer.position;
    
    CALayer *layer = [self createLayerForPath:_path];
    [self.layer addSublayer:layer];
    _animation =[self animationForPath:_path];
}

- (void)run {
    [self.bgLayer addAnimation:_animation forKey:nil];
}

- (CAKeyframeAnimation *)animationForPath:(CGPathRef)path {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    animation.duration = 3;
    animation.repeatCount = 10;
    animation.calculationMode = kCAAnimationPaced;
    animation.rotationMode = kCAAnimationRotateAuto;
    return animation;
}

- (CALayer*)createLayerForPath:(CGPathRef)path{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.strokeColor = [[UIColor redColor] CGColor];
    layer.lineWidth = 3;
    
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(0);
    startAnimation.toValue = @(1);
    startAnimation.beginTime = 2;
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0);
    endAnimation.toValue = @(1);
    
    CAAnimationGroup *group = [CAAnimationGroup animation ];
    group.animations = @[startAnimation,endAnimation];
    group.duration = 5;
    [layer addAnimation:group forKey:nil];
    return layer;

}
- (UIBezierPath *)createPathInRect:(CGRect)rect {
    UIBezierPath *path =[UIBezierPath bezierPath];
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat min_X = CGRectGetMinX(rect);
    CGFloat max_X = CGRectGetMaxX(rect);

    CGFloat min_Y = CGRectGetMinY(rect);
    CGFloat max_Y = min_Y+height;
    
    [path moveToPoint:CGPointMake(max_X, min_Y)];
    
    CGFloat radiusOne = width;
    CGPoint firstARCCenter = CGPointMake(max_X, min_Y+radiusOne);
    [path addArcWithCenter:firstARCCenter radius:radiusOne startAngle:M_PI*3/2 endAngle:M_PI clockwise:NO];
    
    CGFloat radiusTwo =height- radiusOne;
    CGPoint secondARCCenter = CGPointMake(min_X+radiusTwo, firstARCCenter.y);
    [path addArcWithCenter:secondARCCenter radius:radiusTwo startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    
    CGFloat radiusThree =radiusOne- radiusTwo;
    CGPoint thirdARCCenter = CGPointMake(secondARCCenter.x, max_Y - radiusThree);
    [path addArcWithCenter:thirdARCCenter radius:radiusThree startAngle:M_PI_2 endAngle:0 clockwise:NO];

    CGFloat radiusFour = radiusTwo - radiusThree;
    CGPoint fourthARCCenter = CGPointMake(max_X - radiusFour,thirdARCCenter.y);
    [path addArcWithCenter:fourthARCCenter radius:radiusFour startAngle:0 endAngle:M_PI*3/2 clockwise:NO];
    
    CGFloat radiusFive = radiusThree - radiusFour;
    CGPoint fifthARCCenter = CGPointMake(fourthARCCenter.x,firstARCCenter.y+radiusFive);
    [path addArcWithCenter:fifthARCCenter radius:radiusFive startAngle:M_PI*3/2 endAngle:M_PI clockwise:NO];
    [path closePath];
    return path;
    
    
    [path addCurveToPoint:CGPointMake(100, 100) controlPoint1:CGPointMake(200, 150) controlPoint2:CGPointMake(310, 100)];
    return path;
}

@end
