//
//  XWNearFutureViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/6/7.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNearFutureViewController.h"
#import "XWNearFutureCell.h"

static NSString *const XWNearFutureCellID = @"XWNearFutureCellID";


@interface XWNearFutureViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *orderType;

@property (nonatomic, strong) NSMutableArray *tempArray;


@end

@implementation XWNearFutureViewController

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [table registerNib:[UINib nibWithNibName:@"XWNearFutureCell" bundle:nil] forCellReuseIdentifier:XWNearFutureCellID];
        _tableView = table;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)tempArray{
    if (!_tempArray) {
        _tempArray = [[NSMutableArray alloc] init];
    }
    return _tempArray;
}


#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

#pragma mark - Super Methods

- (void)initUI{
    if (self.type == ControllerTypeNear) { // 近期上线
        self.orderType = @"1";
        self.title = @"近期上线";
    }else{ // 热门课程
        self.orderType = @"2";
        self.title = @"热门课程";
    }
    
    [self.view addSubview:self.tableView];
    
    [self setRefresh];
}

- (void)loadData{
    XWWeakSelf
    [XWHttpTool getNearFutureListWithIsFirstLoad:YES orderType:self.orderType success:^(NSMutableArray *array, BOOL isLast) {
        weakSelf.tempArray = array;
        [weakSelf checkData];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *error) {
        [MBProgressHUD showErrorMessage:error];
    } popularOrder:@""];
    
}

- (void)loadMore{
    XWWeakSelf
    [XWHttpTool getNearFutureListWithIsFirstLoad:NO orderType:self.orderType success:^(NSMutableArray *array, BOOL isLast) {
        [weakSelf.tempArray addObjectsFromArray:array];
        [weakSelf checkData];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *error) {
        [MBProgressHUD showErrorMessage:error];
    } popularOrder:@""];
}

#pragma mark - Custom Methods

- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

/** 将数据进行处理*/
- (void)checkData{

    __block NSMutableSet *tempSet = [[NSMutableSet alloc] init];
    [self.tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XWCourseIndexModel *model = (XWCourseIndexModel *)obj;
        NSString *timeStr = [NSDate dateFormTimestamp:model.shelvesTime withFormat:@"yyyy.MM.dd"];
        NSLog(@"timestr is %@", timeStr);
        [tempSet addObject:timeStr];
    }];
    
    [self.dataArray removeAllObjects];
    __block NSMutableArray *strArr = [[NSMutableArray alloc] init];
    [tempSet enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *tempStr = (NSString *)obj;
        [strArr addObject:tempStr];
    }];
    
    NSArray *result = [strArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *tempStr = (NSString *)obj;
        __block NSMutableArray *array = [[NSMutableArray alloc] init];
        [self.tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XWCourseIndexModel *model = (XWCourseIndexModel *)obj;
            NSString *timeStr = [NSDate dateFormTimestamp:model.shelvesTime withFormat:@"yyyy.MM.dd"];
            if ([timeStr isEqualToString:tempStr]) {
                [array addObject:model];
            }
        }];
        [self.dataArray addObject:array];
    }];
    
}

#pragma mark - Action



#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWNearFutureCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNearFutureCellID forIndexPath:indexPath];
    NSArray *arr1 = self.dataArray[indexPath.section];
    cell.model = arr1[indexPath.row];
    cell.isLast = arr1.count-1 == indexPath.row ? NO : YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWCourseIndexModel *model = self.dataArray[indexPath.section][indexPath.row];
    if ([model.courseType isEqualToString:@"2"]) {
        [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:YES] animated:YES];
    }else{
        [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:NO] animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = Color(@"#999999");
    label.font = [UIFont fontWithName:kMedFont size:18];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(25);
        make.top.mas_equalTo(bgView).offset(24);
    }];
    XWCourseIndexModel *model = self.dataArray[section][0];
    label.text = [NSDate dateFormTimestamp:model.shelvesTime withFormat:@"yyyy.MM.dd"];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
