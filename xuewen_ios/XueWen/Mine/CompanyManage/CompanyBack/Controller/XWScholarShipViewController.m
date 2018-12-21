//
//  XWScholarShipViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWScholarShipViewController.h"
#import "XWScholarShipCell.h"
#import "XWCompanyBackModel.h"

static NSString *const XWScholarShipCellID = @"XWScholarShipCellID";

@interface XWScholarShipViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,assign) CGFloat price;

@end

@implementation XWScholarShipViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawUI];
    [self requestData];
    
    if (self.shipPrice > 0) {
        [self setNav];
    }
}

- (void)setNav {
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 45, 30);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    @weakify(self)
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        CGFloat totlep = 0;
        NSInteger count = 0;
        NSString * couponID = @"";
        
        for (CouponModel * model in self.dataArray) {
            
            if (model.isSelect) {
                count ++;
                totlep += [model.price floatValue];
                if ([couponID isEqualToString:@""]) {
                    couponID = model.couponID;
                }else {
                    couponID = [NSString stringWithFormat:@"%@,%@",couponID,model.couponID];
                }
            }
        }
        !self.ScholarShipClick?:self.ScholarShipClick(totlep,count,couponID);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)requestData {
    
    [XWCompanyBackModel getCouponListWithType:@"1" success:^(NSArray * _Nonnull list) {
        NSArray  *array = [self.couponID componentsSeparatedByString:@","];
        for (int i = 0; i < array.count; i ++) {
            for (CouponModel * model in list) {
                if ([array[i] isEqualToString:model.couponID]) {
                    model.isSelect = YES;
                }
            }
        }
        
        [self couponDealWith:list];
        
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

/**
 *注释
 *优惠券逻辑处理
 */
-(void)couponDealWith:(NSArray *)array{
    
    for (CouponModel * model in array) {
        model.canUse = YES;
        if (model.isSelect) {
            
            self.shipPrice -= [model.price floatValue];
        }
    }
    if (self.shipPrice < 0) {
        
        for (CouponModel * model in array){
            if (model.isSelect){
                model.canUse = YES;
            }else {
                model.canUse = NO;
            }
        }
    }
    self.shipPrice = self.price;
}


- (void)drawUI {
    
    self.title = @"奖学金";
    self.price = self.shipPrice;
    self.view.backgroundColor = Color(@"#F9F9F9");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XWScholarShipCell *cell = [tableView dequeueReusableCellWithIdentifier:XWScholarShipCellID forIndexPath:indexPath];
    
    CouponModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.shipPrice == 0) {
        
        return;
    }
    
    CouponModel * model = self.dataArray[indexPath.section];
    
    if (!model.canUse) {
        
        return;
    }
    model.isSelect = !model.isSelect;
    
    
    [self couponDealWith:self.dataArray];
    
    
    
    [self.tableView reloadData];
}


- (UITableView *)tableView {
    if (!_tableView) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [tableview registerNib:[UINib nibWithNibName:@"XWScholarShipCell" bundle:nil]  forCellReuseIdentifier:XWScholarShipCellID];
        
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = self.view.backgroundColor;
        tableview.separatorStyle = 0;
        tableview.estimatedSectionFooterHeight = 0.0;
        _tableView = tableview;
        
    }
    
    return _tableView;
}

@end
