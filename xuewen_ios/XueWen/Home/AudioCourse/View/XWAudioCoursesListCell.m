//
//  XWAudioCoursesListCell.m
//  XueWen
//
//  Created by Karron Su on 2018/5/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWAudioCoursesListCell.h"
#import "AliyunVodPlayerSDK.h"

@interface XWAudioCoursesListCell ()
/** 课程背景图*/
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
/** 正在听状态*/
@property (weak, nonatomic) IBOutlet UIImageView *listenImgView;
@property (weak, nonatomic) IBOutlet UILabel *listenLabel;
/** 试听按钮*/
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
/** 课程标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 讲师信息*/
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
/** 听课人数*/
@property (weak, nonatomic) IBOutlet UILabel *listenCountLabel;
/** 课程时长*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 课程价格*/
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation XWAudioCoursesListCell


#pragma mark - Getter / Lazy


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bgImgView rounded:3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus:) name:@"AUDIOLISTSTATUS" object:nil];
    
}

- (void)changeStatus:(NSNotification*)x{
    if ([_model.courseId isEqualToString:[XWAudioInstanceController shareInstance].model.courseId]) {
        BOOL isPlay ;
        NSString *str = [NSString stringWithFormat:@"%@", x.object];
        if ([str isEqualToString:@"0"]) {
            isPlay = NO;
        }else{
            isPlay = YES;
        }
        if (isPlay) {
            self.listenImgView.hidden = NO;
            self.listenLabel.hidden = NO;
            [self.playBtn setImage:LoadImage(@"icon_audio_stop") forState:UIControlStateNormal];
        }else{
            self.listenImgView.hidden = YES;
            self.listenLabel.hidden = YES;
            [self.playBtn setImage:LoadImage(@"icon_audio_play") forState:UIControlStateNormal];
        }
    }else{
        self.listenImgView.hidden = YES;
        self.listenLabel.hidden = YES;
        [self.playBtn setImage:LoadImage(@"icon_audio_play") forState:UIControlStateNormal];
    }
}

- (IBAction)PlayBtnClick:(UIButton *)sender {
    __block NSInteger playIndex = 0;
    [_model.courseAudioArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /** 查找哪些是看完的,接着之前的播放进度开始播放*/
        XWAudioNodeModel *model = (XWAudioNodeModel *)obj;
        if ([model.play isEqualToString:@"0"]) {
            playIndex = idx;
            *stop = YES;
        }else{
            if ([model.finished isEqualToString:@"0"]) {
                playIndex = idx;
                *stop = YES;
            }
        }
    }];
    
    XWAudioNodeModel *model = _model.courseAudioArray[playIndex];
    if ([_model.courseType isEqualToString:@"0"]) { // 课程未购买
        if ([model.state isEqualToString:@"0"]) { // 节点不免费
            [MBProgressHUD showWarnMessage:@"请购买该课程"];
            return;
        }
    }
    
    XWCoursModel *coursModel = [[XWCoursModel alloc] init];
    coursModel.tchOrgPhotoAll = _model.pictureAll;
    coursModel.courseName = _model.courseName;
    coursModel.tchOrg = _model.tchOrg;
    coursModel.courseId = _model.courseId;
    XWCoursInfoModel *infoModel = [[XWCoursInfoModel alloc] init];
    infoModel.type = _model.courseType;
    [XWAudioInstanceController shareInstance].dataArray = _model.courseAudioArray;
    [XWAudioInstanceController shareInstance].playIndex = playIndex;
    [XWAudioInstanceController shareInstance].model = coursModel;
    [XWAudioInstanceController shareInstance].infoModel = infoModel;
    [XWAudioInstanceController shareInstance].isContinue = YES;
    [[XWAudioInstanceController shareInstance] play];
}

#pragma mark - Setter

- (void)setModel:(XWAudioCoursModel *)model{
    _model = model;
    self.timeLabel.text = _model.timeLength;
    self.titleLabel.text = _model.courseName;
    self.listenCountLabel.text = [NSString stringWithFormat:@"%@人听", _model.total];
    if ([_model.amount isEqualToString:@"0.00"]) {
        self.priceLabel.textColor = Color(@"#0EC950");
        self.priceLabel.text = @"免费";
    }else{
        self.priceLabel.textColor = Color(@"#FC651E");
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _model.amount];
    }
//    NSLog(@"_model.coursid is %@", _model.courseId);
//    NSLog(@"[XWAudioInstanceController shareInstance].model.courseId] is %@", [XWAudioInstanceController shareInstance].model.courseId);
    if ([_model.courseId isEqualToString:[XWAudioInstanceController shareInstance].model.courseId]) {
        AliyunVodPlayer *vodPlayer = [XWAudioInstanceController shareInstance].player;
        if (vodPlayer.playerState == AliyunVodPlayerStatePlay) {
            self.listenImgView.hidden = NO;
            self.listenLabel.hidden = NO;
            [self.playBtn setImage:LoadImage(@"icon_audio_stop") forState:UIControlStateNormal];
        }else{
            self.listenImgView.hidden = YES;
            self.listenLabel.hidden = YES;
            [self.playBtn setImage:LoadImage(@"icon_audio_play") forState:UIControlStateNormal];
        }
    }else{
        self.listenImgView.hidden = YES;
        self.listenLabel.hidden = YES;
        [self.playBtn setImage:LoadImage(@"icon_audio_play") forState:UIControlStateNormal];
    }
    
    self.teacherLabel.text = [NSString stringWithFormat:@"讲师: %@", _model.tchOrg];
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll]];
    
}



- (void)dealloc{
//    NSLog(@"cell释放了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
