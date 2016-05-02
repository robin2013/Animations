//
//  CCLineFlyView.m
//  Animation
//
//  Created by cuiRobim on 16/4/26.
//  Copyright © 2016年 CuiRobin. All rights reserved.
//

#import "CCLineFlyView.h"
#import "CCWaterDrop.h"
#define kRadius  30
#define kRadiusOfControl  26
#define kNumberOfControl 6
#define kNumberOfARC 4

#define kHeight  160
#define kEndPoint  CGPointMake(280, 260)
#define kStartPoint CGPointMake(40, 100)
NSString *const AnimationPathFirst=@"AnimationPathFirst";
NSString *const AnimationPathSecond=@"AnimationPathSecond";
NSString *const AnimationPot=@"AnimationPot";

@interface CCLineFlyView () {
    NSArray *_timesInAnimation;
    NSTimeInterval _timeStep;
}
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
//    [self arrageLayersInArray:[self createControls] atStartPoint:kEndPoint endPoint:kStartPoint numberOfArc:4];
//    return;
    CGPathRef path =[self pathMakerAtStartPoint:kStartPoint endPoint:kEndPoint];
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
    layer.strokeColor = [UIColor whiteColor].CGColor ;
    layer.lineWidth = 1;
    layer.path = path;
    layer.fillColor = [UIColor clearColor].CGColor;
    return layer;
}

- (NSArray *)timePercentInArray:(NSArray *)array byTime:(CGFloat)time stepOffset:(CGFloat)offset step:(NSInteger)step{
    
    CGFloat offPercent = offset/(time+offset)/step;
    NSMutableArray *times = [NSMutableArray array];
    NSMutableArray *timesOfControl = [NSMutableArray array];

    CGFloat percentOfTime =0;
    CGFloat controlTime =0;

    CGFloat timePercent =time/(time+offset);
    [times addObject:@(0)];

    for (int i =1 ; i<array.count; i++) {
        if (i%2==1) {
             percentOfTime += (([array[i] floatValue]-[array[i-1] floatValue])*timePercent);
            controlTime += ([array[i] floatValue]-[array[i-1] floatValue])*time;
        }
        else {
                percentOfTime +=offPercent;
            controlTime +=offset/step;
        }
        [times addObject:@(percentOfTime)];
        [timesOfControl addObject:@(controlTime)];

    }
    _timesInAnimation = timesOfControl;
    return times;
}

- (CAAnimation *)animationForBackByTime:(NSTimeInterval)time {
    NSArray *percents = [self strokePercentsAtStartPoint:kEndPoint endPoint:kStartPoint numberOfArc:4];
    NSArray *timePercent = [self timePercentInArray:percents byTime:4 stepOffset:3 step:5];
    _timeStep = 3.0/5.0;
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    keyAnimation.values = percents;
    keyAnimation.duration = time;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    keyAnimation.keyTimes = timePercent;
    return keyAnimation;

}

- (CAAnimation *)animationFrom:(int)from to:(int)to {
    CABasicAnimation *start = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    start.fromValue = @(from);
    start.toValue = @(to);
    start.duration = 2;
    start.beginTime = 1;
    
    CABasicAnimation *end = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    end.fromValue = @(from);
    end.toValue = @(to);
    end.duration = 2;

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[start,end];
    group.duration = 3;
    group.fillMode = kCAFillModeForwards;
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

#pragma mark - 带圆形的直线
- (UIBezierPath *)path:(UIBezierPath *)path
            startPoint:(CGPoint)point
                radius:(CGFloat)radius
                topOff:(CGFloat)topOff
             bottomOff:(CGFloat)bottomOff
                 toTop:(BOOL)toTop {
    
    if (toTop)
        point = CGPointMake(point.x, point.y - bottomOff);//下边缘
    else
        point = CGPointMake(point.x, point.y + topOff);//上边缘
    
    [path addLineToPoint:point];
    
    if (toTop) {
        point = CGPointMake(point.x, point.y - radius);//圆心
    }
    else
        point = CGPointMake(point.x, point.y + radius);//圆心

    path = [self path:path appendArcAtCenter:point radius:radius atTop:toTop];
    
    if (toTop)
        point = CGPointMake(point.x, point.y - topOff-radius);//上边缘
    else
        point = CGPointMake(point.x, point.y + bottomOff + radius);//下边缘
    
    [path addLineToPoint:point];
    
    return path;
}

#pragma mark -- 画圆形
- (UIBezierPath *)path:(UIBezierPath *)path appendArcAtCenter:(CGPoint)center radius:(CGFloat)radius  atTop:(BOOL)atTop{
    CGFloat arcStart = atTop?M_PI_2:M_PI_2*3;
    CGFloat arcEnd = atTop?M_PI_2*5:-M_PI_2;
    
    [path addArcWithCenter:center radius:radius startAngle:arcStart endAngle:arcEnd clockwise:atTop];
    if (atTop) {
        [path moveToPoint:CGPointMake(center.x, center.y-radius)];
    } else
        [path moveToPoint:CGPointMake(center.x, center.y+radius)];
    return path;
}
#pragma mark - 半圆
- (UIBezierPath *)path:(UIBezierPath *)path
    appendArcFromPoint:(CGPoint)point
                radius:(CGFloat)radius
             clockwise:(BOOL)clockwise {
    CGFloat arcStart = clockwise?0:M_PI*2;
    CGFloat arcEnd = M_PI;
    point = CGPointMake(point.x-radius, point.y);
    [path addArcWithCenter:point radius:radius startAngle:arcStart endAngle:arcEnd clockwise:clockwise];
    return path;
}
#pragma mark - Time Percent
- (NSArray *)strokePercentsAtStartPoint:(CGPoint)start
                             endPoint:(CGPoint)end
                          numberOfArc:(NSInteger)count
                                {
    
    CGFloat width = start.x - end.x;
    CGFloat radius = width/count/2;
    CGFloat height = start.y - end.y;
    CGFloat length = height - 2*kRadiusOfControl;
    CGFloat topOff = length/3;
    CGFloat bottomOff = length/3*2;

    
    NSMutableArray *array = [NSMutableArray array];
                                    [array addObject:@(0)];

    CGFloat controlLen = M_PI*2*kRadiusOfControl;
    CGFloat cornerLen = M_PI*radius;
    CGFloat fullLength = controlLen*kNumberOfControl
                                        + cornerLen*count
                                        + topOff*(count + 1)
                                        + bottomOff*(count + 1);
    
    CGFloat topLen = 2*topOff+cornerLen+controlLen;
    CGFloat bottomLen = 2*bottomOff+cornerLen+controlLen;
    
    CGFloat currentLen = bottomOff +controlLen;
    CGFloat percent = currentLen / fullLength;
    [array addObject:@(percent)];
    for (int i = 0; i < kNumberOfControl - 2 ; i++) {
        [array addObject:@(percent+0.001)];
        if (i%2==0)
            currentLen += topLen;
        else
            currentLen +=bottomLen;
        percent = currentLen / fullLength;
        [array addObject:@(percent)];
    }
                                    
    [array addObject:@(percent+0.001)];
    currentLen += topOff + controlLen;
    percent = currentLen / fullLength;
    [array addObject:@(percent)];
    return array;
}

#pragma mrak - 创建返回路径
- (UIBezierPath*)pathBackAppenderAtStartPoint:(CGPoint)start endPoint:(CGPoint)end numberOfArc:(NSInteger) count   {
    
    CGFloat width = start.x - end.x;
    CGFloat height = start.y - end.y;
    CGFloat radius = width/ count/4;
    CGFloat radiusOfControl = kRadiusOfControl;
    CGFloat length = height - 2*radiusOfControl;
    CGFloat topOff = length/3;
    CGFloat bottomOff = length/3*2;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint  point = start;
    
    [path moveToPoint:point];
    
    for (int i = 0; i<count; i++) {
        path = [self path:path startPoint:point radius:radiusOfControl topOff:topOff bottomOff:bottomOff toTop:YES];
        point = CGPointMake(point.x, point.y-topOff-bottomOff-2*radiusOfControl) ;
        path = [self path:path appendArcFromPoint:point radius:radius clockwise:NO];

        point = CGPointMake(point.x - 2*radius, point.y) ;
        
        path = [self path:path startPoint:point radius:radiusOfControl topOff:topOff bottomOff:bottomOff toTop:NO];
        point = CGPointMake(point.x, point.y + topOff + bottomOff + 2*radiusOfControl) ;
        path = [self path:path appendArcFromPoint:point radius:radius clockwise:YES];
        
        point = CGPointMake(point.x - 2*radius, point.y) ;
        
    }
    path = [self path:path startPoint:point radius:radiusOfControl topOff:topOff bottomOff:bottomOff toTop:YES];
    point = CGPointMake(point.x, point.y-topOff-bottomOff-3*radiusOfControl) ;
    path = [self path:path appendArcAtCenter:point radius:radiusOfControl atTop:YES];
    
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
    animation.duration = 0.1;
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
        [self playBackAnimaion];
    }
}

- (void)playBackAnimaion {
    CGPathRef  path = [self pathBackAppenderAtStartPoint:kEndPoint endPoint:CGPointMake(40, 100)  numberOfArc:2].CGPath;
    self.layerShape.path= path;
    [self.layer addSublayer:self.layerShape];
    CAAnimation *animation=[self animationForBackByTime:7] ;
    animation.delegate = self;
    [animation setValue:AnimationPathSecond  forKey:@"animationName"];
    NSArray *controls =[self createControls] ;
    [self arrageLayersInArray:controls atStartPoint:kEndPoint endPoint:kStartPoint numberOfArc:4];
    for (CCControlLayer *control in controls) {
        [control playByTime:3];
    }
    [self.layerShape addAnimation:animation forKey:AnimationPathSecond];
}

- (CCWaterDrop *)createWaterDrop {
    CCWaterDrop *layer = [CCWaterDrop layerWithFrame:CGRectMake(0, 0, 50, 50)];
    return layer;
}

- (NSArray *)controlTimesArray {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<5; i++) {
        NSArray *times =[_timesInAnimation subarrayWithRange:NSMakeRange(0, i*2) ];
        NSNumber *time = [times  valueForKeyPath:@"@sum.floatValue"];
        [array addObject:time];
    }
    return array;
}

- (NSArray *)createControls {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *times =_timesInAnimation;// [self controlTimesArray];

    for (int i = 0; i<5; i++) {
        CCControlLayer *layer = [self createWaterDrop];
        NSTimeInterval timeDuration =[times[i] floatValue];
        layer.beginTime = timeDuration;
        [array addObject:layer];
    }
    return array;
}

- (void)arrageLayersInArray:(NSArray *)array atStartPoint:(CGPoint)start
                  endPoint:(CGPoint)end
               numberOfArc:(NSInteger)count
{
    
    CGFloat width = start.x - end.x;
    CGFloat radius = width/count/2;
    CGFloat height = start.y - end.y;
    CGFloat length = height - 2*kRadiusOfControl;
    CGFloat bottomOff = length/3*2;
    for ( int i =0; i<array.count; i++) {
        CCControlLayer *layer = array[i];
        CGFloat x_off = start.x - i*radius*2;
        layer.position = CGPointMake( x_off, start.y -bottomOff-kRadiusOfControl);
        [self.layerShape addSublayer:layer];
//        [layer playByTime:4];
    }
}
@end
