//
//  XWIncomeHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIncomeHeaderView.h"
#import "XWWithdrawalController.h"

@interface XWIncomeHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UIButton *applyBtn;

@end

@implementation XWIncomeHeaderView

#pragma mark - Getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"账户资金";
        _titleLabel.textColor = Color(@"#333333");
        _titleLabel.font = [UIFont fontWithName:kMedFont size:12];
    }
    return _titleLabel;
}

- (UILabel *)incomeLabel{
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.text = @"¥0.00";
        _incomeLabel.textColor = Color(@"#666666");
        _incomeLabel.font = [UIFont fontWithName:kMedFont size:25];
    }
    return _incomeLabel;
}

- (UIButton *)applyBtn{
    if (!_applyBtn) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyBtn setTitle:@"申请提现" forState:UIControlStateNormal];
        [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyBtn.backgroundColor = Color(@"#3E7EFF");
        _applyBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:13];
        [_applyBtn rounded:12];
        [_applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.incomeLabel];
    [self addSubview:self.applyBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(27);
    }];
    
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(13);
    }];
    
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.incomeLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(132, 25));
    }];
}

- (void)applyBtnClick{
    [self.navigationController pushViewController:[XWWithdrawalController new] animated:YES];
}

#pragma mark -  Setter
- (void)setBonusesPrice:(NSString *)bonusesPrice{
    _bonusesPrice = bonusesPrice;
    self.incomeLabel.text = [NSString stringWithFormat:@"¥%@", _bonusesPrice];
}

@end
