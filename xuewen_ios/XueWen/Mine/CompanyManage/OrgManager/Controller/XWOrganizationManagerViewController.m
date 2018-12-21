//
//  XWOrganizationManagerViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWOrganizationManagerViewController.h"
#import "XWOrgManagerCell.h"
#import "XWOrgManagerModel.h"
#import "XWOrgManagerHeaderView.h"
#import "XWOrgSearchViewController.h"
#import "XWStaffInfoViewController.h"

static NSString *const XWOrgManagerCellID = @"XWOrgManagerCellID";

@interface XWOrganizationManagerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) XWOrgManagerHeaderView *headerView;

@end

@implementation XWOrganizationManagerViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kWidth, kHeight-kNaviBarH-70) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWOrgManagerCell" bundle:nil] forCellReuseIdentifier:XWOrgManagerCellID];
        _tableView = table;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (XWOrgManagerHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XWOrgManagerHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 70)];
    }
    return _headerView;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"组织管理";
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithImgName:@"icon_search" target:self method:@selector(rightBtnClick)];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    
    [self addNotificationWithName:@"DeleteStaffSuccess" selector:@selector(loadData)];
}

- (void)loadData {
    XWWeakSelf
    [XWHttpTool getAdminUserListWithCompanyId:kUserInfo.company_id success:^(NSMutableArray *dataSource) {
        [dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XWOrgManagerModel *model = (XWOrgManagerModel *)obj;
            model.first = [NSString getLetter:model.name];
        }];
        weakSelf.dataSource = [NSMutableArray sortObjectsAccordingToInitialWithArray:dataSource];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - Custom Methods
- (void)rightBtnClick {
    [self.navigationController pushViewController:[XWOrgSearchViewController new] animated:YES];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataSource[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWOrgManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:XWOrgManagerCellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    cell.isHome = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWStaffInfoViewController *vc = [[XWStaffInfoViewController alloc] init];
    XWOrgManagerModel *model = self.dataSource[indexPath.section][indexPath.row];
    vc.userId = model.userID;
    [self.navigationController pushViewController:vc animated:YES];

}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 20)];
    bgView.backgroundColor = Color(@"#F6F6F6");
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont fontWithName:kRegFont size:14];
    label.textColor = Color(@"#333333");
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(15);
        make.centerY.mas_equalTo(bgView);
    }];
    XWOrgManagerModel *model = self.dataSource[section][0];
    label.text = model.first;
    return bgView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
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
