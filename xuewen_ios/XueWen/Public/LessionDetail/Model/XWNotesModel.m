//
//  XWNotesModel.m
//  XueWen
//
//  Created by Karron Su on 2018/5/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNotesModel.h"

@implementation XWNotesModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"noteID" : @"id",
             @"CourseID" : @"course_id",
             @"noteContent" : @"notes_content",
             @"createTime" : @"create_time",
             @"pictureAll" : @"picture_all",
             @"nickName" : @"nick_name",
             @"companyID" : @"company_id"
             
             };
}

@end
