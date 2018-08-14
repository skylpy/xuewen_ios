//
//  MyExamViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyExamViewController.h"
#import "MyExamCell.h"
#import "ExamModel.h"
#import "MJRefresh.h"
#import "ExamViewController.h"
#import "QuestionsModel.h"
@interface MyExamViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<ExamModel *> *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyExamViewController
#pragma mark- TableView&&Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *questions = self.dataSource[indexPath.row].questions;
    for (QuestionsModel * question in questions) {
        question.commited = YES;
    }
    ExamViewController *vc = [[ExamViewController alloc] initWithQuestions:questions errorOnly:NO];
    vc.showAll = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyExamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.model = self.dataSource[indexPath.row];
    [cell setIsFirst:indexPath.row == 0 leftSpace:15 rightSpace:0];
    return cell;
}

#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"我的考试";
    self.view.backgroundColor = DefaultBgColor;
    self.scrollView = self.tableView;
    [self addHeaderWithAction:@selector(loadTestList)];
    [self addFooterWithAction:@selector(loadTestList)];
    [self beginLoadData];
}

- (void)loadTestList{
    WeakSelf;
    [XWNetworking getMyTestListWithPage:self.page++ completionBlock:^(NSArray<ExamModel *> *exams, BOOL isLast) {
        [weakSelf loadedDataWithArray:exams isLast:isLast];
    }];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma mark- Setter
#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:[MyExamCell class] forCellReuseIdentifier:@"CellID"];
    }
    return _tableView;
}

- (NSMutableArray<ExamModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = self.array;
    }
    return _dataSource;
}

- (BOOL)hiddenNaviLine{
    return NO;
}
#pragma mark- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Analytics event:EventMyExam label:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
