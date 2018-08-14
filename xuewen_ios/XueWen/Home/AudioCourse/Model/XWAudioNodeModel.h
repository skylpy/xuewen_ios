//
//  XWAudioNodeModel.h
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 音频课程目录Model*/
@interface XWAudioNodeModel : NSObject

/** 课程音频节点id*/
@property (nonatomic, strong) NSString *nodeID;
/** 课程id*/
@property (nonatomic, strong) NSString *courseID;
/** 课程音频节点标题*/
@property (nonatomic, strong) NSString *nodeTitle;
/** 课程音频节点播放链接*/
@property (nonatomic, strong) NSString *nodeUrl;
/** 课程音频节点排序*/
@property (nonatomic, strong) NSString *nodeSort;
/** 课程音频节点时长*/
@property (nonatomic, strong) NSString *totalTime;
/** 课程音频节点文本*/
@property (nonatomic, strong) NSString *nodeContent;
/** 1视频2音频*/
@property (nonatomic, strong) NSString *type;
/** 课程音频节点添加时间*/
@property (nonatomic, strong) NSString *createTime;
/** 0不免费 1免费*/
@property (nonatomic, strong) NSString *state;
/** 0没有观看 1已观看*/
@property (nonatomic, strong) NSString *play;
/** 1已观看完 0没有观看完*/
@property (nonatomic, strong) NSString *finished;
/** 观看多少秒*/
@property (nonatomic, strong) NSString *watchTime;
/** 观看状态 1 观看中 0 没在观看中*/
@property (nonatomic, assign) BOOL watchStatus;

@end
