//
//  NSString+CP.h
//  iCloudPlaySupport
//
//  Created by mac on 13-7-29.
//  Copyright (c) 2013年 XunLei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CP)

+ (BOOL)isValidateMobile:(NSString *)mobile;

+ (BOOL)isValidateEmail:(NSString *)email;

// 将秒数时间转为00:00:00的形式
+ (NSString *)formatTimeBySecond:(NSInteger)second;

+ (BOOL)isEmptyString:(NSString*)aString;

- (NSInteger)versionNumberValue;

- (NSString *)md5Encode;
- (NSString *)md516Encode;


+ (NSString*)stringWithDateIntervalFromBase:(unsigned long long)interval;
+ (NSString*)stringWithDateInterval:(unsigned long long)interval;

//大小转换为B、KB等等
+ (NSString*)stringWithFileSize:(unsigned long long)size;

- (BOOL)containChineseWord;
//是否包含大写字母
- (BOOL)containCapitalWord;
//是否包含数字
- (BOOL)containNumeralWord;
//是否包含空格
- (BOOL)containBlankSpace;

- (BOOL)includeString:(NSString *)string;
//是否是合法的url
- (BOOL)isLegalUrLString;

//如果只输入www.baidu.com，该方法也会认为不合法。
//如果确认url的协议，则使用此方法。
- (BOOL)isLegalURL;

// 从一片内存数据中得到一个十六进制字符串
+ (NSString*)hexStringFromBytes:(const void*)data withLength:(NSUInteger)length;
- (NSData*)hexStringToDataBytes;
 

//用于过滤字符串中的网络字符，webStrings为网络字符列表，每一个元素都是NSString类型
- (NSString *)filterWebString:(NSArray *)webStrings;

//清除非法字符串
- (NSString *)clearIllegalCharacter;

- (NSString*) base64Encode;
- (NSString *) base64Decode;

// 这个才是base64的正确使用方式  同时在NSData的扩展里头有encode方法

- (NSData*)base64Decode2;


- (NSString *)encodeString;
- (NSString *)decodeString;

// 确保上报的字段合法（中文字符加%Encode，字段长度255截取）
- (NSString *)legalReportFieldString;

// 从字符串中计算出urlhash
- (int64_t)urlHashFromString;

// 获取系统时间戳
+ (NSString *)timeStampAtNow;

// 时间 转时间戳
+ (NSString *)transTotimeSp:(NSString *)time ;

//将UTC日期字符串转为本地时间字符串
- (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate ;

/**
 日期 与当前 日期 相比 的大小
 日期格式为:yyyy-MM-dd
 */
+ (BOOL)compareDate:(NSString*)date;

//去掉前后空格和换行符
- (NSString *)trim;
//新版获取字符串宽度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/** 对比现在时间的发布时间  几天前、几分钟前、刚刚 */
+ (NSString *)internalFromCreatTime:(NSString *)creatTimeString formatString:(NSString *)formatString;
// 新增一个方法拼接优惠券的时间
+ (NSString *)couponDeadlineTimeConvertBeginTS:(long long)beginTS endTD:(long long)endTS;
// 转拼音
+ (NSString *) ChineseToPhoneticize :(NSString*)sourceString;
/** 获取首字母*/
+ (NSString *) getLetter:(NSString *) strInput;
@end
