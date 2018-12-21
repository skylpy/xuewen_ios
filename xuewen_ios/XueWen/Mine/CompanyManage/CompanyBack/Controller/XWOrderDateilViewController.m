//
//  XWOrderDateilViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/13.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWOrderDateilViewController.h"
#import "XWOrderDateilTopCell.h"
#import "XWOrderDateilCell.h"
#import "XWCourseManageModel.h"

static NSString *const XWOrderDateilTopCellID = @"XWOrderDateilTopCellID";
static NSString *const XWOrderDateilCellID = @"XWOrderDateilCellID";

@interface XWOrderDateilViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) XWCompanyOrderModel * model;

@end

@implementation XWOrderDateilViewController

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

- (void)setNav {
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"claseico"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    @weakify(self)
    [[leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)drawUI {
    
    self.title = @"订单详情";
    self.view.backgroundColor = Color(@"#F6F6F6");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)requestData {
    
    [XWCourseManageModel orderDateilOrderID:self.orderId success:^(NSDictionary * _Nonnull dic) {
        
        self.model = [XWCompanyOrderModel modelWithJSON:dic[@"purchaserecord"]];
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[XWCompanyOrderModel class] json:dic[@"purchase_record_course"][@"data"]]];
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return indexPath.section == 0?259:112;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        XWOrderDateilTopCell *cell = [tableView dequeueReusableCellWithIdentifier:XWOrderDateilTopCellID forIndexPath:indexPath];
        if (self.model) {
            cell.model = self.model;
        }
        
        
        return cell;
    }
    XWOrderDateilCell *cell = [tableView dequeueReusableCellWithIdentifier:XWOrderDateilCellID forIndexPath:indexPath];
    XWCompanyOrderModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}


- (UITableView *)tableView {
    if (!_tableView) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [tableview registerNib:[UINib nibWithNibName:@"XWOrderDateilTopCell" bundle:nil]  forCellReuseIdentifier:XWOrderDateilTopCellID];
        [tableview registerNib:[UINib nibWithNibName:@"XWOrderDateilCell" bundle:nil]  forCellReuseIdentifier:XWOrderDateilCellID];
        
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = self.view.backgroundColor;
        tableview.separatorStyle = 0;
        tableview.estimatedSectionFooterHeight = 0.0;
        _tableView = tableview;
        
    }
    
    return _tableView;
}

@end
