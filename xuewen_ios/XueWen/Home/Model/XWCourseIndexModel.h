//
//  XWCourseIndexModel.h
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 热门课程与近期上线Model*/
@interface XWCourseIndexModel : NSObject

/** 课程ID*/
@property (nonatomic, strong) NSString *courseId;
/** 用户ID*/
@property (nonatomic, strong) NSString *userId;
/** 课程名称*/
@property (nonatomic, strong) NSString *courseName;
/** 课程时长*/
@property (nonatomic, strong) NSString *timeLength;
/** 个人价格*/
@property (nonatomic, strong) NSString *price;
/** 企业价格*/
@property (nonatomic, strong) NSString *favorablePrice;
/** 图片*/
@property (nonatomic, strong) NSString *coverPhoto;
/** 全链接课程图片*/
@property (nonatomic, strong) NSString *coverPhotoAll;
/** 老师名称*/
@property (nonatomic, strong) NSString *name;
/** 多少人学习*/
@property (nonatomic, strong) NSString *total;
/** 老师头像*/
@property (nonatomic, strong) NSString *picture;
/** 全链接老师头像*/
@property (nonatomic, strong) NSString *pictureAll;
/** 课程金额*/
@property (nonatomic, strong) NSString *amount;
/** 1视频 2音频 3音视频*/
@property (nonatomic, strong) NSString *courseType;
/** 老师简介*/
@property (nonatomic, strong) NSString *teacherProfile;
/** 课程介绍*/
@property (nonatomic, strong) NSString *introduction;
/** 上架时间*/
@property (nonatomic, strong) NSString *shelvesTime;
/** 课程纯文字介绍*/
@property (nonatomic, strong) NSString *shortIntroduction;
@end
