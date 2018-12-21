//
//  XWIncomeListController.m
//  XueWen
//
//  Created by Karron Su on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIncomeListController.h"
#import "XWIncomeTableCell.h"
#import "XWIncomeListHeaderView.h"

static NSString *const XWIncomeTableCellID = @"XWIncomeTableCellID";


@interface XWIncomeListController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, XWIncomeListHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XWIncomeListHeaderView *headerView;
@property (nonatomic, strong) BaseAlertView *alertView;
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) NSArray *dateArray;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *date;

@end

@implementation XWIncomeListController

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-202-kNaviBarH) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWIncomeTableCell" bundle:nil] forCellReuseIdentifier:XWIncomeTableCellID];
        table.tableHeaderView = self.headerView;
        _tableView = table;
    }
    return _tableView;
}

- (XWIncomeListHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[XWIncomeListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 43)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (BaseAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, kHeight - 194 - kBottomH, kWidth, 194 + kBottomH)];
        _alertView.animationType = kAnimationBottom;
        _alertView.cornerRadius = 0;
        _alertView.backgroundColor = DefaultBgColor;
        // 背景
        UIView *backgroundView = [UIView new];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [_alertView addSubview:backgroundView];
        backgroundView.sd_layout.topSpaceToView(_alertView, 44).leftSpaceToView(_alertView, 0 ).bottomSpaceToView(_alertView, 0).rightSpaceToView(_alertView, 0);
        
        [backgroundView addSubview:self.datePicker];
        self.datePicker.sd_layout.topSpaceToView(backgroundView, 0).leftSpaceToView(backgroundView, 0).bottomSpaceToView(backgroundView, kBottomH).rightSpaceToView(backgroundView, 0);
        // 确认
        UIButton *confirmButton = [UIButton buttonWithType:0];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        confirmButton.titleLabel.font = kFontSize(16);
        [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:confirmButton];
        confirmButton.sd_layout.topSpaceToView(_alertView, 0).rightSpaceToView(_alertView, 0).heightIs(44).widthIs(70);
        
        // 取消
        UIButton *cancelButton = [UIButton buttonWithType:0];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:DefaultTitleBColor forState:UIControlStateNormal];
        cancelButton.titleLabel.font = kFontSize(16);
        [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:cancelButton];
        cancelButton.sd_layout.topSpaceToView(_alertView, 0).leftSpaceToView(_alertView, 0).heightIs(44).widthIs(70);
        
        
    }
    return _alertView;
}

- (UIPickerView *)datePicker{
    if (!_datePicker) {
        _datePicker = [UIPickerView new];
        _datePicker.delegate = self;
//        _datePicker.dataSour1ce = self;
    }
    return _datePicker;
}

- (NSArray *)dateArray{
    if (!_dateArray) {
        NSString *date = [NSDate dateWithFormat:@"YYYY-MM"];
        NSArray *array = [date componentsSeparatedByString:@"-"];
        if (array.count == 2) {
            NSMutableArray *mArray = [NSMutableArray array];
            int year = [array[0] intValue];
            int month = [array[1] intValue];
            for (int i = 0; i < 12; i++) {
                [mArray addObject:[NSString stringWithFormat:@"%d-%02d",year,month--]];
                if (month <= 0) {
                    month = 12;
                    year -= 1;
                }
            }
            _dateArray = mArray;
        }
    }
    return _dateArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)loadData{
    XWWeakSelf
    [XWHttpTool getBonusesEarningsWithType:self.type isFirstLoad:YES date:self.date success:^(NSMutableArray *array, BOOL isLast, NSString *earnings) {
        weakSelf.dataArray = array;
        weakSelf.headerView.earnings = earnings;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *errorInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTipMessageInWindow:errorInfo];
    }];
}

- (void)loadMore{
    XWWeakSelf
    [XWHttpTool getBonusesEarningsWithType:self.type isFirstLoad:NO date:self.date success:^(NSMutableArray *array, BOOL isLast, NSString *earnings) {
        [weakSelf.dataArray addObjectsFromArray:array];
        weakSelf.headerView.earnings = earnings;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *errorInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTipMessageInWindow:errorInfo];
    }];
}

#pragma mark - Custom Methods
- (void)cancelAction:(UIButton *)sender{
    [self.alertView dismiss];
}

- (void)confirmAction:(UIButton *)sender{
    NSInteger index = [self.datePicker selectedRowInComponent:0];
    self.date = self.dateArray[index];
    [self.alertView dismiss];
    [self loadData];
}

#pragma mark - XWIncomeListHeaderViewDelegate
- (void)datePickShow{
    [self.alertView show];
}

#pragma mark- PickerDeleaget
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dateArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componen{
    return self.dateArray[row];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWIncomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWIncomeTableCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
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
