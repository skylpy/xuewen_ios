//
//  CourseModel.h
//  XueWen
//
//  Created by ShaJin on 2017/11/24.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseProjectModel : NSObject
/** 标签ID */
@property (nonatomic, strong) NSString *projectID;
/** 封面图片 */
@property (nonatomic, strong) NSString *picture;
@end
/** 课程标签模型 */
@interface CourseLabelModel : NSObject<NSCoding>
/** 课程标签ID */
@property (nonatomic, strong) NSString *labelID;
/** 课程名称 */
@property (nonatomic, strong) NSString *labelName;
/** 上级编号，最上级课程为课程编号 */
@property (nonatomic, strong) NSString *pid;
/** 下级课程列表 */
@property (nonatomic, strong) NSArray<CourseLabelModel *> *children;
/** 课程标签对应的专题数组 */
@property (nonatomic, strong) NSArray<CourseProjectModel *> *thematics;
@end

/** 课程模型 */
@interface CourseModel : NSObject
/** 课程ID */
@property (nonatomic, strong) NSString *courseID;
/** 课程名称 */
@property (nonatomic, strong) NSString *courseName;
/** 课程所属标签ID */
@property (nonatomic, strong) NSString *labelID;
/** 课程所属标签名称 */
@property (nonatomic, strong) NSString *labelName;
/** 课程封面图片 */
@property (nonatomic, strong) NSString *coverPhoto;
/** 课程价格 */
@property (nonatomic, strong) NSString *price;
/** 课程时长 */
@property (nonatomic, strong) NSString *timeLength;
/** 课程简介 */
@property (nonatomic, strong) NSString *introduction;
/** 老师或机构名称 */
@property (nonatomic, strong) NSString *teacherName;
/** 老师或机构图片 */
@property (nonatomic, strong) NSString *teacherPhoto;
/** 老师或机构简介 */
@property (nonatomic, strong) NSString *teacherIntroduction;
/** 课程创建时间 */
@property (nonatomic, assign) NSTimeInterval createTime;
/** 学习人数 */
@property (nonatomic, assign) NSInteger total;
/** 最后观看时间 */
@property (nonatomic, assign) NSTimeInterval updateTime;
/** 学习进度 */
@property (nonatomic, assign) NSInteger percentage;
/** 选修课 */
@property (nonatomic, assign) BOOL isOptional;
//学习时间
@property (nonatomic, strong) NSString *learningTime;
//历史记录ID
@property (nonatomic, strong) NSString *hisID;
//课程类型
@property (nonatomic, strong) NSString *courseType;

@end
