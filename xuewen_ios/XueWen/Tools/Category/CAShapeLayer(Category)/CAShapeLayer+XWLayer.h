//
//  CAShapeLayer+XWLayer.h
//  XueWen
//
//  Created by aaron on 2018/8/1.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAShapeLayer (XWLayer)

//绘制圆角
+ (CAShapeLayer *)shapeLayerRect:(CGRect)rect withCornerRadius:(CGFloat)cornerRadius addStrokeColor:(UIColor *)strokeColor wlineWidth:(CGFloat)lineWidth;

@end
