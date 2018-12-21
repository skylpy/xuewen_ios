//
//  XWStaffSetViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWStaffSetViewController.h"


@interface XWStaffSetViewController ()

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation XWStaffSetViewController

#pragma mark - Getter
- (UITextField *)inputField {
    if (!_inputField) {
        UITextField *textfield = [[UITextField alloc] init];
        textfield.borderStyle = UITextBorderStyleNone;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.font = [UIFont systemFontOfSize:15];
        textfield.placeholder = self.plachor;
        _inputField = textfield;
    }
    return _inputField;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    
    self.view.backgroundColor = Color(@"#F6F6F6");
    
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithTitle:@"完成" target:self method:@selector(rightBtnClick)];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.inputField];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(15);
        make.top.bottom.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.bgView).offset(-15);
    }];
}

- (void)rightBtnClick {
    if (self.inputField.text == nil) {
        [MBProgressHUD showTipMessageInWindow:@"请输入修改内容"];
        return;
    }
    
    NSString *key;
    if ([self.title isEqualToString:@"联系方式"]) {
        key = @"phone";
    }else if ([self.title isEqualToString:@"账号"]) {
        key = @"nick_name";
    }
    
    XWWeakSelf
    [XWHttpTool updateUserInfoWithKey:key value:self.inputField.text userId:self.userId success:^{
        [weakSelf postNotificationWithName:@"UpdateUserInfoSuccess" object:nil];
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
