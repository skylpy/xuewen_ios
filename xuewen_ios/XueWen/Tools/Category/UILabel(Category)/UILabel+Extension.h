//
//  UILabel+Extension.h
//  Prepare
//
//  Created by Pingzi on 2017/6/7.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
@property (nonatomic, assign, readonly) CGFloat textWidth;
@property (nonatomic, assign, readonly) CGFloat textHeight;

+ (instancetype)creatLabelWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h Text:(NSString *)text fontSize:(CGFloat)size TextColor:(UIColor *)textColor BGColor:(UIColor *)bgColor;

+ (instancetype)creatLabelWithFontName:(NSString *)name TextColor:(UIColor *)textColor FontSize:(CGFloat)size Text:(NSString *)text;

+ (instancetype)labelWithTextColor:(UIColor *)textColor size:(CGFloat)size;

+ (UILabel *)createALabelText:(NSString *)text withFont:(UIFont *)font withColor:(UIColor *)color;

@end
