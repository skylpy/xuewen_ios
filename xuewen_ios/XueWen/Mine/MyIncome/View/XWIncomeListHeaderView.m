//
//  XWIncomeListHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIncomeListHeaderView.h"

@interface XWIncomeListHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *dateBtn;

@end

@implementation XWIncomeListHeaderView

#pragma mark - Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"累计:0.00元";
        _titleLabel.font = [UIFont fontWithName:kMedFont size:12];
        _titleLabel.textColor = Color(@"#666666");
    }
    return _titleLabel;
}

- (UIButton *)dateBtn {
    if (!_dateBtn) {
        _dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateBtn addTarget:self action:@selector(dateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_dateBtn setImage:LoadImage(@"icon_calendar") forState:UIControlStateNormal];
    }
    return _dateBtn;
}

#pragma mark - Setter
- (void)setEarnings:(NSString *)earnings{
    _earnings = earnings;
    self.titleLabel.text = [NSString stringWithFormat:@"累计:%@元", _earnings];
}

#pragma mark - Lifecycle
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
    [self addSubview:self.dateBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(25);
        make.top.mas_equalTo(self).offset(24);
    }];
    
    [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-25);
        make.centerY.mas_equalTo(self.titleLabel);
//        make.size.mas_equalTo(CGSizeMake(18, 17));
    }];
}

- (void)dateBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickShow)]) {
        [self.delegate datePickShow];
    }
}

@end
