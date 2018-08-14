//
//  XWCoursModel.h
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 课程信息Model*/
@interface XWCoursModel : NSObject

/** 课程ID*/
@property (nonatomic, strong) NSString *courseId;
/** 课程图片*/
@property (nonatomic, strong) NSString *coverPhoto;
/** 全链接课程图片*/
@property (nonatomic, strong) NSString *coverPhotoAll;
/** 课程名称*/
@property (nonatomic, strong) NSString *courseName;
/** 时长*/
@property (nonatomic, strong) NSString *timeLength;
/** 企业价格*/
@property (nonatomic, strong) NSString *favorablePrice;
/** 个人价格*/
@property (nonatomic, strong) NSString *price;
/** 课程简介*/
@property (nonatomic, strong) NSString *introduction;
/** 添加时间*/
@property (nonatomic, strong) NSString *createTime;
/** 多少人学习*/
@property (nonatomic, strong) NSString *total;
/** 试题id*/
@property (nonatomic, strong) NSString *testID;
/** 试题名称*/
@property (nonatomic, strong) NSString *title;
/** 课程人次*/
@property (nonatomic, strong) NSString *peopleNum;
/** 0选修 1必修*/
@property (nonatomic, strong) NSString *courseType;
/** 0上架 1下架*/
@property (nonatomic, strong) NSString *courseShelves;
/** 0普通账号 1讲师 2 业务员*/
@property (nonatomic, strong) NSString *identity;
/** 老师/机构图片*/
@property (nonatomic, strong) NSString *tchOrgPhoto;
/** 老师简介*/
@property (nonatomic, strong) NSString *tchOrgIntroduction;
/** 老师名称*/
@property (nonatomic, strong) NSString *tchOrg;
/** 用户id*/
@property (nonatomic, strong) NSString *userID;
/** 老师头像*/
@property (nonatomic, strong) NSString *picture;
/** 老师简介*/
@property (nonatomic, strong) NSString *teacherProfile;
/** 老师名称*/
@property (nonatomic, strong) NSString *name;
/** 课程百分比*/
@property (nonatomic, strong) NSString *Percentage;
/** 课程价格*/
@property (nonatomic, strong) NSString *amount;
/** 考试id*/
@property (nonatomic, strong) NSString *testid;
/** 全链接老师/机构图片*/
@property (nonatomic, strong) NSString *tchOrgPhotoAll;
/** 免费是否拥有（0未拥有 1拥有）*/
@property (nonatomic, strong) NSString *watched;










@end
