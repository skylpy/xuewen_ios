//
//  RegistViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/11/30.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
// 注册页面
#import "RegistViewController.h"
#import "AuthCodeButton.h"
#import "ReactiveObjC.h"
#import "SetPasswordViewController.h"
#import "MainNavigationViewController.h"
@interface RegistViewController ()
@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UITextField *authCodeTF;
@property (nonatomic, strong) AuthCodeButton *authCodeButton;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSMutableDictionary *authCodeDict;
@end

@implementation RegistViewController

#pragma mark- CustomMethod
- (void)sendAuthCodeAction{
    if (self.accountTF.text.length > 0) {
        WeakSelf;
        self.phone = self.accountTF.text;
        [XWNetworking getAuthCodeWithPhoneNumber:self.phone isRegister:(self.type == 1) completeBlock:^(NSString *authCode) {
            [weakSelf.authCodeDict setObject:[NSDate date] forKey:authCode];
            [weakSelf.authCodeButton startCountdown];
        }];
    }else{
        [MBProgressHUD showErrorMessage:@"手机号为空!"];
    }
    
}

- (void)nextAction:(UIButton *)sender{
    
    /** 先判断验证码是否有效，再判断验证码是否过期 */
    NSDate *date = self.authCodeDict[self.authCodeTF.text];
    if (date) {// date存在说明验证码正确，错误的验证码不能正确取出date
        NSDate *currentDate = [NSDate date];
        if ((currentDate.timeIntervalSince1970 - date.timeIntervalSince1970) <= 300) { //验证码300s有效期
            SetPasswordViewController *vc = [[SetPasswordViewController alloc] initWithType:self.type phone:self.phone code:self.authCodeTF.text];
            if (self.type == 3) {
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self presentViewController:[[MainNavigationViewController alloc] initWithRootViewController:vc] animated:YES completion:nil];
            }
        }
        
    }else{
        [MBProgressHUD showErrorMessage:@"验证码错误!"];
    }
}

- (void)loginAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backAction:(UIButton *)sender{
    if (self.type == 3) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)initUI{
    self.title = (self.type == 1) ? @"注册" : @"手机验证";
    self.view.backgroundColor = [UIColor whiteColor];
    // back
    UIButton *backButton = [UIButton buttonWithType:0];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    [backButton setImage:LoadImage(@"navBack") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.view addSubview:self.accountTF];
    [self.view addSubview:self.line1];
    [self.view addSubview:self.authCodeTF];
    [self.view addSubview:self.authCodeButton];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.loginButton];
    
    self.accountTF.sd_layout.topSpaceToView(self.view,110).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).heightIs(14);
    self.line1.sd_layout.topSpaceToView(self.accountTF,20).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).heightIs(0.5);
    self.authCodeButton.sd_layout.topSpaceToView(self.line1,20).rightSpaceToView(self.view,20).heightIs(14).widthIs(80);
    self.authCodeTF.sd_layout.topSpaceToView(self.line1,20).leftSpaceToView(self.view,20).rightSpaceToView(self.authCodeButton,10).heightIs(14);
    self.line2.sd_layout.topSpaceToView(self.authCodeTF,20).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).heightIs(0.5);
    self.nextButton.sd_layout.topSpaceToView(self.line2,20).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).heightIs(40);
    self.loginButton.sd_layout.topSpaceToView(self.nextButton,15).leftSpaceToView(self.view,20).heightIs(13).widthIs([self.loginButton.titleLabel.text widthWithSize:13]);
    
    
    self.loginButton.hidden = self.type == 3;
    
    //聚合信号 (登录按钮可否点击，颜色改变)
    RACSignal *nameSnal = [self.accountTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(!IsEmptyString(value));
    }];
    RACSignal *passSnal = [self.authCodeTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @((value.length >= 4));
    }];
    
    RACSignal *combineSnal = [RACSignal combineLatest:@[nameSnal,passSnal] reduce:^id _Nullable(NSNumber *nameValid, NSNumber *passValid){
        return @([nameValid boolValue] && [passValid boolValue]);
    }];
    WeakSelf;
    [combineSnal subscribeNext:^(NSNumber *Valid) {
        if ([Valid boolValue]){
            weakSelf.nextButton.enabled = YES;
            [weakSelf.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else{
            weakSelf.nextButton.enabled = NO;
            [weakSelf.nextButton setTitleColor:ColorA(255, 255, 255, 0.2) forState:UIControlStateNormal];
        }
    }];
}

#pragma mark- Getter
- (UITextField *)accountTF{
    if (!_accountTF) {
        _accountTF = [UITextField new];
        _accountTF.placeholder = @"输入手机号";
        _accountTF.font = kFontSize(14);
        _accountTF.textColor = DefaultTitleAColor;
    }
    return _accountTF;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [UIView new];
        _line1.backgroundColor = COLOR(221, 221, 221);
    }
    return _line1;
}

- (UITextField *)authCodeTF{
    if (!_authCodeTF) {
        _authCodeTF = [UITextField new];
        _authCodeTF.placeholder = @"输入短信验证码";
        _authCodeTF.font = kFontSize(14);
        _authCodeTF.textColor = DefaultTitleAColor;
    }
    return _authCodeTF;
}

- (AuthCodeButton *)authCodeButton{
    if (!_authCodeButton) {
        _authCodeButton = [AuthCodeButton authCodeButtonWithTarget:self SendAction:@selector(sendAuthCodeAction)];
    }
    return _authCodeButton;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [UIView new];
        _line2.backgroundColor = COLOR(221, 221, 221);
    }
    return _line2;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:0];
        _nextButton.backgroundColor = kThemeColor;
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        _nextButton.titleLabel.font = kFontSize(15);
        [_nextButton setTitleColor:ColorA(255, 255, 255, 0.2) forState:UIControlStateHighlighted];
        [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        ViewRadius(_nextButton, 1);
    }
    return _nextButton;
}

- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:0];
        [_loginButton setTitle:@"已有账号 去登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        [_loginButton setTitleColor:COLOR(153, 153, 153) forState:UIControlStateHighlighted];
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = kFontSize(13);
    }
    return _loginButton;
}

- (NSMutableDictionary *)authCodeDict{
    if (!_authCodeDict) {
        _authCodeDict = [NSMutableDictionary dictionary];
    }
    return _authCodeDict;
}

#pragma mark- Setter

- (void)loadData{
    
}

#pragma mark- LifeCycle
- (instancetype)initWithType:(NSInteger)type{
    if (self = [super init]) {
        self.type = type;
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
