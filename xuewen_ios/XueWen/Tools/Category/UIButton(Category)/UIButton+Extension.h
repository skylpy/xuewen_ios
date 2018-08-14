//
//  UIButton+Extension.h
//  Prepare
//
//  Created by Pingzi on 2017/6/6.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

/**
 *  系统样式带文字Button
 */
+ (instancetype)creatBtnWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h title:(NSString *)title action:(SEL)sel target:(id)vc FontColor:(UIColor *)color fontSize:(CGFloat)size BGColor:(UIColor *)bgColor;
+ (instancetype)creatBtnWithTitle:(NSString *)title action:(SEL)sel target:(id)vc FontColor:(UIColor *)color fontSize:(CGFloat)size BGColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor isCircle:(BOOL)isC;;

+ (instancetype)vcCreatBtnWithTitle:(NSString *)title action:(SEL)sel target:(id)vc FontColor:(UIColor *)color fontSize:(CGFloat)size BGColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor isCircle:(BOOL)isC;

/**
 *  自定义带图片和文字的Button
 
 @param gray 高亮状态下背景图灰度值，推荐220，越大越接近白色
 @param space 取值为nil时不进行图片和文字的居中对齐
 */
+ (instancetype)creatCustomBtnWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h title:(NSString *)title ImageName:(NSString *)imageName action:(SEL)sel target:(id)vc FontColor:(UIColor *)color BGColor:(UIColor *)bgColor fontSize:(CGFloat)size highLightedGray:(CGFloat)gray CornerRadius:(CGFloat)cornerRadius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor centerImageAndTitleWithSpacing:(CGFloat)space;

/**
 *  设置图片与文字居中
 
 @param spacing 图片与文字的上下间距
 */
- (void)centerImageAndTitle:(float)spacing;


- (void)setFontColor:(UIColor *)fontColor fontSize:(CGFloat)size BGColor:(UIColor *)bgColor;


/** 设置title,仅用于navigationBar的rightButtonItem */
- (void)setTitle:(NSString *)title;

@end
