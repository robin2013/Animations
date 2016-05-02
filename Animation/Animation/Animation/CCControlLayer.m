//
//  CCControlLayer.m
//  Animation
//
//  Created by CuiRobin on 16/5/2.
//  Copyright © 2016年 CuiRobin. All rights reserved.
//

#import "CCControlLayer.h"

@implementation CCControlLayer
+ (id)layerWithFrame:(CGRect)frame {
    CCControlLayer *layer = [[self class] layer];
//    layer.backgroundColor = [UIColor blueColor].CGColor;
     [layer setFrame:frame];
    [layer fillLayer];
//    layer.hidden = YES;
    return layer;
}

+ (instancetype)layer {
    return [super  layer];
}

- (void)fillLayer {
    self.lineCap = kCALineCapRound;
    self.strokeColor=[UIColor whiteColor].CGColor;
    self.lineWidth = 1;
    self.fillColor = [UIColor clearColor].CGColor;
    self.path = [self  pathOfLayer].CGPath;
}

- (UIBezierPath *)pathOfLayer {
    return [UIBezierPath bezierPath];
}

- (void)playByTime:(NSInteger)time {
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    keyAnimation.values = @[@0,@1];
    keyAnimation.duration = 3;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.25;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = time;
    group.animations=@[keyAnimation,animation];
    group.beginTime = self.beginTime;
    group.fillMode = kCAFillModeBackwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [self addAnimation:group forKey:nil];
}
@end
