//
//  XWChoiceLabelSecViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWChoiceLabelSecViewController.h"
#import "XWChoiceDepartmentCell.h"
#import "XWAddStudentViewController.h"


static NSString *const XWChoiceDepartmentCellID = @"XWChoiceDepartmentCellID";

@interface XWChoiceLabelSecViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation XWChoiceLabelSecViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 55;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWChoiceDepartmentCell" bundle:nil] forCellReuseIdentifier:XWChoiceDepartmentCellID];
        
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
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    XWWeakSelf
    [XWHttpTool getLabelListWithLabelId:self.labelId success:^(NSMutableArray *dataSource) {
        weakSelf.dataSource = dataSource;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWChoiceDepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:XWChoiceDepartmentCellID forIndexPath:indexPath];
    cell.isLabel = YES;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWLabelModel *model = self.dataSource[indexPath.row];
    [self postNotificationWithName:@"ChoiceLabelFinished" object:model];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XWAddStudentViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }else if ([vc isKindOfClass:NSClassFromString(@"XWStaffInfoViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
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
