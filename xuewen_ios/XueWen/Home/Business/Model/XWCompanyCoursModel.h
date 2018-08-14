//
//  XWCompanyCoursModel.h
//  XueWen
//
//  Created by Karron Su on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//
// 企业课程列表Model

#import <Foundation/Foundation.h>

@interface XWCompanyCoursModel : NSObject

/** 课程id*/
@property (nonatomic, strong) NSString *courseId;
/** 课程名称*/
@property (nonatomic, strong) NSString *courseName;
/** 公司id*/
@property (nonatomic, strong) NSString *companyId;
/** 课程封面图*/
@property (nonatomic, strong) NSString *coverPhoto;
/** 全链接课程封面图*/
@property (nonatomic, strong) NSString *coverPhotoAll;
/** 用户id*/
@property (nonatomic, strong) NSString *userId;
/** 购买量*/
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *courseType;

@end
