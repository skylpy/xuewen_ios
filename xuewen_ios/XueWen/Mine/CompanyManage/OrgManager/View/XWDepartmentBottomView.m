//
//  XWDepartmentBottomView.m
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWDepartmentBottomView.h"

@interface XWDepartmentBottomView ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *midBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation XWDepartmentBottomView

#pragma mark - Getter
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
        _topLine.backgroundColor = Color(@"#DDDDDD");
    }
    return _topLine;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_leftBtn setTitle:self.titles[0] forState:UIControlStateNormal];
        @weakify(self)
        [[_leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            !self.leftBlock ? : self.leftBlock();
        }];
    }
    return _leftBtn;
}

- (UIButton *)midBtn {
    if (!_midBtn) {
        _midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_midBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateNormal];
        _midBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_midBtn setTitle:self.titles[1] forState:UIControlStateNormal];
        @weakify(self)
        [[_midBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            !self.midBlock ? : self.midBlock();
        }];
    }
    return _midBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_rightBtn setTitle:self.titles[2] forState:UIControlStateNormal];
        @weakify(self)
        [[_rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            !self.rightBlock ? : self.rightBlock();
        }];
    }
    return _rightBtn;
}

- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = Color(@"#DDDDDD");
    }
    return _leftLine;
}

- (UIView *)rightLine {
    if (!_rightLine) {
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = Color(@"#DDDDDD");
    }
    return _rightLine;
}


#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    [self addSubview:self.topLine];
    [self addSubview:self.leftBtn];
    [self addSubview:self.leftLine];
    [self addSubview:self.midBtn];
    [self addSubview:self.rightLine];
    [self addSubview:self.rightBtn];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.topLine.mas_bottom);
        make.width.mas_equalTo((kWidth-2)/3);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.leftBtn.mas_right);
        make.top.mas_equalTo(self.topLine.mas_bottom);
        make.width.mas_equalTo(1);
    }];
    
    [self.midBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLine.mas_right);
        make.width.mas_equalTo((kWidth-2)/3);
        make.top.mas_equalTo(self.topLine.mas_bottom);
        make.bottom.mas_equalTo(self);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.midBtn.mas_right);
        make.top.mas_equalTo(self.topLine.mas_bottom);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(1);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.topLine.mas_bottom);
        make.width.mas_equalTo((kWidth-2)/3);
    }];
}

@end
