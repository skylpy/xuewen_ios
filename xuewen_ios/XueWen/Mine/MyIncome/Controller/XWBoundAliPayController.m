//
//  XWBoundAliPayController.m
//  XueWen
//
//  Created by Karron Su on 2018/9/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBoundAliPayController.h"

@interface XWBoundAliPayController ()

@property (nonatomic, strong) UIImageView *bigImgView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation XWBoundAliPayController

#pragma mark - Getter
- (UIImageView *)bigImgView{
    if (!_bigImgView) {
        _bigImgView = [[UIImageView alloc] initWithImage:LoadImage(@"icon_alipay")];
    }
    return _bigImgView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"请输入您的支付宝账号进行绑定，每个账号只能绑定一个支付宝账号，同一个支付宝不能同时绑定多个账号。";
        _tipLabel.textColor = Color(@"#CCCCCC");
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.font = [UIFont fontWithName:kMedFont size:11];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.placeholder = @"输入支付宝账号";
        _textField.font = [UIFont fontWithName:kMedFont size:12];
        _textField.textAlignment = NSTextAlignmentCenter;
        [_textField border:1 color:Color(@"#cccccc")];
    }
    return _textField;
}

- (UITextField *)nameField{
    if (!_nameField) {
        _nameField = [[UITextField alloc] init];
        _nameField.borderStyle = UITextBorderStyleNone;
        _nameField.placeholder = @"输入真实姓名";
        _nameField.font = [UIFont fontWithName:kMedFont size:12];
        _nameField.textAlignment = NSTextAlignmentCenter;
        [_nameField border:1 color:Color(@"#cccccc")];
    }
    return _nameField;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = Color(@"#3E7EFF");
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:Color(@"#FEFEFE") forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:13];
        [_sureBtn rounded:15];
        [_sureBtn addTarget:self action:@selector(sureBrnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.title = @"绑定支付宝";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bigImgView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.sureBtn];
    
    [self.bigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(83);
        make.size.mas_equalTo(CGSizeMake(78, 78));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.bigImgView.mas_bottom).offset(60);
        make.left.mas_equalTo(self.view).offset(25);
        make.right.mas_equalTo(self.view).offset(-25);
    }];
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(32);
        make.left.mas_equalTo(self.view).offset(43);
        make.right.mas_equalTo(self.view).offset(-43);
        make.height.mas_equalTo(30);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.nameField.mas_bottom).offset(22);
        make.left.mas_equalTo(self.view).offset(43);
        make.right.mas_equalTo(self.view).offset(-43);
        make.height.mas_equalTo(30);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(80);
        make.right.mas_equalTo(self.view).offset(-80);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(30);
    }];
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

#pragma mark - Custom Action
- (void)sureBrnClick{
    if ([self.textField.text isEqualToString:@""] || self.textField.text == nil) {
        [MBProgressHUD showTipMessageInWindow:@"输入账号不能为空!"];
        return;
    }
    
    [XWHttpTool bindingAccountWithAccount:self.textField.text realName:self.nameField.text success:^{
        [UIAlertController alertControllerSingle:self withTitle:nil withMessage:@"绑定成功!" withConfirm:@"确定" actionConfirm:^{
            [self postNotificationWithName:@"BindingAccountSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSString *errorInfo) {
        [UIAlertController alertControllerSingle:self withTitle:nil withMessage:@"绑定失败!" withConfirm:@"确定" actionConfirm:^{
            
        }];
    }];
    
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
