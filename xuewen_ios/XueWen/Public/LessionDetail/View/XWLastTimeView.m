//
//  XWLastTimeView.m
//  XueWen
//
//  Created by Karron Su on 2018/5/22.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWLastTimeView.h"

@interface XWLastTimeView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *tapBtn;

@end

@implementation XWLastTimeView

#pragma mark - Lazy / Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        _titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _titleLabel;
}

- (UIButton *)tapBtn {
    if (!_tapBtn) {
        _tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tapBtn setTitle:@"继续观看" forState:UIControlStateNormal];
        [_tapBtn setTitleColor:Color(@"#ffffff") forState:UIControlStateNormal];
        _tapBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        @weakify(self)
        [[[_tapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(continueBtnAction)]) {
                [self.delegate continueBtnAction];
            }
        }];
    }
    return _tapBtn;
}

#pragma mark - Setter
- (void)setLastTime:(NSString *)lastTime{
    _lastTime = lastTime;
    NSTimeInterval time = [_lastTime integerValue] / 1000;
    self.titleLabel.text = [NSString stringWithFormat:@"您上次学习到%@", translateTime(time)];
}


#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self addSubview:self.tapBtn];
    [self addSubview:self.titleLabel];
    
    [self.tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.tapBtn.mas_left).offset(-5);
    }];
    
}

@end
