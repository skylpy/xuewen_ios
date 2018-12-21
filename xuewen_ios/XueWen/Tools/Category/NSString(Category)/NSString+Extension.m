//
//  NSString+Extension.m
//  Prepare
//
//  Created by Pingzi on 2017/6/7.
//  Copyright © 2017年 张子恒. All rights reserved.
//  XueWen
//
//  Created by ShaJin on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "NSString+Extension.h"
#import "CoreText/CoreText.h"
@implementation NSString (Extension)


/**
 *  计算指定宽度的字符串高度

 */
- (float) calculateHeightWithFont: (UIFont *)font Width: (float) width
{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    return ceil(textRect.size.height);
}

- (instancetype)Encoding
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

- (BOOL)isBlankString
{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}




/**
 根据文字多少计算高度
 */
+ (float)stringHeightWithString:(NSString *)string size:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont fontWithName:kRegFont size:fontSize],NSFontAttributeName, nil];
    
    float height = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return ceilf(height);
}

/**
 *  动态计算文字的宽高（单行）
 *  @param font 文字的字体
 *  @return 计算的宽高
 */
- (CGSize)mh_sizeWithFont:(UIFont *)font
{
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    theSize = [self sizeWithAttributes:attributes];
    // 向上取整
    theSize.width = ceil(theSize.width);
    theSize.height = ceil(theSize.height);
    return theSize;
}

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input

{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"
     
                               withString:@""
     
                                  options:NSLiteralSearch
     
                                    range:NSMakeRange(0,[outputStr length])];
    
    return
    
    [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

/** 字典或数组转换成字符串 */
+ (NSString *)stringWithJsonData:(id)data{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

/** 计算单行文字宽度 */
- (CGFloat)widthWithSize:(int)size{
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
    theSize = [self sizeWithAttributes:attributes];
    // 向上取整
    return ceil(theSize.width);
}

/** 计算指定宽度文字高度 */
- (CGFloat)heightWithWidth:(CGFloat)width size:(int)size{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}
                                         context:nil];
    return ceil(textRect.size.height);
}

/** 对字符串进行URL编码 */
- (NSString *)URLEncodedString{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet]];;
}

/** 对字符串进行URL解码 */
- (NSString *)URLDecodedString{
    return [self stringByRemovingPercentEncoding];
}

/** 根据size计算文件大小 */
+ (NSString *)stringWithSize:(NSInteger)size{
    if (size < 1024) {
        return [NSString stringWithFormat:@"%ldkB",(long)size];
    }else if (size < 1024*1024){
        return [NSString stringWithFormat:@"%.1fMB",size / 1024.0];
    }else if (size < 1024*1024*1024){
        return [NSString stringWithFormat:@"%.1fGB",size / 1024.0 / 1024.0];
    }else{
        return [NSString stringWithFormat:@"%.1fTB",size / 1024.0 / 1024.0 / 1024.0];
    }
    return nil;
}

/** 根据时间戳获取字符串 */
+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval useDateFormatter:(NSDateFormatter *)dateFormatter{
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateFormatter stringFromDate:date];
}

/** 时间戳转换时间 */
- (NSString *)stringWithDataFormatter:(NSString *)dateFormatter{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = (dateFormatter) ? dateFormatter : @"yyyy-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(self.length == 10) ? [self integerValue] : [self integerValue] * 1000];
    return [formatter stringFromDate:date];
}

/** 标准时间格式转化成任意格式*/
- (NSString *)transTimeWithDateFormatter:(NSString *)dateFormatter {
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]]; //设置本地时区
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter1 dateFromString:self];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];//时间戳
    return [timeSp stringWithDataFormatter:dateFormatter];
}

/** 时间戳转换成时间(刚刚、几分钟前、几小时前形式) */
- (NSString *)translateDateFormatter:(NSString *)dateFormatter{
    NSTimeInterval timeInterval = (self.length == 10) ? [self integerValue] : [self integerValue] * 1000;
    NSTimeInterval currentTimeInterval = [NSDate date].timeIntervalSince1970;
    NSInteger seconds = currentTimeInterval - timeInterval; // 时间差
    if (seconds < 60) {
        return @"刚刚";
    }else if (seconds < 60 * 60){
        return [NSString stringWithFormat:@"%ld分钟前",seconds / 60];
    }else if (seconds < 60 * 60 * 24){
        return [NSString stringWithFormat:@"%ld小时前",seconds / 60 /60];
    }else{
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = (dateFormatter) ? dateFormatter : @"yyyy-MM-dd HH:mm";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        return [formatter stringFromDate:date];
    }
    return nil;
}

- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines){
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return linesArray;
}

/**
 按行数截取字符串
 
 @param lines 要截取的行数
 @param width 字符串宽度
 @return 截取后的字符串
 */
- (NSString *)subStringWithLines:(int)lines width:(CGFloat)width font:(UIFont *)font{
    if (self.length > 0) {
        NSArray *textArray = [self componentsSeparatedByFont:font width:width];
        if (lines <= textArray.count) {
            NSMutableString *mStr = [NSMutableString string];
            for (int i = 0; i < lines; i++) {
                [mStr appendString:textArray[i]];
            }
            return mStr;
        }else{
            // 如果行数不够的话直接返回原字符串
            return self;
        }
    }
    return @"";
}
/**
 将文字按行分割成字符串

 @param font 字体
 @param width 字符串宽度
 @return 字符串数组
 */
- (NSArray<NSString *> *)componentsSeparatedByFont:(UIFont *)font width:(CGFloat)width{
    if (self.length > 0) {
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self];
        [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, attStr.length)];
        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0,0,width,MAXFLOAT));
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef linesRef = CTFrameGetLines(frame);
        NSArray *linesArr = (__bridge NSArray *)linesRef;
        NSMutableArray *linesArray = [[NSMutableArray alloc]init];
        for (id line in linesArr){
            CTLineRef lineRef = (__bridge CTLineRef )line;
            CFRange lineRange = CTLineGetStringRange(lineRef);
            NSRange range = NSMakeRange(lineRange.location, lineRange.length);
            NSString *lineString = [self substringWithRange:range];
            [linesArray addObject:lineString];
        }
        return linesArray;
    }else{
        return @[];
    }
    
}

/**
 过滤html标签

 @param html htmt字符串
 @return 过滤后的文字
 */
+ (NSString *)filterHTML:(NSString *)html{
    if (html.length > 0) {
        NSScanner * scanner = [NSScanner scannerWithString:html];
        NSString * text = nil;
        while([scanner isAtEnd]==NO){
            [scanner scanUpToString:@"<" intoString:nil];
            [scanner scanUpToString:@">" intoString:&text];
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        }
        return html;
    }else{
        return @"";
    }
    
}

/** 根据<p>标签分隔html字符串 */
- (NSArray<NSString *> *)componentsSeparatedByTapP{
    if (self.length > 0) {
        NSRange range = [self rangeOfString:@"</p>"];
        if (range.location == NSNotFound) { // 判断有没有完整的p标签
            return @[self];
        }else{
            NSString *string = [NSString stringWithString:self];
            NSScanner *scanner = [NSScanner scannerWithString:string];
            NSString *text = nil;
            NSMutableArray *array = [NSMutableArray array];
            while (![scanner isAtEnd]) {
                string = [string substringFromIndex:text.length];
                if (string.length == 0) {
                    break;
                }
                [scanner scanUpToString:@"<p" intoString:nil];
                [scanner scanUpToString:@"</p>" intoString:&text];
                text = [NSString stringWithFormat:@"%@</p>",text];
                [array addObject:text];
            }
            return array;
        }
    }else{
        return @[];
    }
}
@end
