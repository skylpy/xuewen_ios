//
//  UITableViewCell+Line.m
//  XueWen
//
//  Created by ShaJin on 2018/1/6.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "UITableViewCell+Line.h"
#import <objc/runtime.h>
@implementation UITableViewCell (Line)
- (void)setIsFirst:(BOOL)isFirst{
    [self setIsFirst:isFirst r:238 g:238 b:238 a:1.0f];
}

- (void)setIsFirst:(BOOL)isFirst leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpage{
    [self setIsFirst:isFirst r:238 g:238 b:238 a:1.0f leftSpace:leftSpace rightSpace:rightSpage];
}

- (void)setIsFirst:(BOOL)isFirst r:(int)r g:(int)g b:(int)b a:(CGFloat)a {
    [self setIsFirst:isFirst r:r g:g b:b a:a leftSpace:0 rightSpace:0];
}

- (void)setIsFirst:(BOOL)isFirst r:(int)r g:(int)g b:(int)b a:(CGFloat)a leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpage{
    objc_setAssociatedObject(self, @"isFirst", @(isFirst), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, @"r", @(r), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, @"g", @(g), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, @"b", @(b), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, @"a", @(a), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, @"leftSpace", @(leftSpace), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, @"rightSpage", @(rightSpage), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, @"Redraw", @(YES), OBJC_ASSOCIATION_RETAIN);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    BOOL isFirst = [objc_getAssociatedObject(self, @"isFirst") boolValue];
    BOOL redraw = [objc_getAssociatedObject(self, @"Redraw") boolValue];
    if (!isFirst && redraw) {
        int r = [objc_getAssociatedObject(self, @"r") intValue];
        int g = [objc_getAssociatedObject(self, @"g") intValue];
        int b = [objc_getAssociatedObject(self, @"b") intValue];
        CGFloat a = [objc_getAssociatedObject(self, @"a") floatValue];
        CGFloat leftSpace = [objc_getAssociatedObject(self, @"leftSpace") floatValue];
        CGFloat rightSpace = [objc_getAssociatedObject(self, @"rightSpage") floatValue];
        //获得处理的上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        //设置线条样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //设置颜色
        CGContextSetRGBStrokeColor(context, r / 255.0, g / 255.0, b / 255.0, a);
        //设置线条粗细宽度
        CGContextSetLineWidth(context, [UIScreen mainScreen].scale == 3 ? 1 : 0.5);
        //开始一个起始路径
        CGContextBeginPath(context);
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, leftSpace, 0);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, kWidth - rightSpace ,0);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
    }
}
@end
