//
//  XWPlanListViewController.m
//  XueWen
//
//  Created by aaron on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWPlanListViewController.h"
#import "XWPlanListCell.h"

static NSString * const XWPlanListCellID = @"XWPlanListCellID";
static NSString * const XWNoneTableCellID = @"XWNoneTableCellID";

@interface XWPlanListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * learningPlanArray;
@property (nonatomic,strong) NSMutableArray * executionPlanArray;
@property (nonatomic,strong) NSMutableArray * finishPlanArray;
@property (nonatomic,strong) NSMutableArray * overduePlanArray;
@property (nonatomic,strong) XWPlanListHeaderView * headerView;
@property (nonatomic,assign) PlanStatusType type;

@end

@implementation XWPlanListViewController

- (NSMutableArray *)executionPlanArray {
    
    if (!_executionPlanArray) {
        NSMutableArray * array = [NSMutableArray array];
        _executionPlanArray = array;
    }
    return _executionPlanArray;
}

- (NSMutableArray *)finishPlanArray {
    
    if (!_finishPlanArray) {
        NSMutableArray * array = [NSMutableArray array];
        _finishPlanArray = array;
    }
    return _finishPlanArray;
}

- (NSMutableArray *)overduePlanArray {
    
    if (!_overduePlanArray) {
        NSMutableArray * array = [NSMutableArray array];
        _overduePlanArray = array;
    }
    return _overduePlanArray;
}

- (NSMutableArray *)learningPlanArray {
    
    if (!_learningPlanArray) {
        NSMutableArray * array = [NSMutableArray array];
        _learningPlanArray = array;
    }
    return _learningPlanArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"计划列表";
    self.type = executionType;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self delayLoadLearningPlan];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

- (void)delayLoadLearningPlan{
    
    WeakSelf;
    
    [XWNetworking getLearningPlanListWithPage:1 completeBlock:^(NSArray<LearningPlanModel *> *plans, BOOL isLast) {
        [weakSelf.learningPlanArray removeAllObjects];
        for (LearningPlanModel * obj in plans) {
            NSLog(@"%@",obj.status);
            switch ([obj.status integerValue]) {
                case 1:
                    [weakSelf.executionPlanArray addObject:obj];
                    break;
                case 2:
                    [weakSelf.finishPlanArray addObject:obj];
                    break;
                case 3:
                    [weakSelf.overduePlanArray addObject:obj];
                    break;
                default:
                    break;
            }
        }
        [weakSelf.headerView executionNum:[NSString stringWithFormat:@"%ld",weakSelf.executionPlanArray.count] withFinish:[NSString stringWithFormat:@"%ld",weakSelf.finishPlanArray.count] withOverdue:[NSString stringWithFormat:@"%ld",weakSelf.overduePlanArray.count]];
        [weakSelf.learningPlanArray addObjectsFromArray:plans];
        
        [weakSelf.tableView reloadData];
    }];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
       
        [_tableView registerClass:[XWPlanListCell class] forCellReuseIdentifier:XWPlanListCellID];
        
        [_tableView registerClass:[XWNoneTableCell class] forCellReuseIdentifier:XWNoneTableCellID];
        
        XWPlanListHeaderView * headerView = [[XWPlanListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 84)];
        self.headerView = headerView;
        self.tableView.tableHeaderView = headerView;
        @weakify(self);
        [headerView setPlanListHeaderClick:^(PlanStatusType type) {
            @strongify(self)
            self.type = type;
            [self.tableView reloadData];
        }];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.type == executionType) {
        
        return self.executionPlanArray.count == 0 ? 1: self.executionPlanArray.count;
    }else if (self.type == finishType){
        
        return self.finishPlanArray.count == 0 ? 1: self.finishPlanArray.count;
    }else {
        
        return self.overduePlanArray.count == 0 ? 1: self.overduePlanArray.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = self.type == executionType ? self.executionPlanArray.count:self.type == finishType ?self.finishPlanArray.count:self.overduePlanArray.count;
    if (count == 0) {
        
        return kHeight-84;
    }
    return 184;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = self.type == executionType ? self.executionPlanArray.count:self.type == finishType ?self.finishPlanArray.count:self.overduePlanArray.count;
    
    if (count == 0) {
        XWNoneTableCell * cell = [tableView dequeueReusableCellWithIdentifier:XWNoneTableCellID forIndexPath:indexPath];
        
        return cell;
    }
    XWPlanListCell * cell = [tableView dequeueReusableCellWithIdentifier:XWPlanListCellID forIndexPath:indexPath];
    
    cell.model = self.type == executionType ? self.executionPlanArray[indexPath.section]:self.type == finishType ?self.finishPlanArray[indexPath.section]:self.overduePlanArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = self.type == executionType ? self.executionPlanArray.count:self.type == finishType ?self.finishPlanArray.count:self.overduePlanArray.count;
    if (count == 0) {
        
        return;
    }
    LearningPlanModel * model =  self.type == executionType ? self.executionPlanArray[indexPath.section]:self.type == finishType ?self.finishPlanArray[indexPath.section]:self.overduePlanArray[indexPath.section];
    UIViewController * vc = [NSClassFromString(@"XWPlanDateilViewController") new];
    
    [vc setValue:model forKey:@"model"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end


#pragma XWPlanListHeaderView  计划列表头部

@interface XWPlanListHeaderView()

@property (nonatomic,strong) UILabel * executionNumLabel;
//学习
@property (nonatomic,strong) UILabel * executionLabel;

@property (nonatomic,strong) UILabel * finishNumLabel;
//
@property (nonatomic,strong) UILabel * finishLabel;

@property (nonatomic,strong) UILabel * overdueNumLabel;
//
@property (nonatomic,strong) UILabel * overdueLabel;

@property (nonatomic,strong) UIView * oneLineView;

@property (nonatomic,strong) UIView * twoLineView;

@property (nonatomic,strong) UIView * threeLineView;

@property (nonatomic,strong) UIButton * executionButton;

@property (nonatomic,strong) UIButton * finishButton;

@property (nonatomic,strong) UIButton * overdueButton;

@end

@implementation XWPlanListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self drawUI];
    }
    return self;
}

- (void)executionNum:(NSString *)exe withFinish:(NSString *)fis withOverdue:(NSString *)over {
    
    self.executionLabel.text = exe;
    self.finishLabel.text = fis;
    self.overdueLabel.text = over;
}

- (void)drawUI {
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.executionNumLabel];
    [self addSubview:self.executionLabel];
    [self addSubview:self.finishNumLabel];
    [self addSubview:self.finishLabel];
    [self addSubview:self.overdueNumLabel];
    [self addSubview:self.overdueLabel];
    [self addSubview:self.oneLineView];
    [self addSubview:self.twoLineView];
    [self addSubview:self.executionButton];
    [self addSubview:self.finishButton];
    [self addSubview:self.overdueButton];
    
    [self.executionNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.offset(16);
    }];
    
    [self.executionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.executionNumLabel.mas_bottom).offset(10);
        make.height.offset(16);
    }];
    
    [self.finishNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.executionNumLabel.mas_right).offset(1);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.offset(16);
    }];
    
    [self.finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.executionLabel.mas_right).offset(1);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.executionNumLabel.mas_bottom).offset(10);
        make.height.offset(16);
    }];
    
    [self.overdueNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finishNumLabel.mas_right).offset(1);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.offset(16);
    }];
    
    [self.overdueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finishNumLabel.mas_right).offset(1);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.overdueNumLabel.mas_bottom).offset(10);
        make.height.offset(16);
    }];
    
    [self.oneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.executionNumLabel.mas_top).offset(5);
        make.left.equalTo(self.executionLabel.mas_right);
        make.width.offset(0.5);
        make.height.offset(40);
    }];
    
    [self.twoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.finishNumLabel.mas_top).offset(5);
        make.left.equalTo(self.finishLabel.mas_right);
        make.width.offset(0.5);
        make.height.offset(40);
    }];
    
    [self.executionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.executionButton.mas_right);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.overdueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finishButton.mas_right);
        make.width.offset(kWidth/3-3);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (UIButton *)executionButton {
    
    if (!_executionButton) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        _executionButton = button;
        button.tag = 1000;
        [button addTarget:self action:@selector(executionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _executionButton;
}

- (UIButton *)finishButton {
    
    if (!_finishButton) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        _finishButton = button;
        button.tag = 1001;
        [button addTarget:self action:@selector(executionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

- (UIButton *)overdueButton {
    
    if (!_overdueButton) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        _overdueButton = button;
        button.tag = 1002;
        [button addTarget:self action:@selector(executionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overdueButton;
}

- (void)executionButtonClick:(UIButton *)sender {
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 1000:
        {
            self.executionNumLabel.textColor = Color(@"#3399FF");
            self.executionLabel.textColor = Color(@"#3399FF");
            
            self.finishNumLabel.textColor = Color(@"#323232");
            self.finishLabel.textColor = Color(@"#323232");
            
            self.overdueLabel.textColor = Color(@"#323232");
            self.overdueNumLabel.textColor = Color(@"#323232");
        }
            break;
        case 1001:
        {
            self.executionNumLabel.textColor = Color(@"#323232");
            self.executionLabel.textColor = Color(@"#323232");
            
            self.finishNumLabel.textColor = Color(@"#3399FF");
            self.finishLabel.textColor = Color(@"#3399FF");
            
            self.overdueLabel.textColor = Color(@"#323232");
            self.overdueNumLabel.textColor = Color(@"#323232");
        }
            break;
        case 1002:
        {
            self.executionNumLabel.textColor = Color(@"#323232");
            self.executionLabel.textColor = Color(@"#323232");
            
            self.finishNumLabel.textColor = Color(@"#323232");
            self.finishLabel.textColor = Color(@"#323232");
            
            self.overdueLabel.textColor = Color(@"#3399FF");
            self.overdueNumLabel.textColor = Color(@"#3399FF");
        }
            break;
        default:
            break;
    }
    PlanStatusType type = sender.tag == 1000 ? executionType:sender.tag == 1001 ? finishType:overdueType;
    !self.planListHeaderClick?:self.planListHeaderClick(type);
}

- (UILabel *)executionNumLabel {
    
    if (!_executionNumLabel) {
        UILabel * label = [UILabel createALabelText:@"执行中" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#3399FF")];
        _executionNumLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _executionNumLabel;
}

- (UILabel *)executionLabel {
    
    if (!_executionLabel) {
        UILabel * label = [UILabel createALabelText:@"2" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#3399FF")];
        _executionLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _executionLabel;
}

- (UILabel *)finishNumLabel {
    
    if (!_finishNumLabel) {
        UILabel * label = [UILabel createALabelText:@"已完成" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#323232")];
        _finishNumLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _finishNumLabel;
}

- (UILabel *)finishLabel {
    
    if (!_finishLabel) {
        UILabel * label = [UILabel createALabelText:@"4" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#323232")];
        _finishLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _finishLabel;
}

- (UILabel *)overdueNumLabel {
    
    if (!_overdueNumLabel) {
        UILabel * label = [UILabel createALabelText:@"已过期" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#323232")];
        label.textAlignment = NSTextAlignmentCenter;
        _overdueNumLabel = label;
    }
    return _overdueNumLabel;
}

- (UILabel *)overdueLabel {
    
    if (!_overdueLabel) {
        UILabel * label = [UILabel createALabelText:@"1" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#323232")];
        label.textAlignment = NSTextAlignmentCenter;
        _overdueLabel = label;
    }
    return _overdueLabel;
}

- (UIView *)oneLineView {
    
    if (!_oneLineView) {
        UIView * lineView = [UIView new];
        _oneLineView = lineView;
        lineView.backgroundColor = Color(@"#CCCCCC");
    }
    return _oneLineView;
}

- (UIView *)twoLineView {
    
    if (!_twoLineView) {
        UIView * lineView = [UIView new];
        _twoLineView = lineView;
        lineView.backgroundColor = Color(@"#CCCCCC");
    }
    return _twoLineView;
}

- (UIView *)threeLineView {
    
    if (!_threeLineView) {
        UIView * lineView = [UIView new];
        _threeLineView = lineView;
        lineView.backgroundColor = Color(@"#CCCCCC");
    }
    return _threeLineView;
}

@end
