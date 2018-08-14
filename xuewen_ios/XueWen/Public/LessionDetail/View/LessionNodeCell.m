//
//  LessionNodeCell.m
//  XueWen
//
//  Created by ShaJin on 2018/1/11.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "LessionNodeCell.h"
#import "LessionModel.h"
#import "XWProgressView.h"
#import "CourseAudioModel.h"
typedef NS_ENUM(NSInteger,LessionNodeCellState){
    kUnWatch = 0,           // 没有观看
    kWatched ,              // 正在观看
    kWatchOver,             // 看完了（观看进度超过80%）
};

@interface LessionNodeCell ()

@property (nonatomic, strong) LessionNodeModel *model;
@property (nonatomic, strong) CourseAudioModel *audio;
@property (nonatomic, assign) LessionNodeCellState state;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *freeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) XWProgressView *progressView;

@end
@implementation LessionNodeCell

- (void)setState:(LessionNodeCellState)state{
    _state = state;
    switch (state) {
        case kUnWatch:{
            _icon.image = LoadImage(@"catalogIcoPlayNormal");
            _titleLabel.textColor = DefaultTitleBColor;
            _timeLabel.textColor = DefaultTitleBColor;
        }break;
        case kWatched:{
            _icon.image = LoadImage(@"catalogIcoPlaySelected");
            _titleLabel.textColor = kThemeColor;
            _timeLabel.textColor = kThemeColor;
        }break;
        case kWatchOver:{
            _icon.image = LoadImage(@"catalogIcoPlayPressed");
            _titleLabel.textColor = COLOR(168, 178, 202);
            _timeLabel.textColor = COLOR(168, 178, 202);
        }break;
        default:
            break;
    }
}

- (void)setModel:(LessionNodeModel *)model free:(BOOL)free isPlay:(BOOL)isPlay{
    _model = model;
    if (free) {
        self.freeLabel.sd_layout.widthIs(self.freeLabel.textWidth);
        self.titleLabel.sd_layout.rightSpaceToView(self.freeLabel,10);
    }else{
        self.freeLabel.sd_layout.widthIs(0);
        self.titleLabel.sd_layout.rightSpaceToView(self.timeLabel,20);
    }
    if (isPlay) {
        self.state = kWatched;
    }else{
        self.state = (model.finished) ? kWatchOver : kUnWatch;
    }
    self.titleLabel.text = model.lessionTitle;
    self.timeLabel.text = model.lessionTime;
    
    self.timeLabel.sd_layout.widthIs([self.timeLabel.text widthWithSize:self.timeLabel.font.pointSize]);
    
    self.currentTime = model.watchTime;
}

- (void)setAudio:(CourseAudioModel *)audio free:(BOOL)free isPlay:(BOOL)isPlay{
    _audio = audio;
    if (free) {
        self.freeLabel.sd_layout.widthIs(self.freeLabel.textWidth);
        self.titleLabel.sd_layout.rightSpaceToView(self.freeLabel,10);
    }else{
        self.freeLabel.sd_layout.widthIs(0);
        self.titleLabel.sd_layout.rightSpaceToView(self.timeLabel,20);
    }
    self.state = isPlay ? kWatched : kUnWatch;
    self.titleLabel.text = audio.node_title;
    self.timeLabel.text = audio.total_time;
    self.timeLabel.sd_layout.widthIs(self.timeLabel.textWidth);
}

- (void)setCurrentTime:(NSInteger)currentTime{
    _currentTime = currentTime;
    
    CGFloat progress = currentTime * 1.0 / self.model.sumTime;

    self.progressView.progress = (progress >= 0.8) ? 1.0 : progress; // 播放进度超过80%视为观看完成
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView sd_addSubviews:@[self.progressView,self.titleLabel,self.freeLabel,self.timeLabel]];
        
        self.progressView.sd_layout.leftSpaceToView(self.contentView,13.5).centerYEqualToView(self.contentView).heightIs(10).widthIs(10); self.timeLabel.sd_layout.centerYEqualToView(self.progressView).rightSpaceToView(self.contentView,9.5).heightIs(self.timeLabel.font.lineHeight);
        self.freeLabel.sd_layout.centerYEqualToView(self.progressView).rightSpaceToView(self.timeLabel,10).heightIs(self.freeLabel.font.lineHeight);
        self.titleLabel.sd_layout.centerYEqualToView(self.progressView).leftSpaceToView(self.progressView,6.5).heightIs(self.titleLabel.font.lineHeight);
        
    }
    return self;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
    }
    return _icon;
}

- (XWProgressView *)progressView{
    if (!_progressView) {
        _progressView = [XWProgressView new];
    }
    return _progressView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:14];
    }
    return _titleLabel;
}

- (UILabel *)freeLabel{
    if (!_freeLabel) {
        _freeLabel = [UILabel labelWithTextColor:COLOR(14, 201, 80) size:10];
        _freeLabel.layer.borderColor = COLOR(14, 201, 80).CGColor;
        _freeLabel.layer.borderWidth = 1;
        _freeLabel.text = @"免费试看";
    }
    return _freeLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:12];
    }
    return _timeLabel;
}

@end
