//
//  XWStaffInfoViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWStaffInfoViewController.h"
#import "XWStaffHeaderView.h"
#import "XWStaffFooterView.h"
#import "XWStaffTableCell.h"
#import "XWStaffInfoModel.h"
#import "XWStaffSetViewController.h"
#import "XWChoiceLabelViewController.h"
#import "XWChoiceDepartmentViewController.h"
#import "XWLabelModel.h"
#import "XWDepartmentListModel.h"
#import "XWSexSetViewController.h"
#import "XWGiveCouponView.h"

static NSString *const XWStaffTableCellID = @"XWStaffTableCellID";


@interface XWStaffInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XWStaffHeaderView *headerView;
@property (nonatomic, strong) XWStaffFooterView *footerView;
@property (nonatomic, strong) XWStaffInfoModel *model;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation XWStaffInfoViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 60;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.backgroundColor = [UIColor whiteColor];
        table.tableHeaderView = self.headerView;
        table.tableFooterView = self.footerView;
        [table registerNib:[UINib nibWithNibName:@"XWStaffTableCell" bundle:nil] forCellReuseIdentifier:XWStaffTableCellID];
        _tableView = table;
    }
    return _tableView;
}

- (XWStaffHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XWStaffHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 116)];
        XWWeakSelf
        _headerView.block = ^{
            XWGiveCouponView *couponView = [[XWGiveCouponView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) toUserId:weakSelf.model.userId];
            [kMainWindow addSubview:couponView];
        };
    }
    return _headerView;
}

- (XWStaffFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[XWStaffFooterView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
        XWWeakSelf
        _footerView.block = ^{
            [XWHttpTool updateUserInfoWithKey:@"company_id" value:@"0" userId:weakSelf.model.userId success:^{
                [weakSelf postNotificationWithName:@"DeleteStaffSuccess" object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *error) {
                [MBProgressHUD showTipMessageInWindow:error];
            }];
        };
    }
    return _footerView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"联系方式", @"部门", @"账号", @"性别", @"推荐课程"];
    }
    return _dataArray;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"员工详情";
    [self.view addSubview:self.tableView];
    [self addNotificationWithName:@"ChoiceLabelFinished" selector:@selector(choiceLabelFinish:)];
    [self addNotificationWithName:@"UpdateUserInfoSuccess" selector:@selector(loadData)];
}

- (void)loadData {
    XWWeakSelf
    [XWHttpTool getStaffInfoWithUserId:self.userId success:^(XWStaffInfoModel *model) {
        weakSelf.model = model;
        NSString *sex;
        if ([model.sex isEqualToString:@"1"]) {
            sex = @"男";
        }else {
            sex = @"女";
        }
        weakSelf.dataSource = [@[model.phone, model.department_name, model.nick_name, sex, model.label_name] mutableCopy];
        weakSelf.headerView.model = model;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [MBProgressHUD showTipMessageInWindow:error];
    }];
}

#pragma mark - Custom Methods
- (void)choiceLabelFinish:(NSNotification *)not {
    XWLabelModel *labelModel =  (XWLabelModel *)not.object;
    XWWeakSelf
    [XWHttpTool updateUserInfoWithKey:@"lable_id" value:labelModel.labelId userId:self.model.userId success:^{
        [weakSelf loadData];
    } failure:^(NSString *error) {
        [MBProgressHUD showTipMessageInWindow:error];
    }];
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
    
    XWStaffTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWStaffTableCellID forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    if (self.dataSource.count != 0) {
        cell.name = self.dataSource[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) { // 跳转到选择部门
        XWChoiceDepartmentViewController *vc = [[XWChoiceDepartmentViewController alloc] init];
        XWWeakSelf
        vc.block = ^(XWChildrenDepartmentModel * _Nonnull model) {
            [XWHttpTool updateUserInfoWithKey:@"department_id" value:model.oid userId:self.model.userId success:^{
                [weakSelf loadData];
            } failure:^(NSString *error) {
                [MBProgressHUD showTipMessageInWindow:error];
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row == 4) { // 跳转到选择推荐课程
        XWChoiceLabelViewController *vc = [[XWChoiceLabelViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row == 3) { // 跳转到选择性别
        XWSexSetViewController *vc = [[XWSexSetViewController alloc] init];
        XWWeakSelf
        vc.sexBlock = ^(NSString * _Nonnull sex) {
            [XWHttpTool updateUserInfoWithKey:@"sex" value:sex userId:self.model.userId success:^{
                [weakSelf loadData];
            } failure:^(NSString *error) {
                [MBProgressHUD showTipMessageInWindow:error];
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    XWStaffSetViewController *vc = [[XWStaffSetViewController alloc] init];
    vc.title = self.dataArray[indexPath.row];
    vc.userId = self.model.userId;
    vc.plachor = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
