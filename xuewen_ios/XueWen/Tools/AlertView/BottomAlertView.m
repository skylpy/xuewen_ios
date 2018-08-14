//
//  BottomAlertView.m
//  XueWen
//
//  Created by ShaJin on 2018/1/18.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "BottomAlertView.h"
/** 底部弹窗 */
@interface BottomAlertView()
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, copy) ActionBlock firstBlock;
@property (nonatomic, copy) ActionBlock secondBlock;
@end
@implementation BottomAlertView
- (void)first{
    if (self.firstBlock) {
        self.firstBlock();
    }
    [self dismiss];
}

- (void)second{
    if (self.secondBlock) {
        self.secondBlock();
    }
    [self dismiss];
}

- (instancetype)initWithMessage:(NSString *)message firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle firstAction:(ActionBlock)firstAction secondAction:(ActionBlock)secondAction{
    if (self = [super initWithFrame:CGRectMake(0, kHeight - 182, kWidth, 182)]) {
        self.animationType = kAnimationBottom;
        self.cornerRadius = 0.0;
        [self addSubview:self.titleLabel];
        [self addSubview:self.firstButton];
        [self addSubview:self.secondButton];
        
        self.titleLabel.sd_layout.topSpaceToView(self,25).leftSpaceToView(self,15).rightSpaceToView(self,15).heightIs(15);
        self.firstButton.sd_layout.topSpaceToView(self.titleLabel,24).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(44);
        self.secondButton.sd_layout.topSpaceToView(self.firstButton,15).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(44);
        
        self.titleLabel.text = message;
        [_firstButton setTitle:firstTitle forState:UIControlStateNormal];
        [_secondButton setTitle:secondTitle forState:UIControlStateNormal];
        
        [self.firstButton addTarget:self action:@selector(first) forControlEvents:UIControlEventTouchUpInside];
        [self.secondButton addTarget:self action:@selector(second) forControlEvents:UIControlEventTouchUpInside];
        self.firstBlock = firstAction;
        self.secondBlock= secondAction;
        
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setTitleAttributed:(NSAttributedString *)titleAttributed{
    _titleAttributed = titleAttributed;
    self.titleLabel.attributedText = titleAttributed;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:DefaultTitleAColor size:15];
        _titleLabel.textAlignment = 1;
    }
    return _titleLabel;
}

- (UIButton *)firstButton{
    if (!_firstButton) {
        _firstButton = [UIButton buttonWithType:0];
        ViewRadius(_firstButton, 5);
        [_firstButton setBackgroundColor:kThemeColor];
    }
    return _firstButton;
}

- (UIButton *)secondButton{
    if (!_secondButton) {
        _secondButton = [UIButton buttonWithType:0];
        ViewRadius(_secondButton, 5);
        [_secondButton setBackgroundColor:COLOR(204, 204, 204)];
    }
    return _secondButton;
}

+ (instancetype)alertWithMessage:(NSString *)message firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle firstAction:(ActionBlock)firstAction secondAction:(ActionBlock)secondAction{
    return [[BottomAlertView alloc] initWithMessage:message firstTitle:firstTitle secondTitle:secondTitle firstAction:firstAction secondAction:secondAction];
}
@end
