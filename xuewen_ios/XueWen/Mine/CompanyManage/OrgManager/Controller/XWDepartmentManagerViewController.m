//
//  XWDepartmentManagerViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWDepartmentManagerViewController.h"
#import "XWDepartmentHeaderView.h"
#import "XWOrgManagerCell.h"
#import "XWOrgManagerCell.h"
#import "XWDepartmentCell.h"
#import "XWDepartmentListModel.h"
#import "XWOrgTwoBottomView.h"
#import "XWAddDepartmentViewController.h"
#import "XWAddStudentViewController.h"
#import "XWSecDepartmentViewController.h"
#import "XWDepartmentManagerViewController.h"
#import "XWStaffInfoViewController.h"

static NSString *const XWOrgManagerCellID = @"XWOrgManagerCellID";
static NSString *const XWDepartmentCellID = @"XWDepartmentCellID";

@interface XWDepartmentManagerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XWDepartmentHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XWOrgTwoBottomView *bottomView;

@property (nonatomic, strong) XWDepartmentListModel *model;

@end

@implementation XWDepartmentManagerViewController

#pragma mark - Getter
- (XWDepartmentHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XWDepartmentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 70)];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kWidth, kHeight-kNaviBarH-70-50) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWOrgManagerCell" bundle:nil] forCellReuseIdentifier:XWOrgManagerCellID];
        [table registerNib:[UINib nibWithNibName:@"XWDepartmentCell" bundle:nil] forCellReuseIdentifier:XWDepartmentCellID];
        table.backgroundColor = [UIColor whiteColor];
        _tableView = table;
    }
    return _tableView;
}

- (XWOrgTwoBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[XWOrgTwoBottomView alloc] initWithFrame:CGRectMake(0, kHeight - 50 - kNaviBarH, kWidth, 50) titleArrays:@[@"添加部门", @"新增学员"]];
        XWWeakSelf
        _bottomView.leftBlock = ^{
            XWAddDepartmentViewController *vc = [[XWAddDepartmentViewController alloc] init];
            XWDepartmentModel *department = weakSelf.model.depeparList[0];
            vc.name = department.department_name;
            vc.pid = department.oid;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _bottomView.rightBlock = ^{
            XWAddStudentViewController *vc = [[XWAddStudentViewController alloc] init];
            XWDepartmentModel *department = weakSelf.model.depeparList[0];
            vc.department_name = department.department_name;
            vc.oid = department.oid;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _bottomView;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"部门管理";
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    [self addNotificationWithName:@"DeleteStaffSuccess" selector:@selector(loadData)];
    [self addNotificationWithName:@"CreateUserSuccess" selector:@selector(loadData)];
    [self addNotificationWithName:@"DeleteDepartmentSuccess" selector:@selector(loadData)];
    [self addNotificationWithName:@"UpdateDepartmentList" selector:@selector(loadData)];
}

- (void)loadData {
    XWWeakSelf
    [XWHttpTool getCompanyDepartmentWithCompanyID:kUserInfo.company_id dId:@"" success:^(XWDepartmentListModel *dataModel) {
        weakSelf.model = dataModel;
        weakSelf.headerView.nums = dataModel.nums;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}

- (void)dealloc {
    [self removeNotification];
}


#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.model.userList.count;
    }
    XWDepartmentModel *department = self.model.depeparList[0];
    
    return department.children.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XWOrgManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:XWOrgManagerCellID forIndexPath:indexPath];
        cell.isDepartment = YES;
        cell.user = self.model.userList[indexPath.row];
        return cell;
    }
    
    XWDepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:XWDepartmentCellID forIndexPath:indexPath];
    XWDepartmentModel *department = self.model.depeparList[0];
    cell.model = department.children[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        XWDepartmentUserModel *user = self.model.userList[indexPath.row];
        XWStaffInfoViewController *vc = [[XWStaffInfoViewController alloc] init];
        vc.userId = user.userId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    XWSecDepartmentViewController *vc = [[XWSecDepartmentViewController alloc] init];
    XWDepartmentModel *department = self.model.depeparList[0];
    XWChildrenDepartmentModel *child = department.children[indexPath.row];
    vc.oid = child.oid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 55;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
        headView.backgroundColor = Color(@"#F6F6F6");
        return headView;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIImageView *icon = [[UIImageView alloc] initWithImage:LoadImage(@"icolist03")];
    UILabel *label = [UILabel creatLabelWithFontName:@"PingFang-SC-Bold" TextColor:Color(@"#333333") FontSize:15 Text:@"组织架构"];
    [bgView addSubview:icon];
    [bgView addSubview:label];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView);
        make.left.mas_equalTo(bgView).offset(15);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView);
        make.left.mas_equalTo(bgView).offset(40);
    }];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return nil;
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    headView.backgroundColor = Color(@"#F6F6F6");
    return headView;
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
