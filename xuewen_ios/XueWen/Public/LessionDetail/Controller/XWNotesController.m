//
//  XWNotesController.m
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNotesController.h"
#import "XWNotesTableCell.h"
#import "XWCommentViewController.h"
#import "MainNavigationViewController.h"
#import "XWNoteInputView.h"
#import "XWPopMenuView.h"

static NSString *const XWNotesTableCellID = @"XWNotesTableCellID";


@interface XWNotesController () <UITableViewDelegate, UITableViewDataSource>

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
/** 输入框*/
@property (nonatomic, strong) XWNoteInputView *noteInputView;
@property (nonatomic, strong) XWNoteInputView *keyInputView;

@property (nonatomic, strong) NSMutableArray *menuArray;

@end

@implementation XWNotesController

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

- (XWNoteInputView *)noteInputView{
    if (!_noteInputView) {
        CGFloat height = [self getBasicHeight];
        _noteInputView = [[XWNoteInputView alloc] initWithFrame:CGRectMake(0, kHeight-158-height+kNaviBarH-kStasusBarH, kWidth, 50)];
        XWWeakSelf
        _noteInputView.TapAction = ^(BOOL isNotes){
            [weakSelf pushEditNoteViewController];
        };
        _noteInputView.TapBecomeAction = ^(BOOL isNotes){
            [kMainWindow addSubview:weakSelf.keyInputView];
            [weakSelf.keyInputView.textView becomeFirstResponder];
        };
        _noteInputView.isNotes = self.isNotes;
    }
    return _noteInputView;
}

- (XWNoteInputView *)keyInputView{
    if (!_keyInputView) {
        _keyInputView = [[XWNoteInputView alloc] initWithFrame:CGRectZero];
        XWWeakSelf
        _keyInputView.SendText = ^(NSString *text){
            [weakSelf addCommonWithText:text];
        };
    }
    return _keyInputView;
}



#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Analytics event:self.isNotes ? EventCourseNote : EventCourseCommont label:self.courseID];
}

- (instancetype)initWithCoursId:(NSString *)courseID isNotes:(BOOL)isNotes{
    if (self = [super init]) {
        self.courseID = courseID;
        self.isNotes = isNotes;
        self.status = @"0";
    }
    return self;
}

#pragma mark - Super Methods
- (void)initUI{
    
    if (self.isNotes) {
        [self.view addSubview:self.choiceBtn];
        [self.view addSubview:self.tableView];
        [self.choiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view).offset(-20);
            make.top.mas_equalTo(self.view).offset(19);
            make.size.mas_equalTo(CGSizeMake(80, 15));
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(50);
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-50);
        }];
    }else{
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(0);
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-50);
        }];
    }
    
    /** 输入框*/
    [self.view insertSubview:self.noteInputView aboveSubview:self.tableView];
    
    /** 设置刷新*/
    [self setRefresh];
    /** 添加观察者*/
    [self addObserver];
}

- (void)loadData{
    XWWeakSelf
    if (self.isNotes) {  // 笔记
        [XWHttpTool getCourseNotesWithCoursID:self.courseID status:self.status isFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.dataArray = array;
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }else{  // 讨论
        [XWHttpTool getCourseCommentWithCoursID:self.courseID isFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.dataArray = array;
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
}

#pragma mark - Custom Methods

- (void)reloadData{
    CGFloat height = [self getBasicHeight];
    self.noteInputView.frame = CGRectMake(0, kHeight-165-height+kNaviBarH-kStasusBarH, kWidth, 50);
}

- (CGFloat)getBasicHeight{
    CGFloat height  = 0;
    if ([self.delegate respondsToSelector:@selector(getBasicHeight)]) {
        height = [self.delegate getBasicHeight];
    }
    return height;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)addObserver{
    [self addKeyboardNoticationWithShowAction:@selector(keyboardWillShow:) hiddenAciton:@selector(keyboardWillHidden:)];
}

- (void)loadMore{
    XWWeakSelf
    if (self.isNotes) { // 笔记
        [XWHttpTool getCourseNotesWithCoursID:self.courseID status:self.status isFirstLoad:NO success:^(NSMutableArray *array, BOOL isLast) {
            [weakSelf.dataArray addObjectsFromArray:array];
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }else{ // 讨论
        [XWHttpTool getCourseCommentWithCoursID:self.courseID isFirstLoad:NO success:^(NSMutableArray *array, BOOL isLast) {
            [weakSelf.dataArray addObjectsFromArray:array];
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
}

/** 添加讨论*/
- (void)addCommonWithText:(NSString *)text{
    XWWeakSelf
    [XWNetworking addCommentWithID:self.courseID content:text CompletionBlock:^(BOOL succeed) {
        if (succeed) {
            [weakSelf loadData];
        }
    }];
}

/** 添加笔记*/
- (void)pushEditNoteViewController{
    if(self.isNotes){
        if ([self.type isEqualToString:@"1"]){
            WeakSelf;
            [self presentViewController:[[MainNavigationViewController alloc] initWithRootViewController:[[XWCommentViewController alloc] initWithCourseID:self.courseID comment:NO sendBlock:^(NSString *content,NSInteger status) {
                [weakSelf addCourseNote:content status:status];
            }]] animated:YES completion:nil];
        }else{
            [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"您还未购买该课程，不能添加笔记呦！" buttonTitle:@"好的" buttonBlock:nil];
        }
    }
}

/** 发送笔记*/
- (void)addCourseNote:(NSString *)note status:(NSInteger)status{
    WeakSelf;
    NSString *type = @"";
    switch (status) {
        case 1:{
            type = @"企业笔记";
        }break;
        case 2:{
            type = @"个人笔记";
        }break;
        default:
            type = @"全部笔记";
            break;
    }
    
    [XWNetworking addCourseNoteWithCourseID:self.courseID courseName:@"" content:note status:[NSString stringWithFormat:@"%ld",(long)status] completeBlock:^{
        [weakSelf loadData];
    }];
}

- (void)keyboardWillShow:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    CGRect endRect = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    XWWeakSelf
    [UIView animateWithDuration:duration animations:^{
        weakSelf.keyInputView.frame = CGRectMake(0, kHeight-endRect.size.height-50, kWidth, 50);
    }];
}

- (void)keyboardWillHidden:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    XWWeakSelf
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.keyInputView removeFromSuperview];
    }];
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
    [self.view addSubview:menuView];
    [self.menuArray addObject:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
    }];
    
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
