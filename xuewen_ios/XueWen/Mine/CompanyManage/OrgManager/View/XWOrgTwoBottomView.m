//
//  XWOrgTwoBottomView.m
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWOrgTwoBottomView.h"

@interface XWOrgTwoBottomView ()

@property (nonatomic, strong) UIButton *addDepartmentBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *addStudentBtn;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation XWOrgTwoBottomView

#pragma mark - Getter
- (UIButton *)addDepartmentBtn {
    if (!_addDepartmentBtn) {
        _addDepartmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addDepartmentBtn setTitle:self.titles[0] forState:UIControlStateNormal];
        [_addDepartmentBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateNormal];
        _addDepartmentBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_addDepartmentBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addDepartmentBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color(@"#DDDDDD");
    }
    return _lineView;
}

- (UIButton *)addStudentBtn {
    if (!_addStudentBtn) {
        _addStudentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addStudentBtn setTitle:self.titles[1] forState:UIControlStateNormal];
        [_addStudentBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateNormal];
        _addStudentBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_addStudentBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addStudentBtn;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = Color(@"#DDDDDD");
    }
    return _topLine;
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame titleArrays:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.topLine];
    [self addSubview:self.addDepartmentBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.addStudentBtn];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.addDepartmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo((kWidth-1)/2);
        make.top.mas_equalTo(self.topLine.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(self.topLine.mas_bottom);
    }];
    
    [self.addStudentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self);
        make.width.mas_equalTo((kWidth-1)/2);
        make.top.mas_equalTo(self.topLine.mas_bottom);
    }];
}

#pragma mark - Custom Methods
- (void)leftBtnClick {
    !self.leftBlock ? : self.leftBlock();
}

- (void)rightBtnClick {
    !self.rightBlock ? : self.rightBlock();
}

@end
