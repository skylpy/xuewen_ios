//
//  LessionModel.m
//  XueWen
//
//  Created by ShaJin on 2017/11/27.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "LessionModel.h"

@implementation LessionNodeModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"lessionID"       : @"id",
             @"courseID"        : @"course_id",
             @"lessionTitle"    : @"node_titile",
             @"lessionURL"      : @"node_url",
             @"lessionSort"     : @"node_sort",
             @"lessionTime"     : @"total_time",
             @"watchTime"       : @"watch_time"
             };
}

- (NSInteger)sumTime{
    if (_sumTime == 0) {
        NSArray *array = [_lessionTime componentsSeparatedByString:@":"];
        if (array.count == 3) {
            NSInteger hours = [array[0] integerValue];
            NSInteger minutes = [array[1] integerValue];
            NSInteger seconds = [array[2] integerValue];
            _sumTime = hours * 60 * 60 + minutes * 60 + seconds;
        }
    }
    return _sumTime;
}

- (void)setWatchTime:(NSInteger)watchTime{
    /** 为了和安卓统一，观看时间保存的是ms */
    _watchTime = watchTime / 1000;
}
@end

@implementation LessionModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"courseID"            : @"id",
             @"courseName"          : @"course_name",
             @"coverPhoto"          : @"cover_photo_all",
             @"price"               : @"amount",
             @"timeLength"          : @"time_length",
             @"teacherName"         : @"tch_org",
             @"teacherPhoto"        : @"tch_org_photo_all",
             @"teacherIntroduction" : @"tch_org_introduction",
             @"createTime"          : @"create_time",
             @"testID"              : @"testid",
             @"canTest"             : @"course_test",
             @"reset_test"         : @"reset_test"
             };
}

- (BOOL)needRestudy{
    return [_reset_test isEqualToString:@"1"];
}

- (void)setWatched:(NSString *)watched{
    _watched = watched;
    _isWatched = [watched isEqualToString:@"1"];
}

- (void)setIsWatched:(BOOL)isWatched{
    _isWatched = isWatched;
    _watched = isWatched ? @"1" : @"0" ;
}

- (void)setIntroduction:(NSString *)introduction{
    _introduction = (introduction.length > 0) ? introduction : @"";
}

- (void)setTeacherIntroduction:(NSString *)teacherIntroduction{
    _teacherIntroduction = (teacherIntroduction.length > 0 ) ? teacherIntroduction : @"";
}
@end
