//
//  XWCompanyManageViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCompanyManageViewController.h"
#import "XWManageCell.h"
#import "XWManageModel.h"
#import "XWManageHeaderView.h"

static NSString *const ManageCellID = @"ManageCellID";

@interface XWCompanyManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic, strong) XWManageHeaderView *headerView;
@end

@implementation XWCompanyManageViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (XWManageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [XWManageHeaderView shareManageHeaderView];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, -kStasusBarH, kWidth, kHeight - kTabBarH  ) style:UITableViewStyleGrouped];
        
        [tableview registerNib:[UINib nibWithNibName:@"XWManageCell" bundle:nil]  forCellReuseIdentifier:ManageCellID];
        
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = self.view.backgroundColor;
        tableview.separatorStyle = 0;
        tableview.estimatedSectionFooterHeight = 0.0;
        _tableView = tableview;
        
        XWManageHeaderView * headerView = self.headerView;
        tableview.tableHeaderView = headerView;
    }
    
    return _tableView;
}

#pragma mark - lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:COLOR(18, 88, 238) size:CGSizeMake(1, 1)] forBarMetrics:0];
    // 标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:kRegFont size:18]}];
    
    [self.navigationController.navigationBar setBackIndicatorImage:[[UIImage imageNamed:@"back_ico"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"back_ico"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     */
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /*
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
    // 标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:Color(@"#333333"),NSFontAttributeName:[UIFont fontWithName:kRegFont size:18]}];
     */
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawUI];
    [self requestData];
}

- (BOOL)hiddenNavigationBar {
    return YES;
}

- (void)drawUI {
    self.title = @"企业管理";
    [self.view addSubview:self.tableView];
    
    [self addNotificationWithName:@"UpdateCompanyInfo" selector:@selector(updateCompanyInfo)];
}

- (void)requestData {
    
    [self.dataArray addObjectsFromArray:[XWManageModel shareManage]];
    [self.tableView reloadData];
}

- (void)updateCompanyInfo {
    [self.headerView update];
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - UITableViewDelegate / DataSource

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
    if ([model.title isEqualToString:@"课程管理"]) {
        
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"XWCourseManage" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseManage"] animated:YES];
    }else {
        [self.navigationController pushViewController:[NSClassFromString(model.controller) new] animated:YES];
    }
    
}



@end
