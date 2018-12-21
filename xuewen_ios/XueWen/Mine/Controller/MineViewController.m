//
//  MineViewController.m
//  XueWen
//
//  Created by Pingzi on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MineViewController.h"
#import "MineListTableViewCell.h"
#import "BaseCellModel.h"
#import "MineHeaderView.h"
#import "MyClassesViewController.h"
#import "MineInfoViewController.h"
#import "MyExamViewController.h"
#import "SettingViewController.h"
#import "PurchaseRecordViewController.h"
#import "MyNotesViewController.h"
#import "LearningPlanViewController.h"
#import "MineClassesViewController.h"
#import "MyCouponViewController.h"
#import "InvitationViewController.h"
#import "XWFeedBackViewController.h"
#import "XWMyCertificateViewController.h"
#import "XWMineTopCell.h"
#import "MyWalletViewController.h"
#import "XWMineModel.h"

static NSString *const MineListTableViewCellID = @"MineListTableViewCellID";
static NSString *const XWMineTopCellID = @"XWMineTopCellID";

@interface MineViewController () <UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *Table;
@property (nonatomic, strong) MineHeaderView *headerView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation MineViewController

#pragma mark - --- TableView Delegate&DataSource ---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XWMineModel * model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:[NSClassFromString(model.controller) new] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /** 如需改成新版,打开注释即可*/

    return 59;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /** 如需改成新版,注释上面一行,打开下面一行*/
    
    return self.dataArray.count;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    /** 如需改成新版,注释上面一行,打开下面一行*/
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineListTableViewCellID forIndexPath:indexPath];
    cell.detailLB.hidden = YES;
    
    XWMineModel * model = self.dataArray[indexPath.row];
    
    cell.titleLB.text = model.title;
    cell.imgV.image = LoadImage(model.imageStr);
    if (![model.subtitle isEqualToString:@""]) {
        cell.detailLB.hidden = NO;
        cell.detailLB.text = model.subtitle;
    }
    cell.isFirst = (indexPath.row == 0);
    return cell;

    
}

#pragma mark - --- Custom Method ---
- (void)infoAction:(UIGestureRecognizer *)sender{
    
    [self.navigationController pushViewController:[MineInfoViewController new] animated:YES];
}

- (void)setAction:(UIButton *)sender{
    
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

- (void)initUI{
    
    self.view.backgroundColor = DefaultBgColor;
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    
    /** 如需改成新版, 把topView给注释了即可*/
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kStasusBarH)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.Table];
    self.Table.contentOffset = CGPointMake(0, 1);
}

- (void)loadData{
    [XWNetworking getAccountInfoWithCompletionBlock:nil];
}

- (void)setheaderViewInfo{
    [self.headerView refresh];
    [self.Table reloadData];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - 50;
}

#pragma mark - --- UINavigationControllerDelegate ---

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (UITableView *)Table {
    if (!_Table) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 170+kStasusBarH, kWidth, kHeight - kTabBarH - 170 - kStasusBarH ) style:UITableViewStyleGrouped];
        
        [tableview registerNib:[UINib nibWithNibName:@"MineListTableViewCell" bundle:nil]  forCellReuseIdentifier:MineListTableViewCellID];
        [tableview registerNib:[UINib nibWithNibName:@"XWMineTopCell" bundle:nil] forCellReuseIdentifier:XWMineTopCellID];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = self.view.backgroundColor;
        tableview.separatorStyle = 0;
        tableview.estimatedSectionFooterHeight = 0.0;
        _Table = tableview;
    }
    
    return _Table;
}

- (MineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, kStasusBarH, kWidth, 170) target:self infoAction:@selector(infoAction:) setAction:@selector(setAction:)];
    }
    return _headerView;
}
#pragma mark - --- Life Cycle ---

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self requestData];
}

- (void)requestData {
    
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionStrin"];
    WeakSelf;
    [XWMineModel mineVersion:app_Version success:^(NSInteger hide) {
        
        weakSelf.dataArray = [[XWMineModel sharemineHide:hide] mutableCopy];
        
        [weakSelf.Table reloadData];
        
    } failure:^(NSString * _Nonnull error) {
        
        [weakSelf requestData];
    }];
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self loadData];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setheaderViewInfo];
    self.navigationController.delegate = self;
    [self addNotificationWithName:PersonalInformationUpdate selector:@selector(setheaderViewInfo)];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

- (void)dealloc{
    NSLog(@"%s DEALLOC",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}
@end
