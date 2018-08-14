//
//  XWRecommendCourseModel.h
//  XueWen
//
//  Created by Karron Su on 2018/7/5.
//  Copyright © 2018年 KarronSu. All rights reserved.
//
// 个人课程标签推荐Model

#import <Foundation/Foundation.h>

@interface XWRecommendCourseModel : NSObject

/** 课程ID*/
@property (nonatomic, strong) NSString *courseID;
/** 课程名称*/
@property (nonatomic, strong) NSString *courseName;
/** 课程价格*/
@property (nonatomic, strong) NSString *amount;
/** 学习人数*/
@property (nonatomic, strong) NSString *studynum;
/** 封面图的完整连接*/
@property (nonatomic, strong) NSString *coverPhotoAll;
/** 封面图的部分连接*/
@property (nonatomic, strong) NSString *coverPhoto;

@end
