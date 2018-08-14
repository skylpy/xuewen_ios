//
//  NSMutableAttributedString+XWUtil.m
//  XueWen
//
//  Created by aaron on 2018/7/30.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "NSMutableAttributedString+XWUtil.h"

@implementation NSMutableAttributedString (XWUtil)

+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textFont:(UIFont *)font textColor:(UIColor *)color  {
    
    NSRange hightlightTextRange = [text rangeOfString:rangeText];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 改变文字颜色
    if (hightlightTextRange.length > 0) {
        
        [attributeStr addAttribute:NSForegroundColorAttributeName
         
                             value:color
         
                             range:hightlightTextRange];
        
        [attributeStr addAttribute:NSFontAttributeName value:font range:hightlightTextRange];
        
        return attributeStr;
        
    }else {
        
        return [rangeText copy];
        
    }
    
}

@end
