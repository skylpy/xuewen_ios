//
//  XWTestEducationViewController.m
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWTestEducationViewController.h"
#import "XWTestEduListCell.h"
#import "XWTestEduHeaderView.h"
#import "XWTestEduModel.h"

static NSString * const XWTestEduListCellID = @"XWTestEduListCellID";

@interface XWTestEducationViewController ()<UITableViewDelegate,UITableViewDataSource,XWTestEduHeaderViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,copy) NSString * htmlString;

@property (nonatomic,strong) XWTestEduHeaderView * headerView ;

@end

@implementation XWTestEducationViewController

#pragma dataArray
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    [self requestData];
}

#pragma setDrawUI
- (void)setDrawUI {
    
    self.title = @"测一测";
    
    self.view.backgroundColor = Color(@"#F4F4F4");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

#pragma requestData
- (void)requestData {
    
    [XWTestEduModel getJobTestListSuccess:^(NSArray * _Nonnull list,XWTestModel * model) {
        
        self.htmlString = model.html;
        self.headerView.desLabel.text = model.describe;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

#pragma tableView
- (UITableView *)tableView {
    
    if (!_tableView) {
        UITableView * table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView = table;
        table.separatorStyle = 0;
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = Color(@"#F4F4F4");
        [table registerClass:[XWTestEduListCell class] forCellReuseIdentifier:XWTestEduListCellID];
        
        XWTestEduHeaderView * headerView = [[XWTestEduHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 290)];
        table.tableHeaderView = headerView;
        self.headerView = headerView;
        headerView.delegate = self;
    }
    return _tableView;
}

#pragma UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 227;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWTestEduListCell * cell = [tableView dequeueReusableCellWithIdentifier:XWTestEduListCellID forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWTestEduModel * model = self.dataArray[indexPath.section];
    UIViewController * vc = [NSClassFromString(@"XWTestEduDateilViewController") new];
    [vc setValue:model forKey:@"model"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark XWTestEduHeaderViewDelegate
- (void)push {
    
    UIViewController * vc = [NSClassFromString(@"XWEduWebViewController") new];
    [vc setValue:self.htmlString forKey:@"htmlString"];
    [self.navigationController pushViewController:vc animated:YES];
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
