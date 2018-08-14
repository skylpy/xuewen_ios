//
//  XWAudioCoursModel.h
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWAudioNodeModel.h"

/** 音频课程列表Model*/
@interface XWAudioCoursModel : NSObject

/** 课程ID*/
@property (nonatomic, strong) NSString *courseId;
/** 课程名*/
@property (nonatomic, strong) NSString *courseName;
/** 老师名*/
@property (nonatomic, strong) NSString *tchOrg;
/** 多少人学习*/
@property (nonatomic, strong) NSString *total;
/** 课程时长*/
@property (nonatomic, strong) NSString *timeLength;
/** 个人价格*/
@property (nonatomic, strong) NSString *price;
/** 企业价格*/
@property (nonatomic, strong) NSString *favorablePrice;
/** 课程封面*/
@property (nonatomic, strong) NSString *coverPhoto;
/** 全链接课程封面*/
@property (nonatomic, strong) NSString *coverPhotoAll;
/** 1购买0未购买*/
@property (nonatomic, strong) NSString *courseType;
/** 名字*/
@property (nonatomic, strong) NSString *name;
/** 老师头像*/
@property (nonatomic, strong) NSString *picture;
/** 全链接老师头像*/
@property (nonatomic, strong) NSString *pictureAll;
/** 课程价格*/
@property (nonatomic, strong) NSString *amount;
/** 课程音频*/
@property (nonatomic, strong) NSMutableArray *courseAudioArray;
@end
