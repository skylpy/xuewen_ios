//
//  XWSuperOrgViewController.m
//  XueWen
//
//  Created by aaron on 2018/10/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWSuperOrgViewController.h"
#import "XWSuperOrgLeftCell.h"
#import "XWSuperGroupModel.h"
#import "ConfirmOrderViewController.h"

static NSString * const XWSuperOrgLeftCellID = @"XWSuperOrgLeftCellID";
static NSString * const XWSuperOrgRightCellID = @"XWSuperOrgRightCellID";

@interface XWSuperOrgViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) UIView * footerView;
@property (nonatomic,strong) UIButton * numberButton;
@property (nonatomic,strong) UIButton * likeButton;

@end

@implementation XWSuperOrgViewController

#pragma dataArray
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    [self loadData];
}

- (void)loadData {
    
    [XWSuperGModel getSuperGroupListPage:1 Success:^(XWSuperGroupModel * _Nonnull model) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:model.data];
        [self setFooterViewWith:model];
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [MBProgressHUD showTipMessageInWindow:error];
    }];
}

- (void)setFooterViewWith:(XWSuperGroupModel *)model{
    NSString *title = [NSString stringWithFormat:@"年费每人¥%@/年", model.total_price];
    [self.numberButton setTitle:title forState:UIControlStateNormal];
    if (model.buy) {
        [self.likeButton setTitle:@"已参与" forState:UIControlStateNormal];
        self.likeButton.userInteractionEnabled = NO;
    }else{
        [self.likeButton setTitle:@"立即参与" forState:UIControlStateNormal];
        self.likeButton.userInteractionEnabled = YES;
    }
}

- (void)setDrawUI {
    
    self.title = @"超级组织";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];
    
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.numberButton];
    [self.footerView addSubview:self.likeButton];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.offset(45);
    }];
    
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.footerView);
        make.width.offset(kWidth/2);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self.footerView);
        make.width.offset(kWidth/2);
    }];
}

#pragma mark View

- (UIView *)footerView {
    
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        
    }
    return _footerView;
}

- (UIButton *)numberButton {
    
    if (!_numberButton) {
        _numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _numberButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_numberButton setTitleColor:Color(@"#FFCD67") forState:UIControlStateNormal];;
        [_numberButton setTitle:@"年费每人¥998/年" forState:UIControlStateNormal];
        _numberButton.backgroundColor = Color(@"#FFFFFF");
    }
    return _numberButton;
}

- (UIButton *)likeButton {
    
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.titleLabel.font = [UIFont fontWithName:kRegFont size:18];
        [_likeButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];;
        [_likeButton setTitle:@"立即参与" forState:UIControlStateNormal];
        _likeButton.backgroundColor = Color(@"#317FFF");
        @weakify(self)
        [[_likeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            ConfirmOrderViewController * vc = [[ConfirmOrderViewController alloc] initWithID:@"" type:1 updateBlcok:^{
                [self loadData];
            }];
            vc.isSuper = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _likeButton;
}

#pragma tableView
- (UITableView *)tableView {
    
    if (!_tableView) {
        UITableView * table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView = table;
        table.separatorStyle = 0;
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = Color(@"#F4F4F4");
        [table registerClass:[XWSuperOrgRightCell class] forCellReuseIdentifier:XWSuperOrgRightCellID];
        [table registerClass:[XWSuperOrgLeftCell class] forCellReuseIdentifier:XWSuperOrgLeftCellID];
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1047)];
        table.tableHeaderView = headerView;
        
        UIImageView * headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1047)];
        [headerView addSubview:headerImage];
        headerImage.image = [UIImage imageNamed:@"×_edu_header"];
        
        UIView * fooderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1561)];
        table.tableFooterView = fooderView;
        
        UIImageView * fooderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1561)];
        [fooderView addSubview:fooderImage];
        fooderImage.image = [UIImage imageNamed:@"photo_edu_footer"];
    }
    return _tableView;
}


#pragma UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 != 0) {
        return 98;
    }
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 78;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 78)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"2018下半年课程表";
    label.textColor = Color(@"#614901");
    label.font = [UIFont fontWithName:kMedFont size:16];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.top.mas_equalTo(bgView).offset(26);
    }];
    return bgView;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row%2 != 0) {
        
        XWSuperOrgRightCell * cell = [tableView dequeueReusableCellWithIdentifier:XWSuperOrgRightCellID forIndexPath:indexPath];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    
    XWSuperOrgLeftCell * cell = [tableView dequeueReusableCellWithIdentifier:XWSuperOrgLeftCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWSuperGModel *model = self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.mid isAudio:NO] animated:YES];
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
