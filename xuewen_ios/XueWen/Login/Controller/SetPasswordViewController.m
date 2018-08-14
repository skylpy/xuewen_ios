//
//  SetPasswordViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/1.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "ReactiveObjC.h"
#import "NSString+Regular.h"
@interface SetPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UITextField *password1TF;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UITextField *password2TF;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *phone;
@end

@implementation SetPasswordViewController
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *mStr = [NSMutableString stringWithString:textField.text];
    [mStr replaceCharactersInRange:range withString:string];
    return (mStr.length <= 12);
}

- (void)completeAction:(UIButton *)sender{
    if ([self.password1TF.text isEqualToString:self.password2TF.text]) {
        if (self.password1TF.text.length >= 6) {
            if ([self.password1TF.text isValidateByRegex:@"^[A-Za-z0-9]+$"]) {
                XWWeakSelf
                if (self.type == 3) {
                    [XWNetworking setPersonalInfoWithParam:@{@"password":self.password1TF.text,@"code":self.code} completionBlock:^(NSString *status) {
                        if ([status isEqualToString:Succeed]) {
                            [MBProgressHUD showSuccessMessage:@"修改成功" completionBlock:^{
                                [weakSelf dismiss];
                            }];
                        }else{
                            [MBProgressHUD showErrorMessage:status];
                        }
                        
                    }];
                }else{
                    [XWNetworking registWithPhone:self.phone password:self.password1TF.text code:self.code regist:(self.type == 1) completeBlock:^(BOOL succeed,NSString *status) {
                        if (succeed) {
                            [MBProgressHUD showSuccessMessage:status completionBlock:^{
                                [weakSelf dismiss];
                            }];
                            
                        }else{
                            [MBProgressHUD showErrorMessage:status];
                        }
                    }];
                }
            }else{
                [MBProgressHUD showErrorMessage:@"密码只能由数字和字母组成"];
            }
        }else{
            [MBProgressHUD showErrorMessage:@"密码至少为六位"];
        }
    }else{
        [MBProgressHUD showErrorMessage:@"两次填写的密码不一致"];
    }
}

#pragma mark- CustomMethod
- (void)initUI{
    if (self.type == 1) {
        self.title = @"注册";
    }else if (self.type == 2){
        self.title = @"重置密码";
    }else{
        self.title = @"修改密码";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    // back
    UIButton *backButton = [UIButton buttonWithType:0];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setImage:LoadImage(@"navBack") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.view addSubview:self.password1TF];
    [self.view addSubview:self.line1];
    [self.view addSubview:self.password2TF];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.completeButton];
    
    self.password1TF.sd_layout.topSpaceToView(self.view,108).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).heightIs(14);
    self.line1.sd_layout.topSpaceToView(self.password1TF,20).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).heightIs(0.5);
    self.password2TF.sd_layout.topSpaceToView(self.line1,20).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).heightIs(14);
    self.line2.sd_layout.topSpaceToView(self.password2TF,20).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).heightIs(0.5);
    self.completeButton.sd_layout.topSpaceToView(self.line2,20).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).heightIs(40);
    
    // 聚合信号 (完成按钮可否点击，颜色改变)
    RACSignal *signal1 = [self.password1TF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return value;
    }];
    RACSignal *signal2 = [self.password2TF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return value;
    }];
    RACSignal *combineSnal = [RACSignal combineLatest:@[signal1,signal2] reduce:^id _Nullable(NSString *str1 , NSString *str2){
        return @([str1 isEqualToString:str2] && str1.length >= 6);
    }];
    WeakSelf;
    [combineSnal subscribeNext:^(NSNumber *valid) {
        if ([valid boolValue]){
            weakSelf.completeButton.enabled = YES;
            [weakSelf.completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else{
            weakSelf.completeButton.enabled = NO;
            [weakSelf.completeButton setTitleColor:ColorA(255, 255, 255, 0.2) forState:UIControlStateNormal];
        }
    }];
    
}

- (void)loadData{
    
}

- (void)backAction:(UIButton *)sender{
    if (self.type == 3) {
        for ( id viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:NSClassFromString(@"SettingViewController")]) {
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
    }else{
        [self dismiss];
    }
}

- (void)dismiss{
    if (self.type == 3) {
        /** 修改/重置密码后直接跳到登录界面 */
        [[XWInstance shareInstance] logout];
    }else{
        [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark- Setter
#pragma mark- Getter
- (UITextField *)password1TF{
    if (!_password1TF) {
        _password1TF = [UITextField new];
        _password1TF.placeholder = (self.type == 1) ? @"创建密码" : @"设置新密码";
        _password1TF.font = kFontSize(14);
        _password1TF.textColor = DefaultTitleAColor;
        _password1TF.secureTextEntry = YES;
        _password1TF.delegate = self;
    }
    return _password1TF;
}

- (UITextField *)password2TF{
    if (!_password2TF) {
        _password2TF = [UITextField new];
        _password2TF.placeholder = @"确认密码";
        _password2TF.font = kFontSize(14);
        _password2TF.textColor = DefaultTitleAColor;
        _password2TF.secureTextEntry = YES;
        _password2TF.delegate = self;
    }
    return _password2TF;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [UIView new];
        _line1.backgroundColor = COLOR(221, 221, 221);
    }
    return _line1;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [UIView new];
        _line2.backgroundColor = COLOR(221, 221, 221);
    }
    return _line2;
}

- (UIButton *)completeButton{
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:0];
        _completeButton.backgroundColor = kThemeColor;
        ViewRadius(_completeButton, 1);
        [_completeButton setTitleColor:ColorA(225, 225, 225, 0.2) forState:UIControlStateHighlighted];
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        _completeButton.titleLabel.font = kFontSize(15);
        [_completeButton addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

#pragma mark- LifeCycle
- (instancetype)initWithType:(NSInteger)type phone:(NSString *)phone code:(NSString *)code{
    if (self = [super init]) {
        self.type = type;
        self.phone = phone;
        self.code = code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
