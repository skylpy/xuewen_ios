//
//  XWArticleContentModel.m
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWArticleContentModel.h"

@implementation XWArticleContentModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"articleId" : @"id",
             @"classFid" : @"class_f_id",
             @"copyrightStat" : @"copyright_stat",
             @"updateTime" : @"update_time",
             @"createTime" : @"create_time",
             @"contentUrl" : @"content_url",
             @"contentHtml" : @"content_html",
             @"isShow" : @"is_show"
             };
}

@end
