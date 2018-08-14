//
//  XWCoursInfoModel.m
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCoursInfoModel.h"

@implementation XWCoursInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"nodeAudioArray" : @"node_audio",
             @"audioType" : @"audio_type",
             @"courseAudioArray" : @"course_node",
             @"shareUrl" : @"nosignShare_url",
             @"friendCircleTitle" : @"friend_circle_title",
             @"shareTitle" : @"share_title",
             @"shareContent" : @"share_content"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"courseAudioArray" : [XWAudioNodeModel class],
             @"nodeAudioArray" : [XWAudioNodeModel class]
             };
}

@end
