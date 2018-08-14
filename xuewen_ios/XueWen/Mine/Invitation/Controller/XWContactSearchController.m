//
//  XWContactSearchController.m
//  XueWen
//
//  Created by Karron Su on 2018/5/2.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWContactSearchController.h"
#import "ContactTabCell.h"
#import "ContactModel.h"
#import <MessageUI/MessageUI.h>

static NSString *const ContactTabCellID = @"ContactTabCellID";


@interface XWContactSearchController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MFMessageComposeViewControllerDelegate>

/** 搜索结果数据*/
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *searchField;

@end

@implementation XWContactSearchController

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kNaviBarH) style:UITableViewStylePlain];
        table.delegate = self;
        table.backgroundColor = Color(@"#EDEDED");
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerClass:[ContactTabCell class] forCellReuseIdentifier:ContactTabCellID];
        _tableView = table;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITextField *)searchField{
    if (!_searchField) {
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(15, kStasusBarH+3, kWidth-80, 30)];
        [field rounded:15];
        field.backgroundColor = Color(@"#EDEDED");
        field.placeholder = @"搜索名称/号码";
        field.font = [UIFont fontWithName:kRegFont size:12];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 28)];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 12, 12)];
        icon.image = LoadImage(@"icon_search");
        [leftView addSubview:icon];
        field.leftView = leftView;
        field.leftViewMode = UITextFieldViewModeAlways;
        [field leftViewRectForBounds:CGRectMake(5, 5, 20, 20)];
        field.delegate = self;
        field.returnKeyType = UIReturnKeySearch;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField = field;
    }
    return _searchField;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UI
- (void)initUI{
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchField];
    
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithTitle:@"取消" target:self method:@selector(cancelClick)];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.dataArray removeAllObjects];
    XWWeakSelf
    [self.searchArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContactModel *model = (ContactModel *)obj;
        if ([model.name containsString:textField.text] || [model.phoneNumber containsString:textField.text]) {
            [weakSelf.dataArray addObject:model];
        }
    }];
    [self.tableView reloadData];
    return YES;
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactTabCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactTabCellID forIndexPath:indexPath];
    cell.isMultiple = NO;
    cell.model = self.dataArray[indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] init];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactModel *model = self.dataArray[indexPath.row];
    NSMutableArray *array = [@[model] mutableCopy];
    [UIAlertController alertControllerTwo:self withTitle:@"分享学问App" withMessage:[NSString stringWithFormat:@"分享给%@", model.name] withConfirm:@"确定" withCancel:@"取消" actionConfirm:^{
        [self showMessageView:array];
    } actionCancel:^{
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 28)];
    bgView.backgroundColor = Color(@"#F4F4F4");
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont fontWithName:kRegFont size:14];
    label.textColor = Color(@"#2A2732");
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(15);
        make.centerY.mas_equalTo(bgView);
    }];
    label.text = @"最佳匹配";
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


#pragma mark - Action / Custom Methods

- (void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMessageView:(NSMutableArray *)phone {
    NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
    [phone enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContactModel *model = (ContactModel *)obj;
        [phoneArray addObject:model.phoneNumber];
    }];
    
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
    vc.body = [NSString stringWithFormat:@"千名权威专家让您工作更出色生活更精彩，注册送百元奖学金! 地址: %@", self.invitationURL];
    vc.recipients = phoneArray;
    vc.messageComposeDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultSent) {
        [MBProgressHUD showInfoMessage:@"发送成功"];
        
    }else if (result == MessageComposeResultCancelled){
        [MBProgressHUD showWarnMessage:@"用户取消发送"];
        
    }else{
        NSLog(@"发送失败");
    }
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
