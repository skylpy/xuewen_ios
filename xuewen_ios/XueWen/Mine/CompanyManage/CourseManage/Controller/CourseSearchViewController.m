//
//  CourseSearchViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "CourseSearchViewController.h"
#import "ClassesHeaderView.h"
#import "ClassesInfoCell.h"
#import "ClassesInfoHeaderView.h"
#import "XWCourseTableCell.h"
#import "XWNoneManageCell.h"
#import "CourseModel.h"
#import "MJRefresh.h"

static NSString *const XWCourseTableCellID = @"XWCourseTableCellID";
static NSString *const XWNoneManageCellID = @"XWNoneManageCellID";

@interface CourseSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,ClassesSelectViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILabel *noresultLabel;
@property (nonatomic, assign) BOOL hasResult;
@property (nonatomic, strong) ClassesHeaderView *headerView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ClassesInfoHeaderView *cellHeaderView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) NSMutableArray<XWCourseManageModel *> *dataSource;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *free;

@end

@implementation CourseSearchViewController

#pragma mark- ClassesSelectViewDelegate
- (void)sortLessionDidSelect:(NSString *)text dismiss:(BOOL)dismiss{
    self.orderType = text;
    [self loadData];
}

- (void)allLessionDidSelectLabel:(CourseLabelModel *)model dismiss:(BOOL)dismiss{
    NSLog(@"text = %@",model.labelName);
}

- (void)selectLessionDidSelect:(NSString *)text dismiss:(BOOL)dismiss{
    self.free = text;
    [self loadData];
}

#pragma mark- TableView&&Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource.count == 0) return;
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:self.dataSource[indexPath.section].Id isAudio:NO] animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.cellHeaderView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return self.dataSource.count == 0?0:27;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.dataSource.count > 0?135:kHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count > 0?self.dataSource.count:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource.count == 0) {
        XWNoneManageCell * cell = [tableView dequeueReusableCellWithIdentifier:XWNoneManageCellID forIndexPath:indexPath];
        cell.titleLabel.text = @"没有课程～";
        return cell;
        
    }
    
    XWCourseTableCell * cell = [tableView dequeueReusableCellWithIdentifier:XWCourseTableCellID forIndexPath:indexPath];
    XWCourseManageModel * model = self.dataSource[indexPath.section];
    cell.libmodel = model;
    cell.hideBtn.hidden = NO;
    @weakify(self)
    [cell setFunctionClick:^{
        @strongify(self)
        NSLog(@"%@",model.coursename);
        
        [self purchase:model.Id];
    }];
    
    [cell setHideBtnClick:^(NSString * _Nonnull cid) {
        @strongify(self)
        if([model.type isEqualToString:@"0"]){
            [self addCollect:cid];
        }else {
            [self cancelCollect:cid];
        }
    }];
    
    
    return cell;
}

- (void)purchase:(NSString *)courseId {
    
    [XWCourseManageModel addOrderCourseId:courseId success:^(NSDictionary * _Nonnull dic) {
        
        UIViewController * vc = [NSClassFromString(@"XWFirmOrderViewController") new];
        [vc setValue:dic forKey:@"dict"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

- (void)addCollect:(NSString *)cid{
    
    [XWCourseManageModel addFavoriteCourseManageCourseId:cid success:^{
        [self requestData];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}

- (void)cancelCollect:(NSString *)cid{
    
    [XWNetworking deleteFavoriteCourseWithID:cid CompletionBlock:^(BOOL succeed) {
        [self requestData];
    }];
}

#pragma mark- UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismiss];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([searchBar.text isEqualToString:@"xuewenceshi"]) {// 切换测试接口
        [searchBar resignFirstResponder];
        [XWInstance shareInstance].isTest = ![XWInstance shareInstance].isTest;
        [self dismiss];
    }else{
        self.searchText = searchBar.text;
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        [searchBar resignFirstResponder];
        [self.tableView.mj_header beginRefreshing];
        self.hasResult = YES;
    }
    
}

#pragma mark- CustomMethod
- (void)cancelAction:(UIButton *)sender{
    [self dismiss];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)initUI{
    self.view.backgroundColor = DefaultBgColor;
    [self.view addSubview:self.tableView];
}

//刷新
- (void)loadDatas {
    
    self.page = 1;
    [self requestData];
}

//加载更多
- (void)moreData {
    self.page ++;
    [self requestData];
}

- (void)requestData {
    
    [XWCourseManageModel courseLibraryPage:self.page Name:self.searchText Lid:@"" success:^(NSArray * _Nonnull list) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.page == 1) {
            [self.dataSource removeAllObjects];
        }
        [self.dataSource addObjectsFromArray:list];
        if(self.dataSource.count == 0){
            
            self.tableView.scrollEnabled = NO;
        }else {
            
            self.tableView.scrollEnabled = YES;
        }
        [self.tableView reloadData];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
- (void)loadMoreData{
    WeakSelf;
    [XWNetworking searchWithSearch:self.searchText page:self.page++ orderType:self.orderType free:self.free CompletionBlock:^(NSArray<CourseModel *> *courses, NSInteger totalCount) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.dataSource addObjectsFromArray:courses];
        [weakSelf.tableView reloadData];
        if (weakSelf.dataSource.count >= totalCount) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        if (totalCount == 0) {
            weakSelf.hasResult = NO;
        }
        weakSelf.cellHeaderView.count = totalCount;
    }];
}

- (void)loadSearchData{
    self.page = 1;
    self.cellHeaderView.count = 0;
    WeakSelf;
    [XWNetworking searchWithSearch:self.searchText page:self.page++ orderType:self.orderType free:self.free CompletionBlock:^(NSArray<CourseModel *> *courses, NSInteger totalCount) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:courses];
        [weakSelf.tableView reloadData];
        if (weakSelf.dataSource.count >= totalCount) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        if (totalCount == 0) {
            weakSelf.hasResult = NO;
        }
        weakSelf.cellHeaderView.count = totalCount;
    }];
}

#pragma mark- Setter
- (void)setHasResult:(BOOL)hasResult{
    _hasResult = hasResult;
    if (hasResult) {
        [self.noresultLabel removeFromSuperview];
        [self.view addSubview:self.headerView];
        [self.view addSubview:self.tableView];
        
    }else{
        [self.headerView removeFromSuperview];
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.noresultLabel];
    }
}

- (void)setOrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"最新发布"]) {
        _orderType = @"1";
    }else if ([orderType isEqualToString:@"人气最高"]){
        _orderType = @"2";
    }else if ([orderType isEqualToString:@"价格从低到高"]){
        _orderType = @"3";
    }else if ([orderType isEqualToString:@"价格由高到低"]){
        _orderType = @"4";
    }else{
        _orderType = @"0";
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)setFree:(NSString *)free{
    if ([free isEqualToString:@"全部"]) {
        _free = @"0";
    }else if ([free isEqualToString:@"免费"]){
        _free = @"1";
    }else if ([free isEqualToString:@"付费"]){
        _free = @"2";
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark- Getter
- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        _searchView.backgroundColor = [UIColor whiteColor];
        [_searchView addSubview:self.searchBar];
        [_searchView addSubview:self.cancelButton];
    }
    return _searchView;
}

- (ClassesInfoHeaderView *)cellHeaderView{
    if (!_cellHeaderView) {
        _cellHeaderView = [ClassesInfoHeaderView new];
    }
    return _cellHeaderView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeightNoNaviBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = Color(@"#F6F6F6");
        [_tableView registerNib:[UINib nibWithNibName:@"XWCourseTableCell" bundle:nil] forCellReuseIdentifier:XWCourseTableCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"XWNoneManageCell" bundle:nil] forCellReuseIdentifier:XWNoneManageCellID];
        _tableView.scrollEnabled = NO;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDatas)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
       
    }
    return _tableView;
}

- (ClassesHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ClassesHeaderView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 45) all:NO];
    }
    return _headerView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15,7, kWidth - 70, 30)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索课程";
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.backgroundColor = COLOR(238, 238, 238);
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor clearColor]];
            searchField.layer.cornerRadius = 0.0f;
            searchField.font = kFontSize(13);
        }
    }
    return _searchBar;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:0];
        _cancelButton = [UIButton buttonWithType:0];
        _cancelButton.frame = CGRectMake(_searchBar.x + _searchBar.width, 0, 55, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:COLOR(153, 153, 153) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kThemeColor forState:UIControlStateHighlighted];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)noresultLabel{
    if (!_noresultLabel) {
        NSString *text = @"暂无相关课程\n换个关键词试试:)";
        _noresultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, [text heightWithWidth:110 size:14])];
        _noresultLabel.text = text;
        _noresultLabel.textAlignment = 1;
        _noresultLabel.font = [UIFont systemFontOfSize:14];
        _noresultLabel.textColor = COLOR(153, 153, 153);
        _noresultLabel.numberOfLines = 0;
        _noresultLabel.center = CGPointMake(kWidth / 2.0, 180);
        
    }
    return _noresultLabel;
}

- (NSMutableArray<CourseModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark- LifeCycle
- (BOOL)hiddenNaviLine{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.searchView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.searchView removeFromSuperview];
}

@end
