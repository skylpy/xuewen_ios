//
//  XWRedRandViewController.m
//  XueWen
//
//  Created by aaron on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRedRandViewController.h"
#import "XWRedRandCell.h"
#import "XWRedPakModel.h"

static NSString * const XWRedRandCellID = @"XWRedRandCellID";

@interface XWRedRandViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView * tableView;

@property (strong,nonatomic) UIView * bgView;
@property (strong,nonatomic) NSMutableArray * dataArray;

@end

@implementation XWRedRandViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:Color(@"#E74143")];
    
    //创建一个UIButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //设置UIButton的图像
    [backButton setImage:[UIImage imageNamed:@"icoBackWhite"] forState:UIControlStateNormal];
    //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    //覆盖返回按键
    self.navigationItem.leftBarButtonItem = backItem;
    @weakify(self)
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"红包排行";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:kMedFont size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:Color(@"#ffffff")];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self requestData];
}

- (void)setupUI {
    
    self.view.backgroundColor = Color(@"#F4F4F4");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)requestData {
    
    [XWRedPakModel redBackListSuccess:^(XWRedPakModel *cmodel) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:cmodel.data];
        
        [self.tableView reloadData];
        
    } failure:nil];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = Color(@"#F4F4F4");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[XWRedRandCell class] forCellReuseIdentifier:XWRedRandCellID];
    }
    return _tableView;
}

- (UIView *)bgView {
    
    if (!_bgView) {
        UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        _bgView = bgview;
        UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(25, 20, kWidth- 50, 30)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [bgview addSubview:whiteView];
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)]; // UIRectCornerBottomRight通过这个设置
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = whiteView.bounds;
        maskLayer.path = maskPath.CGPath;
        
        whiteView.layer.mask = maskLayer;
        
        UILabel * randLabel = [UILabel createALabelText:@"排行" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#666666")];
        
        [whiteView addSubview:randLabel];
        [randLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView.mas_left).offset(8);
            make.centerY.equalTo(whiteView);
        }];
        
        UILabel * nakeLabel = [UILabel createALabelText:@"昵称" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#666666")];
        
        [whiteView addSubview:nakeLabel];
        [nakeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView.mas_left).offset(110);
            make.centerY.equalTo(whiteView);
        }];
        
        UILabel * moneyLabel = [UILabel createALabelText:@"红包金额" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#666666")];
        
        [whiteView addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(whiteView.mas_right).offset(-8);
            make.centerY.equalTo(whiteView);
        }];
    }
    return _bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.bgView;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWRedRandCell * cell = [tableView dequeueReusableCellWithIdentifier:XWRedRandCellID forIndexPath:indexPath];
    
    XWRedPakListModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.indexPath = indexPath;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
