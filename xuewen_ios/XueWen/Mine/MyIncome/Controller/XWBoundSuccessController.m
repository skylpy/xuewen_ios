//
//  XWBoundSuccessController.m
//  XueWen
//
//  Created by Karron Su on 2018/9/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBoundSuccessController.h"

@interface XWBoundSuccessController ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bigImgView;
@property (nonatomic, strong) UILabel *successLab;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *aliNormalLab;
@property (nonatomic, strong) UILabel *priceNormalLab;
@property (nonatomic, strong) UILabel *dateNormalLab;
@property (nonatomic, strong) UILabel *accountLab;
@property (nonatomic, strong) UILabel *amountLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIButton *completeBtn;

@end

@implementation XWBoundSuccessController

#pragma mark - Getter
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)bigImgView{
    if (!_bigImgView) {
        _bigImgView = [[UIImageView alloc] initWithImage:LoadImage(@"icon_ok")];
    }
    return _bigImgView;
}

- (UILabel *)successLab{
    if (!_successLab) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"申请成功";
        lab.textColor = Color(@"#666666");
        lab.font = [UIFont fontWithName:kMedFont size:13];
        _successLab = lab;
    }
    return _successLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color(@"#F0EFEF");
    }
    return _lineView;
}

- (UILabel *)aliNormalLab{
    if (!_aliNormalLab) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"支付宝";
        lab.textColor = Color(@"#666666");
        lab.font = [UIFont fontWithName:kMedFont size:12];
        _aliNormalLab = lab;
    }
    return _aliNormalLab;
}

- (UILabel *)priceNormalLab{
    if (!_priceNormalLab) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"提现金额";
        lab.textColor = Color(@"#666666");
        lab.font = [UIFont fontWithName:kMedFont size:12];
        _priceNormalLab = lab;
    }
    return _priceNormalLab;
}

- (UILabel *)dateNormalLab{
    if (!_dateNormalLab) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"申请日期";
        lab.textColor = Color(@"#666666");
        lab.font = [UIFont fontWithName:kMedFont size:12];
        _dateNormalLab = lab;
    }
    return _dateNormalLab;
}

- (UILabel *)accountLab{
    if (!_accountLab) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"17636473467";
        lab.textColor = Color(@"#666666");
        lab.font = [UIFont fontWithName:kMedFont size:12];
        lab.textAlignment = NSTextAlignmentRight;
        _accountLab = lab;
    }
    return _accountLab;
}

- (UILabel *)amountLab{
    if (!_amountLab) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"¥4875.0";
        lab.textColor = Color(@"#666666");
        lab.font = [UIFont fontWithName:kMedFont size:12];
        lab.textAlignment = NSTextAlignmentRight;
        _amountLab = lab;
    }
    return _amountLab;
}

- (UILabel *)dateLab{
    if (!_dateLab) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"2018-09-11";
        lab.textColor = Color(@"#666666");
        lab.font = [UIFont fontWithName:kMedFont size:12];
        lab.textAlignment = NSTextAlignmentRight;
        _dateLab = lab;
    }
    return _dateLab;
}

- (UIButton *)completeBtn{
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:12];
        _completeBtn.backgroundColor = Color(@"#3E7EFF");
        [_completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_completeBtn rounded:15];
    }
    return _completeBtn;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.view.backgroundColor = Color(@"#F0EFEF");
    self.title = @"提现申请";
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.bigImgView];
    [self.bgView addSubview:self.successLab];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.aliNormalLab];
    [self.bgView addSubview:self.priceNormalLab];
    [self.bgView addSubview:self.dateNormalLab];
    [self.bgView addSubview:self.accountLab];
    [self.bgView addSubview:self.amountLab];
    [self.bgView addSubview:self.dateLab];
    [self.bgView addSubview:self.completeBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(10);
        make.height.mas_equalTo(277);
    }];
    
    [self.bigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView).offset(21);
        make.size.mas_equalTo(CGSizeMake(62, 62));
    }];
    
    [self.successLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.bigImgView.mas_bottom).offset(11);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(25);
        make.right.mas_equalTo(self.bgView).offset(-25);
        make.top.mas_equalTo(self.bgView).offset(134);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.aliNormalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(25);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
    }];
    
    [self.priceNormalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(25);
        make.top.mas_equalTo(self.aliNormalLab.mas_bottom).offset(3);
    }];
    
    [self.dateNormalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(25);
        make.top.mas_equalTo(self.priceNormalLab.mas_bottom).offset(3);
    }];
    
    [self.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView).offset(-25);
        make.centerY.mas_equalTo(self.aliNormalLab);
    }];
    
    [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView).offset(-25);
        make.centerY.mas_equalTo(self.priceNormalLab);
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView).offset(-25);
        make.centerY.mas_equalTo(self.dateNormalLab);
    }];
    
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(80);
        make.right.mas_equalTo(self.bgView).offset(-80);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.bgView).offset(-25);
    }];
    
    self.accountLab.text = self.model.payeeAccount;
    self.amountLab.text = [NSString stringWithFormat:@"¥%@", self.model.price];
    self.dateLab.text = self.model.time;
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

#pragma mark - Action
- (void)completeBtnClick{
    [self popToViewController:@"XWIncomeViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
