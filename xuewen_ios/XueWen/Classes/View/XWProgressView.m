//
//  XWProgressView.m
//  XueWen
//
//  Created by ShaJin on 2018/1/22.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "XWProgressView.h"

@implementation XWProgressView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    /** 中心点 */
    CGFloat x = self.width / 2.0;
    
    CGFloat y = self.height / 2.0;
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    // 开始角度
    CGFloat startAngle = - M_PI;
    // 进度
    CGFloat progressAngle = startAngle + _progress * M_PI * 2;
    // 终止角 = 开始角+ 2π
    CGFloat endAngle = M_PI;
    //线的宽度
    CGContextSetLineWidth(context, 1.5);
    //绘制路径
    CGContextSetStrokeColorWithColor(context, kThemeColor.CGColor);
    CGContextAddArc(context, x, y, x - 1.5, startAngle, progressAngle, 0);
    CGContextDrawPath(context, kCGPathStroke);
    //绘制路径
    CGContextSetStrokeColorWithColor(context, COLOR(204, 204, 204).CGColor);
    CGContextAddArc(context, x, y, x - 1.5, progressAngle, endAngle, 0);
    CGContextDrawPath(context, kCGPathStroke);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}
@end
