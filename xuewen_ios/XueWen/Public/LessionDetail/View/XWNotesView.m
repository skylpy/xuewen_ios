//
//  XWNotesView.m
//  XueWen
//
//  Created by aaron on 2018/7/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNotesView.h"
#import "XWNotesTableCell.h"
#import "XWCommentViewController.h"
#import "MainNavigationViewController.h"
#import "XWPopMenuView.h"
#import "XWEmptyDataCell.h"
static NSString *const XWNotesTableCellID = @"XWNotesTableCellID";
static NSString *const XWEmptyDataCellID = @"XWEmptyDataCellID";


@interface XWNotesView() <UITableViewDelegate, UITableViewDataSource>

/** 课程id*/
@property (nonatomic, strong) NSString *courseID;
/** 是笔记还是讨论*/
@property (nonatomic, assign) BOOL isNotes;
/** 选择笔记类型的按钮*/
@property (nonatomic, strong) UIButton *choiceBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
/** 笔记类型 (0全部1企业笔记2我的笔记)*/
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSMutableArray *menuArray;

@end

@implementation XWNotesView

#pragma mark - Lazy / Getter
- (UIButton *)choiceBtn{
    if (!_choiceBtn) {
        _choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choiceBtn setTitle:@"全部笔记 " forState:UIControlStateNormal];
        [_choiceBtn setImage:LoadImage(@"icon_option") forState:UIControlStateNormal];
        [_choiceBtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
        _choiceBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_choiceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_choiceBtn.currentImage.size.width, 0, _choiceBtn.currentImage.size.width)];
        [_choiceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, -65)];
        _choiceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_choiceBtn addTarget:self action:@selector(choiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choiceBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = [UIColor whiteColor];
        [table registerClass:[XWNotesTableCell class] forCellReuseIdentifier:XWNotesTableCellID];
        [table registerNib:[UINib nibWithNibName:@"XWEmptyDataCell" bundle:nil] forCellReuseIdentifier:XWEmptyDataCellID];
        _tableView = table;
    }
    return _tableView;
}

- (NSMutableArray *)menuArray{
    if (!_menuArray) {
        _menuArray = [[NSMutableArray alloc] init];
    }
    return _menuArray;
}


#pragma mark - lifecycle
- (void)didAppeared{
    
}

- (void)initWithCoursId:(NSString *)courseID isNotes:(BOOL)isNotes{
    self.courseID = courseID;
    self.isNotes = isNotes;
    self.status = @"0";
    [self initUI];
    [self loadData];
    [Analytics event:self.isNotes ? EventCourseNote : EventCourseCommont label:self.courseID];
}

#pragma mark - Super Methods
- (void)initUI{
    
    if (self.isNotes) {
        [self addSubview:self.choiceBtn];
        [self addSubview:self.tableView];
        [self.choiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-20);
            make.top.mas_equalTo(self).offset(19);
            make.size.mas_equalTo(CGSizeMake(80, 15));
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(50);
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-50);
        }];
    }else{
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(0);
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-50);
        }];
    }
    
    /** 设置刷新*/
    [self setRefresh];

}

- (void)loadData{
    XWWeakSelf
    if (self.isNotes) {  // 笔记
        [XWHttpTool getCourseNotesWithCoursID:self.courseID status:self.status isFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.dataArray = array;
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                weakSelf.tableView.mj_footer.hidden = YES;
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            [weakSelf.tableView.mj_header endRefreshing];
            
            [weakSelf.tableView reloadData];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.tableView.mj_footer.hidden = NO;
        }];
    }else{  // 讨论
        [XWHttpTool getCourseCommentWithCoursID:self.courseID isFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.dataArray = array;
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                weakSelf.tableView.mj_footer.hidden = YES;
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.tableView.mj_footer.hidden = NO;
        }];
    }
    
}

#pragma mark - Custom Methods

- (void)reloadData{
    CGFloat height = [self getBasicHeight];

}

- (CGFloat)getBasicHeight{
    CGFloat height  = 0;
    if ([self.delegate respondsToSelector:@selector(getBasicHeight)]) {
        height = [self.delegate getBasicHeight];
    }
    return height;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)loadMore{
    XWWeakSelf
    if (self.isNotes) { // 笔记
        [XWHttpTool getCourseNotesWithCoursID:self.courseID status:self.status isFirstLoad:NO success:^(NSMutableArray *array, BOOL isLast) {
            [weakSelf.dataArray addObjectsFromArray:array];
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                weakSelf.tableView.mj_footer.hidden = YES;
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.tableView.mj_footer.hidden = NO;
        }];
    }else{ // 讨论
        [XWHttpTool getCourseCommentWithCoursID:self.courseID isFirstLoad:NO success:^(NSMutableArray *array, BOOL isLast) {
            [weakSelf.dataArray addObjectsFromArray:array];
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                weakSelf.tableView.mj_footer.hidden = YES;
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.tableView.mj_footer.hidden = NO;
        }];
    }
}

#pragma mark - Button Action

- (void)choiceBtnClick:(UIButton *)sender{
    NSArray *titleArray = @[@"全部笔记", @"企业笔记", @"我的笔记"];
    
    XWWeakSelf
    XWPopMenuView *menuView = [[XWPopMenuView alloc] initWithTitleArray:titleArray selectedIndex:[self.status integerValue] doBlock:^(NSInteger selectedIndex) {
        weakSelf.status = [NSString stringWithFormat:@"%ld", selectedIndex];
        [sender setTitle:titleArray[selectedIndex] forState:UIControlStateNormal];
        [weakSelf loadData];
    } dismissBlock:^{
        
    }];
    [self addSubview:menuView];
    [self.menuArray addObject:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return 150;
    }
    XWWeakSelf
    return [tableView fd_heightForCellWithIdentifier:XWNotesTableCellID cacheByIndexPath:indexPath configuration:^(XWNotesTableCell* cell) {
        if (self.isNotes) {
            cell.noteModel = weakSelf.dataArray[indexPath.section];
        }else{
            cell.commentModel = weakSelf.dataArray[indexPath.section];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count == 0) {
        XWEmptyDataCell *cell = [tableView dequeueReusableCellWithIdentifier:XWEmptyDataCellID forIndexPath:indexPath];
        return cell;
    }
    XWNotesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNotesTableCellID forIndexPath:indexPath];
    if (self.isNotes) {
        cell.noteModel = self.dataArray[indexPath.section];
    }else{
        cell.commentModel = self.dataArray[indexPath.section];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


@end

