//
//  XWAudioPlayView.h
//  XueWen
//
//  Created by Karron Su on 2018/5/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCoursInfoModel.h"
#import "XWPlayerStatus.h"

/** 音频播放代理*/
@protocol XWAudioPlayViewDelegate <NSObject>

/** 点击了视频按钮*/
- (void)videoBtnClick;
/** 分享按钮点击事件*/
- (void)shareBtnClick;



@end

@interface XWAudioPlayView : UIView

@property (nonatomic, assign) BOOL isManual;

@property (nonatomic, weak) id<XWAudioPlayViewDelegate> delegate;

@property (nonatomic, strong) XWCoursModel *model;

@property (nonatomic, strong) XWCoursInfoModel *infoModel;

/** 节点数据用于播放*/
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isHideVideoBtn;

@property (nonatomic, assign) NSTimeInterval totalTime;

@property (nonatomic, assign) NSTimeInterval currentTime;

/** 播放的节点的下标*/
@property (nonatomic, assign) NSInteger playIndex;

/** 播放状态 */
@property (nonatomic, assign) PlayStatus status;


- (void)playIndex:(NSInteger)index;

@end
