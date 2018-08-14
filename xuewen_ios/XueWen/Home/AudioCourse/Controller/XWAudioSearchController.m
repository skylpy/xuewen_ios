//
//  XWAudioSearchController.m
//  XueWen
//
//  Created by Karron Su on 2018/5/23.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWAudioSearchController.h"
#import "XWAudioCoursesListCell.h"

static NSString *const XWAudioCoursesListCellID = @"XWAudioCoursesListCellID";

@interface XWAudioSearchController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *cancelBtn;

/** 搜索关键字*/
@property (nonatomic, strong) NSString *keyWord;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XWAudioSearchController

#pragma mark - Getter / Lazy
- (UITextField *)searchField{
    if (!_searchField) {
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kWidth-80, 28)];
        field.backgroundColor = COLOR(240, 240, 240);
        field.leftViewMode = UITextFieldViewModeAlways;
        field.placeholder = @"搜索";
        field.adjustsFontSizeToFitWidth = YES;
        field.minimumFontSize = 0.1;
        field.font = [UIFont fontWithName:kRegFont size:14];
        field.returnKeyType = UIReturnKeySearch;
        [field rounded:4];
        field.delegate = self;
        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 16, 16)];
        [leftView addSubview:icon];
        icon.image = [UIImage imageNamed:@"icoSearch"];
        field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field.leftView = leftView;
        field.clearButtonMode = UITextFieldViewModeAlways;
        [field leftViewRectForBounds:CGRectMake(5, 5, 20, 20)];
        _searchField = field;
    }
    return _searchField;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR(51, 51, 51) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:17];
        @weakify(self)
        [[[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _cancelBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWAudioCoursesListCell" bundle:nil] forCellReuseIdentifier:XWAudioCoursesListCellID];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = table;
    }
    return _tableView;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

#pragma mark - Super Methods

- (void)initUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchField];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelBtn];
    [self.view addSubview:self.tableView];
    self.keyWord = @"";
    
    /** 刷新*/
    [self setRefresh];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - kNaviBarH - 50;
}

#pragma mark - Custom Methods

- (void)loadSearchResult{
    XWWeakSelf
    [XWHttpTool getAudioCoursesWithName:self.keyWord isFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast) {
        weakSelf.dataArray = array;
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showErrorMessage:errorInfo];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMore{
    XWWeakSelf
    [XWHttpTool getAudioCoursesWithName:self.keyWord isFirstLoad:NO success:^(NSMutableArray *array, BOOL isLast) {
        [weakSelf.dataArray addObjectsFromArray:array];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.searchField resignFirstResponder];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showErrorMessage:errorInfo];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadSearchResult)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XWWeakSelf
    return [tableView fd_heightForCellWithIdentifier:XWAudioCoursesListCellID cacheByIndexPath:indexPath configuration:^(XWAudioCoursesListCell* cell) {
        XWAudioCoursModel *model = weakSelf.dataArray[indexPath.row];
        cell.model = model;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWAudioCoursesListCell *cell = [tableView dequeueReusableCellWithIdentifier:XWAudioCoursesListCellID forIndexPath:indexPath];
    XWAudioCoursModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWAudioCoursModel *model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:YES] animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text == nil || [textField.text isEqualToString:@""]) {
        [MBProgressHUD showInfoMessage:@"请输入关键字"];
        return NO;
    }
    self.keyWord = textField.text;
    [self loadSearchResult];
    return YES;
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
