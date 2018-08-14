//
//  SettingViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/14.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
// 个人设置界面
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "MainNavigationViewController.h"
#import "RegistViewController.h"
#import "InvitationCodeViewController.h"
#import "AboutViewController.h"
@interface SettingFooterView : UIView

- (instancetype)initWithTarget:(id)target action:(SEL)action;

@end

@implementation SettingFooterView
- (instancetype)initWithTarget:(id)target action:(SEL)action{
    if (self = [super initWithFrame:CGRectMake(0, 0, kWidth, 84)]) {
        UIButton *button = [UIButton buttonWithType:0];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setTitleColor:COLOR(251, 27, 27) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = kFontSize(16);
        [self addSubview:button];
        button.sd_layout.spaceToSuperView(UIEdgeInsetsMake(20, 15, 20, 15));
        button.layer.borderColor = COLOR(204, 204, 204).CGColor;
        button.layer.borderWidth = 1;
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}
@end

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            [self.navigationController pushViewController:[[RegistViewController alloc] initWithType:3] animated:YES];
        }break;
        case 1:{
            [self.navigationController pushViewController:[[InvitationCodeViewController alloc] init] animated:YES];
        }break;
        case 2:{
            [self.navigationController pushViewController:[AboutViewController new] animated:YES];
        }break;
            
        case 3:{
            [self.navigationController pushViewController:[ViewControllerManager debugViewController] animated:YES];
        }break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    [cell setIsFirst:indexPath.row == 0 leftSpace:15 rightSpace:0];
    UILabel *label = cell.textLabel;
    label.font = kFontSize(14);
    label.textColor = DefaultTitleAColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:{
            label.text = @"修改密码";
        }break;
        case 1:{
            label.text = @"我的邀请码";
        }break;
        case 2:{
            label.text = @"关于学问";
        }break;
        case 3:{
            label.text = @"测试";
        }break;
        default:
            break;
    }
    return cell;
}

#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"设置";
    self.view.backgroundColor = DefaultBgColor;
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    
}

- (void)LoginOut{
    [XWPopupWindow popupWindowsWithTitle:@"退出" message:@"确认退出?" leftTitle:@"确认" rightTitle:@"取消" leftBlock:^{
        [[XWInstance shareInstance] logout];
    } rightBlock:nil];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma mark- Setter
#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
        _tableView.tableFooterView = [[SettingFooterView alloc] initWithTarget:self action:@selector(LoginOut)];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
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
