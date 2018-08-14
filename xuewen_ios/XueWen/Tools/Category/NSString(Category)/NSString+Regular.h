//
//  NSString+Regular.h
//  XueWen
//
//  Created by ShaJin on 2018/1/16.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)
/** 验证表达式 */
- (BOOL)isValidateByRegex:(NSString *)regex;
@end
