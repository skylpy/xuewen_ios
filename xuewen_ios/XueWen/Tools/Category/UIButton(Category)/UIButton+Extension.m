//
//  UIButton+Extension.m
//  Prepare
//
//  Created by Pingzi on 2017/6/6.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import "UIButton+Extension.h"


@implementation UIButton (Extension)


/**
 *  系统样式带文字Button
 */
+ (instancetype)creatBtnWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h title:(NSString *)title action:(SEL)sel target:(id)vc FontColor:(UIColor *)color fontSize:(CGFloat)size BGColor:(UIColor *)bgColor {
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(x, y, w, h);
    [button setTitle:title forState:UIControlStateNormal];
    [button setFontColor:color fontSize:size BGColor:bgColor];
    [button addTarget:vc action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (instancetype)creatBtnWithTitle:(NSString *)title action:(SEL)sel target:(id)vc FontColor:(UIColor *)color fontSize:(CGFloat)size BGColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor isCircle:(BOOL)isC {
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFontColor:color fontSize:size BGColor:bgColor];
    if (isC) {
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = true;
    }
    if (borderColor != nil) {
        button.layer.borderColor = borderColor.CGColor;
        [button.layer setBorderWidth:1];
    }
    
    [button addTarget:vc action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (instancetype)vcCreatBtnWithTitle:(NSString *)title action:(SEL)sel target:(id)vc FontColor:(UIColor *)color fontSize:(CGFloat)size BGColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor isCircle:(BOOL)isC {
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFontColor:color fontSize:size BGColor:bgColor];
    if (isC) {
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = true;
    }
    if (borderColor != nil) {
        button.layer.borderColor = borderColor.CGColor;
        [button.layer setBorderWidth:1];
    }
    
    [button addTarget:vc action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
/**
 *  自定义带图片和文字的Button

 @param gray 高亮状态下背景图灰度值，推荐220，越大越接近白色
 @param space 取值为0时不进行图片和文字的居中对齐
 */
+ (instancetype)creatCustomBtnWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h title:(NSString *)title ImageName:(NSString *)imageName action:(SEL)sel target:(id)vc FontColor:(UIColor *)color BGColor:(UIColor *)bgColor fontSize:(CGFloat)size highLightedGray:(CGFloat)gray CornerRadius:(CGFloat)cornerRadius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor centerImageAndTitleWithSpacing:(CGFloat)space {
    
    UIButton *button = [UIButton creatBtnWithFrameX:x Y:y W:w H:h title:title action:sel target:vc FontColor:color fontSize:size BGColor:bgColor];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor Gray:gray] size:button.frame.size ] ? :nil forState:UIControlStateHighlighted];
    if(cornerRadius != 0)
    {
        button.layer.cornerRadius = cornerRadius;
        button.layer.masksToBounds = YES;
    }
    
    if (borderWidth > 0) {
        button.layer.borderWidth = borderWidth;
    }
    if (borderColor) {
        button.layer.borderColor = [borderColor CGColor];
    }
    if (space != 0) {
        [button centerImageAndTitle:space];
    }
    return button;
}

/**
 *  设置文字的颜色和大小
 
 @param fontColor when nil is black
 @param bgColor when nil is white
 */
- (void)setFontColor:(UIColor *)fontColor fontSize:(CGFloat)size BGColor:(UIColor *)bgColor
{
    
    [self setTitleColor:fontColor ? : [UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:kRegFont size:size];
    self.backgroundColor = bgColor? : [UIColor whiteColor];
    
}



/**
 设置图片与文字居中

 @param spacing 图片与文字的上下间距
 */
- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
    
}

- (void)setTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, self.width - [self.titleLabel.text widthWithSize:self.titleLabel.font.pointSize], 0,0);
}


@end
