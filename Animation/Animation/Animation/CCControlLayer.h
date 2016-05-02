//
//  CCControlLayer.h
//  Animation
//
//  Created by CuiRobin on 16/5/2.
//  Copyright © 2016年 CuiRobin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface CCControlLayer : CAShapeLayer
+ (id)layerWithFrame:(CGRect)frame;
- (void)playByTime:(NSInteger)time;
- (UIBezierPath *)pathOfLayer;
@end
