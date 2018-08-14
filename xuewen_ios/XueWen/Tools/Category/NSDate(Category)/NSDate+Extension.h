//
//  NSDate+Extension.h
//  XueWen
//
//  Created by ShaJin on 2018/1/27.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/** 当前时间转字符串 */
+ (NSString *)dateWithFormat:(NSString *)format;
/**
 时间转字符串
 
 @param format 要转换的时间格式，不传则默认yyyy-MM-dd形式
 @return 字符串时间
 */
- (NSString *)dateWithFormat:(NSString *)format;
/**
 时间戳格式化时间字符串
 
 @param timestamp 时间戳
 @param format 要转换的时间格式，不传则默认yyyy-MM-dd形式
 @return 字符串时间
 */
+ (NSString *)dateFormTimestamp:(NSString *)timestamp withFormat:(NSString *)format;
/** 获取当前时间戳 */
NSString * getCurrentTime(NSInteger count);
/** 秒数转换字符串 */
NSString *translateTime(NSInteger time);
//获取最近7天时间 数组
+(NSMutableArray *)latelyEightTime:(NSString *)format;
@end
