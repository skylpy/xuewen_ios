//
//  XWVideoPlayView.m
//  XueWen
//
//  Created by Karron Su on 2018/5/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWVideoPlayView.h"
#import "XWPlayerProgressView.h"
#import "AILoadingView.h"
#import "AliyunVodPlayerSDK.h"
#import "XWPopupWindow.h"
#import "Analytics.h"
#import "XWLastTimeView.h"
#import "XWCustomPopView.h"
#import "ClassTestViewController.h"
#import "QuestionsModel.h"

@interface XWVideoPlayView ()<XWPlayerProgressDelegate, AliyunVodPlayerDelegate, XWLastTimeViewDelegate>

/** 返回按钮*/
@property (nonatomic, strong) UIButton *backBtn;
/** 进度条 */
@property (nonatomic, strong) XWPlayerProgressView *progressView;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton *fullScreen;
/** 当前时间 */
@property (nonatomic, strong) UILabel *currentTimeLabel;
/** 视频总时间 */
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 听课人数*/
@property (nonatomic, strong) UILabel *listenCount;
/** 播放按钮*/
@property (nonatomic, strong) UIButton *playBtn;
/** 封面*/
@property (nonatomic, strong) UIImageView *coverImgView;
/** 是否正在滑动 */
@property (nonatomic, assign) BOOL sliding;
/** 控制器消失时间 默认5s 精确到0.1s */
@property (nonatomic, assign) CGFloat disappearTime;
@property (nonatomic, assign) CGFloat timing;
@property (nonatomic, strong) RACDisposable    *disposable;

/** 加载动画 */
@property (nonatomic, strong) AILoadingView *loadingView;
/** 阿里播放器*/
@property (nonatomic, strong) AliyunVodPlayer *player;

@property (nonatomic, strong) RACDisposable    *disposable1;

@property (nonatomic, assign) int timeCount;

//控制弹窗
@property (nonatomic, assign) BOOL isShowPop;

@property (nonatomic, strong) UIView *playView;

@property (nonatomic, strong) XWAudioNodeModel *oldModel;

/** 上次播放时间*/
@property (nonatomic, strong) XWLastTimeView *lastView;
/** 统计累加时间*/
@property (nonatomic, assign) NSTimeInterval oldTime;



@end

@implementation XWVideoPlayView

#pragma mark - Lazy / Getter

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:LoadImage(@"icon_cours_back") forState:UIControlStateNormal];
        @weakify(self)
        [[[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.isFullScreen) {
                [self startTiming];
                self.isFullScreen = !self.isFullScreen;
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
    }
    return _backBtn;
}

- (XWLastTimeView *)lastView {
    if (!_lastView) {
        _lastView = [[XWLastTimeView alloc] initWithFrame:CGRectMake(self.bounds.size.width, (self.bounds.size.height-50)/2, self.bounds.size.width, 50)];
        _lastView.delegate = self;
        _lastView.hidden = YES;
    }
    return _lastView;
}

- (UIView *)playView{
    if (!_playView) {
        _playView = self.player.playerView;
        
    }
    return _playView;
}

- (AliyunVodPlayer *)player{
    if (!_player) {
        _player = [[AliyunVodPlayer alloc] init];
        [_player setDisplayMode:AliyunVodPlayerDisplayModeFit];
        _player.autoPlay = YES;
        _player.quality = 0;
        _player.circlePlay = NO;
        _player.delegate = self;
    }
    return _player;
}

- (AILoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [AILoadingView new];
        _loadingView.strokeColor = [UIColor whiteColor];
        _loadingView.alpha = 0.0;
    }
    return _loadingView;
}

- (XWPlayerProgressView *)progressView{
    if (!_progressView) {
        _progressView = [XWPlayerProgressView new];
        _progressView.delegate = self;
    }
    return _progressView;
}

- (UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];;
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textAlignment = 1;
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont fontWithName:kRegFont size:12];
    }
    return _currentTimeLabel;
}
- (UILabel  *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.textAlignment = 1;
        _totalTimeLabel.font = [UIFont fontWithName:kRegFont size:12];
        _totalTimeLabel.textColor = [UIColor whiteColor];
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreen{
    if (!_fullScreen) {
        _fullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreen setImage:LoadImage(@"icon_audio_fullscreen") forState:UIControlStateNormal];
        @weakify(self)
        [[[_fullScreen rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self startTiming];
            self.isFullScreen = !self.isFullScreen;
        }];
    }
    return _fullScreen;
}

- (UIButton *)audioBtn{
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioBtn setImage:LoadImage(@"icon_audio") forState:UIControlStateNormal];
        @weakify(self)
        [[[_audioBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self startTiming];
            [self.player pause];
            if (self.delegate && [self.delegate respondsToSelector:@selector(audioBtnClick)]) {
                [self.delegate audioBtnClick];
            }
        }];
    }
    return _audioBtn;
}

- (UILabel *)listenCount{
    if (!_listenCount) {
        _listenCount = [[UILabel alloc] init];
        _listenCount.textColor = [UIColor whiteColor];
        _listenCount.font = [UIFont fontWithName:kRegFont size:14];
        _listenCount.textAlignment = NSTextAlignmentLeft;
    }
    return _listenCount;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:LoadImage(@"icon_audio_play") forState:UIControlStateNormal];
        @weakify(self)
        [[[_playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self startTiming];
            if (self.player.playerState == AliyunVodPlayerStatePlay) {
                [self.player pause];
            }else if (self.player.playerState == AliyunVodPlayerStatePause){
                /** 开始播放视频,关闭音频*/
                [self postNotificationWithName:@"VIDEOSTARTPLAY" object:nil];
                [self.player resume];
            }else{
                XWWeakSelf
                [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    /** 查找哪些是看完的,接着之前的播放进度开始播放*/
                    XWAudioNodeModel *model = (XWAudioNodeModel *)obj;
                    if ([model.play isEqualToString:@"0"]) {
                        weakSelf.playIndex = idx;
                        *stop = YES;
                    }else{
                        if ([model.finished isEqualToString:@"0"]) {
                            weakSelf.playIndex = idx;
                            *stop = YES;
                        }
                    }
                    if ([weakSelf.infoModel.type isEqualToString:@"0"]) {
                        weakSelf.playIndex = 0;
                    }
                }];
                [self playIndex:self.playIndex];
            }
            
        }];
    }
    return _playBtn;
}

- (UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImgView;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:LoadImage(@"icon_cours_share") forState:UIControlStateNormal];
        @weakify(self)
        [[[_shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(shareBtnClick)]) {
                [self.delegate shareBtnClick];
            }
        }];
    }
    return _shareBtn;
}

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
        _disappearTime = 2.0f;
        
    }
    return self;
}

- (void)drawUI{
    self.backgroundColor = [UIColor clearColor];
    self.isShowPop = YES;
    [self addSubview:self.playView];
    [self addSubview:self.coverImgView];
    [self addSubview:self.backBtn];
    [self addSubview:self.listenCount];
    [self addSubview:self.audioBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.playBtn];
    [self addSubview:self.fullScreen];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.progressView];
    [self addSubview:self.loadingView];
    [self addSubview:self.lastView];
    
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self).offset(8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.listenCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backBtn.mas_right).offset(10);
        make.centerY.mas_equalTo(self.backBtn);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.right.mas_equalTo(self).offset(-15);
        make.top.mas_equalTo(self).offset(13);
    }];
    
    [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.right.mas_equalTo(self.shareBtn.mas_left).offset(-10);
        make.top.mas_equalTo(self).offset(13);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(41, 41));
        make.center.mas_equalTo(self);
    }];
    
    [self.fullScreen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.mas_equalTo(self).offset(-16);
        make.bottom.mas_equalTo(self).offset(-18);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullScreen.mas_left).offset(-17);
        make.centerY.mas_equalTo(self.fullScreen);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(25);
        make.centerY.mas_equalTo(self.totalTimeLabel);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(60);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self.totalTimeLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.totalTimeLabel);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self addNotificationWithName:UIApplicationDidEnterBackgroundNotification selector:@selector(stop)];
    [self addNotificationWithName:NotiExamAction selector:@selector(examActionPausePlayer)];
    
    [self addNotificationWithName:@"videoEND" selector:@selector(updata)];
}

- (void)updata{
    [self updateTime:NO];
}

- (void)dealloc{

    [self.player releasePlayer];
    [self removeNotification];
    
}


#pragma mark - Setter
- (void)setModel:(XWCoursModel *)model{
    _model = model;
    if (_model.total == nil) {
        _model.total = @"0";
    }
    self.listenCount.text = [NSString stringWithFormat:@"%@人学习", _model.total];
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll] placeholderImage:DefaultImage];
}

- (void)setIsHideAudioBtn:(BOOL)isHideAudioBtn{
    _isHideAudioBtn = isHideAudioBtn;
    self.audioBtn.hidden = _isHideAudioBtn;
}

- (void)setLoadTime:(NSTimeInterval)loadTime{
    _loadTime = loadTime;
    if (_totalTime >= 0) {
        _progressView.bufferProgress = _loadTime * 1.0 / _totalTime;
    }
}

- (void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime = currentTime;
    self.currentTimeLabel.text = translateTime(_currentTime);
    if (_totalTime >= 0 && self.progressView.isUserInteractionEnabled && !_sliding) { // 不在滑动状态才设置进度
        _progressView.playProgress = _currentTime * 1.0 / _totalTime;
    }
    
}

- (void)setTotalTime:(NSTimeInterval)totalTime{
    _totalTime = totalTime;
    self.totalTimeLabel.text = translateTime(_totalTime);
}

- (void)setStatus:(PlayStatus)status{
    if (_status != status) {
        _status = status;
        // 状态变化时显示控制器
        [self appear];
        [[UIApplication sharedApplication] setIdleTimerDisabled:status == kStatusPlay]; // 播放视频时设置屏幕常亮
        if (_status == kStatusPlay) {
            [self startTiming];
            self.coverImgView.hidden = YES;
            self.playBtn.selected = YES;
            [self.playBtn setImage:LoadImage(@"icon_audio_stop") forState:UIControlStateNormal];
        }else{
            self.playBtn.selected = NO;
            [self.playBtn setImage:LoadImage(@"icon_audio_play") forState:UIControlStateNormal];
        }
        
        [self getTime:status == kStatusPlay];
    }
}

- (void)setIsFullScreen:(BOOL)isFullScreen{
    _isFullScreen = isFullScreen;
    if (_isFullScreen) {
        [self.fullScreen setImage:LoadImage(@"icoSmallScreen") forState:UIControlStateNormal];
    }else{
        [self.fullScreen setImage:LoadImage(@"icon_audio_fullscreen") forState:UIControlStateNormal];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenAction:)]) {
        [self.delegate fullScreenAction:_isFullScreen];
    }
}

#pragma mark - XWPlayerProgressDelegate
- (void)setProgress:(CGFloat)progress{
    self.sliding = NO;
    [self startTiming];
    [self.player seekToTime:_totalTime * progress];
    
}

- (void)slidingWithProgress:(CGFloat)progress{
    [self startTiming];
    self.sliding = YES;
}

/** 触摸屏幕显示控制界面 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self appear];
}

#pragma mark - Custom Methods

/** 缓冲动画*/
- (void)startAnimation{
    self.playBtn.hidden = YES;
    self.loadingView.alpha = 1.0;
    [self.loadingView starAnimation];
}

/** 结束缓冲动画*/
- (void)stopAnimation{
    self.playBtn.hidden = NO;
    self.loadingView.alpha = 0.0;
    [self.loadingView stopAnimation];
}

/** 开始计时 */
- (void)startTiming{
    _timing = _disappearTime * 10;
    if (!self.disposable) {
        RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault];
        @weakify(self)
        [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self)
            self.disposable = [scheduler after:[NSDate dateWithTimeIntervalSinceNow:0] repeatingEvery:0.1 withLeeway:0.0 schedule:^{
                [subscriber sendNext:nil];
            }];
            return self.disposable;
        }] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if (self.timing-- <= 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self disappear];
                });
                
            }
        }];
    }
}

/** 停止计时 */
- (void)stopTiming{
    [self.disposable dispose];
    self.disposable = nil;
}

/** 消失 */
- (void)disappear{
    if (_status == kStatusPlay) {
        XWWeakSelf
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.playBtn.alpha      = 0.0;
            weakSelf.fullScreen.alpha       = 0.0;
            weakSelf.currentTimeLabel.alpha = 0.0;
            weakSelf.progressView.alpha     = 0.0;
            weakSelf.totalTimeLabel.alpha   = 0.0;
            weakSelf.listenCount.alpha       = 0.0;
            weakSelf.audioBtn.alpha      = 0.0;
            weakSelf.shareBtn.alpha = 0.0;
        }];
    }
    
    [self stopTiming];
}

/** 出现 */
- (void)appear{
    if (_status == kStatusPlay) {// 播放状态时才隐藏控制器
        [self startTiming];
    }
    XWWeakSelf
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.playBtn.alpha      = 1.0;
        weakSelf.fullScreen.alpha       = 1.0;
        weakSelf.currentTimeLabel.alpha = 1.0;
        weakSelf.progressView.alpha     = 1.0;
        weakSelf.totalTimeLabel.alpha   = 1.0;
        weakSelf.listenCount.alpha       = 1.0;
        weakSelf.audioBtn.alpha      = 1.0;
        weakSelf.shareBtn.alpha = 1.0;
    }];
}

- (void)playIndex:(NSInteger)index{
    /** 开始播放视频,关闭音频*/
    [self postNotificationWithName:@"VIDEOSTARTPLAY" object:nil];
    self.playIndex = index;
    if (0 <= index && index < self.dataArray.count) {
        XWAudioNodeModel *model = self.dataArray[index];
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XWAudioNodeModel *model1 = (XWAudioNodeModel *)obj;
            if (model.nodeID == model1.nodeID) {
                model1.watchStatus = YES;
            }else{
                model1.watchStatus = NO;
            }
        }];
        if (![self.oldModel.nodeID isEqualToString:model.nodeID]) {
            
            if (![self.oldModel.nodeID isEqualToString:@""] && self.oldModel.nodeID != nil) {
                [self updateTime:NO];
            }
            if ([self.infoModel.type isEqualToString:@"0"]) { // 课程未购买
                if ([model.state isEqualToString:@"0"]) { // 当前播放节点不免费
                    [MBProgressHUD showTipMessageInWindow:@"请先购买课程!"];
                    return;
                }
            }
            [self startAnimation];
            
            XWWeakSelf
            [XWNetworking getPlayAuthWithVideoID:model.nodeUrl completionBlock:^(NSString *playAuth) {
//                [weakSelf.player stop];
                weakSelf.oldModel = model;
                [weakSelf.player prepareWithVid:model.nodeUrl playAuth:playAuth];
            } failure:^(NSString *errorinfo) {
                [self stopAnimation];
                [MBProgressHUD showTipMessageInWindow:errorinfo];
            }];
        }else{
            if (self.player.playerState == AliyunVodPlayerStatePlay) {
                [self.player pause];
            }else if (self.player.playerState == AliyunVodPlayerStatePause){
                [self.player resume];
            }else{
                [self startAnimation];
                XWWeakSelf
                [XWNetworking getPlayAuthWithVideoID:model.nodeUrl completionBlock:^(NSString *playAuth) {
                    [weakSelf.player prepareWithVid:model.nodeUrl playAuth:playAuth];
                } failure:^(NSString *errorinfo) {
                    [self stopAnimation];
                    [MBProgressHUD showTipMessageInWindow:errorinfo];
                }];
            }
        }
        
    }
}

/** 添加课程观看记录 */
- (void)addCourseViewRecoder{
    if ([self.model.amount isEqualToString:@"0.00"] && ![self.model.watched isEqualToString:@"1"]) {
        [XWNetworking addUserWatchRecordWithCourseID:self.model.courseId];
        
    }
    /** 添加播放器*/
    [XWHttpTool postCouresNodePlayWithNodeId:self.oldModel.nodeID];
    
}

/** 在播放时获取视频时间 */
- (void)getTime:(BOOL)flag{
    if (flag && _status == kStatusPlay) {
        if (!self.disposable1) {
            RACScheduler *scheduler = [RACScheduler mainThreadScheduler];
            @weakify(self)
            [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                self.disposable1 = [scheduler after:[NSDate dateWithTimeIntervalSinceNow:0] repeatingEvery:0.1 withLeeway:0.0 schedule:^{
                    [subscriber sendNext:nil];
                }];
                return self.disposable1;
            }] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
//                if ([self.infoModel.type isEqualToString:@"0"]) {
//                    if (self.player.currentTime >= 60) {
//                        [self.player stop];
//                        self.currentTime = 0;
//                        [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"请先购买课程" buttonTitle:@"好的" buttonBlock:nil];
//                    }
//                }
                self.totalTime = self.player.duration;
                self.currentTime = self.player.currentTime;
                self.loadTime = self.player.loadedTime;
                self.timeCount ++;
                if (self.timeCount > 600) {
                    [self updateTime:NO];
                    self.timeCount = 0;
                }
                
            }];
            
        }
        
    }else{
        
        if (self.disposable1) {
            [self.disposable1 dispose];
            self.disposable1 = nil;
        }
    }
}

/** 更新视频播放时间 */
- (void)updateTime:(BOOL)finished{
    
    /** 如果是已观看完的,参数传入1*/
    if ([self.oldModel.finished isEqualToString:@"1"]) {
        finished = YES;
    }else{
        /** 如果观看时间大于80%,就算观看完*/
        if (self.player.currentTime >= self.player.duration*0.8) {
            finished = YES;
        }else{
            finished = NO;
        }
    }
    
    @weakify(self)
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        [XWNetworking  updateNewUserViewingRecordWithCourseID:self.oldModel.courseID NodeID:self.oldModel.nodeID watchTime:self.player.currentTime finished:finished completionBlock:^(NSArray<RecordModel *> *questions) {
            NSLog(@"播放时间更新成功");
            if (questions.count > 0) {
                RecordModel * rmodel = questions[0];
                
                NSString * testID = rmodel.id;
                if ( self.currentTime * 1.0 / self.totalTime >= 0.8 && self.isShowPop) {
                    
                    self.isShowPop = NO;
                    [XWNetworking getQuestionsListWithTestID:testID CompletionBlock:^(NSArray<QuestionsModel *> *questions) {
                        
                        [[XWCustomPopView shareCustomNew] showFoemSuperView:[UIApplication sharedApplication].keyWindow withTitle:rmodel.title withExamClick:^{
                            
                            [[UIViewController getCurrentVC].navigationController pushViewController:[[ClassTestViewController alloc] initWithQuestions:questions withTest:YES withAtid:rmodel.a_t_id]  animated:YES];
                            NSLog(@"考试");
                        }];
                    }];
                }
            }
            
            [subscriber sendNext:@"1"];
        }];
        
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        NSInteger time = self.player.currentTime - self.oldTime;

        if (time < 0) {
            time = self.player.currentTime;
        }

        NSLog(@"time is %ld", time);
        [XWHttpTool postStudyTimeWithTime:time userID:[XWInstance shareInstance].userInfo.oid success:^{
            self.oldTime = self.player.currentTime;
            NSLog(@"累加时间成功");
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            
        }];
        return nil;
    }];
    [self rac_liftSelector:@selector(completedRequest1:request2:) withSignalsFromArray:@[signal1, signal2]];

}

- (void)completedRequest1:(NSString *)data1 request2:(NSString *)data2 {
    if ([data1 isEqualToString:@"1"] && [data2 isEqualToString:@"1"] ) {
        NSLog(@"更新成功");
        
    }else{
        NSLog(@"更新失败");
    }

}

/** 5s后隐藏*/
- (void)hideLastView{
    XWWeakSelf
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.lastView.frame = CGRectMake(self.bounds.size.width, (self.bounds.size.height-50)/2, self.bounds.size.width, 50);
    } completion:^(BOOL finished) {
        weakSelf.lastView.hidden = YES;
    }];
}

/** 程序退到后台,停止播放*/
- (void)stop{
    [self.player pause];
}

/** 去考试时,暂停视频播放*/
- (void)examActionPausePlayer{
    [self.player pause];
}

#pragma mark - XWLastViewDelegate
- (void)continueBtnAction{
    [self startTiming];
    [self.player seekToTime:[self.oldModel.watchTime integerValue] / 1000];
}

#pragma mark- AliyunVodPlayerDelegate
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event {
    [self stopAnimation];
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:{
            //播放准备完成时触发
            /** 添加播放记录*/
            [self addCourseViewRecoder];
            /** 友盟统计*/
            [Analytics event:EventPlayCourse attributes:@{@"CourseID":(self.model.courseId.length > 0) ? self.model.courseId : @"",@"LessionID":(self.oldModel.nodeID.length > 0) ? self.oldModel.nodeID : @""}];
            /** 发送一个通知,告知当前播放的节点上次观看记录*/
            /*
            if ([self.oldModel.play isEqualToString:@"1"] && ![self.oldModel.finished isEqualToString:@"1"]) {
                
                if ([self.oldModel.watchTime integerValue] < 10000) {
                    return;
                }
                self.lastView.lastTime = self.oldModel.watchTime;
                XWWeakSelf
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.lastView.hidden = NO;
                    weakSelf.lastView.frame = CGRectMake(0, (self.bounds.size.height-50)/2, self.bounds.size.width, 50);
                    [weakSelf performSelector:@selector(hideLastView) withObject:nil afterDelay:4];
                } completion:^(BOOL finished) {
                    
                }];
            }
            */
            NSTimeInterval time = [self.oldModel.watchTime integerValue] / 1000;
            if ([self.oldModel.play isEqualToString:@"1"]) { // 如果已观看
                if (self.player.duration * 0.8 > time) { // 如果观看时间大于总时长的80%,就重头开始播放
                    [self.player seekToTime:time];
                }
            }
            
        }break;
        case AliyunVodPlayerEventPlay:{
            //暂停后恢复播放时触发
            self.status = kStatusPlay;
        }break;
        case AliyunVodPlayerEventFirstFrame:{
            
            //播放视频首帧显示出来时触发
            self.status = kStatusPlay;
            
        }break;
        case AliyunVodPlayerEventPause:{
            //视频暂停时触发
            self.status = kStatusPause;
            [self updateTime:NO];
        }break;
        case AliyunVodPlayerEventStop:{
            //主动使用stop接口时触发
            self.status = kStatusStop;
//            [self updateTime:NO];
        }break;
        case AliyunVodPlayerEventFinish:{
            //视频正常播放完成时触发
            self.status = kStatusStop;
//            [self updateTime:YES];
            self.playIndex += 1;
            [self playIndex:self.playIndex];
            
        }break;
        case AliyunVodPlayerEventBeginLoading:{
            //视频开始载入时触发
            self.status = kStatusLoading;
            
        }break;
        case AliyunVodPlayerEventEndLoading:{
        
            //视频加载完成时触发
            if (self.player.playerState == AliyunVodPlayerStatePlay) {
                self.status = kStatusPlay;
            }
        }break;
        case AliyunVodPlayerEventSeekDone:{
            //视频Seek完成时触发
            if (self.player.playerState == AliyunVodPlayerStatePlay) {
                self.oldTime = self.player.currentTime;
                self.status = kStatusPlay;
            }
        }break;
        default:
            break;
    }
    
    /** 发送通知,以更改"开始学习"按钮的显示或者隐藏*/
    [self postNotificationWithName:@"HideLearnBtn" object:@(self.status)];
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel{
    NSLog(@"error %@",errorModel.errorMsg);
    [self stopAnimation];
}




@end
