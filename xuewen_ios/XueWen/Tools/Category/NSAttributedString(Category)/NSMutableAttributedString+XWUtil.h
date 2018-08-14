//
//  NSMutableAttributedString+XWUtil.h
//  XueWen
//
//  Created by aaron on 2018/7/30.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (XWUtil)

+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textFont:(UIFont *)font textColor:(UIColor *)color ;

@end
