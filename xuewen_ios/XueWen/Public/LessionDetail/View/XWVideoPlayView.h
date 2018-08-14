//
//  XWVideoPlayView.h
//  XueWen
//
//  Created by Karron Su on 2018/5/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCoursInfoModel.h"
#import "XWPlayerStatus.h"

@protocol XWVideoPlayViewDelegate <NSObject>

/** 音频按钮点击事件*/
- (void)audioBtnClick;
/** 全屏事件*/
- (void)fullScreenAction:(BOOL)isFullScreen;
/** 分享按钮点击事件*/
- (void)shareBtnClick;

@end

@interface XWVideoPlayView : UIView

@property (nonatomic, weak) id<XWVideoPlayViewDelegate> delegate;

@property (nonatomic, strong) XWCoursModel *model;

@property (nonatomic, strong) XWCoursInfoModel *infoModel;

@property (nonatomic, assign) BOOL isHideAudioBtn;
/** 音频按钮*/
@property (nonatomic, strong) UIButton *audioBtn;
/** 分享按钮*/
@property (nonatomic, strong) UIButton *shareBtn;
/** 是否是全屏*/
@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, assign) NSTimeInterval totalTime;

@property (nonatomic, assign) NSTimeInterval currentTime;

@property (nonatomic, assign) NSTimeInterval loadTime;

@property (nonatomic, assign) BOOL isPlay;

/** 播放状态 */
@property (nonatomic, assign)PlayStatus status;

/** 节点数据用于播放*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 播放的节点的下标*/
@property (nonatomic, assign) NSInteger playIndex;

- (void)playIndex:(NSInteger)index;


@end
