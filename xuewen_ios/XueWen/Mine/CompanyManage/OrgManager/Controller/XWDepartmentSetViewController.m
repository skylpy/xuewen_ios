//
//  XWDepartmentSetViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWDepartmentSetViewController.h"
#import "XWSecDepartmentViewController.h"
#import "XWDepartmentManagerViewController.h"

@interface XWDepartmentSetViewController ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation XWDepartmentSetViewController

#pragma mark - Getter
- (UITextField *)inputField {
    if (!_inputField) {
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, kWidth-30, 55)];
        text.borderStyle = UITextBorderStyleNone;
        text.backgroundColor = [UIColor whiteColor];
        text.placeholder = self.name;
        text.font = [UIFont systemFontOfSize:15];
        _inputField = text;
    }
    return _inputField;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除部门" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:Color(@"#FD4743") forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        [_deleteBtn rounded:2 width:1 color:Color(@"#DDDDDD")];
        @weakify(self)
        [[_deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [UIAlertController alertControllerTwo:self withTitle:@"您确认要删除部门吗？" withMessage:@"" withConfirm:@"取消" withCancel:@"确定" actionConfirm:nil actionCancel:^{
                [XWHttpTool deleteDepartmentWithId:self.oid success:^{
                    [self postNotificationWithName:@"DeleteDepartmentSuccess" object:nil];
                    if ([self.pid isEqualToString:@"1"]) { // 跳回最上面那一层
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[XWDepartmentManagerViewController class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    }else {
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[XWSecDepartmentViewController class]]) {
                                XWSecDepartmentViewController *secVc = (XWSecDepartmentViewController *)vc;
                                if (secVc.oid == self.pid) {
                                    [self.navigationController popToViewController:secVc animated:YES];
                                }
                            }
                        }
                    }
                    
                } failure:^(NSString *error) {
                    [MBProgressHUD showTipMessageInWindow:error];
                }];
            }];
        }];
    }
    return _deleteBtn;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"部门设置";
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithTitle:@"完成" target:self method:@selector(rightBtnClick)];
    
    self.view.backgroundColor = Color(@"#F6F6F6");
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.inputField];
    [self.view addSubview:self.deleteBtn];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.view).offset(80);
    }];
}

#pragma mark - Custom Methods
- (void)rightBtnClick {
    if (self.inputField.text == nil) {
        [MBProgressHUD showTipMessageInWindow:@"请输入部门名称"];
        return;
    }
    
    XWWeakSelf
    [XWHttpTool changeDepartmentWithId:self.oid name:self.inputField.text success:^{
        [weakSelf postNotificationWithName:@"ChangeDepartmentNameSuccess" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [MBProgressHUD showTipMessageInWindow:error];
    }];
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
