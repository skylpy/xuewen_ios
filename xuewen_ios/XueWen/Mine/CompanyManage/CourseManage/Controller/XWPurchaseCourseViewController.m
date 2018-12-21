//
//  XWPurchaseCourseViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWPurchaseCourseViewController.h"
#import "XWCourseTableCell.h"
#import "XWCourseManageModel.h"
#import "XWNoneManageCell.h"

static NSString *const XWCourseTableCellID = @"XWCourseTableCellID";
static NSString *const XWNoneManageCellID = @"XWNoneManageCellID";
@interface XWPurchaseCourseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
//页数
@property (nonatomic,assign) NSInteger page;

@end

@implementation XWPurchaseCourseViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawUI];
    [self requestData];
}

//刷新
- (void)loadData {
    
    self.page = 1;
    [self requestData];
}

//加载更多
- (void)moreData {
    self.page ++;
    [self requestData];
}
/**
 *注释
 *请求数据
 */
- (void)requestData {
    
    [XWCourseManageModel courseManagePage:self.page success:^(NSArray * _Nonnull list) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
       
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:list];
        if(self.dataArray.count == 0){
            
            self.tableView.scrollEnabled = NO;
        }else {
            
            self.tableView.scrollEnabled = YES;
        }
        [self.tableView reloadData];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

- (void)drawUI {
    
    self.page = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.backgroundColor = Color(@"#F6F6F6");
    [self.tableView registerNib:[UINib nibWithNibName:@"XWCourseTableCell" bundle:nil] forCellReuseIdentifier:XWCourseTableCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWNoneManageCell" bundle:nil] forCellReuseIdentifier:XWNoneManageCellID];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
}

#pragma mark tableView 代理

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.dataArray.count > 0?135:kHeight-100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return self.dataArray.count > 0?self.dataArray.count:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count == 0) {
        XWNoneManageCell * cell = [tableView dequeueReusableCellWithIdentifier:XWNoneManageCellID forIndexPath:indexPath];
        
        return cell;
        
    }
    XWCourseTableCell * cell = [tableView dequeueReusableCellWithIdentifier:XWCourseTableCellID forIndexPath:indexPath];
    XWCourseManageModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    @weakify(self)
    [cell setFunctionClick:^{
        @strongify(self)
        NSLog(@"%@",model.coursename);
        [self purchase:model.Id];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) return;
    XWCourseManageModel * model = self.dataArray[indexPath.section];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.Id isAudio:NO] animated:YES];
}

/**
 *注释
 *添加订单
 */
- (void)purchase:(NSString *)courseId {
    
    [XWCourseManageModel addOrderCourseId:courseId success:^(NSDictionary * _Nonnull dic) {
        
        UIViewController * vc = [NSClassFromString(@"XWFirmOrderViewController") new];
        [vc setValue:dic forKey:@"dict"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

@end
