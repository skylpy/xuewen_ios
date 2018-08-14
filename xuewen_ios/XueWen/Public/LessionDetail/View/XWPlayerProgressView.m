//
//  XWPlayerProgressView.m
//  XueWen
//
//  Created by ShaJin on 2018/1/3.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "XWPlayerProgressView.h"
@interface XWPlayerProgressView()
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UISlider *sliderView;
@end
@implementation XWPlayerProgressView
- (void)setBufferProgress:(CGFloat)bufferProgress{
    // 控制范围
    if (bufferProgress < 0.0) {
        _bufferProgress = 0.0;
    }else if (bufferProgress > 1.0){
        _bufferProgress = 1.0;
    }else{
        _bufferProgress = bufferProgress;
    }
    self.progressView.progress = _bufferProgress;
}

- (void)setPlayProgress:(CGFloat)playProgress{
    if (playProgress < 0.0) {
        _playProgress = 0.0;
    }else if (_playProgress > 1.0){
        _playProgress = 1.0;
    }else{
        _playProgress = playProgress;
    }
    self.sliderView.value = _playProgress;
}

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.progressView];
        [self addSubview:self.sliderView];
        self.progressView.sd_layout.centerYEqualToView(self).leftSpaceToView(self,2).rightSpaceToView(self,2).heightIs(10);
        self.sliderView.sd_layout.centerYEqualToView(self).leftSpaceToView(self,0).rightSpaceToView(self,0).heightIs(44);
    }
    return self;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.trackTintColor = ColorA(255, 255, 255, 0.5);
    }
    return _progressView;
}

- (UISlider *)sliderView{
    if (!_sliderView) {
        _sliderView = [UISlider new];
        [_sliderView setThumbImage:LoadImage(@"iconPlayControl") forState:UIControlStateNormal];
        _sliderView.minimumTrackTintColor = kThemeColor;
        _sliderView.maximumTrackTintColor = [UIColor clearColor];
        _sliderView.maximumValue = 1.0;
        _sliderView.minimumValue = 0.0;
        [_sliderView addTarget:self action:@selector(sliding) forControlEvents:UIControlEventValueChanged];
        [_sliderView addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sliderView addTarget:self action:@selector(touchOutSide) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _sliderView;
}

- (void)sliderAction:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(setProgress:)]) {
        [self.delegate setProgress:slider.value];
    }
}

- (void)touchOutSide{
    if ([self.delegate respondsToSelector:@selector(setProgress:)]) {
        [self.delegate setProgress:_sliderView.value];
    }
}

- (void)sliding{
    if ([self.delegate respondsToSelector:@selector(slidingWithProgress:)]) {
        [self.delegate slidingWithProgress:_sliderView.value];
    }
}
@end
