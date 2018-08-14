//
//  XWLearningModel.h
//  XueWen
//
//  Created by Karron Su on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//
// 大家在学Model

#import <Foundation/Foundation.h>

@interface XWLearningModel : NSObject

/** 课程id*/
@property (nonatomic, strong) NSString *courseId;
/** 课程名称*/
@property (nonatomic, strong) NSString *courseName;
/** 老师名称*/
@property (nonatomic, strong) NSString *tchOrg;
/** 课程封面图*/
@property (nonatomic, strong) NSString *coverPhoto;
/** 全链接课程封面图*/
@property (nonatomic, strong) NSString *coverPhotoAll;
/** 姓名*/
@property (nonatomic, strong) NSString *name;
/** 多少同事在学*/
@property (nonatomic, strong) NSString *total;
/** 标签*/
@property (nonatomic, strong) NSMutableArray *lable;
@property (nonatomic, strong) NSString *courseType;
@end
