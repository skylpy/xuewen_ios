//
//  XWExamHistoryController.m
//  XueWen
//
//  Created by Karron Su on 2018/6/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWExamHistoryController.h"
#import "XWHistoryHeaderView.h"
#import "XWHistoryTableCell.h"
#import "XWExamHistoryModel.h"

static NSString *const XWHistoryTableCellID = @"XWHistoryTableCellID";


@interface XWExamHistoryController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XWExamHistoryModel *model;

@end

@implementation XWExamHistoryController

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.backgroundColor = [UIColor whiteColor];
        [table registerNib:[UINib nibWithNibName:@"XWHistoryTableCell" bundle:nil] forCellReuseIdentifier:XWHistoryTableCellID];
        _tableView = table;
    }
    return _tableView;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Super Methods
- (void)initUI{
    self.title = @"历史成绩";
    
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    XWWeakSelf
    [XWHttpTool getExamHistoryInfoWithCourseId:self.courseId success:^(XWExamHistoryModel *historyModel) {
        weakSelf.model = historyModel;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showTipMessageInWindow:errorInfo];
    }];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.model.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWHistoryTableCell * cell = [tableView dequeueReusableCellWithIdentifier:XWHistoryTableCellID forIndexPath:indexPath];
    cell.model = self.model.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 229+112;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    XWHistoryHeaderView *headerView = [[XWHistoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 229+112)];
    headerView.model = self.model;
    return headerView;
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
