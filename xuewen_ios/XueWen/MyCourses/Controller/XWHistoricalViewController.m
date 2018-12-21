//
//  XWHistoricalViewController.m
//  XueWen
//
//  Created by aaron on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHistoricalViewController.h"
#import "ClassesInfoCell.h"
#import "XWRecordsCell.h"

static NSString * const XWRecordsCellID = @"XWRecordsCellID";

@interface XWHistoricalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * recordArray;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) NSInteger page;

@end

@implementation XWHistoricalViewController



- (NSMutableArray *)recordArray {
    
    if (!_recordArray) {
        NSMutableArray * array = [NSMutableArray array];
        _recordArray = array;
    }
    return _recordArray;
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        NSMutableArray * array = [NSMutableArray array];
        _dataArray = array;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史记录";
    self.page = 0;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadClassData];
    
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadClassData)];
//    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadClassData)];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;
}

- (void)loadClassData{
    // remove后需要reload collectionView 要不然连续刷新的时候会崩溃
    [MBProgressHUD showActivityMessageInWindow:@"正在加载..."];
    self.page ++;
    WeakSelf;
    NSString * size = [self.size integerValue] > 150 ? @"150" : self.size;
    [XWNetworking getMyLearningRecordWithPage:self.page Size:@"15" CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        [MBProgressHUD hideHUD];

        [self.tableView.mj_header endRefreshing];
 
        if (isLast) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.page == 1) {
            [weakSelf.recordArray removeAllObjects];
            [weakSelf.dataArray removeAllObjects];
            
            [weakSelf.dataArray addObjectsFromArray:array];
            NSMutableArray * a = [weakSelf arraySplitSubArrays:array];
            
            [weakSelf.recordArray addObjectsFromArray:a];
            [weakSelf.tableView reloadData];
        }else {
            [weakSelf.recordArray removeAllObjects];
            
            [weakSelf.dataArray addObjectsFromArray:array];
            NSMutableArray * a = [weakSelf arraySplitSubArrays:weakSelf.dataArray];
            
            [weakSelf.recordArray addObjectsFromArray:a];
            [weakSelf.tableView reloadData];
        }
    
        
    }];
    
}

- (NSMutableArray *)arraySplitSubArrays:(NSArray *)array {
    // 数组去重,根据数组元素对象中time字段去重
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for(CourseModel *obj in array) {
        
        NSLog(@"==========%@",obj.learningTime);
//        NSLog(@"=====%@",[NSDate dateFormTimestamp:[NSString stringWithFormat:@"%f",obj.updateTime]  withFormat:@"yyyy-MM-dd"]);
        [dic setValue:obj forKey:[NSDate dateFormTimestamp:[NSString stringWithFormat:@"%@",obj.learningTime] withFormat:@"yyyy-MM-dd"]];

    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSString *dictKey in dic) {
        [tempArr addObject:dictKey];
        
    }
    NSArray *sortedArray = [tempArr sortedArrayUsingSelector:@selector(compare:)]; NSLog(@"排序后:%@",sortedArray);
    // 字典重不会有重复值,allKeys返回的是无序的数组
    NSLog(@"去重后字典:%@",[dic allKeys]);
    NSMutableArray *temps = [NSMutableArray array];
    for (NSString *dictKey in sortedArray) {
        NSMutableArray *subTemps = [NSMutableArray array];
        for (CourseModel *obj in array) {
            if ([dictKey isEqualToString:[NSDate dateFormTimestamp:[NSString stringWithFormat:@"%@",obj.learningTime] withFormat:@"yyyy-MM-dd"]]) {
                [subTemps addObject:obj];
                
            }
            
        }
        [temps addObject:subTemps]; }
    // 排序后,元素倒序的,逆向遍历
    NSEnumerator *enumerator = [temps reverseObjectEnumerator];
    temps = (NSMutableArray*)[enumerator allObjects];
    NSLog(@"temps:%@",temps);
    return temps;
    
}

//刷新
- (void)loadData {
    
    self.page = 0;
    [self loadClassData];
}

//加载更多
- (void)moreData {
    self.page ++;
    [self loadClassData];
}

- (UITableView *)tableView{
    if (!_tableView) {
   
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:NSClassFromString(@"ClassesInfoCell") forCellReuseIdentifier:@"ClassesId"];
        [_tableView registerClass:[XWRecordsCell class] forCellReuseIdentifier:XWRecordsCellID];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];//[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.recordArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * array = self.recordArray[indexPath.section];
    return array.count * 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWRecordsCell * cell = [tableView dequeueReusableCellWithIdentifier:XWRecordsCellID forIndexPath:indexPath];
    cell.array = self.recordArray[indexPath.section];
    @weakify(self)
    [cell setRecordsClick:^(NSString *couresId,BOOL isA) {
        @strongify(self)
        [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:couresId isAudio:NO] animated:YES];
    }];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
