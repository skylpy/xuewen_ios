//
//  XWTransactionListHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/9/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWTransactionListHeaderView.h"

@interface XWTransactionListHeaderView ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation XWTransactionListHeaderView

#pragma mark - Getter
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"提现记录";
        _titleLabel.font = [UIFont fontWithName:kMedFont size:13];
        _titleLabel.textColor = Color(@"#666666");
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color(@"#DEDEDE");
    }
    return _lineView;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = Color(@"#DEDEDE");
    }
    return _bottomLineView;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = @"日期";
        _dateLabel.textColor = Color(@"#666666");
        _dateLabel.font = [UIFont fontWithName:kMedFont size:13];
    }
    return _dateLabel;
}

- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.text = @"提现金额";
        _amountLabel.textColor = Color(@"#666666");
        _amountLabel.font = [UIFont fontWithName:kMedFont size:13];
    }
    return _amountLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = @"状态";
        _statusLabel.textColor = Color(@"#666666");
        _statusLabel.font = [UIFont fontWithName:kMedFont size:13];
    }
    return _statusLabel;
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    self.backgroundColor = Color(@"#f6f6f6");
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.titleLabel];
    [self.bottomView addSubview:self.lineView];
    [self.bottomView addSubview:self.dateLabel];
    [self.bottomView addSubview:self.amountLabel];
    [self.bottomView addSubview:self.statusLabel];
    [self.bottomView addSubview:self.bottomLineView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(70);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(25);
        make.top.mas_equalTo(self.bottomView).offset(10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.bottomView).offset(37);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView).offset(-7);
        make.centerX.mas_equalTo(self).multipliedBy(0.3);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView).offset(-7);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView).offset(-7);
        make.centerX.mas_equalTo(self).multipliedBy(1.7);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.bottomView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
