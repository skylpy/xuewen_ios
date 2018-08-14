//
//  InvitationCodeViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/25.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
// 我的邀请码界面
#import "InvitationCodeViewController.h"
#import "CompleteInfoViewController.h"
@interface InvitationCodeViewController ()

@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextField *inputTF;
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation InvitationCodeViewController
#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"我的邀请码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputView];
    [self.inputView addSubview:self.inputTF];
    [self.view addSubview:self.commitButton];
    
    self.commitButton.sd_layout.topSpaceToView(self.view,26).rightSpaceToView(self.view,15).widthIs(70).heightIs(44);
    self.inputView.sd_layout.topEqualToView(self.commitButton).leftSpaceToView(self.view,15).heightIs(44).rightSpaceToView(self.commitButton,15);
    self.inputTF.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 10, 0, 10));
}

- (void)loadData{
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

- (void)commitAction:(UIButton *)sender{
    [self.view endEditing:YES];
    // 2018.03.20：填完邀请码后(如果没有填写姓名)跳转到一个补全资料的界面
    NSString *name = kUserInfo.name;
    if (name.length > 0) {
        WeakSelf;
        [XWNetworking invitationAccessWithCode:self.inputTF.text completionBlock:^(BOOL succeed) {
            if (succeed) {
                [XWNetworking getAccountInfoWithCompletionBlock:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        if (self.inputTF.text.length > 0) {
            [self.navigationController pushViewController:[[CompleteInfoViewController alloc] initWithInvationCode:self.inputTF.text] animated:YES];
        }else{
            [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"请输入有效的邀请码" buttonTitle:@"好的" buttonBlock:nil];
        }
    }
}
#pragma mark- Setter
#pragma mark- Getter
- (UITextField *)inputTF{
    if (!_inputTF) {
        _inputTF = [UITextField textFieldWithTextColor:DefaultTitleAColor size:14 placeholder:@"请输入组织邀请码"];
    }
    return _inputTF;
}

- (UIButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:0];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_commitButton setBackgroundColor:kThemeColor];
        [_commitButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
        _commitButton.titleLabel.font = kFontSize(14);
        ViewRadius(_commitButton, 1);
    }
    return _commitButton;
}

- (UIView *)inputView{
    if (!_inputView) {
        _inputView = [UIView new];
        _inputView.layer.borderWidth = 1;
        _inputView.layer.borderColor = COLOR(204, 204, 204).CGColor;
    }
    return _inputView;
}
#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Analytics event:EventMyInvitation label:nil];
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
