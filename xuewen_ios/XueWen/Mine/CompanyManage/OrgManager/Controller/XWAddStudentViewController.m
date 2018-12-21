//
//  XWAddStudentViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWAddStudentViewController.h"
#import "XWOrgInputCell.h"
#import "XWSelectTableCell.h"
#import "XWChoiceLabelViewController.h"
#import "XWChoiceDepartmentViewController.h"
#import "XWDepartmentListModel.h"
#import "XWLabelModel.h"

static NSString *const XWOrgInputCellID = @"XWOrgInputCellID";
static NSString *const XWSelectTableCellID = @"XWSelectTableCellID";

@interface XWAddStudentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) XWChildrenDepartmentModel *department;
@property (nonatomic, strong) XWLabelModel *labelModel;

@end

@implementation XWAddStudentViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 55;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWOrgInputCell" bundle:nil] forCellReuseIdentifier:XWOrgInputCellID];
        [table registerNib:[UINib nibWithNibName:@"XWSelectTableCell" bundle:nil] forCellReuseIdentifier:XWSelectTableCellID];
        _tableView = table;
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        NSArray *title1 = @[@"姓名", @"电话", @"密码", @"岗位"];
        NSDictionary *dict1 = @{@"info" : title1};
        NSArray *title2 = @[@"部门", @"推荐课程"];
        NSDictionary *dict2 = @{@"choice" : title2};
        _dataArray = @[dict1, dict2];
    }
    return _dataArray;
}

- (NSMutableDictionary *)dataDict {
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

- (XWLabelModel *)labelModel {
    if (!_labelModel) {
        _labelModel = [[XWLabelModel alloc] init];
    }
    return _labelModel;
}

- (XWChildrenDepartmentModel *)department {
    if (!_department) {
        _department = [[XWChildrenDepartmentModel alloc] init];
        _department.department_name = self.department_name;
        _department.oid = self.oid;
    }
    return _department;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"新增学员";
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithTitle:@"完成" target:self method:@selector(rightBtnClick)];
    [self.view addSubview:self.tableView];
    
    [self addNotificationWithName:@"ChoiceLabelFinished" selector:@selector(choiceLabelFinish:)];
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - Custom Methods
- (void)rightBtnClick {
    NSString *name = self.dataDict[@"姓名"];
    NSString *phone = self.dataDict[@"电话"];
    NSString *password = self.dataDict[@"密码"];
    NSString *post = self.dataDict[@"岗位"];
    NSString *departmentId = self.department.oid;
    NSString *labelId = self.labelModel.labelId;
    
    if (name == nil || [name isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInWindow:@"请输入姓名"];
        return;
    }
    
    if (phone == nil || [phone isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInWindow:@"请输入电话"];
        return;
    }
    
    if (password == nil || [password isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInWindow:@"请输入密码"];
        return;
    }
    
    if (departmentId == nil || [departmentId isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInWindow:@"请选择部门"];
        return;
    }
    
    XWWeakSelf
    [XWHttpTool createUserWithName:name password:password phone:phone departmentId:departmentId lableId:labelId post:post success:^{
        [weakSelf postNotificationWithName:@"CreateUserSuccess" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [MBProgressHUD showTipMessageInWindow:error];
    }];
}

- (void)choiceLabelFinish:(NSNotification *)not {
    NSLog(@"not is %@", not);
    XWLabelModel *labelModel =  (XWLabelModel *)not.object;
    self.labelModel = labelModel;
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 4) {
        XWOrgInputCell * cell = [tableView dequeueReusableCellWithIdentifier:XWOrgInputCellID forIndexPath:indexPath];
        __block NSString *title = self.dataArray[0][@"info"][indexPath.row];
        cell.title = title;
        XWWeakSelf
        cell.block = ^(NSDictionary * _Nonnull dict) {
            NSString *value = dict[title];
            [weakSelf.dataDict setObject:value forKey:title];
        };
        return cell;
    }
    
    XWSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWSelectTableCellID forIndexPath:indexPath];
    cell.title = self.dataArray[1][@"choice"][indexPath.row-4];
    if (indexPath.row == 4) {
        cell.departmentName = self.department.department_name;
    }else {
        cell.departmentName = self.labelModel.label_name;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 5) {
        XWChoiceLabelViewController *vc = [[XWChoiceLabelViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row == 4) {
        XWChoiceDepartmentViewController *vc = [[XWChoiceDepartmentViewController alloc] init];
        XWWeakSelf
        vc.block = ^(XWChildrenDepartmentModel * _Nonnull model) {
            weakSelf.department = model;
            [weakSelf.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
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
