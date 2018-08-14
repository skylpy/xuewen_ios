//
//  CourseAudioModel.h
//  XueWen
//
//  Created by ShaJin on 2018/4/3.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 "id":5542,
 "course_id":null,
 "node_id":null,
 "content":"文章内容",
 "update_time":null,
 "create_time":null,
 "a_id":null,
 "node_titile":"音频标题",
 "node_url":"音频地址",
 "node_sort":1,
 "total_time":"时长",
 "type":2,
 "name":"老师名",
 "course_name":"课程名称"
 */
@interface CourseAudioModel : NSObject
/** 课程名称 */
@property (nonatomic, strong) NSString *course_name;
/** 老师名字 */
@property (nonatomic, strong) NSString *name;
/** 时长 */
@property (nonatomic, strong) NSString *total_time;
/** 音频地址 */
@property (nonatomic, strong) NSString *node_url;
/** 小节标题 */
@property (nonatomic, strong) NSString *node_title;
/** 文章内容 */
@property (nonatomic, strong) NSString *content;
@end
