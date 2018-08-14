//
//  XWAudioPlayView.m
//  XueWen
//
//  Created by Karron Su on 2018/5/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWAudioPlayView.h"
#import "AliyunVodPlayerSDK.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XWAudioInstanceController.h"
#import "XWLastTimeView.h"

@interface XWAudioPlayView () <AliyunVodPlayerDelegate, XWLastTimeViewDelegate>


/** 返回按钮*/
@property (nonatomic, strong) UIButton *backBtn;
/** 课程图片*/
@property (nonatomic, strong) UIImageView *imgView;
/** 学习人数*/
@property (nonatomic, strong) UILabel *countLabel;
/** 视频按钮*/
@property (nonatomic, strong) UIButton *videoBtn;
/** 分享按钮*/
@property (nonatomic, strong) UIButton *shareBtn;
/** 进度条*/
@property (nonatomic, strong) UISlider *progressView;
/** 当前时间*/
@property (nonatomic, strong) UILabel *currentTimeLabel;
/** 总时间*/
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 快退按钮*/
@property (nonatomic, strong) UIButton *leftBtn;
/** 快进按钮*/
@property (nonatomic, strong) UIButton *rightBtn;
/** 播放按钮*/
@property (nonatomic, strong) UIButton *playBtn;
/** 上一节*/
@property (nonatomic, strong) UIButton *upBtn;
/** 下一节*/
@property (nonatomic, strong) UIButton *nextBtn;
/** 是否正在滑动 */
@property (nonatomic, assign) BOOL sliding;

@property (nonatomic, strong) RACDisposable    *disposable;

@property (nonatomic, assign) int timeCount;

/** 提示上次播放的时间*/
@property (nonatomic, strong) XWLastTimeView *lastView;

@property (nonatomic, assign) BOOL isAdd;

@end

@implementation XWAudioPlayView

#pragma mark - Lazy / Getter

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:LoadImage(@"icon_cours_back") forState:UIControlStateNormal];
        @weakify(self)
        [[[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _backBtn;
}

- (XWLastTimeView *)lastView{
    if (!_lastView) {
        _lastView = [[XWLastTimeView alloc] initWithFrame:CGRectMake(self.width, (self.height-50)/2, self.width, 50)];
        _lastView.delegate = self;
    }
    return _lastView;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.backgroundColor = Color(@"#2B3141");
    }
    return _imgView;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont fontWithName:kRegFont size:14];
        _countLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _countLabel;
}

- (UIButton *)videoBtn{
    if (!_videoBtn) {
        _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoBtn setImage:LoadImage(@"icon_video") forState:UIControlStateNormal];
        @weakify(self)
        [[[_videoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoBtnClick)]) {
                [self.delegate videoBtnClick];
            }
        }];
    }
    return _videoBtn;
}

- (UISlider *)progressView{
    if (!_progressView) {
        _progressView = [[UISlider alloc] init];
        [_progressView setThumbImage:LoadImage(@"icon_progress") forState:UIControlStateNormal];
        _progressView.minimumTrackTintColor = Color(@"#000000");
        _progressView.maximumTrackTintColor = Color(@"#c4c4c4");
        _progressView.minimumValue = 0;
        [_progressView addTarget:self action:@selector(slidingAction:) forControlEvents:UIControlEventValueChanged];
        [_progressView addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView addTarget:self action:@selector(touchOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _progressView;
}

- (UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"00:00";
        label.textColor = Color(@"#000000");
        label.font = [UIFont fontWithName:kRegFont size:12];
        label.textAlignment = NSTextAlignmentLeft;
        _currentTimeLabel = label;
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"00:00";
        label.textColor = Color(@"#000000");
        label.font = [UIFont fontWithName:kRegFont size:12];
        label.textAlignment = NSTextAlignmentLeft;
        _totalTimeLabel = label;
    }
    return _totalTimeLabel;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:LoadImage(@"icon_fast_back") forState:UIControlStateNormal];
        @weakify(self)
        [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [[XWAudioInstanceController shareInstance] seekToTime:self.currentTime - 15];
        }];
        _leftBtn = btn;
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:LoadImage(@"icon_fast_forward") forState:UIControlStateNormal];
        @weakify(self)
        [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [[XWAudioInstanceController shareInstance] seekToTime:self.currentTime + 15];
        }];
        _rightBtn = btn;
    }
    return _rightBtn;
}

- (UIButton *)upBtn{
    if (!_upBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:LoadImage(@"icon_audio_left") forState:UIControlStateNormal];
        @weakify(self)
        [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            self.isManual = YES;
            self.isAdd = NO;
            self.playIndex = self.playIndex - 1;
            [self playIndex:self.playIndex];
        }];
        _upBtn = btn;
    }
    return _upBtn;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:LoadImage(@"icon_audio_right") forState:UIControlStateNormal];
        @weakify(self)
        [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            self.isManual = YES;
            self.isAdd = YES;
            self.playIndex = self.playIndex + 1;
            [self playIndex:self.playIndex];
        }];
        _nextBtn = btn;
    }
    return _nextBtn;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:LoadImage(@"icon_max_play") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _playBtn = btn;
    }
    return _playBtn;
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


#pragma mark - lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imgView];
    [self addSubview:self.backBtn];
    [self addSubview:self.countLabel];
    [self addSubview:self.videoBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.progressView];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self .playBtn];
    [self addSubview:self.upBtn];
    [self addSubview:self.nextBtn];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    [self addSubview:self.lastView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(145);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(11);
        make.top.mas_equalTo(self).offset(8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backBtn.mas_right).offset(10);
        make.centerY.mas_equalTo(self.backBtn);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(12);
        make.right.mas_equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(17);
        make.right.mas_equalTo(self.shareBtn.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(21, 14));
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(45);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self).offset(-45);
        make.top.mas_equalTo(self.imgView.mas_bottom);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(6);
        make.centerY.mas_equalTo(self.progressView).multipliedBy(1.01);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-6);
        make.centerY.mas_equalTo(self.progressView).multipliedBy(1.01);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.mas_equalTo(self).offset(5);
    }];
    
    [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).multipliedBy(0.65);
        make.centerY.mas_equalTo(self.playBtn).multipliedBy(1.02);
        make.size.mas_equalTo(CGSizeMake(12, 13));
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).multipliedBy(1.35);
        make.centerY.mas_equalTo(self.playBtn).multipliedBy(1.02);
        make.size.mas_equalTo(CGSizeMake(12, 13));
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).multipliedBy(0.35);
        make.centerY.equalTo(self.playBtn).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 16));
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).multipliedBy(1.65);
        make.centerY.equalTo(self.playBtn).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 16));
    }];
    
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ADUIOPLAYERSTATUS" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        self.status = [XWAudioInstanceController shareInstance].status;
        
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UPDATEPLAYERTIME" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if ([self.model.courseId isEqualToString:[XWAudioInstanceController shareInstance].model.courseId]) {
            AliyunVodPlayer *player = [XWAudioInstanceController shareInstance].player;
            self.totalTime = player.duration;
            self.currentTime = player.currentTime;
            self.status = [XWAudioInstanceController shareInstance].status;
            self.playIndex = [XWAudioInstanceController shareInstance].playIndex;
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"LASTWATCHTIME" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        self.lastView.lastTime = x.object;
        XWWeakSelf
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.lastView.frame = CGRectMake(0, (weakSelf.height-50)/2, weakSelf.width, 50);
            [weakSelf performSelector:@selector(hideLastView) withObject:nil afterDelay:4];
        }];
    }];
    
}

#pragma mark - Custom Methods
- (void)hideLastView{
    XWWeakSelf
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.lastView.frame = CGRectMake(weakSelf.width, (weakSelf.height-50)/2, weakSelf.width, 50);
    }];
}

#pragma mark - XWLastViewDelegate
- (void)continueBtnAction{
    NSTimeInterval time = [self.lastView.lastTime integerValue] / 1000;
    [[XWAudioInstanceController shareInstance] seekToTime:time];
}

#pragma mark - Setter
- (void)setModel:(XWCoursModel *)model{
    _model = model;
    if (_model.total == nil) {
        _model.total = @"0";
    }
    self.countLabel.text = [NSString stringWithFormat:@"%@人听", _model.total];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll]];
    
    if ([_model.courseId isEqualToString:[XWAudioInstanceController shareInstance].model.courseId]) {
        AliyunVodPlayer *player = [XWAudioInstanceController shareInstance].player;
        self.totalTime = player.duration;
        self.currentTime = player.currentTime;
        self.status = [XWAudioInstanceController shareInstance].status;
        self.playIndex = [XWAudioInstanceController shareInstance].playIndex;
    }
}

- (void)setIsHideVideoBtn:(BOOL)isHideVideoBtn{
    _isHideVideoBtn = isHideVideoBtn;
    self.videoBtn.hidden = _isHideVideoBtn;
}

- (void)setTotalTime:(NSTimeInterval)totalTime{
    _totalTime = totalTime;
    self.progressView.maximumValue = totalTime;
    self.totalTimeLabel.text = translateTime(_totalTime);
}

- (void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime = currentTime;
    self.currentTimeLabel.text = translateTime(_currentTime);
    if (!self.sliding) {
        self.progressView.value = currentTime;
    }
    
}

- (void)setStatus:(PlayStatus)status{
    _status = status;
    if (_status == kStatusPlay) {
        [self.playBtn setImage:LoadImage(@"icon_suspend") forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:LoadImage(@"icon_max_play") forState:UIControlStateNormal];
    }
}

#pragma mark - Action
- (void)sliderAction:(UISlider *)slider{
    [self performSelector:@selector(cancelSliding) withObject:nil afterDelay:0.5];  // 延迟0.1s取消滑动，这样进度条不会抖动
    [[XWAudioInstanceController shareInstance] seekToTime:slider.value];
}

- (void)touchOutSide:(UISlider *)slider{
    [self performSelector:@selector(cancelSliding) withObject:nil afterDelay:0.5]; // 延迟0.1s取消滑动，这样进度条不会抖动
    [[XWAudioInstanceController shareInstance] seekToTime:slider.value];
}

- (void)slidingAction:(UISlider *)slider{
    // 正在滑动
    self.sliding = YES;
}

- (void)cancelSliding{
    self.sliding = NO;
}

/** 播放*/
- (void)playBtnAction:(UIButton *)sender{
    if ([XWAudioInstanceController shareInstance].player.playerState == AliyunVodPlayerStatePlay) {
        [[XWAudioInstanceController shareInstance].player pause];
    }else if ([XWAudioInstanceController shareInstance].player.playerState == AliyunVodPlayerStatePause){
        [[XWAudioInstanceController shareInstance].player start];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
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
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isManual = NO;
                [self playIndex:self.playIndex];
            });
        });
    }
    
}

- (void)playIndex:(NSInteger)index{
    self.playIndex = index;
    
    if (0 <= index && index < self.dataArray.count) {
        XWAudioNodeModel *model = self.dataArray[self.playIndex];
        
        if ([self.infoModel.type isEqualToString:@"0"]) { // 该课程未购买
            if ([model.state isEqualToString:@"0"]) { // 当前播放节点不免费
                if (self.isManual) {
                    if (self.isAdd) {
                        self.playIndex += 1;
                        if (self.playIndex == self.dataArray.count) {
                            [MBProgressHUD showTipMessageInWindow:@"已经是免费的最后一节,请先购买课程。"];
                            return;
                        }
                    }else{
                        self.playIndex -= 1;
                        if (self.playIndex <= 0) {
                            [MBProgressHUD showTipMessageInWindow:@"已经是免费的第一节,请先购买课程。"];
                            return;
                        }
                    }
                    [self playIndex:self.playIndex];
                }else{
                    [MBProgressHUD showTipMessageInWindow:@"请先购买课程!"];
                }
                return;
            }
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XWAudioNodeModel *model1 = (XWAudioNodeModel *)obj;
                if (model.nodeID == model1.nodeID) {
                    model1.watchStatus = YES;
                }else{
                    model1.watchStatus = NO;
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [XWAudioInstanceController shareInstance].isContinue = NO;
                [XWAudioInstanceController shareInstance].infoModel = self.infoModel;
                [XWAudioInstanceController shareInstance].model = self.model;
                [XWAudioInstanceController shareInstance].dataArray = self.dataArray;
                [XWAudioInstanceController shareInstance].playIndex = self.playIndex;
                [[XWAudioInstanceController shareInstance] play];
            });
        });
    }else{
        
    }
    
    
}




@end
