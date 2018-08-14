//
//  XWCatalogView.m
//  XueWen
//
//  Created by Karron Su on 2018/5/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCatalogView.h"

@interface XWCatalogView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation XWCatalogView

#pragma mark - Lazy / Getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = Color(@"#333333");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        _titleLabel.text = @"如何进行个人成长规划如何进行规划";
    }
    return _titleLabel;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:LoadImage(@"icon_catalog") forState:UIControlStateNormal];
        [_rightBtn setTitle:@" 目录" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont fontWithName:kHeaFont size:16];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

#pragma mark - Setter
- (void)setModel:(XWCoursModel *)model{
    _model = model;
    self.titleLabel.text = _model.courseName;
}

#pragma mark - BtnAction
- (void)rightBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(catalogBtnClick:)]) {
        [self.delegate catalogBtnClick:sender];
    }
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-107);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self).offset(-17);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
}

@end
