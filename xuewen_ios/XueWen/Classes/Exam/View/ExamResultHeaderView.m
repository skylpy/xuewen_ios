//
//  ExamResultHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ExamResultHeaderView.h"
@interface ExamResultHeaderView ()

@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *retestButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *errorBtn;
@property (nonatomic, strong) UIButton *hosBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSTimer *balanceLabelAnimationTimer;

@end
@implementation ExamResultHeaderView

#pragma mark - Setter

- (void)setScore:(NSInteger)score{
    _score = score;
//    self.scoreLabel.text = [NSString stringWithFormat:@"%ld分",(long)score];
    NSString *text = nil;
    UIColor *strokeColor = [[UIColor alloc] init];
    switch (score / 10) {
        case 10:{
            text = @"好棒，全答对了呢，不愧是社会主义接班人";
            strokeColor = Color(@"#FEAA17");
        }break;
        case 9:{
            text = @"真厉害，你离满分只差一小步";
            strokeColor = Color(@"#31FF36");
        }break;
        case 8:{
            text = @"棒棒哟，不过还有很大的进步空间呢";
            strokeColor = Color(@"#31FF36");
        }break;
        case 7:{
            text = @"哎哟还不错哦，加油加油";
            strokeColor = Color(@"#31FF36");
        }break;
        case 6:{
            text = @"这个成绩怎么说呢，还行吧";
            strokeColor = Color(@"#31FF36");
        }break;
        default:{
            text = @"Emm你这个成绩有点低迷，继续加把劲吧";
            strokeColor = Color(@"#31FF36");
        }break;
    }
    self.contentLabel.text = text;
    
    CGFloat value = (score / 100.0 * 1.5);
    if (value + 0.75 >= 2) {
        value = value + 0.75 - 2;
    }else{
        value = value + 0.75;
    }
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.lineWidth = 5;
    layer.strokeColor = strokeColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineJoinRound;
    CGFloat radius = 60;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kWidth/2, 85) radius:radius startAngle:(0.75*M_PI) endAngle:value*M_PI clockwise:YES];
    layer.path = [path CGPath];
    [self.layer addSublayer:layer];
    
}

- (void)setComment:(NSString *)comment{
    _comment = comment;
    self.contentLabel.text = _comment;
    if (_score == 0) {
        self.scoreLabel.text = @"0分";
    }
    [self setNumberTextOfLabel:self.scoreLabel WithAnimationForValueContent:_score];
}

#pragma mark - initUI

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kThemeColor;
        [self addSubview:self.scoreLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.retestButton];
        [self addSubview:self.continueButton];
        CAShapeLayer *layer = [CAShapeLayer new];
        layer.lineWidth = 5;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineCap = kCALineJoinRound;
        CGFloat radius = 60;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kWidth/2, 85) radius:radius startAngle:(0.75*M_PI) endAngle:0.25f*M_PI clockwise:YES];
        layer.path = [path CGPath];
        [self.layer addSublayer:layer];
        
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(65);
            make.centerX.mas_equalTo(self);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scoreLabel.mas_bottom).offset(48);
            make.centerX.mas_equalTo(self);
        }];
        
        [self.retestButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).multipliedBy(0.6);
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(13);
        }];
        
        [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).multipliedBy(1.4);
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(13);
        }];
        
        
        [self addSubview:self.lineView];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.errorBtn];
        [self.bgView addSubview:self.hosBtn];
        [self.bgView addSubview:self.shareBtn];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.titleLabel];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(229);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(8);
        }];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(82);
        }];
        
        [self.errorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView);
            make.centerX.mas_equalTo(self.bgView).multipliedBy(0.35);
            make.size.mas_equalTo(CGSizeMake(53, 49));
        }];
        
        [self.hosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView);
            make.centerX.mas_equalTo(self.bgView);
            make.size.mas_equalTo(CGSizeMake(53, 53));
        }];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView);
            make.centerX.mas_equalTo(self.bgView).multipliedBy(1.65);
            make.size.mas_equalTo(CGSizeMake(52, 51));
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(self.bgView.mas_bottom);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bottomView).offset(14);
            make.left.mas_equalTo(self.bottomView).offset(16);
        }];
    }
    return self;
}

#pragma mark --- 分数显示的动画----
- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value
{
    CGFloat lastValue = [label.text floatValue];
    CGFloat delta = value - lastValue;
    if (delta == 0) {
        return;
    }
    
    if (delta > 0) {
        
        CGFloat ratio = value / 30.0;
        
        NSDictionary *userInfo = @{@"label" : label,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
                                   };
        _balanceLabelAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(setupLabel:) userInfo:userInfo repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_balanceLabelAnimationTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)setupLabel:(NSTimer *)timer
{
    NSDictionary *userInfo = timer.userInfo;
    UILabel *label = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    
    static int flag = 1;
    CGFloat lastValue = [label.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;
    
    if ((resValue >= value) || (flag == 50)) {
        label.text = [NSString stringWithFormat:@"%.f分", value];
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%.f分", resValue];
    }
    flag++;
}

#pragma mark - Getter

- (UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [UILabel new];
        _scoreLabel.textColor = [UIColor whiteColor];
        _scoreLabel.textAlignment = 1;
        _scoreLabel.font = [UIFont fontWithName:kMedFont size:25];
    }
    return _scoreLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textAlignment = 1;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont fontWithName:kRegFont size:13];
    }
    return _contentLabel;
}

- (UIButton *)retestButton{
    if (!_retestButton) {
        _retestButton = [UIButton buttonWithType:0];
        [_retestButton setBackgroundColor:COLOR(253, 176, 48)];
        ViewRadius(_retestButton, 15);
        [_retestButton setTitle:@"重新测试" forState:UIControlStateNormal];
        [_retestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _retestButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        @weakify(self)
        [[_retestButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(retestAction)]) {
                [self.delegate retestAction];
            }
        }];
    }
    return _retestButton;
}

- (UIButton *)continueButton{
    if (!_continueButton) {
        _continueButton = [UIButton buttonWithType:0];
        ViewRadius(_continueButton, 15);
        _continueButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _continueButton.layer.borderWidth = 1;
        [_continueButton setTitle:@"继续观看" forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _continueButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        @weakify(self)
        [[_continueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(continueAction)]) {
                [self.delegate continueAction];
            }
        }];
    }
    return _continueButton;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color(@"#F7F7F7");
    }
    return _lineView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIButton *)errorBtn{
    if (!_errorBtn) {
        _errorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_errorBtn setImage:LoadImage(@"icon_false") forState:UIControlStateNormal];
        @weakify(self)
        [[_errorBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(errorAction)]) {
                [self.delegate errorAction];
            }
        }];
    }
    return _errorBtn;
}

- (UIButton *)hosBtn{
    if (!_hosBtn) {
        _hosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hosBtn setImage:LoadImage(@"ico_history") forState:UIControlStateNormal];
        @weakify(self)
        [[_hosBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(hosAction)]) {
                [self.delegate hosAction];
            }
        }];
    }
    return _hosBtn;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:LoadImage(@"icon_test_share") forState:UIControlStateNormal];
        @weakify(self)
        [[_shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(shareAction)]) {
                [self.delegate shareAction];
            }
        }];
    }
    return _shareBtn;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = Color(@"#F7F7F7");
    }
    return _bottomView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"推荐课程";
        _titleLabel.font = [UIFont fontWithName:kMedFont size:13];
        _titleLabel.textColor = Color(@"#4f4f4f");
    }
    return _titleLabel;
}


@end
