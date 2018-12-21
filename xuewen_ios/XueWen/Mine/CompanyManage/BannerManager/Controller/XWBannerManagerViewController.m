//
//  XWBannerManagerViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/10.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWBannerManagerViewController.h"
#import "XWBannerManagerCell.h"
#import "XWBannerEditViewController.h"

static NSString *const XWBannerManagerCellID = @"XWBannerManagerCellID";

@interface XWBannerManagerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation XWBannerManagerViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWBannerManagerCell" bundle:nil] forCellReuseIdentifier:XWBannerManagerCellID];
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = table;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"轮播图管理";
    [self.view addSubview:self.tableView];
    [self addNotificationWithName:@"ReloadBannerData" selector:@selector(loadData)];
    [self addNotificationWithName:@"UpdateBannerManager" selector:@selector(loadData)];
}

- (void)loadData {
    XWWeakSelf
    [XWNetworking getBannerImagesWithCompleteBlock:^(NSArray<BannerModel *> *banners) {
        weakSelf.dataSource = [banners mutableCopy];
        [weakSelf.tableView reloadData];
    } cid:kUserInfo.company_id];
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 148;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWBannerManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:XWBannerManagerCellID forIndexPath:indexPath];
    if (indexPath.row == self.dataSource.count) {
        cell.isLastCell = YES;
    }else {
        cell.isLastCell = NO;
        cell.banner = self.dataSource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWBannerEditViewController *vc = [[XWBannerEditViewController alloc] init];
    if (indexPath.row == self.dataSource.count) {
        vc.type = ControllerTypeAdd;
    }else{
        vc.type = ControllerTypeEdit;
        vc.banner = self.dataSource[indexPath.row];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
