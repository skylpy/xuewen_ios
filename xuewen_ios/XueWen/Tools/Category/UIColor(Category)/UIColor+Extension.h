//
//  UIColor+Extension.h
//  Prepare
//
//  Created by Pingzi on 2017/6/6.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 *  rgb颜色
 */
+ (instancetype)R:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue;

/**
 *  16进制转UIColor
 */
+ (instancetype)transferFromString:(NSString *)colorStr;

/**
 *  灰色
 */
+ (instancetype)Gray:(CGFloat)gray;


// 随机颜色
+ (UIColor *) randomColor;

@end
