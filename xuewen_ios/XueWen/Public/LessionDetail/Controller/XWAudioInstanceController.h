//
//  XWAudioInstanceController.h
//  XueWen
//
//  Created by Karron Su on 2018/5/21.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XWPlayerStatus.h"
#import "XWAudioSmallView.h"
@class AliyunVodPlayerSDK;
@class AliyunVodPlayer;
#import "XWCoursInfoModel.h"

@interface XWAudioInstanceController : UIViewController

+ (instancetype)shareInstance;
+ (UIView *)getPlayerView;
+ (void)playerViewAppear;
+ (void)playerViewDisappear;
+ (BOOL)hasInstance;

/** 阿里播放器*/
@property (nonatomic, strong) AliyunVodPlayer *player;
/** 课程信息*/
@property (nonatomic, strong) XWCoursModel *model;
/** 课程所有信息*/
@property (nonatomic, strong) XWCoursInfoModel *infoModel;
/** 播放状态*/
@property (nonatomic, assign) PlayStatus status;
/** 原始frame*/
@property (nonatomic, assign) CGRect origentFrame;
/** 播放数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 播放节点的下标*/
@property (nonatomic, assign) NSInteger playIndex;
/** 是否接着历史记录播放*/
@property (nonatomic, assign) BOOL isContinue;
/** 播放*/
- (void)play;
/** 暂停*/
- (void)pause;
/** 继续播放*/
- (void)resume;
/** 跳转到指定时间播放*/
- (void)seekToTime:(NSTimeInterval)time;
/** 更新视频播放时间 */
- (void)updateTime:(BOOL)finished;

@end
