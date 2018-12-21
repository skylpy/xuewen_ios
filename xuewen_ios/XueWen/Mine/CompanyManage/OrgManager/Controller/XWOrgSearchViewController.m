//
//  XWOrgSearchViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWOrgSearchViewController.h"
#import "XWOrgManagerCell.h"
#import "XWOrgManagerModel.h"

static NSString *const XWOrgManagerCellID = @"XWOrgManagerCellID";

@interface XWOrgSearchViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation XWOrgSearchViewController

#pragma mark - Getter
- (UITextField *)searchBar {
    if (!_searchBar) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kWidth-65, 30)];
        textField.placeholder = @"搜索";
        textField.borderStyle = UITextBorderStyleNone;
        [textField rounded:2];
        textField.backgroundColor = Color(@"#F6F6F6");
        textField.font = [UIFont fontWithName:kRegFont size:15];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 14, 14)];
        icon.image = LoadImage(@"searchicomini");
        [leftView addSubview:icon];
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        [textField leftViewRectForBounds:CGRectMake(5, 5, 20, 20)];
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeySearch;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchBar = textField;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kNaviBarH) style:UITableViewStyleGrouped];
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

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)loadData {
    
}

- (void)loadMore {
    XWWeakSelf
    [XWHttpTool searchAdminUserWithName:self.searchBar.text success:^(NSMutableArray *dataSource, BOOL isLast) {
        [weakSelf.dataSource addObjectsFromArray:dataSource];
        [weakSelf.tableView reloadData];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *error) {
        [MBProgressHUD showTipMessageInWindow:error];
    } isFirstLoad:NO];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    XWWeakSelf
    if ([self.searchBar.text isEqualToString:@""] || self.searchBar.text == nil) {
        [MBProgressHUD showTipMessageInWindow:@"请输入搜索关键字"];
        return NO;
    }
    
    [self.searchBar resignFirstResponder];
    
    [XWHttpTool searchAdminUserWithName:self.searchBar.text success:^(NSMutableArray *dataSource, BOOL isLast) {
        weakSelf.dataSource = dataSource;
        [weakSelf.tableView reloadData];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *error) {
        [MBProgressHUD showTipMessageInWindow:error];
    } isFirstLoad:YES];
    return YES;
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWOrgManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:XWOrgManagerCellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
