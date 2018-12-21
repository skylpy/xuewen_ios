//
//  XWCompanyCoursView.m
//  XueWen
//
//  Created by Karron Su on 2018/7/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCompanyCoursView.h"
#import "XWCompanyTabCell.h"
#import "XWCompanyCoursCell.h"
#import "XWLearningViewController.h"
#import "XWNoneDataTableCell.h"

static NSString *const XWCompanyTabCellID = @"XWCompanyTabCellID";
static NSString *const XWCompanyCoursCellID = @"XWCompanyCoursCellID";
static NSString *const XWNoneDataTableCellID = @"XWNoneDataTableCellID";

@interface XWCompanyCoursView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation XWCompanyCoursView

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = Color(@"#F4F4F4");
        table.scrollEnabled = NO;
        [table registerNib:[UINib nibWithNibName:@"XWCompanyTabCell" bundle:nil] forCellReuseIdentifier:XWCompanyTabCellID];
        [table registerClass:[XWCompanyCoursCell class] forCellReuseIdentifier:XWCompanyCoursCellID];
        [table registerNib:[UINib nibWithNibName:@"XWNoneDataTableCell" bundle:nil] forCellReuseIdentifier:XWNoneDataTableCellID];
        _tableView = table;
    }
    return _tableView;
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
            XWLearningViewController *vc = [XWLearningViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _moreBtn;
}



- (void)setLearnArray:(NSMutableArray *)learnArray{
    _learnArray = learnArray;
    [self.tableView reloadData];
}

- (void)setCompanyCoursArray:(NSMutableArray *)companyCoursArray{
    _companyCoursArray = companyCoursArray;
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.learnArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 127;
    }
    if (self.companyCoursArray.count == 0) {
        return 193;
    }
    return (kWidth-100)*1.4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        XWCompanyTabCell *cell = [tableView dequeueReusableCellWithIdentifier:XWCompanyTabCellID forIndexPath:indexPath];
        if (self.learnArray.count != 0) {
            cell.model = self.learnArray[indexPath.row];
        }
        
        return cell;
    }
    
    if (self.companyCoursArray.count == 0) {
        XWNoneDataTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNoneDataTableCellID forIndexPath:indexPath];
        return cell;
    }
    
    XWCompanyCoursCell *cell = [tableView dequeueReusableCellWithIdentifier:XWCompanyCoursCellID forIndexPath:indexPath];
    cell.dataArray = self.companyCoursArray;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        XWLearningModel *model = self.learnArray[indexPath.row];
//        if ([model.courseType isEqualToString:@"2"]) {
//            [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:YES] animated:YES];
//        }else{
            [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:NO] animated:YES];
//        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (self.learnArray.count == 0) {
            return 0.01;
        }
        return 50;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"大家在学";
    label.textColor = Color(@"#333333");
    label.font = [UIFont fontWithName:kMedFont size:17];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(25);
        make.centerY.mas_equalTo(bgView);
    }];
    
    
    [bgView addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView).offset(-25);
        make.centerY.mas_equalTo(bgView);
    }];
    
    if (self.isMyCompany) {
        self.moreBtn.hidden = NO;
    }else{
        self.moreBtn.hidden = YES;
    }
    
    if (self.learnArray.count == 0) {
        return nil;
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
