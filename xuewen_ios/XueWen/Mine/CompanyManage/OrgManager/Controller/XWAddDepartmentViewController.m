//
//  XWAddDepartmentViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWAddDepartmentViewController.h"

@interface XWAddDepartmentViewController ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *departmentNameLabel;
@property (nonatomic, strong) UILabel *pdepartmentNameLabel;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UILabel *pdepartmentLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation XWAddDepartmentViewController

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 111)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)departmentNameLabel {
    if (!_departmentNameLabel) {
        _departmentNameLabel = [UILabel createALabelText:@"部门名称" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#333333")];
    }
    return _departmentNameLabel;
}

- (UILabel *)pdepartmentNameLabel {
    if (!_pdepartmentNameLabel) {
        _pdepartmentNameLabel = [UILabel createALabelText:@"上级部门" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#333333")];
    }
    return _pdepartmentNameLabel;
}

- (UITextField *)nameField {
    if (!_nameField) {
        UITextField *text = [[UITextField alloc] init];
        text.borderStyle = UITextBorderStyleNone;
        text.placeholder = @"必填";
        text.font = [UIFont fontWithName:kRegFont size:15];
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField = text;
    }
    return _nameField;
}

- (UILabel *)pdepartmentLabel {
    if (!_pdepartmentLabel) {
        _pdepartmentLabel = [UILabel createALabelText:self.name withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#999999")];
        _pdepartmentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _pdepartmentLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = Color(@"#F6F6F6");
    }
    return _line;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"添加部门";
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithTitle:@"完成" target:self method:@selector(rightBtnClick)];
    self.view.backgroundColor = Color(@"#F6F6F6");
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.departmentNameLabel];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.pdepartmentNameLabel];
    [self.bgView addSubview:self.nameField];
    [self.bgView addSubview:self.pdepartmentLabel];
    
    [self.departmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(15);
        make.top.mas_equalTo(self.bgView).offset(16);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgView);
        make.centerY.mas_equalTo(self.bgView);
        make.height.mas_equalTo(1);
    }];
    
    [self.pdepartmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(15);
        make.bottom.mas_equalTo(self.bgView).offset(-16);
    }];
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.departmentNameLabel);
        make.left.mas_equalTo(self.bgView).offset(90);
        make.right.mas_equalTo(self.bgView).offset(-15);
    }];
    
    [self.pdepartmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.pdepartmentNameLabel);
        make.right.mas_equalTo(self.bgView).offset(-15);
    }];
}



#pragma mark - Custom Methods
- (void)rightBtnClick {
    if (self.nameField.text == nil || [self.nameField.text isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInWindow:@"请输入部门名称"];
        return;
    }
    
    XWWeakSelf
    [XWHttpTool addDepartmentWithName:self.nameField.text pid:self.pid success:^{
        [weakSelf postNotificationWithName:@"UpdateDepartmentList" object:nil];
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
