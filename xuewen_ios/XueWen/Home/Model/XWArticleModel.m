//
//  XWArticleModel.m
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWArticleModel.h"

@implementation XWArticleModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"articleId" : @"id",
             @"updateTime" : @"update_time",
             @"createTime" : @"create_time"
             };
}

@end
