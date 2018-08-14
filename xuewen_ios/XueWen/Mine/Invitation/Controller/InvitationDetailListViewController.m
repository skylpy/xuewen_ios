//
//  InvitationDetailListViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/3/29.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "InvitationDetailListViewController.h"
#import "InvitationDetailCell.h"
#import "InvitationedModel.h"
@interface InvitationDetailListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL hasInitUI;
@property (nonatomic, assign) BOOL isCompany;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *currentDate;

@end

@implementation InvitationDetailListViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isCompany) {
        InvitationedModel *model = self.dataSource[indexPath.row];
        model.showAll = !model.showAll;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 72;
    if (self.isCompany) {
        InvitationedModel *model = self.dataSource[indexPath.row];
        height = model.showAll ? 156 : 72;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InvitationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];

    if (self.isCompany) {
        InvitationedModel *model = self.dataSource[indexPath.row];
        cell.model = model;
    }else{
        InvitationPersonalModel *model = self.dataSource[indexPath.row];
        cell.personalModel = model;
    }
    [cell setIsFirst:indexPath.row == 0 leftSpace:15 rightSpace:15];
    return cell;
}

#pragma mark- CustomMethod
- (void)beginLoadData{
    if (self.hasInitUI) {
        if (![self.currentDate isEqualToString:self.date]) {
            self.currentDate = [NSString stringWithString:self.date];
            [super beginLoadData];
        }
    }
}

- (void)initUI{
    self.scrollView = self.tableView;
    [self addHeaderFooterAction:@selector(loadListData)];
    self.hasInitUI = YES;
    [self beginLoadData];
    
}

- (void)loadListData{
    WeakSelf;
    if (self.isCompany) {
        [XWNetworking getRegisteredRecordWithPage:self.page++ date:self.date completeBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
            [weakSelf loadedDataWithArray:array isLast:isLast];
        }];
    }else{
        [XWNetworking getPersonalRegisteredRecordWithPage:self.page++ date:self.date completeBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
            [weakSelf loadedDataWithArray:array isLast:isLast];
        }];
    }
}

#pragma mark- Setter
#pragma mark- Getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = self.array;
    }
    return _dataSource;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView tableViewWithFrame:CGRectMake(0, 0, kWidth, kHeight - kNaviBarH - 108) style:UITableViewStylePlain delegate:self dataSource:self registerClass:@{@"InvitationDetailCell" : CellID}];
    }
    return _tableView;
}

#pragma mark- LifeCycle
- (instancetype)initWithCompany:(BOOL)company{
    if (self = [super init]) {
        self.isCompany = company;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
