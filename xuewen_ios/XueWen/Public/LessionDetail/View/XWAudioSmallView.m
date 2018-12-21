//
//  XWAudioSmallView.m
//  XueWen
//
//  Created by Karron Su on 2018/5/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWAudioSmallView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface XWAudioSmallView ()

@property (nonatomic, assign) BOOL hasDisappear;
@property (nonatomic, assign) BOOL animating;

@end

@implementation XWAudioSmallView

#pragma mark - Getter / Lazy

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = Color(@"#454F58");
        [_bgView rounded:3];
        [_bgView addTapTarget:self action:@selector(JumpToDetailController)];
    }
    return _bgView;
}

- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
    }
    return _headImgView;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:LoadImage(@"icon_audio_play") forState:UIControlStateNormal];
        @weakify(self)
        [[[_playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(playAction)]) {
                [self.delegate playAction];
            }
        }];
    }
    return _playBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = Color(@"#FFFFFF");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:kMedFont size:14];
    }
    return _titleLabel;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:LoadImage(@"icon_player_close") forState:UIControlStateNormal];
        @weakify(self)
        [[[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(closeAction)]) {
                [self.delegate closeAction];
            }
        }];
    }
    return _closeBtn;
}

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.headImgView];
    [self.bgView addSubview:self.playBtn];
    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:self.titleLabel];
    
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.top.bottom.mas_equalTo(self);
    }];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(10);
        make.top.bottom.mas_equalTo(self.bgView);
        make.width.mas_equalTo(50);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.headImgView);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 19));
        make.right.mas_equalTo(self.bgView).offset(-20);
        make.centerY.mas_equalTo(self.bgView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImgView.mas_right).offset(15);
        make.centerY.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.closeBtn.mas_left).offset(-22);
    }];
    
    
    
    
}

#pragma mark - Setter


#pragma mark - Custom Methods
- (void)appearWithAnimation:(BOOL)animation{
    if (animation) {
        if (!_animating && _hasDisappear) {
            _animating = YES;
            XWWeakSelf
            [UIView animateWithDuration:0.5 animations:^{
                
                weakSelf.frame = [XWAudioInstanceController shareInstance].origentFrame;
            } completion:^(BOOL finished) {
                weakSelf.animating = NO;
                weakSelf.hasDisappear = NO;
                weakSelf.userInteractionEnabled = YES;
            }];
        }
    }else{
        self.frame = [XWAudioInstanceController shareInstance].origentFrame;
        _animating = NO;
        _hasDisappear = NO;
        self.userInteractionEnabled = YES;
    }
    
}

- (void)disappear{
    if (!_animating && !_hasDisappear) {
        _animating = YES;
        XWWeakSelf
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.frame = CGRectMake(0, kHeight, kWidth, 50);
        } completion:^(BOOL finished) {
            weakSelf.hasDisappear = YES;
            weakSelf.animating = NO;
            weakSelf.userInteractionEnabled = NO; // 消失时不响应触摸事件
        }];
    }
}

- (void)JumpToDetailController{
    NSLog(@"点击了");
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:[XWAudioInstanceController shareInstance].model.courseId isAudio:YES] animated:YES];
    
}


@end
