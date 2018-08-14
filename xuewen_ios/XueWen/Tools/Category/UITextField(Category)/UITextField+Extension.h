//
//  UITextField+Extension.h
//  Prepare
//
//  Created by Pingzi on 2017/6/7.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)


+ (instancetype)creatTextFieldWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h fontSize:(CGFloat)size;


+ (instancetype)textFieldWithFrame:(CGRect)frame fontSize:(CGFloat)size text:(NSString *)text placeholder:(NSString *)placeholder textColor:(UIColor *)textColor;
+ (instancetype)textFieldWithTextColor:(UIColor *)color size:(CGFloat)size placeholder:(NSString *)placeholder;
@end
