//
//  XWStudyRankView.m
//  XueWen
//
//  Created by Karron Su on 2018/7/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWStudyRankView.h"
#import "XWStudyRankCell.h"
#import "XWStudyHeaderView.h"
#import "XWRankTableCell.h"
#import "XWRankListController.h"

static NSString *const XWStudyRankCellID = @"XWStudyRankCellID";
static NSString *const XWRankTableCellID = @"XWRankTableCellID";

@interface XWStudyRankView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) XWStudyHeaderView *headerView;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation XWStudyRankView

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = Color(@"#F4F4F4");
        table.scrollEnabled = NO;
        [table registerNib:[UINib nibWithNibName:@"XWStudyRankCell" bundle:nil] forCellReuseIdentifier:XWStudyRankCellID];
        [table registerNib:[UINib nibWithNibName:@"XWRankTableCell" bundle:nil] forCellReuseIdentifier:XWRankTableCellID];
        table.tableHeaderView = self.headerView;
        if (self.isMyCompany) {
            self.headerView.height = 90;
            self.headerView.hidden = NO;
        }else{
            self.headerView.height = 0;
            self.headerView.hidden = YES;
        }
        
        _tableView = table;
    }
    return _tableView;
}

- (XWStudyHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[XWStudyHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 90)];
//        _headerView.type = self.type;
    }
    return _headerView;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:LoadImage(@"icon_home_right") forState:UIControlStateNormal];
        [_moreBtn setTitle:@"更多 " forState:UIControlStateNormal];
        [_moreBtn setTitleColor:Color(@"#999999") forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        _moreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        // 重点位置开始
        _moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _moreBtn.titleLabel.width + 35, 0, -_moreBtn.titleLabel.width - 35);
        _moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_moreBtn.currentImage.size.width, 0, _moreBtn.currentImage.size.width);
        // 重点位置结束
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        @weakify(self)
        [[_moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            XWRankListController *vc = [[XWRankListController alloc] initWithIndex:self.index];
//            vc.index = self.index;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _moreBtn;
}

#pragma mark - Setter

- (void)setStudyArray:(NSMutableArray *)studyArray{
    _studyArray = studyArray;
    [self.tableView reloadData];
}

- (void)setRankModel:(XWCountPlayTimeModel *)rankModel{
    _rankModel = rankModel;
    self.headerView.rankModel = _rankModel;
    self.headerView.type = ControllerTypeWeek;
}

- (void)setTargetArray:(NSMutableArray *)targetArray{
    _targetArray = targetArray;
    [self.tableView reloadData];
}

- (void)setTargetModel:(XWTargetRankModel *)targetModel{
    _targetModel = targetModel;
    self.headerView.goalModel = _targetModel;
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.index == 0) {
        return self.studyArray.count;
    }
    return self.targetArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= 2) {
        return 92;
    }
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= 2) {
        XWRankTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWRankTableCellID forIndexPath:indexPath];
        cell.isLast = indexPath.row == 2 ? YES : NO;
        if (self.index == 0) {
            cell.model = self.studyArray[indexPath.row];
        }else{
            cell.targetModel = self.targetArray[indexPath.row];
        }
        cell.idx = indexPath.row;
        cell.isMyCompany = self.isMyCompany;
        return cell;
    }
    XWStudyRankCell *cell = [tableView dequeueReusableCellWithIdentifier:XWStudyRankCellID forIndexPath:indexPath];
    if (self.index == 0) {
        cell.isLast = indexPath.row == self.studyArray.count-1 ? YES : NO;
        cell.model = self.studyArray[indexPath.row];
    }else{
        cell.isLast = indexPath.row == self.targetArray.count-1 ? YES : NO;
        cell.targetModel = self.targetArray[indexPath.row];
    }
    cell.idx = indexPath.row;
    cell.isMyCompany = self.isMyCompany;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 63;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 63)];
    bgView.backgroundColor = Color(@"#7EBDFF");
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(25);
        make.right.mas_equalTo(bgView).offset(-25);
        make.top.bottom.mas_equalTo(bgView);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"本周排名";
    label.textColor = Color(@"#333333");
    label.font = [UIFont fontWithName:kMedFont size:17];
    [backView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView).offset(13);
        make.bottom.mas_equalTo(backView).offset(-17);
    }];
    
    [backView addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView).offset(-12);
        make.bottom.mas_equalTo(label.mas_bottom);
    }];
    if (self.isMyCompany) {
        self.moreBtn.hidden = NO;
    }else{
        self.moreBtn.hidden = YES;
    }
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)didAppeared{
    [self addSubview:self.tableView];
}

@end
