//
//  XWAudioInstanceController.m
//  XueWen
//
//  Created by Karron Su on 2018/5/21.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWAudioInstanceController.h"
#import "XWAudioNodeModel.h"
#import "XWNetworking.h"
#import "AliyunVodPlayerSDK.h"
#import "XWPopupWindow.h"
#import "Analytics.h"
#import "XWCustomPopView.h"
#import "ClassTestViewController.h"
#import "QuestionsModel.h"
#import <AVFoundation/AVFoundation.h>

static XWAudioInstanceController *instance = nil;

@interface XWAudioInstanceController () <AliyunVodPlayerDelegate, XWAudioSmallViewDelegate>

@property (nonatomic, strong) XWAudioNodeModel *oldModel;

@property (nonatomic, strong) XWAudioSmallView *playerView;

@property (nonatomic, strong) RACDisposable *disposable;

@property (nonatomic, assign) int timeCount;

@property (nonatomic, assign) NSTimeInterval oldTime;

@property (nonatomic, strong) AVAudioPlayer *avPlayer;

@end

@implementation XWAudioInstanceController

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark- 锁屏界面控制回调
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:{
                //播放
                [self play];
                [dict setObject:@(1.0) forKey:MPNowPlayingInfoPropertyPlaybackRate];
                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
                break;
            }
            case UIEventSubtypeRemoteControlPause:{
                self.oldModel.watchTime = [NSString stringWithFormat:@"%.f", self.player.currentTime*1000];
                //暂停
                [self.player stop];
                [dict setObject:@(self.player.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经过时间
                [dict setObject:@(0.0) forKey:MPNowPlayingInfoPropertyPlaybackRate];
                
                
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:{
                //下一首
                self.playIndex ++;
                if (self.playIndex >= self.dataArray.count-1) {
                    self.playIndex = self.dataArray.count-1;
                }
                [self play];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:{
                //上一首
                self.playIndex--;
                if (self.playIndex<=0) {
                    self.playIndex = 0;
                }
                [self play];
                break;
            }
            
            default:
                break;
        }
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}



#pragma mark - Getter / Lazy

- (AliyunVodPlayer *)player{
    if (!_player) {
        _player = [AliyunVodPlayer new];
        // 配置播放器
        [_player setDisplayMode:AliyunVodPlayerDisplayModeFit];
        _player.autoPlay = YES;
        _player.quality = 0; // 清晰度
        _player.circlePlay = NO; // 循环播放
        _player.delegate = self;
        _player.printLog = NO; // 是否打印工作日志
    }
    return _player;
}

- (XWAudioSmallView *)playerView{
    if (!_playerView) {
        _playerView = [XWAudioSmallView new];
        _playerView.delegate = self;
    }
    return _playerView;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            @weakify(instance)
            [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"VIDEOSTARTPLAY" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
                @strongify(instance)
                [instance pause];
            }];
        }
    });
    
    return instance;
}

+ (instancetype)shareInstance{
    return [[self alloc] init];
}

#pragma mark - Custom Methods
/** 播放*/
- (void)play{
    
    if (self.playIndex >= 0 && self.playIndex < self.dataArray.count) {
        XWAudioNodeModel *model = self.dataArray[self.playIndex];
        if (![self.oldModel.nodeID isEqualToString:model.nodeID]) {
            if (![self.oldModel.nodeID isEqualToString:@""] && self.oldModel.nodeID != nil) {
                [self updateTime:NO];
            }
            
            self.oldModel = model;
            
            if ([self.infoModel.type isEqualToString:@"0"]) { // 该课程未购买
                if ([model.state isEqualToString:@"0"]) { // 当前播放节点不免费
                    return;
                }
            }
            [self.player prepareWithURL:[NSURL URLWithString:model.nodeUrl]];
        }else{
            if (self.player.playerState == AliyunVodPlayerStatePlay) {
                [self pause];
            }else if (self.player.playerState == AliyunVodPlayerStatePause){
                [self resume];
            }else{
                [self.player prepareWithURL:[NSURL URLWithString:model.nodeUrl]];
            }
        }
        
    }
}

/** 暂停*/
- (void)pause{
    [self.player pause];
}

/** 暂停之后继续播放*/
- (void)resume{
    [self.player resume];
}

/** 跳转到指定时间播放*/
- (void)seekToTime:(NSTimeInterval)time{
    if (time < 0) {
        time = 0;
    }else if (time > self.self.player.duration){
        time = self.player.duration;
    }
    [self.player seekToTime:time];
}

/** 更新视频播放时间 */
- (void)updateTime:(BOOL)finished{
    
    if ([self.oldModel.finished isEqualToString:@"1"]) {
        finished = YES;
    }else{
        if (self.player.currentTime >= self.player.duration*0.8) {
            finished = YES;
        }else{
            finished = NO;
        }
    }
    
    @weakify(self)
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        NSLog(@"currentTime is %.f, nodeID is %@", self.player.currentTime, self.oldModel.nodeID);
        [XWNetworking  updateNewUserViewingRecordWithCourseID:self.oldModel.courseID NodeID:self.oldModel.nodeID watchTime:self.player.currentTime finished:finished completionBlock:^(NSArray<RecordModel *> *questions) {
            NSLog(@"播放时间更新成功");
            
            if (questions.count > 0) {
                RecordModel * rmodel = questions[0];
                
                NSString * testID = rmodel.id;
                [XWNetworking getQuestionsListWithTestID:testID CompletionBlock:^(NSArray<QuestionsModel *> *questions) {
                    
                    [[XWCustomPopView shareCustomNew] showFoemSuperView:[UIApplication sharedApplication].keyWindow withTitle:rmodel.title withExamClick:^{
                        
                        [[UIViewController getCurrentVC].navigationController pushViewController:[[ClassTestViewController alloc] initWithQuestions:questions withTest:YES withAtid:rmodel.a_t_id]  animated:YES];
                        NSLog(@"考试");
                    }];
                }];
                
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
        NSLog(@" time is %ld", time);
        [XWHttpTool postStudyTimeWithTime:time userID:[XWInstance shareInstance].userInfo.oid success:^{
            self.oldTime = self.player.currentTime;
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

/** 添加课程观看记录 */
- (void)addCourseViewRecoder{
    if ([self.model.amount isEqualToString:@"0.00"] && ![self.model.watched isEqualToString:@"1"]) {
        [XWNetworking addUserWatchRecordWithCourseID:self.model.courseId];
    }
    
    /** 添加播放量*/
    [XWHttpTool postCouresNodePlayWithNodeId:self.oldModel.nodeID];
}

#pragma mark - PlayerView Methods

+ (UIView *)getPlayerView{
    if (instance) {
        XWAudioSmallView *playerView = instance.playerView;
        [playerView removeFromSuperview];
        playerView.userInteractionEnabled = YES;
        [playerView appearWithAnimation:NO];
        return playerView;
    }
    return nil;
}

+ (void)playerViewAppear{
    if (instance) {
        [instance.playerView appearWithAnimation:YES];
    }
}
+ (void)playerViewDisappear{
    
    if (instance) {
        [instance.playerView disappear];
    }
}

+ (BOOL)hasInstance{
    if (instance.player.playerState == AliyunVodPlayerStatePlay || instance.player.playerState == AliyunVodPlayerStatePause) {
        return YES;
    }else {
        return NO;
    }
    
}

#pragma mark - Setter
- (void)setStatus:(PlayStatus)status{
    _status = status;
    if (_status == kStatusPlay) {
        [self postNotificationWithName:@"showAudioPlayerView" object:nil];
        [self.playerView.playBtn setImage:LoadImage(@"icon_audio_stop") forState:UIControlStateNormal];
    }else{
        [self.playerView.playBtn setImage:LoadImage(@"icon_audio_play") forState:UIControlStateNormal];
    }
    
    [self.playerView.headImgView sd_setImageWithURL:[NSURL URLWithString:self.model.tchOrgPhotoAll]];
    self.playerView.titleLabel.text = self.oldModel.nodeTitle;
    [self getTime:status == kStatusPlay];
    switch (status) {
        case kStatusStop:{
            
            [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
            
            [self resignFirstResponder];
        }break;
        case kStatusLoading:
        case kStatusPlay:{
            // 设置锁屏信息
            if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                [dict setObject:self.oldModel.nodeTitle forKey:MPMediaItemPropertyTitle];
                // 歌手
                [dict setObject:self.model.tchOrg forKey:MPMediaItemPropertyArtist];
                // 标题
                [dict setObject:self.model.courseName forKey:MPMediaItemPropertyAlbumTitle];
                // 总时长
                [dict setObject:@(self.player.duration) forKey:MPMediaItemPropertyPlaybackDuration];
                [dict setObject:@(self.player.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
                
                MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.tchOrgPhotoAll]]]];
                [dict setObject:@(MPNowPlayingInfoMediaTypeAudio) forKey:MPNowPlayingInfoPropertyMediaType];
                [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
                
                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
            }
            
            [self becomeFirstResponder];
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        }break;
        case kStatusPause:{
            [self updateTime:NO];
            
        }break;
        default:
            break;
    }
}

/** 在播放时获取视频时间 */
- (void)getTime:(BOOL)flag{
    if (flag && _status == kStatusPlay) {
        if (!self.disposable) {
            RACScheduler *scheduler = [RACScheduler mainThreadScheduler];
            @weakify(self)
            [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                self.disposable = [scheduler after:[NSDate dateWithTimeIntervalSinceNow:0] repeatingEvery:0.1 withLeeway:0.0 schedule:^{
                    [subscriber sendNext:nil];
                }];
                return self.disposable;
            }] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                self.timeCount ++;
                
                /** 发送通知实时修改显示时间*/
                [self postNotificationWithName:@"UPDATEPLAYERTIME" object:nil];
                if (self.timeCount > 600) {
                    [self updateTime:NO];
                    self.timeCount = 0;
                }
            }];
        }
        
    }else{
        
        if (self.disposable) {
            [self.disposable dispose];
            self.disposable = nil;
        }
    }
}

#pragma mark - XWAudioSmallViewDelegate
- (void)playAction{
    if (self.player.playerState == AliyunVodPlayerStatePlay){
        [self.player pause];
    }else if (self.player.playerState == AliyunVodPlayerStatePause){
        [self.player start];
    }else{
        [self play];
    }
}

- (void)closeAction{
    [self.player stop];
    [self updateTime:NO];
    
    [self.player releasePlayer];
    if (self.disposable) {
        [self.disposable dispose];
        self.disposable = nil;
    }
    self.dataArray = nil;
    self.model = nil;
    self.infoModel = nil;
    self.playIndex = 0;
    self.oldModel = nil;
    [self.playerView removeFromSuperview];
}


#pragma mark- AliyunVodPlayerDelegate
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event {
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:{
            //播放准备完成时触发
            /** 添加观看记录*/
            [self addCourseViewRecoder];
            /** 友盟统计*/
            [Analytics event:EventPlayCourse attributes:@{@"CourseID":(self.model.courseId.length > 0) ? self.model.courseId : @"",@"LessionID":(self.oldModel.nodeID.length > 0) ? self.oldModel.nodeID : @""}];
            /** 上次观看时间*/
            /*
            if ([self.oldModel.play isEqualToString:@"1"] && ![self.oldModel.finished isEqualToString:@"1"]) {
                // 大于10s才显示上次播放时间
                if ([self.oldModel.watchTime integerValue] < 10000) {
                    return;
                }
                [self postNotificationWithName:@"LASTWATCHTIME" object:self.oldModel.watchTime];
            }
            if (self.isContinue) {
                [self.player seekToTime:[self.oldModel.watchTime integerValue] / 1000];
            }
            */
            
            NSLog(@"watchTime is %@, nodeID is %@", self.oldModel.watchTime, self.oldModel.nodeID);
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
        }break;
        case AliyunVodPlayerEventStop:{
            //主动使用stop接口时触发
//            [self updateTime:NO];
            self.status = kStatusStop;
            
        }break;
        case AliyunVodPlayerEventFinish:{
            //视频正常播放完成时触发
            self.status = kStatusStop;
            self.playIndex += 1;
            [self play];
            

        }break;
        case AliyunVodPlayerEventBeginLoading:{
            //视频开始载入时触发
            [MBProgressHUD showActivityMessageInWindow:@""];
            self.status = kStatusLoading;
        }break;
        case AliyunVodPlayerEventEndLoading:{
            //视频加载完成时触发
            [MBProgressHUD hideHUD];
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
    /** 音频播放状态*/
    [self postNotificationWithName:@"ADUIOPLAYERSTATUS" object:nil];
    /** 发送通知,以更改"开始学习"按钮的显示或者隐藏*/
    [self postNotificationWithName:@"HideLearnBtn" object:@(self.status)];
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel{
    NSLog(@"error %@",errorModel.errorMsg);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
