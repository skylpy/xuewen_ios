//
//  XWChoiceDiscountViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/15.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWChoiceDiscountViewController.h"
#import "XWDiscountTableCell.h"

static NSString *const XWDiscountTableCellID = @"XWDiscountTableCellID";

@interface XWChoiceDiscountViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation XWChoiceDiscountViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-50-kNaviBarH) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 113;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.backgroundColor = Color(@"#F6F6F6");
        [table registerNib:[UINib nibWithNibName:@"XWDiscountTableCell" bundle:nil] forCellReuseIdentifier:XWDiscountTableCellID];
        _tableView = table;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = Color(@"#DDDDDD");
    }
    return _line;
}

- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [[UITextField alloc] init];
        _inputField.borderStyle = UITextBorderStyleNone;
        _inputField.backgroundColor = [UIColor whiteColor];
        _inputField.placeholder = @"请输入金额...";
        _inputField.font = [UIFont systemFontOfSize:15];
        _inputField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _inputField;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = Color(@"#3975EA");
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn rounded:2];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        @weakify(self)
        [[_sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            NSString *userId = [self.userArray componentsJoinedByString:@","];
            NSLog(@"userid is %@", userId);
            __block NSString *coupon_id;
            [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XWDiscountModel *model = (XWDiscountModel *)obj;
                if (model.isSelect) {
                    coupon_id = model.couponId;
                    *stop = YES;
                }
            }];
            if (coupon_id == nil || [coupon_id isEqualToString:@""]) {
                [MBProgressHUD showTipMessageInWindow:@"请选择优惠券"];
                return;
            }
            NSLog(@"coupon_id is %@", coupon_id);
            if (self.inputField.text == nil || [self.inputField.text isEqualToString:@""]) {
                [MBProgressHUD showTipMessageInWindow:@"请输入赠送金额"];
                return;
            }
            
            [XWHttpTool giveCouponWithUserID:userId couponId:coupon_id couponPrice:self.inputField.text success:^{
                [MBProgressHUD showTipMessageInWindow:@"赠送成功"];
            } failure:^(NSString *error) {
                [MBProgressHUD showTipMessageInWindow:error];
            }];
            
        }];
    }
    return _sureBtn;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"选择优惠券";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.line];
    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.inputField];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 38));
        make.bottom.mas_equalTo(self.view).offset(-6);
        make.right.mas_equalTo(self.view).offset(-15);
    }];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.height.mas_equalTo(49);
        make.bottom.mas_equalTo(self.view);
        make.right.mas_equalTo(self.sureBtn.mas_left).offset(-10);
    }];
}

- (void)loadData {
    XWWeakSelf
    [XWHttpTool getDiscountListSuccess:^(NSMutableArray *dataSource) {
        weakSelf.dataSource = dataSource;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [MBProgressHUD showTipMessageInWindow:error];
    }];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 113;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWDiscountTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWDiscountTableCellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XWDiscountModel *model = (XWDiscountModel *)obj;
        model.isSelect = indexPath.row == idx;
    }];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
