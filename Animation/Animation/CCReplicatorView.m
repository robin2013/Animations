//
//  CCReplicatorView.m
//  Animation
//
//  Created by cuiRobim on 16/4/25.
//  Copyright © 2016年 CuiRobin. All rights reserved.
//

#import "CCReplicatorView.h"
#define kLayerCount 16
@implementation CCReplicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self setupLayers];
    }
    return self;
}

- (void)setupLayers {
    CAReplicatorLayer *layer = [CAReplicatorLayer layer];
    [layer setFrame:self.bounds];
    layer.instanceCount =kLayerCount;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, M_PI*2/kLayerCount, 0, 0, 1);
    layer.instanceTransform = transform;
    
    layer.instanceBlueOffset= -1.0/(kLayerCount);
    layer.instanceRedOffset= -1.0/(kLayerCount);
    layer.instanceGreenOffset= -1.0/(kLayerCount);

    CALayer *subLayer = [self contentLayerWithARC:M_PI*2/kLayerCount];
    [layer addSublayer:subLayer];
    [self.layer addSublayer:layer];
    }

- (CALayer *)contentLayerWithARC:(CGFloat)arc {
    CALayer *layer = [CALayer layer];

    CGPoint center = self.layer.position;
       [layer setFrame:CGRectMake(center.x-50, center.y-50, 50, 50)];
    [layer setBackgroundColor:[UIColor whiteColor].CGColor];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];
    [path addLineToPoint:CGPointMake(50, 0)];
    [path addArcWithCenter:CGPointMake(50, 50) radius:layer.frame.size.width-1 startAngle:M_PI_2*3 endAngle:M_PI_2*3-M_PI*2/kLayerCount clockwise:NO];
    [path closePath];
    
    CAShapeLayer *masklayer = [CAShapeLayer layer];
    masklayer.path = path.CGPath;
    masklayer.strokeColor = [UIColor blackColor].CGColor;
//    masklayer.fillColor = [UIColor clearColor].CGColor;
//    masklayer.lineWidth = 0;
    layer.mask = masklayer;
//
//    layer.shadowPath = path.CGPath;
//    layer.shadowOpacity = 0.5f;
//    layer.shadowColor = [UIColor blackColor].CGColor;
    return layer;
}

//- (CGPathRef )pathForARC:(CGFloat)arc radius:(){
//    
//}
@end
