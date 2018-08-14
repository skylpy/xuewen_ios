//
//  XWExamHistoryModel.m
//  XueWen
//
//  Created by Karron Su on 2018/7/3.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWExamHistoryModel.h"

@implementation XWExamHistoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XWHistoryInfoModel class]};
}

@end

@implementation XWHistoryInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"creatTime" : @"create_time",
             @"rangeName" : @"range_name"
             };
}

@end
