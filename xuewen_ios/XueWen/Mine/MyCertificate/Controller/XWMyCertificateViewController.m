//
//  XWMyCertificateViewController.m
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWMyCertificateViewController.h"
#import "XWCertificateListViewController.h"
#import "XWMyCertificateCell.h"
#import "XWCertificateModel.h"

static NSString * const XWMyCertificateCellID = @"XWMyCertificateCellID";

@interface XWMyCertificateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation XWMyCertificateViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的证书";
    
    [self drawUI];
    [self requestData];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

- (void)drawUI {
    self.view.backgroundColor = Color(@"#E8E8E8");
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)requestData {
    
    [XWCertificateModel myCertificateThematicList:1 Page:1 success:^(XWCertificateModel * cmodel) {
        
        //计算每个cell的高度
        CGFloat cellH = (kWidth - 70) / 4 +30;
        for (XWCerDataModel * model in cmodel.data) {
            
            model.cellHeight = (model.children.count/3 +1) * cellH + 80;
            
            [self.dataArray addObject:model];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSString *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    XWCerDataModel * model = self.dataArray[indexPath.section];
    return model.cellHeight;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWMyCertificateCell * cell = [tableView dequeueReusableCellWithIdentifier:XWMyCertificateCellID forIndexPath:indexPath];
    
    XWCerDataModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    @weakify(self)
    [cell setDidSelectCerClick:^(XWCerChildrenModel *chModel) {
        @strongify(self)
        XWCertificateListViewController * cerListVc = [XWCertificateListViewController new];
        cerListVc.cuid = chModel.id;
        cerListVc.cuname = chModel.achievement_name;
        [self.navigationController pushViewController:cerListVc animated:YES];
    }];
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = Color(@"#E8E8E8");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"XWMyCertificateCell" bundle:nil] forCellReuseIdentifier:@"XWMyCertificateCellID"];
        
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
