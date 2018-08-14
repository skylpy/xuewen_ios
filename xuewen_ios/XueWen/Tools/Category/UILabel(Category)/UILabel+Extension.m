//
//  UILabel+Extension.m
//  Prepare
//
//  Created by Pingzi on 2017/6/7.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (instancetype)creatLabelWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h Text:(NSString *)text fontSize:(CGFloat)size TextColor:(UIColor *)textColor BGColor:(UIColor *)bgColor
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, y, w, h);
    label.text = text ? :@"";
    label.font = size? [UIFont fontWithName:kRegFont size:size]:[UIFont fontWithName:kRegFont size:19];
    label.textColor = textColor? :[UIColor blackColor];
    label.backgroundColor = bgColor ? :[UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (instancetype)creatLabelWithFontName:(NSString *)name TextColor:(UIColor *)textColor FontSize:(CGFloat)size Text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text ? :@"";
    label.font = size? [UIFont fontWithName:kRegFont size:size]:[UIFont fontWithName:kRegFont size:19];
    label.textColor = textColor? :[UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (UILabel *)createALabelText:(NSString *)text withFont:(UIFont *)font withColor:(UIColor *)color {
    
    
    UILabel * label = [UILabel new];
    
    label.textColor = color;
    label.font = font;
    label.text = text;
    
    return label;
}

+ (instancetype)labelWithTextColor:(UIColor *)textColor size:(CGFloat)size{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:size];
    return label;
}

- (CGFloat)textWidth{
    return [self.text widthWithSize:self.font.pointSize];
}

- (CGFloat)textHeight{
    return [self.text heightWithWidth:self.width size:self.font.pointSize];
}
@end
