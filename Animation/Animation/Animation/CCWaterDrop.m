//
//  CCWaterDrop.m
//  Animation
//
//  Created by CuiRobin on 16/5/2.
//  Copyright © 2016年 CuiRobin. All rights reserved.
//

#import "CCWaterDrop.h"

@implementation CCWaterDrop
+ (id)layerWithFrame:(CGRect)frame {
    return [super layerWithFrame:frame];
}

- (UIBezierPath *)pathOfLayer {
    
    UIBezierPath *path = [super pathOfLayer];
    CGRect rect = self.bounds;
    CGFloat offset = 4;
    CGFloat radius = (CGRectGetWidth(rect)-2*offset)/3;
    CGFloat y_off = CGRectGetHeight(rect)-offset-radius;;
    CGFloat x_off = CGRectGetWidth(rect)/2;

    CGPoint top = CGPointMake(x_off, offset);
    CGPoint left = CGPointMake(x_off - radius, y_off);
    CGPoint right = CGPointMake(x_off + radius, y_off);
    
    [path moveToPoint:left];
    
    [path addLineToPoint:top];
    [path addLineToPoint:right];
    
    [path addArcWithCenter:CGPointMake(CGRectGetMidX(rect), y_off) radius:radius startAngle:0 endAngle:M_PI clockwise:YES];
    
    return path;
}
@end
