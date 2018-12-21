//
//  XWSecDepartmentViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWSecDepartmentViewController.h"
#import "XWOrgManagerCell.h"
#import "XWSelectTableCell.h"
#import "XWDepartmentBottomView.h"
#import "XWDepartmentTitleView.h"
#import "XWDepartmentManagerViewController.h"
#import "XWOrgTwoBottomView.h"
#import "XWAddDepartmentViewController.h"
#import "XWAddStudentViewController.h"
#import "XWDepartmentSetViewController.h"
#import "XWStaffInfoViewController.h"
#import "XWChoiceBottomView.h"
#import "XWChoiceDiscountViewController.h"

static NSString *const XWOrgManagerCellID = @"XWOrgManagerCellID";
static NSString *const XWSelectTableCellID = @"XWSelectTableCellID";


@interface XWSecDepartmentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XWDepartmentBottomView *bottomView;
@property (nonatomic, strong) XWDepartmentListModel *model;
@property (nonatomic, strong) XWDepartmentModel *department;
@property (nonatomic, strong) XWDepartmentTitleView *titleView;
@property (nonatomic, strong) XWOrgTwoBottomView *bottomTwoView;
@property (nonatomic, assign) BOOL isChoiceStatus;
@property (nonatomic, strong) XWChoiceBottomView *choiceView;

@end

@implementation XWSecDepartmentViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, kWidth, kHeight-100-kNaviBarH) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 55;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWOrgManagerCell" bundle:nil] forCellReuseIdentifier:XWOrgManagerCellID];
        [table registerNib:[UINib nibWithNibName:@"XWSelectTableCell" bundle:nil] forCellReuseIdentifier:XWSelectTableCellID];
        table.backgroundColor = [UIColor whiteColor];
        _tableView = table;
        
    }
    return _tableView;
}

- (XWDepartmentBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[XWDepartmentBottomView alloc] initWithFrame:CGRectMake(0, kHeight-50-kNaviBarH, kWidth, 50) titles:@[@"添加部门", @"添加学员", @"赠送奖学金"]];
        XWWeakSelf
        // 添加部门
        _bottomView.leftBlock = ^{
            XWAddDepartmentViewController *vc = [[XWAddDepartmentViewController alloc] init];
            vc.name = weakSelf.department.department_name;
            vc.pid = weakSelf.department.oid;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        // 添加学员
        _bottomView.midBlock = ^{
            XWAddStudentViewController *vc = [[XWAddStudentViewController alloc] init];
            vc.department_name = weakSelf.department.department_name;
            vc.oid = weakSelf.department.oid;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        // 赠送奖学金
        
        _bottomView.rightBlock = ^{
            weakSelf.isChoiceStatus = YES;
        };
    }
    return _bottomView;
}

- (XWOrgTwoBottomView *)bottomTwoView {
    if (!_bottomTwoView) {
        _bottomTwoView = [[XWOrgTwoBottomView alloc] initWithFrame:CGRectMake(0, kHeight-50-kNaviBarH, kWidth, 50) titleArrays:@[ @"添加学员", @"赠送奖学金"]];
        XWWeakSelf
        // 添加学员
        _bottomTwoView.leftBlock = ^{
            XWAddStudentViewController *vc = [[XWAddStudentViewController alloc] init];
            vc.department_name = weakSelf.department.department_name;
            vc.oid = weakSelf.department.oid;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        // 赠送奖学金
        _bottomTwoView.rightBlock = ^{
            weakSelf.isChoiceStatus = YES;
        };
    }
    return _bottomTwoView;
}

- (XWChoiceBottomView *)choiceView {
    if (!_choiceView) {
        _choiceView = [[XWChoiceBottomView alloc] initWithFrame:CGRectMake(0, kHeight-50-kNaviBarH, kWidth, 50)];
        XWWeakSelf
        _choiceView.choiceBlock = ^(BOOL selected) { // 全选
            [weakSelf.model.userList enumerateObjectsUsingBlock:^(XWDepartmentUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.isSelect = selected;
            }];
            [weakSelf.tableView reloadData];
        };
        _choiceView.nextBlock = ^{ // 下一步
            __block NSMutableArray *userArray = [NSMutableArray array];
            [weakSelf.model.userList enumerateObjectsUsingBlock:^(XWDepartmentUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isSelect) {
                    [userArray addObject:obj.userId];
                }
            }];
            
            if (userArray.count == 0) {
                [MBProgressHUD showTipMessageInWindow:@"请选择人员"];
                return;
            }
            XWChoiceDiscountViewController *vc = [[XWChoiceDiscountViewController alloc] init];
            vc.userArray = userArray;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _choiceView;
}

- (XWDepartmentTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[XWDepartmentTitleView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
        XWWeakSelf
        _titleView.block = ^(XWChildrenDepartmentModel * _Nonnull child) {
            if ([child.pid isEqualToString:@"1"]) { // 跳回最上面那一层
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[XWDepartmentManagerViewController class]]) {
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                    }
                }
            }else {
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[XWSecDepartmentViewController class]]) {
                        XWSecDepartmentViewController *secVc = (XWSecDepartmentViewController *)vc;
                        if (secVc.oid == child.oid) {
                            [weakSelf.navigationController popToViewController:secVc animated:YES];
                        }
                    }
                }
            }
        };
    }
    return _titleView;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithTitle:@"部门设置" target:self method:@selector(rightBtnClick)];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.tableView];
    
    [self addNotificationWithName:@"DeleteStaffSuccess" selector:@selector(loadData)];
    [self addNotificationWithName:@"UpdateDepartmentList" selector:@selector(loadData)];
    [self addNotificationWithName:@"DeleteDepartmentSuccess" selector:@selector(loadData)];
    [self addNotificationWithName:@"ChangeDepartmentNameSuccess" selector:@selector(loadData)];
    [self addNotificationWithName:@"CreateUserSuccess" selector:@selector(loadData)];
}

- (void)loadData {
    XWWeakSelf
    [XWHttpTool getCompanyDepartmentWithCompanyID:kUserInfo.company_id dId:self.oid success:^(XWDepartmentListModel *dataModel) {
        weakSelf.model = dataModel;
        weakSelf.department = [dataModel.depeparList firstObject];
        [weakSelf drawUI];
    } failure:^(NSString *error) {
        
    }];
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - Setter
- (void)setIsChoiceStatus:(BOOL)isChoiceStatus {
    _isChoiceStatus = isChoiceStatus;
    
    if (_isChoiceStatus) { // 选择状态
        [self.view addSubview:self.choiceView];
    }else {
        [self.choiceView removeFromSuperview];
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - Custom Methods
- (void)rightBtnClick {
    XWDepartmentSetViewController *vc = [[XWDepartmentSetViewController alloc] init];
    vc.oid = self.department.oid;
    vc.name = self.department.department_name;
    vc.pid = self.department.pid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)drawUI {
    self.title = self.department.department_name;
    self.titleView.titles = self.model.Department;
    if (self.model.Department.count == 4) {
        [self.view addSubview:self.bottomTwoView];
    }else {
        [self.view addSubview:self.bottomView];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.department.children != nil && self.model.userList != nil) {
        if (self.isChoiceStatus) {
            return 1;
        }
        return 2;
    }
    if (self.department.children == nil && self.model.userList == nil) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.model.userList.count;
    }
    return self.department.children.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        XWOrgManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:XWOrgManagerCellID forIndexPath:indexPath];
        cell.isLast = indexPath.row == self.model.userList.count - 1;
        cell.user = self.model.userList[indexPath.row];
        return cell;
    }
    XWSelectTableCell * cell = [tableView dequeueReusableCellWithIdentifier:XWSelectTableCellID forIndexPath:indexPath];
    cell.hideRight = YES;
    cell.children = self.department.children[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.isChoiceStatus) {
            XWWeakSelf
            __block NSMutableArray *boolArray = [NSMutableArray array];
            __block NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.model.userList.count];
            [self.model.userList enumerateObjectsUsingBlock:^(XWDepartmentUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (indexPath.row == idx) {
                    obj.isSelect = !obj.isSelect;
                }
                [boolArray addObject:@(obj.isSelect)];
                [arr addObject:@(YES)];
            }];
            BOOL isSame = [self filterArr:boolArray andArr2:arr];
            [weakSelf postNotificationWithName:@"ChangeChoiceStatus" object:@(isSame)];
            
            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        XWDepartmentUserModel *user = self.model.userList[indexPath.row];
        XWStaffInfoViewController *vc = [[XWStaffInfoViewController alloc] init];
        vc.userId = user.userId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    XWSecDepartmentViewController *vc = [[XWSecDepartmentViewController alloc] init];
    XWChildrenDepartmentModel *children = self.department.children[indexPath.row];
    vc.oid = children.oid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15)];
        head.backgroundColor = Color(@"#F6F6F6");
        
        return head;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//比较两个数组中是否相等
- (BOOL)filterArr:(NSArray *)arr1 andArr2:(NSArray *)arr2 {
    if (arr1.count != arr2.count) {
        return NO;
    }else {
        int hasSame = 0;
        for (int i = 0; i < arr1.count; i++) {
            int value1 = [arr1[i] intValue];
            int value2 = [arr2[i] intValue];
            if (value1 == value2) {
                hasSame ++;
            }
        }
        if (hasSame < arr1.count) {
            return NO;
        }else {
            return YES;
        }
    }
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
