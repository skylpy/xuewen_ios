//
//  XWGradientView.m
//  XueWen
//
//  Created by Pingzi on 2017/11/14.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWGradientView.h"

@implementation XWGradientView

- (id)initWithFrame:(CGRect)frame GradientColors:(NSArray *)gradientColors
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gradientColors = gradientColors;
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) 
    {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[self.gradientColors count]];
    [self.gradientColors enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIColor class]]) {
            [colors addObject:(__bridge id)[obj CGColor]];
        } else if (CFGetTypeID((__bridge void *)obj) == CGColorGetTypeID()) {
            [colors addObject:obj];
        } else {
            @throw [NSException exceptionWithName:@"CRGradientLabelError"
                                          reason:@"Object in gradientColors array is not a UIColor or CGColorRef"
                                        userInfo:NULL];
        }
    }];
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context,1.0, -1.0);
    CGContextTranslateCTM(context,0, -rect.size.height);
    
    CGGradientRef gradient =CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)colors, NULL);
    
    CGPoint startPoint =CGPointMake(CGRectGetMinX(rect),CGRectGetMidY(rect));
    CGPoint endPoint = CGPointMake(kWidth - 30,CGRectGetMidY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
                                kCGGradientDrawsAfterEndLocation |kCGGradientDrawsBeforeStartLocation);
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    
    [super drawRect: rect];
}


@end
