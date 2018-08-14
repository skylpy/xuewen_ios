//
//  XWAudioNodeModel.m
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWAudioNodeModel.h"

@implementation XWAudioNodeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"nodeID" : @"id",
             @"courseID" : @"course_id",
             @"nodeTitle" : @"node_titile",
             @"nodeUrl" : @"node_url",
             @"nodeSort" : @"node_sort",
             @"totalTime" : @"total_time",
             @"nodeContent" : @"node_content",
             @"createTime" : @"create_time",
             @"watchTime" : @"watch_time"
             };
}

@end
