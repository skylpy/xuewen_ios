//
//  SwitchQuestionView.m
//  XueWen
//
//  Created by ShaJin on 2018/1/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 考试界面上一题下一题View
#import "SwitchQuestionView.h"
@interface QuestionButton : UIButton

@property (nonatomic, assign) BOOL lastQuestion;
+ (instancetype)lastQuestion:(BOOL)lastQuestion;

@end

@implementation QuestionButton
+ (instancetype)lastQuestion:(BOOL)lastQuestion{
    QuestionButton *button = [QuestionButton buttonWithType:0];
    button.lastQuestion = lastQuestion;
    [button setTitle:lastQuestion ? @"上一题" : @"下一题" forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:COLOR(0, 0, 0) forState:UIControlStateNormal];
    [button setTitleColor:COLOR(183, 183, 183) forState:UIControlStateHighlighted];
    button.imageView.image = LoadImage(lastQuestion ? @"icoLastQuestion" : @"icoNextQuestion");
    return button;
}

- (void)layoutSubviews{
    CGFloat width = [self.titleLabel.text widthWithSize:self.titleLabel.font.pointSize];
    if (_lastQuestion) {
        self.imageView.frame = CGRectMake(15, 17, 15.5, 15.5);
        self.titleLabel.frame = CGRectMake(5 + 15.5 + 15, 18, width , 13);
    }else{
        self.titleLabel.frame = CGRectMake(15, 18, width, 13);
        self.imageView.frame = CGRectMake(15 + width + 5, 17, 15.5, 15.5);
    }
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        [self setTitleColor:COLOR(0, 0, 0) forState:UIControlStateNormal];
    }else{
        [self setTitleColor:COLOR(183, 183, 183) forState:UIControlStateNormal];
    }
}

@end

@interface SwitchQuestionView ()
@property (nonatomic, strong) QuestionButton *lastButton;

@property (nonatomic, strong) QuestionButton *nextButton;

@end
@implementation SwitchQuestionView
- (void)setHasLastQuestion:(BOOL)hasLastQuestion{
    _hasLastQuestion = hasLastQuestion;
    _lastButton.enabled = hasLastQuestion;
}

- (void)setHasNextQuestion:(BOOL)hasNextQuestion{
    _hasNextQuestion = hasNextQuestion;
    _nextButton.enabled = hasNextQuestion;
}

- (instancetype)initWithTarget:(id)target lastQuestion:(SEL)lastQuestion nextQuestion:(SEL)nextQuestion{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lastButton];
        [self addSubview:self.nextButton];
        
        self.lastButton.sd_layout.topSpaceToView(self,0).leftSpaceToView(self,0).bottomSpaceToView(self,0).widthIs(91.5);
        self.nextButton.sd_layout.topSpaceToView(self,0).bottomSpaceToView(self,0).rightSpaceToView(self,0).widthIs(91.5);
        
        [self.lastButton addTarget:target action:lastQuestion forControlEvents:UIControlEventTouchUpInside];
        [self.nextButton addTarget:target action:nextQuestion forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (QuestionButton *)lastButton{
    if (!_lastButton) {
        _lastButton = [QuestionButton lastQuestion:YES];
    }
    return _lastButton;
}

- (QuestionButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [QuestionButton lastQuestion:NO];
    }
    return _nextButton;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 238 / 255.0, 238 / 255.0, 238 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 0.5);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.width ,0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}
@end
