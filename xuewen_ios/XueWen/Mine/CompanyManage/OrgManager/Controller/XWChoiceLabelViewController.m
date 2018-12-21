//
//  XWChoiceLabelViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWChoiceLabelViewController.h"
#import "XWChoiceLabelCell.h"
#import "XWChoiceLabelSecViewController.h"

static NSString *const XWChoiceLabelCellID = @"XWChoiceLabelCellID";


@interface XWChoiceLabelViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) XWLabelModel *labelModel;

@end

@implementation XWChoiceLabelViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 55;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWChoiceLabelCell" bundle:nil] forCellReuseIdentifier:XWChoiceLabelCellID];
        
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
    self.title = @"全部课程";
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithTitle:@"完成" target:self method:@selector(rightBtnClick)];
}

- (void)loadData {
    XWWeakSelf
    [XWHttpTool getLabelListWithLabelId:@"47" success:^(NSMutableArray *dataSource) {
        weakSelf.dataSource = dataSource;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - Custom Methods
- (void)rightBtnClick {
    [self postNotificationWithName:@"ChoiceLabelFinished" object:self.labelModel];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    XWChoiceLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:XWChoiceLabelCellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    XWWeakSelf
    cell.block = ^(XWLabelModel * _Nonnull labelModel) {
        labelModel.isSelect = !labelModel.isSelect;
        __block NSInteger index = [weakSelf.dataSource indexOfObject:labelModel];
        [weakSelf.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XWLabelModel *model = (XWLabelModel *)obj;
            if (idx != index) {
                model.isSelect = NO;
            }
        }];
        weakSelf.labelModel = labelModel;
        [weakSelf.dataSource replaceObjectAtIndex:index withObject:labelModel];
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWLabelModel *model = self.dataSource[indexPath.row];
    XWChoiceLabelSecViewController *vc = [XWChoiceLabelSecViewController new];
    vc.title = model.label_name;
    vc.labelId = model.labelId;
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
