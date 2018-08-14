//
//  XWCommentModel.m
//  XueWen
//
//  Created by Karron Su on 2018/5/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCommentModel.h"

@implementation XWCommentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"createTime" : @"create_time",
             @"pictureAll" : @"picture_all",
             @"nickName" : @"nick_name"
             };
}

@end
