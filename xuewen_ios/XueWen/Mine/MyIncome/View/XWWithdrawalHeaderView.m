//
//  XWWithdrawalHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWWithdrawalHeaderView.h"
#import "XWBoundAliPayController.h"
#import "XWBoundSuccessController.h"

@interface XWWithdrawalHeaderView ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *bigImgView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *normalLabel;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UILabel *withdrawalLab;
@property (nonatomic, strong) UIImageView *aliImgView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *allWithdrawalBtn;
@property (nonatomic, strong) UIButton *withdrawalBtn;

@end

@implementation XWWithdrawalHeaderView

#pragma mark - Getter
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = Color(@"#3376FF");
    }
    return _topView;
}

- (UIImageView *)bigImgView{
    if (!_bigImgView) {
        _bigImgView = [[UIImageView alloc] initWithImage:LoadImage(@"icon_money")];
    }
    return _bigImgView;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"¥0.00";
        _moneyLabel.textColor = Color(@"#FEFEFE");
        _moneyLabel.font = [UIFont fontWithName:kMedFont size:25];
    }
    return _moneyLabel;
}

- (UILabel *)normalLabel{
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc] init];
        _normalLabel.textColor = Color(@"#FFFFFF");
        _normalLabel.text = @"(账户资金)";
        _normalLabel.font = [UIFont fontWithName:kMedFont size:12];
    }
    return _normalLabel;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = Color(@"#666666");
        _tipsLabel.font = [UIFont fontWithName:kMedFont size:12];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.text = @"账户资金满10元可提现，每天提现次数最多3批，每月最多10次。到账时间T+3日。";
    }
    return _tipsLabel;
}

- (UIView *)midView{
    if (!_midView) {
        _midView = [[UIView alloc] init];
        _midView.backgroundColor = [UIColor whiteColor];
    }
    return _midView;
}

- (UILabel *)withdrawalLab{
    if (!_withdrawalLab) {
        _withdrawalLab = [[UILabel alloc] init];
        _withdrawalLab.text = @"提现金额";
        _withdrawalLab.textColor = Color(@"#666666");
        _withdrawalLab.font = [UIFont fontWithName:kMedFont size:13];
    }
    return _withdrawalLab;
}

- (UIImageView *)aliImgView{
    if (!_aliImgView) {
        _aliImgView = [[UIImageView alloc] initWithImage:LoadImage(@"icon_alipay1")];
    }
    return _aliImgView;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont fontWithName:kMedFont size:12];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.placeholder = @"输入提现金额";
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIButton *)allWithdrawalBtn{
    if (!_allWithdrawalBtn) {
        _allWithdrawalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allWithdrawalBtn setTitle:@"全部提现" forState:UIControlStateNormal];
        [_allWithdrawalBtn setTitleColor:Color(@"#3E7EFF") forState:UIControlStateNormal];
        _allWithdrawalBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:11];
        [_allWithdrawalBtn addTarget:self action:@selector(allWithdrawalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allWithdrawalBtn;
}

- (UIButton *)withdrawalBtn{
    if (!_withdrawalBtn) {
        _withdrawalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawalBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawalBtn setTitleColor:Color(@"#ffffff") forState:UIControlStateNormal];
        _withdrawalBtn.backgroundColor = Color(@"#3E7EFF");
        [_withdrawalBtn rounded:12];
        _withdrawalBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:13];
        [_withdrawalBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _withdrawalBtn;
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
    
    [self addSubview:self.topView];
    [self.topView addSubview:self.bigImgView];
    [self.topView addSubview:self.moneyLabel];
    [self.topView addSubview:self.normalLabel];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(155);
    }];
    
    [self.bigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(68, 68));
        make.centerX.mas_equalTo(self.topView);
        make.top.mas_equalTo(self.topView).offset(12);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topView);
        make.top.mas_equalTo(self.bigImgView.mas_bottom).offset(8);
    }];
    
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topView);
        make.top.mas_equalTo(self.moneyLabel.mas_bottom).offset(1);
    }];
    
    [self addSubview:self.tipsLabel];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(25);
        make.right.mas_equalTo(self).offset(-25);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(15);
    }];
    
    [self addSubview:self.midView];
    [self.midView addSubview:self.withdrawalLab];
    [self.midView addSubview:self.aliImgView];
    [self.midView addSubview:self.allWithdrawalBtn];
    [self.midView addSubview:self.textField];
    [self.midView addSubview:self.withdrawalBtn];
    
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(15);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(87);
    }];
    
    [self.withdrawalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(25);
        make.top.mas_equalTo(self.midView).offset(10);
    }];
    
    [self.aliImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.withdrawalLab.mas_right).offset(3);
        make.centerY.mas_equalTo(self.withdrawalLab);
        make.size.mas_equalTo(CGSizeMake(13, 14));
    }];
    
    [self.allWithdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-25);
        make.centerY.mas_equalTo(self.withdrawalLab);
        make.height.mas_equalTo(15);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(121);
        make.right.mas_equalTo(self.allWithdrawalBtn.mas_left).offset(-15);
        make.centerY.mas_equalTo(self.withdrawalLab);
        make.height.mas_equalTo(24);
    }];
    
    [self.withdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.midView);
        make.size.mas_equalTo(CGSizeMake(132, 25));
        make.bottom.mas_equalTo(self.midView).offset(-12);
    }];
    
}

#pragma mark - Action
/** 提现*/
- (void)btnAction{
    
    if ([self.textField.text isEqualToString:@""] || self.textField.text == nil || [self.textField.text floatValue] == 0) {
        [MBProgressHUD showTipMessageInWindow:@"输入金额"];
        return;
    }
    
    if ([self.payeeAccount isEqualToString:@""] || self.payeeAccount == nil) {
        [self.navigationController pushViewController:[XWBoundAliPayController new] animated:YES];
        return;
    }
    
    [XWHttpTool createTransactionRecordWithPrice:self.textField.text success:^(XWTransactionRecordModel *model) {
        XWBoundSuccessController *vc = [[XWBoundSuccessController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showTipMessageInWindow:errorInfo];
    }];
    
}

/** 全部提现*/
- (void)allWithdrawalBtnClick{
    self.textField.text = self.bonusesPrice;
}

/** 输入框变化*/
- (void)textFieldDidChange:(UITextField *)textField{
    if ([textField.text floatValue] > [self.bonusesPrice floatValue]) {
        [self.allWithdrawalBtn setTitle:@"输入金额超过账户余额" forState:UIControlStateNormal];
        [self.allWithdrawalBtn setTitleColor:Color(@"#FE4242") forState:UIControlStateNormal];
        self.allWithdrawalBtn.userInteractionEnabled = NO;
        self.withdrawalBtn.userInteractionEnabled = NO;
    }else{
        [self.allWithdrawalBtn setTitle:@"全部提现" forState:UIControlStateNormal];
        [self.allWithdrawalBtn setTitleColor:Color(@"#3E7EFF") forState:UIControlStateNormal];
        self.allWithdrawalBtn.userInteractionEnabled = YES;
        self.withdrawalBtn.userInteractionEnabled = YES;
    }
}

#pragma mark - Setter
- (void)setBonusesPrice:(NSString *)bonusesPrice{
    _bonusesPrice = bonusesPrice;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@", _bonusesPrice];
}

- (void)setPayeeAccount:(NSString *)payeeAccount{
    _payeeAccount = payeeAccount;
    if ([_payeeAccount isEqualToString:@""] || _payeeAccount == nil) {
        self.aliImgView.image = LoadImage(@"icon_alipay1");
    }else{
        self.aliImgView.image = LoadImage(@"icon_alipay2");
    }
}



@end
