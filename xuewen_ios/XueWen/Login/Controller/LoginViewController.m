//
//  LoginViewController.m
//  XueWen
//
//  Created by Pingzi on 2017/11/14.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "LoginViewController.h"
#import "ReactiveObjC.h"
#import "RACEXTScope.h"
#import "HomeTabController.h"
#import "RegistViewController.h"
#import "MainNavigationViewController.h"
@interface LoginViewController ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@end

@implementation LoginViewController

#pragma mark - --- Life Cycle ---

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)dealloc
{
    NSLog(@"%s DEALLOC",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - --- Custom Method ---
- (IBAction)registerAction:(id)sender {
    [self presentViewController:[[MainNavigationViewController alloc] initWithRootViewController:[[RegistViewController alloc] initWithType:1]] animated:YES completion:nil];
}

- (IBAction)forgetPassword:(id)sender{
    [self presentViewController:[[MainNavigationViewController alloc] initWithRootViewController:[[RegistViewController alloc] initWithType:2]] animated:YES completion:nil];
}

- (IBAction)LoginClick:(UIButton *)sender{
    [self.view endEditing:YES];
    [XWNetworking loginWithAccount:_accountField.text password:_passwordField.text completionBlock:^(NSString *status) {
        if ([status isEqualToString:@"登陆成功"]) {
            [MBProgressHUD showSuccessMessage:status];
        }else{
            [MBProgressHUD showErrorMessage:status];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([status isEqualToString:@"登陆成功"]) {
                [UIApplication sharedApplication].keyWindow.rootViewController = [HomeTabController new];
            }
        });
    }];
}

- (void)initUI
{
    ViewRadius(self.iconImgV, 15);
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    
    ViewRadius(self.LoginBtn, 2);
    
    //聚合信号 (登录按钮可否点击，颜色改变)
    RACSignal *nameSnal = [self.accountField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(!IsEmptyString(value));
    }];
    RACSignal *passSnal = [self.passwordField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(!IsEmptyString(value));
    }];
    
    
    RACSignal *combineSnal = [RACSignal combineLatest:@[nameSnal,passSnal] reduce:^id _Nullable(NSNumber *nameValid, NSNumber *passValid){
        return @([nameValid boolValue] && [passValid boolValue]);
    }];
    @weakify(self)
    [combineSnal subscribeNext:^(NSNumber *Valid) {
        @strongify(self)
        if ([Valid boolValue]){
            self.LoginBtn.enabled = YES;
            [self.LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else{
            self.LoginBtn.enabled = NO;
            [self.LoginBtn setTitleColor:ColorA(255, 255, 255, 0.2) forState:UIControlStateNormal];
        }
    }];
}
#pragma mark - --- UINavigationControllerDelegate ---

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}




@end
