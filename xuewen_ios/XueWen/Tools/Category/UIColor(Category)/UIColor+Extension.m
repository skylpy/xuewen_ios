//
//  UIColor+Extension.m
//  Prepare
//
//  Created by Pingzi on 2017/6/6.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)


/**
 *  rgb颜色
 */
+ (instancetype)R:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

/**
 *  灰色
 */
+ (instancetype)Gray:(CGFloat)gray {
    return [UIColor colorWithRed:gray/255.0 green:gray/255.0 blue:gray/255.0 alpha:1.0];
}

/**
 *  16进制转UIColor
 */
+ (instancetype)transferFromString:(NSString *)colorStr {
    UIColor *color = [UIColor redColor];
    NSString *cStr = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cStr hasPrefix:@"#"]) {
        cStr = [cStr substringFromIndex:1];
    }
    if (cStr.length != 6) {
        return [UIColor blackColor];
    }
    
    NSString *rStr = [cStr substringWithRange:NSMakeRange(0, 2)];
    NSString *gStr = [cStr substringWithRange:NSMakeRange(2, 2)];
    NSString *bStr = [cStr substringWithRange:NSMakeRange(4, 2)];
    
    unsigned int r = 0;
    unsigned int g = 0;
    unsigned int b = 0;
    
    NSScanner *rScanner = [[NSScanner alloc]initWithString:rStr];
    NSScanner *gScanner = [[NSScanner alloc]initWithString:gStr];
    NSScanner *bScanner = [[NSScanner alloc]initWithString:bStr];
    
    [rScanner scanHexInt:&r];
    [gScanner scanHexInt:&g];
    [bScanner scanHexInt:&b];
    
    color = [UIColor R:r G:g B:b];
    
    return color;
}

// 随机颜色
+ (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}



@end
