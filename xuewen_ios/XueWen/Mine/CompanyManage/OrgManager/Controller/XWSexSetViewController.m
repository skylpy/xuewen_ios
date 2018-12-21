//
//  XWSexSetViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/15.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWSexSetViewController.h"
#import "XWChoiceDepartmentCell.h"

static NSString *const XWChoiceDepartmentCellID = @"XWChoiceDepartmentCellID";

@interface XWSexSetViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XWSexSetViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 55;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.backgroundColor = Color(@"#F6F6F6");
        [table registerNib:[UINib nibWithNibName:@"XWChoiceDepartmentCell" bundle:nil] forCellReuseIdentifier:XWChoiceDepartmentCellID];
        _tableView = table;
    }
    return _tableView;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"选择性别";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWChoiceDepartmentCell * cell = [tableView dequeueReusableCellWithIdentifier:XWChoiceDepartmentCellID forIndexPath:indexPath];
    cell.isLabel = YES;
    if (indexPath.row == 0) {
        cell.name = @"男";
    }else {
        cell.name = @"女";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sex;
    if (indexPath.row == 0) {
        sex = @"1";
    }else {
        sex = @"0";
    }
    !self.sexBlock ? : self.sexBlock(sex);
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.010;
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
