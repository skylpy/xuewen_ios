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
#import "MyWalletViewController.h"
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

static NSString *const MineListTableViewCellID = @"MineListTableViewCellID";

@interface MineViewController () <UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *Table;
@property (nonatomic, strong) MineHeaderView *headerView;

@end

@implementation MineViewController
#pragma mark - --- TableView Delegate&DataSource ---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:{
//                // 我的课程
//                if ([[XWInstance shareInstance].userInfo.role_id isEqualToString:@"3"]) {
//                    [self.navigationController pushViewController:[[MyClassesViewController alloc] initWithType:kMyClasses] animated:YES];
//                }else{
//                    [self.navigationController pushViewController:[MineClassesViewController new] animated:YES];
//                }
//            }break;
//            case 1:{
//                [self.navigationController pushViewController:[LearningPlanViewController new] animated:YES];
//            }break;
//            case 2:{
//                [self.navigationController pushViewController:[MyExamViewController new] animated:YES];
//            }break;
//            case 3:{
//                // 我的笔记
//                [self.navigationController pushViewController:[MyNotesViewController new] animated:YES];
//            }break;
//            default:
//                break;
//        }
//    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 3:{
                // 邀请y有礼
                [self.navigationController pushViewController:[InvitationViewController new] animated:YES];
            }break;
            case 0:{
                // 我的钱包
                [self.navigationController pushViewController:[MyWalletViewController new] animated:YES];
            }break;
            case 1:{
                // 我的优惠券
                [self.navigationController pushViewController:[MyCouponViewController new] animated:YES];
            }break;
            case 2:{
                // 我的订单
                [self.navigationController pushViewController:[PurchaseRecordViewController new] animated:YES];
            }break;
            case 4:{
                // 个人设置
                [self setAction:nil];
            }break;
            case 5:{
                // 用户反馈
                [self.navigationController pushViewController:[XWFeedBackViewController new] animated:YES];
            }break;
            default:
                break;
        }
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
//    return (section == 0) ? 4 : 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
//    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineListTableViewCellID forIndexPath:indexPath];
    cell.detailLB.hidden = YES;
    NSString *title = nil;
    NSString *image = nil;
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:{
//                title = @"我的课程";
//                image = @"iconMyCourse";
//            }break;
//            case 1:{
//                title = @"学习计划";
//                image = @"ico_learning_plan";
//            }break;
//            case 2:{
//                title = @"我的考试";
//                image = @"icoExamination";
//            }break;
//            case 3:{
//                title = @"我的笔记";
//                image = @"icoNote";
//            }break;
//            default:
//                break;
//        }
//    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 3:{
                title = @"邀请有礼";
                image = @"icoInvitation";
                cell.detailLB.hidden = NO;
                cell.detailLB.text = @"邀请1人得30元";
            }break;
            case 0:{
                title = @"我的钱包";
                image = @"iconMoney";
                cell.detailLB.hidden = NO;
                cell.detailLB.text = [NSString stringWithFormat:@"￥%@",[XWInstance shareInstance].userInfo.gold];
            }break;
            case 1:{
                title = @"我的奖学金";
                image = @"icoCoupon";
                cell.detailLB.hidden = NO;
                if ([[XWInstance shareInstance].userInfo.user_coupon isEqualToString:@""] || [XWInstance shareInstance].userInfo.user_coupon == nil) {
                    cell.detailLB.text = @"";
                }else{
                    cell.detailLB.text = [NSString stringWithFormat:@"￥%@",[XWInstance shareInstance].userInfo.user_coupon];
                }
                
            }break;
            case 2:{
                title = @"我的订单";
                image = @"icoOrder";
            }break;
            case 4:{
                title = @"个人设置";
                image = @"icoSetUp-1";
            }break;
            case 5:{
                title = @"用户反馈";
                image = @"icoNote";
            }break;
            default:
                break;
        }
//    }
    cell.titleLB.text = title;
    cell.imgV.image = LoadImage(image);
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
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 189, kWidth, kHeight - kTabBarH - 189 ) style:UITableViewStyleGrouped];
        
        [tableview registerNib:[UINib nibWithNibName:@"MineListTableViewCell" bundle:nil]  forCellReuseIdentifier:MineListTableViewCellID];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = self.view.backgroundColor;
        tableview.separatorStyle = 0;
        _Table = tableview;
    }
    
    return _Table;
}

- (MineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 190) target:self infoAction:@selector(infoAction:) setAction:@selector(setAction:)];
    }
    return _headerView;
}
#pragma mark - --- Life Cycle ---

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self loadData];
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
