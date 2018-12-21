//
//  XWFindViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/10/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWFindViewController.h"
#import "XWFindTableCell.h"
#import "XWHeaderBannerView.h"
#import "XWBBusinessController.h"
#import "XWFindModel.h"

static NSString *const XWFindTableCellID = @"XWFindTableCellID";


@interface XWFindViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XWHeaderBannerView *bannerView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation XWFindViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStasusBarH, kWidth, kHeightNoNaviBar) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Color(@"#f4f4f4");
        _tableView.tableHeaderView = self.bannerView;
        [_tableView registerNib:[UINib nibWithNibName:@"XWFindTableCell" bundle:nil] forCellReuseIdentifier:XWFindTableCellID];
    }
    return _tableView;
}

- (XWHeaderBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XWHeaderBannerView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 175)];
    }
    return _bannerView;
}

#pragma mark - LifeCyele
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)loadData {
    
    @weakify(self)
    /** 公司列表*/
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
         @strongify(self)
        [XWFindModel getDiscoveryWithIsFirstLoad:YES Success:^(NSMutableArray * _Nonnull list, BOOL isLast) {
            XWWeakSelf
            weakSelf.dataArray = list;
            [weakSelf.tableView reloadData];
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [subscriber sendNext:@"1"];
        } failure:^(NSString * _Nonnull error) {
            
        }];
        return nil;
    }];
    
   /** 轮播图*/
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWNetworking getFindBannerImagesWithCompleteBlock:^(NSArray<BannerModel *> *banners) {
            
            weakSelf.bannerView.modelArray = [banners mutableCopy];
            [subscriber sendNext:@"1"];
        }];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(completedRequest1:request2:) withSignalsFromArray:@[signal1, signal2]];
}

- (void)completedRequest1:(NSString *)data1 request2:(NSString *)data2 {
    if ([data1 isEqualToString:@"1"] && [data2 isEqualToString:@"1"] ) {
        NSLog(@"更新成功");
        [self.tableView.mj_header endRefreshing];
    }else{
        NSLog(@"更新失败");
         [self.tableView.mj_header endRefreshing];
    }
    
}

- (BOOL)hiddenNavigationBar{
    return YES;
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 258;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWFindTableCell * cell = [tableView dequeueReusableCellWithIdentifier:XWFindTableCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWFindListModel *model = self.dataArray[indexPath.section];
    XWBBusinessController *vc = [[XWBBusinessController alloc] init];
    vc.title = model.college_name;
    vc.companyId = model.mid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
