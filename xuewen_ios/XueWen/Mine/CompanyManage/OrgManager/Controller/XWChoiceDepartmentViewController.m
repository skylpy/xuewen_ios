//
//  XWChoiceDepartmentViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWChoiceDepartmentViewController.h"
#import "XWChoiceDepartmentCell.h"
#import "XWDepartmentListModel.h"

static NSString *const XWChoiceDepartmentCellID = @"XWChoiceDepartmentCellID";

@interface XWChoiceDepartmentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) XWDepartmentModel *department;
@property (nonatomic, strong) NSString *did;

@end

@implementation XWChoiceDepartmentViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 55;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWChoiceDepartmentCell" bundle:nil] forCellReuseIdentifier:XWChoiceDepartmentCellID];
        
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

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"部门";
    [self.view addSubview:self.tableView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:LoadImage(@"navBack") forState:UIControlStateNormal];
    @weakify(self)
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if ([self.department.pid isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            self.did = self.department.pid;
            [self loadData];
        }
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)loadData {
    XWWeakSelf
    [XWHttpTool getDepartmentListWithCompanyId:kUserInfo.company_id did:self.did success:^(XWDepartmentModel *department) {
        weakSelf.department = department;
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
    
    return self.department.children.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWChoiceDepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:XWChoiceDepartmentCellID forIndexPath:indexPath];
    cell.department = self.department.children[indexPath.row];
    XWWeakSelf
    cell.block = ^(XWChildrenDepartmentModel * _Nonnull model) {
        weakSelf.did = model.oid;
        [weakSelf loadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWChildrenDepartmentModel *model = self.department.children[indexPath.row];
    !self.block ? : self.block(model);
    [self.navigationController popViewControllerAnimated:YES];
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
