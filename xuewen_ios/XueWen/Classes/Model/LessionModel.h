//
//  LessionModel.h
//  XueWen
//
//  Created by ShaJin on 2017/11/27.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CourseAudioModel;
/** 课程小节模型，一套课程有N小节 */
@interface LessionNodeModel : NSObject
/** 小节ID */
@property (nonatomic, strong) NSString *lessionID;
/** 课程ID */
@property (nonatomic, strong) NSString *courseID;
/** 小节标题 */
@property (nonatomic, strong) NSString *lessionTitle;
/** 视频URL */
@property (nonatomic, strong) NSString *lessionURL;
/** 小节序号 */
@property (nonatomic, strong) NSString *lessionSort;
/** 视频时长 */
@property (nonatomic, strong) NSString *lessionTime;
/** 是否观看过 */
@property (nonatomic, assign) BOOL play;
/** 观看时长（秒） */
@property (nonatomic, assign) NSInteger watchTime;
/** 是否已经看完 */
@property (nonatomic, assign) BOOL finished;
/** 总时长 */
@property (nonatomic, assign) NSInteger sumTime;

/** 内容*/
@property (nonatomic, strong) NSString *node_content;

/** 类型*/
@property (nonatomic, strong) NSString *type;

/** 创建时间*/
@property (nonatomic, assign) NSInteger create_time;
@end


/** 带有详细信息的课程模型 */
@interface LessionModel : NSObject
/** 课程ID */
@property (nonatomic, strong) NSString *courseID;
/** 课程封面图片 */
@property (nonatomic, strong) NSString *coverPhoto;
/** 课程名称 */
@property (nonatomic, strong) NSString *courseName;
/** 课程价格 */
@property (nonatomic, strong) NSString *price;
/** 课程简介 */
@property (nonatomic, strong) NSString *introduction;
/** 课程时长 */
@property (nonatomic, strong) NSString *timeLength;
/** 老师或机构名称 */
@property (nonatomic, strong) NSString *teacherName;
/** 老师或机构图片 */
@property (nonatomic, strong) NSString *teacherPhoto;
/** 老师或机构简介 */
@property (nonatomic, strong) NSString *teacherIntroduction;
/** 课程创建时间 */
@property (nonatomic, strong) NSString *createTime;
/** 学习人数 */
@property (nonatomic, strong) NSString *total;
/** 是否购买 */
@property (nonatomic, assign) BOOL isBought;
/** 试卷ID */
@property (nonatomic, strong) NSString *testID;

/** 课程小节 */
@property (nonatomic, strong) NSArray<LessionNodeModel *> *lessions;
/** 音频小节 */
@property (nonatomic, strong) NSArray<CourseAudioModel *> *audios;
/** 是否可以考试（观看完全部课程之后才能考试） */
@property (nonatomic, assign) BOOL canTest;
/** 是否需要重新学习(已经考试完毕再考试的时候需要清空播放记录重新学习课程之后才能考试) */
@property (nonatomic, assign) BOOL needRestudy;
@property (nonatomic, strong) NSString *reset_test; // 是否需要重新学习,上面的needRestudy根据这个属性赋值

/** 课程是否看过 这个是程序里判断用*/
@property (nonatomic, assign) BOOL isWatched;
/** 课程是否看过 这个是数据里携带的字段*/
@property (nonatomic, strong) NSString *watched;

/** 是否包含视频小节内容*/
@property (nonatomic, assign) BOOL isCourse_node;

/** 是否有音频 0没有 1有*/
@property (nonatomic, assign) NSInteger audio_type;

@end
