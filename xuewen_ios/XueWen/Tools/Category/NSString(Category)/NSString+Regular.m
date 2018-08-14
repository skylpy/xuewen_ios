//
//  NSString+Regular.m
//  XueWen
//
//  Created by ShaJin on 2018/1/16.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)
/** 验证表达式 */
- (BOOL)isValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

@end
