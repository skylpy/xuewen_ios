//
//  XWCompanyBackViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCompanyBackViewController.h"
#import "MyWalletViewController.h"
#import "XWComBackView.h"
#import "XWManageCell.h"

static NSString *const ManageCellID = @"ManageCellID";

@interface XWCompanyBackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation XWCompanyBackViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawUI];
    [self setNav];
    [self requestData];
}

- (void)requestData {
    
    [self.dataArray addObjectsFromArray:[XWManageModel shareManageBack]];
    [self.tableView reloadData];
}

- (void)drawUI {
    self.title = @"企业钱包";
    [self.view addSubview:self.tableView];
}

- (void)setNav {
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 45, 30);
    [rightBtn setTitle:@"余额记录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    @weakify(self)
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController pushViewController:[NSClassFromString(@"XWBalanceViewController") new] animated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XWManageCell *cell = [tableView dequeueReusableCellWithIdentifier:ManageCellID forIndexPath:indexPath];
    XWManageModel * model = self.dataArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWManageModel * model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:[NSClassFromString(model.controller) new] animated:YES];
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - kTabBarH  ) style:UITableViewStylePlain];
        
        [tableview registerNib:[UINib nibWithNibName:@"XWManageCell" bundle:nil]  forCellReuseIdentifier:ManageCellID];
        
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = self.view.backgroundColor;
        tableview.separatorStyle = 0;
        tableview.estimatedSectionFooterHeight = 0.0;
        _tableView = tableview;
        
        XWComBackView * headerView = [XWComBackView shareCompanyBackView];
        self.tableView.tableHeaderView = headerView;
       
        @weakify(self)
        [headerView setRechargeClick:^{
            @strongify(self)
            MyWalletViewController * vc = [NSClassFromString(@"MyWalletViewController") new];
            vc.isCompany = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    return _tableView;
}

@end
