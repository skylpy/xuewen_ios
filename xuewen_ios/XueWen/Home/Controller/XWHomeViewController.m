//
//  XWHomeViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/4/25.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeViewController.h"
#import "ClassesSearchViewController.h"
#import "MainNavigationViewController.h"
#import "XWHeaderBannerView.h"
#import "XWHeaderKindCell.h"
#import "XWHeaderTitleView.h"
#import "XWHotNewsCell.h"
#import "XWCourseInfoCell.h"
#import "XWCollegeCell.h"
#import "XWHotNewsController.h"
#import "XWHotContentController.h"
#import "XWArticleModel.h"
#import "ViewControllerManager.h"
#import "BannerModel.h"
#import "XWNearFutureViewController.h"

static NSString *const XWHeaderKindCellID = @"XWHeaderKindCellID";
static NSString *const XWHotNewsCellID = @"XWHotNewsCellID";
static NSString *const XWCourseInfoCellID = @"XWCourseInfoCellID";
static NSString *const XWCollegeCellID = @"XWCollegeCellID";


@interface XWHomeViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** 搜索栏*/
@property (nonatomic, strong) UITextField *searchField;

@property (nonatomic, strong) UIView *backView;

/** 存放近期上线和热门课程*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 存放猜你喜欢*/
@property (nonatomic, strong) NSMutableArray *lickArray;

/** 存放标签*/
@property (nonatomic, strong) NSMutableArray *labelArray;

/** 轮播图*/
@property (nonatomic, strong) NSMutableArray *modelArray;


/** 商城跳转链接*/
@property (nonatomic, strong) NSString *shopUrl;



@end

@implementation XWHomeViewController

#pragma mark - Lazy

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kTabBarH) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 四大分类
        [table registerNib:[UINib nibWithNibName:@"XWHeaderKindCell" bundle:nil] forCellReuseIdentifier:XWHeaderKindCellID];
        // 课程
        [table registerNib:[UINib nibWithNibName:@"XWCourseInfoCell" bundle:nil] forCellReuseIdentifier:XWCourseInfoCellID];
        // 热点资讯
        [table registerNib:[UINib nibWithNibName:@"XWHotNewsCell" bundle:nil] forCellReuseIdentifier:XWHotNewsCellID];
        // 主推学院
        [table registerClass:[XWCollegeCell class] forCellReuseIdentifier:XWCollegeCellID];
        
        _tableView = table;
    }
    return _tableView;
}

- (UITextField *)searchField{
    if (!_searchField) {
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(19, kStasusBarH+3, kWidth-38, 28)];
        [field rounded:14];
        field.backgroundColor = [UIColor whiteColor];
        field.placeholder = @"搜索课程";
        field.font = [UIFont fontWithName:kRegFont size:12];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 28)];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 12, 12)];
        icon.image = LoadImage(@"icon_search");
        [leftView addSubview:icon];
        field.leftView = leftView;
        field.leftViewMode = UITextFieldViewModeAlways;
        [field leftViewRectForBounds:CGRectMake(5, 5, 20, 20)];
        field.delegate = self;
        _searchField = field;
    }
    return _searchField;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kStasusBarH+38)];
        _backView.backgroundColor = [UIColor clearColor];
        [_backView addSubview:self.searchField];
    }
    return _backView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)lickArray{
    if (!_lickArray) {
        _lickArray = [[NSMutableArray alloc] init];
    }
    return _lickArray;
}

- (NSMutableArray *)labelArray{
    if (!_labelArray) {
        _labelArray = [[NSMutableArray alloc] init];
    }
    return _labelArray;
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] init];
    }
    return _modelArray;
}

#pragma mark - lifecyc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

- (BOOL)hiddenNavigationBar{
    return YES;
}

- (void)initUI{
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    [self.view addSubview:self.tableView];

    [self setRefresh];
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - 50;;
}

- (void)loadData{
    
    [MBProgressHUD showActivityMessageInWindow:@"正在加载..."];
    @weakify(self)
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWHttpTool getCourseIndexWithOrderType:@"0" success:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.dataArray = array;
            [weakSelf.tableView reloadData];
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [subscriber sendNext:@"0"];
        }];
        
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWHttpTool getCourseLabelSuccess:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.labelArray = array;
            [weakSelf.tableView reloadData];
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [subscriber sendNext:@"0"];
        }];
        [subscriber sendNext:@"2"];
        return nil;
    }];
    
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWNetworking getBannerImagesWithCompleteBlock:^(NSArray<BannerModel *> *banners) {
            weakSelf.modelArray = [banners mutableCopy];
            [weakSelf.tableView reloadData];
            [subscriber sendNext:@"1"];
        } cid:@"1"];
        
        return nil;
    }];
    
    RACSignal *signal4 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWHttpTool getLickCourseWith:@"2" isFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.lickArray = array;
            [weakSelf.tableView reloadData];
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [subscriber sendNext:@"0"];
        }];
        
        return nil;
    }];
    
    [self rac_liftSelector:@selector(completedRequest1:request2:request3:request4:) withSignalsFromArray:@[signal1, signal2, signal3, signal4]];
//    [self loadShopUrl];
    
    
}

- (void)completedRequest1:(NSString *)data1 request2:(NSString *)data2 request3:(NSString *)data3 request4:(NSString *)data4{
    if ([data1 isEqualToString:@"1"] && [data2 isEqualToString:@"1"] && [data3 isEqualToString:@"1"] && [data4 isEqualToString:@"1"]) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    }else{
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
        [MBProgressHUD hideHUD];
    }
    
}

/** 商城跳转链接*/
- (void)loadShopUrl{
    XWWeakSelf
    [XWHttpTool getShopUrlSuccess:^(NSString *url) {
        [MBProgressHUD hideHUD];
        weakSelf.shopUrl = url;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:errorInfo];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

/** 设置下拉刷新 */
- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
}

#pragma mark - UITableView Delegate / DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {  // 4大分类
        return 1;
    }else if (section == 1){  // 热点资讯
        NSArray *data = [self.dataArray lastObject];
        return data.count;
    }
    if (section == 4) {  // 主推学院
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) { // 4大分类
        return 104;
    }
    if (indexPath.section == 1){ // 热点资讯
        return 37;
    }
    if (indexPath.section == 4) { // 主推学院
        return 95;
    }
    return 145;  // 课程
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 四大分类
        XWHeaderKindCell *cell = [tableView dequeueReusableCellWithIdentifier:XWHeaderKindCellID forIndexPath:indexPath];
        cell.shopUrl = self.shopUrl;
        return cell;
    }
    if (indexPath.section == 1){ // 热点资讯
        XWHotNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:XWHotNewsCellID forIndexPath:indexPath];
        NSArray *data = [self.dataArray lastObject];
        cell.model = data[indexPath.row];
        return cell;
    }
    if (indexPath.section == 4) { // 主推学院
        XWCollegeCell *cell = [tableView dequeueReusableCellWithIdentifier:XWCollegeCellID forIndexPath:indexPath];
        cell.array = self.labelArray;
        return cell;
    }
    // 课程
    XWCourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:XWCourseInfoCellID forIndexPath:indexPath];
    if (indexPath.section == 2) { // 热门课程
        NSArray *data = [self.dataArray firstObject];
        cell.indexModel = data[indexPath.row];
    }else if (indexPath.section == 3){ // 近期上线
        NSArray *data = [self.dataArray objectAtIndex:1];
        cell.indexModel = data[indexPath.row];
    }else{ // 猜你喜欢
        cell.indexModel = self.lickArray[indexPath.row];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    if (indexPath.section == 1) { // 热点资讯
        NSArray *data = [self.dataArray lastObject];
        XWArticleModel *model = data[indexPath.row];
        XWHotContentController *vc = [[XWHotContentController alloc] init];
        vc.articleId = model.articleId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 4) {
        return;
    }
    XWCourseIndexModel *model = [[XWCourseIndexModel alloc] init];
    if (indexPath.section == 2) { // 热门课程
        NSArray *data = [self.dataArray firstObject];
        model = data[indexPath.row];
    }else if (indexPath.section == 3){ // 近期上线
        NSArray *data = [self.dataArray objectAtIndex:1];
        model = data[indexPath.row];
    }else{ // 猜你喜欢
        model = self.lickArray[indexPath.row];
    }
    BOOL isAudio;
    if ([model.courseType isEqualToString:@"2"]) {
        isAudio = YES;
    }else{
        isAudio = NO;
    }
    
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:isAudio] animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 214;
    }else if (section == 1){
        return 34;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        XWHeaderBannerView *banner = [[XWHeaderBannerView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 214)];
        banner.modelArray = self.modelArray;
        [banner addSubview:self.backView];
        return banner;
    }
    
    XWHeaderTitleView *titleView = [[XWHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    if (section == 1) {
        titleView.frame = CGRectMake(0, 0, kWidth, 34);
        titleView.backgroundColor = Color(@"#f4f4f4");
        [titleView setTitle:@"热点资讯" showMoreBtn:YES btnAction:@selector(moreAction) target:self];
    }else{
        titleView.backgroundColor = [UIColor whiteColor];
        titleView.frame = CGRectMake(0, 0, kWidth, 44);
        NSString *title = [[NSString alloc] init];
        BOOL showMoreBtn;
        SEL action;
        if (section == 2) {
            title = @"热门课程";
            showMoreBtn = YES;
            action = @selector(hotMoreAction);
        }else if (section == 3){
            title = @"近期上线";
            showMoreBtn = YES;
            action = @selector(nearMoreAction);
        }else if (section == 4){
            title = @"主推学院";
            showMoreBtn = NO;
            action = nil;
        }else{
            title = @"猜你喜欢";
            showMoreBtn = NO;
            action = nil;
        }
        [titleView setTitle:title showMoreBtn:showMoreBtn btnAction:action target:nil];
    }
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (self.tableView.contentOffset.y <= 0) {
//        self.backView.backgroundColor = [UIColor clearColor];
//    }else{
//        self.backView.backgroundColor = Color(@"#334956");
//    }
    if (self.isDraging) {
        float y = scrollView.contentOffset.y;
        // 判断滑动方向
        static float oldY = 0;
        if ([XWAudioInstanceController hasInstance] && y != oldY) {
            if (y > oldY) {
                [XWAudioInstanceController playerViewDisappear];
            }else{
                [XWAudioInstanceController playerViewAppear];
            }
        }
        oldY = y;
    }
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    MainNavigationViewController *navi = [[MainNavigationViewController alloc] initWithRootViewController:[ClassesSearchViewController new]];
    [self presentViewController:navi animated:NO completion:nil];
    return YES;
}

#pragma mark - Action
- (void)moreAction{
    XWHotNewsController *hotVC = [[XWHotNewsController alloc] init];
    [self.navigationController pushViewController:hotVC animated:YES];
}

- (void)hotMoreAction{
    XWNearFutureViewController *vc = [[XWNearFutureViewController alloc] init];
    vc.type = ControllerTypeHot;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)nearMoreAction{
    XWNearFutureViewController *vc = [[XWNearFutureViewController alloc] init];
    vc.type = ControllerTypeNear;
    [self.navigationController pushViewController:vc animated:YES];
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
