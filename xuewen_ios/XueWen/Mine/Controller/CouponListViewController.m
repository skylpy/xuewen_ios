//
//  CouponListViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/3/6.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponCell.h"
#import "CouponModel.h"
@interface CouponListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL hasUsed;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<CouponModel *> *coupons;

@end

@implementation CouponListViewController
#pragma mark- UITableViewDelegate&&DataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0) ? 15 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.coupons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.model = self.coupons[indexPath.section];
    return cell;
}

#pragma mark- CustomMethod
- (void)initUI{
    [self setDefaultPage];
    self.scrollView = self.tableView;
    [self addHeaderWithAction:@selector(loadCouponList)];
    [self addFooterWithAction:@selector(loadCouponList)];
    [self beginLoadData];
}

- (void)loadCouponList{
    WeakSelf;
    [XWNetworking getCouponListWithType:_hasUsed ? @"2" : @"1" page:(int)self.page++ completeBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        [weakSelf loadedDataWithArray:array isLast:isLast];
    }];
}

- (void)setDefaultPage{
    UIView *defaultPage = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kWidth, 92)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:LoadImage(@"iconCouponEmpty")];
    UILabel *title = [UILabel labelWithTextColor:DefaultTitleCColor size:14];
    title.text = @"暂无优惠券可用";
    title.textAlignment = 1;
    [defaultPage addSubview:imageView];
    [defaultPage addSubview:title];
    imageView.sd_layout.topSpaceToView(defaultPage, 0).centerXEqualToView(defaultPage).widthIs(70).heightIs(70);
    title.sd_layout.topSpaceToView(imageView, 9).leftSpaceToView(defaultPage,0).rightSpaceToView(defaultPage, 0).bottomSpaceToView(defaultPage, 0);
    self.defaultPage.hidden = YES;
    self.defaultPage = defaultPage;
}
#pragma mark- Setter
#pragma mark- Getter
- (NSArray<CouponModel *> *)coupons{
    if (!_coupons) {
        _coupons = self.array;
    }
    return _coupons;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView tableViewWithFrame:CGRectMake(0, 0, kWidth, kHeight - kNaviBarH - 45) style:UITableViewStylePlain delegate:self dataSource:self registerClass:@{@"CouponCell" : CellID}];
    }
    return _tableView;
}

#pragma mark- LifeCycle
- (instancetype)initWithHasUsed:(BOOL)hasUsed{
    if (self = [super init]) {
        self.hasUsed = hasUsed;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
