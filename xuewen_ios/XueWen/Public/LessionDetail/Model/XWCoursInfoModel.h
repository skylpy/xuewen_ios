//
//  XWCoursInfoModel.h
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWCoursModel.h"
#import "XWAudioNodeModel.h"

/** 课程详情Model*/
@interface XWCoursInfoModel : NSObject

/** 课程信息*/
@property (nonatomic, strong) XWCoursModel *course;
/** 1已购买 0未购买*/
@property (nonatomic, strong) NSString *type;
/** 课程视频节点*/
@property (nonatomic, strong) NSMutableArray *courseAudioArray;
/** 优惠券*/
@property (nonatomic, strong) NSString *coupon;
/** 1视频 2音频 3视频和音频*/
@property (nonatomic, strong) NSString *audioType;
/** 课程音频节点*/
@property (nonatomic, strong) NSMutableArray *nodeAudioArray;
/** 分享链接*/
@property (nonatomic, strong) NSString *shareUrl;
/** 分享朋友圈标题*/
@property (nonatomic, strong) NSString *friendCircleTitle;
/** 分享对话标题*/
@property (nonatomic, strong) NSString *shareTitle;
/** 分享对话内容*/
@property (nonatomic, strong) NSString *shareContent;

@end
