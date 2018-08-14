//
//  XWHistoryHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/6/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHistoryHeaderView.h"


@interface XWHistoryHeaderView ()

@property (nonatomic, strong) UIView *bgView; // 蓝色底色
@property (nonatomic, strong) UILabel *scoreLabel; // 分数
@property (nonatomic, strong) UILabel *tipsLabel; // 历史最高分

@property (nonatomic, strong) UILabel *totalTestCountLabel; // 累计考试次数
@property (nonatomic, strong) UILabel *totalTestLabel; // 累计考试
@property (nonatomic, strong) UILabel *passCountLabel; // 及格次数
@property (nonatomic, strong) UILabel *passLabel; // 及格次数
@property (nonatomic, strong) UILabel *answerCountLabel; // 累计答题次数
@property (nonatomic, strong) UILabel *answerLabel; // 累计答题

@property (nonatomic, strong) UIView *lineView; // 线
@property (nonatomic, strong) UIView *bottomView; // 底部中间View
@property (nonatomic, strong) UILabel *historyLabel; // 历史分数

@property (nonatomic, strong) NSTimer *balanceLabelAnimationTimer;


@end

@implementation XWHistoryHeaderView

#pragma mark - Getter
- (UILabel *)historyLabel{
    if (!_historyLabel) {
        _historyLabel = [[UILabel alloc] init];
        _historyLabel.text = @"历史分数";
        _historyLabel.textColor = Color(@"#00A0E9");
        _historyLabel.font = [UIFont fontWithName:kRegFont size:14];
    }
    return _historyLabel;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView rounded:5 width:1 color:Color(@"#D2D2D2")];
    }
    return _bottomView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color(@"#D2D2D2");
    }
    return _lineView;
}

- (UILabel *)answerLabel{
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.text = @"正确率";
        _answerLabel.textColor = [UIColor blackColor];
        _answerLabel.font = [UIFont fontWithName:kMedFont size:14];
    }
    return _answerLabel;
}

- (UILabel *)answerCountLabel{
    if (!_answerCountLabel) {
        _answerCountLabel = [[UILabel alloc] init];
        _answerCountLabel.text = @"17题";
        _answerCountLabel.textColor = Color(@"#00A0E9");
        _answerCountLabel.font = [UIFont fontWithName:kRegFont size:20];
    }
    return _answerCountLabel;
}

- (UILabel *)passLabel{
    if (!_passLabel) {
        _passLabel = [[UILabel alloc] init];
        _passLabel.text = @"及格次数";
        _passLabel.textColor = [UIColor blackColor];
        _passLabel.font = [UIFont fontWithName:kMedFont size:14];
    }
    return _passLabel;
}

- (UILabel *)passCountLabel{
    if (!_passCountLabel) {
        _passCountLabel = [[UILabel alloc] init];
        _passCountLabel.text = @"7次";
        _passCountLabel.textColor = Color(@"#FFAB08");
        _passCountLabel.font = [UIFont fontWithName:kRegFont size:20];
    }
    return _passCountLabel;
}

- (UILabel *)totalTestLabel{
    if (!_totalTestLabel) {
        _totalTestLabel = [[UILabel alloc] init];
        _totalTestLabel.text = @"累计考试";
        _totalTestLabel.textColor = Color(@"#000000");
        _totalTestLabel.font = [UIFont fontWithName:kMedFont size:14];
    }
    return _totalTestLabel;
}

- (UILabel *)totalTestCountLabel{
    if (!_totalTestCountLabel) {
        _totalTestCountLabel = [[UILabel alloc] init];
        _totalTestCountLabel.font = [UIFont fontWithName:kRegFont size:20];
        _totalTestCountLabel.textColor = Color(@"#00A0E9");
        _totalTestCountLabel.text = @"7次";
    }
    return _totalTestCountLabel;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 229)];
        _bgView.backgroundColor = Color(@"#476EFF");
    }
    return _bgView;
}

- (UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.font = [UIFont fontWithName:kMedFont size:30];
        _scoreLabel.text = @"0分";
        _scoreLabel.textColor = [UIColor whiteColor];
    }
    return _scoreLabel;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont fontWithName:kRegFont size:20];
        _tipsLabel.text = @"历史最高分";
        _tipsLabel.textColor = [UIColor whiteColor];
    }
    return _tipsLabel;
}

#pragma mark - Setter
- (void)setModel:(XWExamHistoryModel *)model{
    _model = model;
//    self.scoreLabel.text = [NSString stringWithFormat:@"%@分", _model.topFraction];
    if (_model == nil) {
        _model = [[XWExamHistoryModel alloc] init];
        _model.testNum = @"0";
        _model.passNum = @"0";
        _model.accuracy = @"0";
    }
    self.totalTestCountLabel.text = [NSString stringWithFormat:@"%@次", _model.testNum];
    self.passCountLabel.text = [NSString stringWithFormat:@"%@次", _model.passNum];
    self.answerCountLabel.text = [NSString stringWithFormat:@"%@%%", _model.accuracy];
    [self setNumberTextOfLabel:self.scoreLabel WithAnimationForValueContent:[_model.topFraction intValue]];
    NSRange range1 = [self.totalTestCountLabel.text rangeOfString:@"次"];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:self.totalTestCountLabel.text];
    [attr1 addAttribute:NSForegroundColorAttributeName value:Color(@"#00A0E9") range:range1];
    [attr1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:14] range:range1];
    self.totalTestCountLabel.attributedText = attr1;
    
    NSRange range2 = [self.passCountLabel.text rangeOfString:@"次"];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:self.passCountLabel.text];
    [attr2 addAttribute:NSForegroundColorAttributeName value:Color(@"#FFAB08") range:range2];
    [attr2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:14] range:range2];
    self.passCountLabel.attributedText = attr2;
    
    NSRange range3 = [self.answerCountLabel.text rangeOfString:@"%"];
    NSMutableAttributedString *attr3 = [[NSMutableAttributedString alloc] initWithString:self.answerCountLabel.text];
    [attr3 addAttribute:NSForegroundColorAttributeName value:Color(@"#00A0E9") range:range3];
    [attr3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:14] range:range3];
    self.answerCountLabel.attributedText = attr3;
}


#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

#pragma mark - Methods
- (void)drawUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.bgView];
    [self addSubview:self.scoreLabel];
    [self addSubview:self.tipsLabel];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(80);
        make.centerX.mas_equalTo(self.bgView);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.scoreLabel.mas_bottom).offset(1);
    }];
    
    // 贝塞尔画圆
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.lineWidth = 5;
    layer.strokeColor = Color(@"#FDB030").CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineJoinRound;
    CGFloat radius = 73;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.bgView.center radius:radius startAngle:(0*M_PI) endAngle:2*M_PI clockwise:YES];
    layer.path = [path CGPath];
    [self.bgView.layer addSublayer:layer];
    
    [self addSubview:self.totalTestLabel];
    [self addSubview:self.passLabel];
    [self addSubview:self.answerLabel];
    [self addSubview:self.totalTestCountLabel];
    [self addSubview:self.passCountLabel];
    [self addSubview:self.answerCountLabel];
    
    [self.totalTestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(44);
        make.centerX.mas_equalTo(self).multipliedBy(0.35);
    }];
    
    [self.passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.totalTestLabel);
    }];
    
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).multipliedBy(1.65);
        make.centerY.mas_equalTo(self.totalTestLabel);
    }];
    
    [self.totalTestCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.totalTestLabel.mas_top).offset(-2);
        make.centerX.mas_equalTo(self.totalTestLabel);
    }];
    
    [self.passCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.totalTestCountLabel);
        make.centerX.mas_equalTo(self.passLabel);
    }];
    
    [self.answerCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.totalTestCountLabel);
        make.centerX.mas_equalTo(self.answerLabel);
    }];
    
    [self addSubview:self.lineView];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.historyLabel];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(90);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.lineView);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(101, 24));
    }];
    
    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bottomView);
    }];

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

@end
