//
//  XWCertificateListViewController.m
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCertificateListViewController.h"
#import "XWMedalCerViewController.h"
#import "XWCustomPopView.h"
#import "XWCerListCell.h"
#import "XWCertificateModel.h"

static NSString * const XWCerListCellID = @"XWCerListCellID";

@interface XWCertificateListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation XWCertificateListViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.cuname;
    
    [self drawUI];
    [self requestData];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

- (void)requestData {
    
    [XWCertificateModel certificateThematicListID:self.cuid withName:self.cuname success:^(NSArray *list) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSString *error) {
        
    }];
}

- (void)drawUI {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XWCerHeaderView * header = [XWCerHeaderView new];
    header.titleLabel.text = section == 0 ? @"上岗认证":section == 1 ? @"优秀认证":@"高级认证";
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWCerListCell * cell = [tableView dequeueReusableCellWithIdentifier:XWCerListCellID forIndexPath:indexPath];
    XWCerListModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWCerListModel * model = self.dataArray[indexPath.section];
    XWMedalCerViewController * vc = [[UIStoryboard storyboardWithName:@"MyCertificate" bundle:nil] instantiateViewControllerWithIdentifier:@"XWMedalCer"];
    vc.model = model;
    vc.testId = model.test_id;
    [self.navigationController pushViewController:vc animated:YES];
   
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        
        [_tableView registerNib:[UINib nibWithNibName:@"XWCerListCell" bundle:nil] forCellReuseIdentifier:XWCerListCellID];
        
        
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
