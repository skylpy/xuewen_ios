//
//  KKChartView.m
//  KKChartView
//
//  Created by lk on 2017/5/9.
//  Copyright © 2017年 lukai. All rights reserved.
//


#define KKWidth self.frame.size.width
#define KKHeight self.frame.size.height
#define KKTop 10
#define KKRight 20


#import "KKChartView.h"
#import "UIColor+expanded.h"
#import <objc/runtime.h>
@interface KKChartView ()
@property(nonatomic, strong)UILabel *titilLable;
@end

@implementation KKChartView
{
    NSMutableArray *_pointAry;
    CAShapeLayer *layer;
    CGPoint _endPoint;
    CALayer *baseLayer;
    CAShapeLayer * _lineLay;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pointAry = [NSMutableArray array];
        self.marginX = 20;
        self.marginY = 20;
        _coordinateColor = [UIColor whiteColor];
        _lineWidth = 4;
        _gradientColor = @"0xf38b10";
        _lineColor = [UIColor yellowColor];
    }
    return self;
}

-(void)kk_drawRect{
    
//    [self.layer removeAllAnimations];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_marginX, KKTop)];
    [path addLineToPoint:CGPointMake(_marginX, KKHeight - _marginY)];
    [path moveToPoint:CGPointMake(_marginX, KKHeight - _marginY)];
    [path addLineToPoint:CGPointMake(KKWidth - KKRight, KKHeight - _marginY)];
    

    if (layer) {
        [layer removeFromSuperlayer];
    }
    layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineJoin = kCALineJoinRound;
    layer.lineCap = kCALineCapRound;
    layer.lineWidth = _lineWidth;
    layer.strokeColor = _coordinateColor.CGColor;
    [self.layer addSublayer:layer];
    
}

-(void)kk_addLeftBezierPoint{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointFromString(_pointAry.firstObject)];
        
    for (int i=0; i<_pointAry.count; i++) {

        if (i != 0) {
            CGPoint nowPoint = CGPointFromString(_pointAry[i]);
            CGPoint oldPoint = CGPointFromString(_pointAry[i-1]);
            [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+oldPoint.x)/2, oldPoint.y) controlPoint2:CGPointMake((nowPoint.x+oldPoint.x)/2, nowPoint.y)];
            
        }
    }
    
    //画线
    CAShapeLayer *lineLay = [CAShapeLayer new];
    lineLay.path = path.CGPath;
    _lineLay = lineLay;
    lineLay.lineWidth = 2;
    lineLay.strokeColor = _lineColor.CGColor;
    lineLay.lineJoin = kCALineJoinRound;
    lineLay.lineCap = kCALineCapRound;
    lineLay.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:lineLay];
    
}

-(void)kk_addGradientLayer{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointFromString(_pointAry.firstObject)];
    
    
    for (int i=0; i<_pointAry.count; i++) {
        
        if (i != 0) {
            CGPoint nowPoint = CGPointFromString(_pointAry[i]);
            CGPoint oldPoint = CGPointFromString(_pointAry[i-1]);
            [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+oldPoint.x)/2, oldPoint.y) controlPoint2:CGPointMake((nowPoint.x+oldPoint.x)/2, nowPoint.y)];
            
            if (i == _pointAry.count-1) {
                _endPoint = nowPoint;
                [path moveToPoint:nowPoint];//添加连线
                
            }
        }
    }
    
    CGPoint p1 = CGPointFromString(_pointAry.firstObject);
    [path addLineToPoint:CGPointMake(_endPoint.x, KKHeight - _marginY)];
    [path addLineToPoint:CGPointMake(_marginX, KKHeight - _marginY)];
    [path addLineToPoint:CGPointMake(_marginX, p1.y)];
    [path addLineToPoint:CGPointMake(p1.x, p1.y)];
    
    CAShapeLayer *shadeLayer = [CAShapeLayer new];
    shadeLayer.path = path.CGPath;
    shadeLayer.lineJoin = kCALineJoinRound;
    shadeLayer.lineCap = kCALineCapRound;
    shadeLayer.strokeColor = [UIColor clearColor].CGColor;
//    shadeLayer.fillColor = [UIColor yellowColor].CGColor;
//    [self.layer addSublayer:shadeLayer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, KKHeight  - KKTop);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:_gradientColor andAlpha:0.3].CGColor,(__bridge id)[UIColor colorWithHexString:_gradientColor andAlpha:0.1].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    if (baseLayer) {
        [baseLayer removeFromSuperlayer];
    }//需要删除原来的
    
    baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [self.layer addSublayer:baseLayer];
    
    
    CABasicAnimation *anmio = [CABasicAnimation animation];
    anmio.keyPath = @"bounds";
    anmio.duration = 2.0f;
    anmio.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*_endPoint.x, self.bounds.size.height - KKTop)];
    anmio.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmio.fillMode = kCAFillModeForwards;
    anmio.autoreverses = NO;
    anmio.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmio forKey:@"bounds"];
}


-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    [self kk_addLeftBezierPoint];
}
-(void)setLineWidth:(NSInteger)lineWidth{
    _lineWidth = lineWidth;
    [self kk_drawRect];
}
-(void)setCoordinateColor:(UIColor *)coordinateColor{
    _coordinateColor = coordinateColor;
    [self kk_drawRect];
}

-(void)setDataAry:(NSArray *)dataAry {
    _dataAry = dataAry;
    if (!dataAry || dataAry.count<1) return;
    
    [_pointAry removeAllObjects];
    
    CGFloat max = [self getMaxValueForAry:dataAry];
    for (int i=0; i<dataAry.count; i++) {
        CGFloat value = [dataAry[i] floatValue];
        CGFloat x =_marginX + (KKWidth - _marginX - KKRight)/dataAry.count*(i+1);
        CGFloat y = KKHeight-_marginY-(KKHeight - _marginY - KKTop)/max*value;
        if (isnan(y)) {
            //我是 nan
            y = 80;
        }
        CGPoint point = CGPointMake(x, y);
        [_pointAry addObject:NSStringFromCGPoint(point)];
        
        
    }
    [_lineLay removeFromSuperlayer];
    [self kk_drawRect];
    [self kk_addLeftBezierPoint];
}

- (void)setDateArray:(NSArray *)dateArray {
    _dateArray = dateArray;
    
    for (int i = 0; i < dateArray.count; i ++) {
        
        UIButton *button = [self viewWithTag:i+100];
        if (button) {
            
            CGPoint point = CGPointFromString(_pointAry[i]);
            
            [self bringSubviewToFront:button];
            
            if (i == dateArray.count -1) {
                button.center = point;
                UILabel * label = [self viewWithTag:1006];
                label.text = [NSString stringWithFormat:@"%.f",[_dataAry[i] floatValue] * 100];
                
                label.center = CGPointMake(point.x, point.y-13);
                [self bringSubviewToFront:label];
                UIImageView * imageView = [self viewWithTag:200];
                imageView.center = CGPointMake(point.x, point.y-12);
            }
            
        }
        
    }
    if (!self.isCell) return;
    
    for (int i = 0; i < dateArray.count; i ++) {
        
        
        CGPoint point = CGPointFromString(_pointAry[i]);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.frame = CGRectMake(0, 0, 8, 8);
        btn.tag = i+100;
        btn.center = point;
        [btn setImage:[UIImage imageNamed:@"circle3"] forState:UIControlStateNormal];
        
        if (i == dateArray.count -1) {
            UIImageView * imageView = [UIImageView new];
            imageView.image = [UIImage imageNamed:@"timeBg"];
            imageView.tag = 200;
            [self addSubview:imageView];
            imageView.center = CGPointMake(btn.center.x-13, btn.center.y-18);
            imageView.size = CGSizeMake(25, 15);
        }
        
        UILabel * titilLable = [UILabel new];
        titilLable.font = [UIFont systemFontOfSize:10.0f];
        titilLable.tag = 1000 + i;
        titilLable.textColor = i == dateArray.count -1 ? [UIColor whiteColor] : [UIColor lightGrayColor];
        [self addSubview:titilLable];
        
        titilLable.text = [NSString stringWithFormat:@"%.f",[_dataAry[i] floatValue] * 100];
        titilLable.frame = CGRectMake(btn.center.x-12, btn.center.y - titilLable.frame.size.height-20, 25, 15);///CGSizeMake(25, 15);
        titilLable.textAlignment = UITextAlignmentCenter;
//        [titilLable sizeToFit];
//        titilLable.center = CGPointMake(btn.center.x, btn.center.y - titilLable.frame.size.height-2);

        UILabel * dateLable = [UILabel new];
        dateLable.font = [UIFont systemFontOfSize:10.0f];
        dateLable.textColor = [UIColor lightGrayColor];
        dateLable.tag = 10+i;
        [self addSubview:dateLable];
        dateLable.text = i == dateArray.count -1 ? @"今天" : dateArray[i];
        
        [dateLable sizeToFit];
        dateLable.center = CGPointMake(btn.center.x, 100);
    }
    
    self.isCell = NO;
}

-(void)setDataAry:(NSArray *)dataAry withDateArray:(NSArray *)dateArray{
    _dataAry = dataAry;
    if (!dataAry || dataAry.count<1) return;
    
    CGFloat max = [self getMaxValueForAry:dataAry];
    for (int i=0; i<dataAry.count; i++) {
        CGFloat value = [dataAry[i] floatValue];
        CGFloat x =_marginX + (KKWidth - _marginX - KKRight)/dataAry.count*(i+1);
        CGFloat y = KKHeight-_marginY-(KKHeight - _marginY - KKTop)/max*value;
        CGPoint point = CGPointMake(x, y);
        [_pointAry addObject:NSStringFromCGPoint(point)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.frame = CGRectMake(0, 0, 8, 8);
//        [btn addTarget:self action:@selector(showLable:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.center = point;
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = _lineColor;
        
        UILabel * titilLable = [UILabel new];
        titilLable.font = [UIFont systemFontOfSize:10.0f];
        titilLable.textColor = _lineColor;
        [self addSubview:titilLable];
        
        titilLable.text = [NSString stringWithFormat:@"%.f 分",[_dataAry[i] floatValue] * 100];
        [titilLable sizeToFit];
        titilLable.center = CGPointMake(btn.center.x, btn.center.y - titilLable.frame.size.height);
        
        UILabel * dateLable = [UILabel new];
        dateLable.font = [UIFont systemFontOfSize:10.0f];
        dateLable.textColor = [UIColor lightGrayColor];
        [self addSubview:dateLable];
        
        dateLable.text = dateArray.count-1 == i ? @"今天" : dateArray[i];
        [dateLable sizeToFit];
        dateLable.center = CGPointMake(btn.center.x, 100);
    }
    [self kk_drawRect];
    [self kk_addLeftBezierPoint];
}
-(void)setIsShowGradient:(BOOL)isShowGradient{
    
    _isShowGradient = isShowGradient;
    
    if (isShowGradient == YES) {
        [self kk_addGradientLayer];
    }

}
-(void)setGradientColor:(NSString *)gradientColor{
    
    _gradientColor = gradientColor;
    [self kk_addGradientLayer];
}

-(void)showLable:(UIButton *)sender{
    NSInteger i = sender.tag;
    
    if (_titilLable) {
        [_titilLable removeFromSuperview];
        _titilLable = nil;
    }
    
    [self addSubview:self.titilLable];
    self.titilLable.text = _dataAry[i];
    [_titilLable sizeToFit];
    _titilLable.center = CGPointMake(sender.center.x, sender.center.y - _titilLable.frame.size.height);
}

-(CGFloat)getMaxValueForAry:(NSArray *)ary{
    
    CGFloat max = [ary[0] floatValue];
    for (int i=0; i<ary.count; i++) {
        if (max < [ary[i] floatValue]) {
            max = [ary[i] floatValue];
        }
    }
    return max;
}

-(UILabel *)titilLable{
    
    if (_titilLable == nil) {
        _titilLable = [UILabel new];
        _titilLable.font = [UIFont systemFontOfSize:10.0f];
        _titilLable.textColor = _lineColor;
    }
    return _titilLable;
}

@end
