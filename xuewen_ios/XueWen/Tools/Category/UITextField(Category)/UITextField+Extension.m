//
//  UITextField+Extension.m
//  Prepare
//
//  Created by Pingzi on 2017/6/7.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)



+ (instancetype)creatTextFieldWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h fontSize:(CGFloat)size
{
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.font = [UIFont fontWithName:kRegFont size:size];
    return tf;
}

+ (instancetype)textFieldWithFrame:(CGRect)frame fontSize:(CGFloat)size text:(NSString *)text placeholder:(NSString *)placeholder textColor:(UIColor *)textColor{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = kFontSize(size);
    textField.text = text;
    textField.placeholder = placeholder;
    textField.textColor = textColor;
    return textField;
}

+ (instancetype)textFieldWithTextColor:(UIColor *)color size:(CGFloat)size placeholder:(NSString *)placeholder{
    UITextField *textField = [UITextField new];
    textField.font = kFontSize(size);
    textField.placeholder = placeholder;
    textField.textColor = color;
    return textField;
}
@end
