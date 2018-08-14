//
//  CAShapeLayer+XWLayer.m
//  XueWen
//
//  Created by aaron on 2018/8/1.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "CAShapeLayer+XWLayer.h"

@implementation CAShapeLayer (XWLayer)

+ (CAShapeLayer *)shapeLayerRect:(CGRect)rect withCornerRadius:(CGFloat)cornerRadius addStrokeColor:(UIColor *)strokeColor wlineWidth:(CGFloat)lineWidth{
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = rect;
    borderLayer.lineWidth = lineWidth;
    borderLayer.strokeColor = strokeColor.CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    maskLayer.path = bezierPath.CGPath;
    borderLayer.path = bezierPath.CGPath;
    
    return maskLayer;
}

@end
