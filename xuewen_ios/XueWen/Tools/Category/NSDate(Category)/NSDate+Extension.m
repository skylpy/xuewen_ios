//
//  NSDate+Extension.m
//  XueWen
//
//  Created by ShaJin on 2018/1/27.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
/** 当前时间转字符串 */
+ (NSString *)dateWithFormat:(NSString *)format{
    return [[NSDate date] dateWithFormat:format];
}

/**
 时间转字符串

 @param format 要转换的时间格式，不传则默认yyyy-MM-dd形式
 @return 字符串时间
 */
- (NSString *)dateWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (format.length > 0) {
        [formatter setDateFormat:format];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [formatter stringFromDate:self];
}

/**
 时间戳格式化时间字符串

 @param timestamp 时间戳
 @param format 要转换的时间格式，不传则默认yyyy-MM-dd形式
 @return 字符串时间
 */
+ (NSString *)dateFormTimestamp:(NSString *)timestamp withFormat:(NSString *)format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timestamp.length == 10) ? [timestamp integerValue] : [timestamp integerValue] / 1000.0];
    return [date dateWithFormat:format];
}

//获取最近7天时间 数组
+(NSMutableArray *)latelyEightTime:(NSString *)format{
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 7; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = -i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        
        //转换英文为中文
        NSString *chinaStr = [self cTransformFromE:weekStr];
        
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@",dateStr];
        [eightArr addObject:strTime];
    }
    
    return eightArr;
}

//转换英文为中文
+(NSString *)cTransformFromE:(NSString *)theWeek{
    NSString *chinaStr;
    if(theWeek){
        if([theWeek isEqualToString:@"Monday"]){
            chinaStr = @"一";
        }else if([theWeek isEqualToString:@"Tuesday"]){
            chinaStr = @"二";
        }else if([theWeek isEqualToString:@"Wednesday"]){
            chinaStr = @"三";
        }else if([theWeek isEqualToString:@"Thursday"]){
            chinaStr = @"四";
        }else if([theWeek isEqualToString:@"Friday"]){
            chinaStr = @"五";
        }else if([theWeek isEqualToString:@"Saturday"]){
            chinaStr = @"六";
        }else if([theWeek isEqualToString:@"Sunday"]){
            chinaStr = @"七";
        }
    }
    return chinaStr;
}

/** 获取当前时间戳 */
NSString * getCurrentTime(NSInteger count){
    if (count == 10) {
        return [NSString stringWithFormat:@"%0.f",[[NSDate date] timeIntervalSince1970] - [XWInstance shareInstance].timeDiff];
    }else{
        return [NSString stringWithFormat:@"%0.f",(([[NSDate date] timeIntervalSince1970] - [XWInstance shareInstance].timeDiff) * 1000.0)];
    }
    return nil;
}

/** 秒数转换字符串 */
NSString *translateTime(NSInteger time){
    if (time > 0 && time < 60) {
        return [NSString stringWithFormat:@"00:%02ld",time];
    }else if (time < 60 * 60){
        NSInteger mm = time / 60;
        NSInteger ss = time % 60;
        return [NSString stringWithFormat:@"%02ld:%02ld",mm,ss];
    }else{
        NSInteger hh = time / 60 / 60;
        NSInteger mm = time % 60 / 60;
        NSInteger ss = time % 60 % 60;
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hh,mm,ss];
    }
    return @"00:00";
}
@end
