//
//  XWPlanDateilViewController.m
//  XueWen
//
//  Created by aaron on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWPlanDateilViewController.h"
#import "XWPlanDateilCell.h"
#import "XWNProgressView.h"

static NSString * const XWPlanSectorCellID = @"XWPlanSectorCellID";
static NSString * const XWPlanDateilCellID = @"XWPlanDateilCellID";
static NSString * const XWPlanProgressCellID = @"XWPlanProgressCellID";

@interface XWPlanDateilViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) UIView * headerView;

@end

@implementation XWPlanDateilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"计划详情";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
}


- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:NSClassFromString(@"XWPlanSectorCell") forCellReuseIdentifier:XWPlanSectorCellID];
        [_tableView registerClass:[XWPlanDateilCell class] forCellReuseIdentifier:XWPlanDateilCellID];
        [_tableView registerClass:[XWPlanProgressCell class] forCellReuseIdentifier:XWPlanProgressCellID];
    }
    return _tableView;
}

- (UIView *)headerView {
    
    if (!_headerView) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        header.backgroundColor = [UIColor clearColor];
        _headerView = header;
        UIView * boby = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kWidth, 40)];
        boby.backgroundColor = [UIColor whiteColor];
        [header addSubview:boby];
        
        UILabel * titleLabel = [UILabel createALabelText:@"学习进度" withFont:[UIFont fontWithName:kMedFont size:14] withColor:Color(@"#323232")];
        [boby addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(boby);
            make.left.equalTo(boby.mas_left).offset(25);
        }];
        
    }
    return _headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 2) {
        
        return self.model.scheduleInfo.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        return 289;
    }
    if (indexPath.section == 2) {
        
        return 90;
    }
    return 212;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.01;
    }
    if (section == 2){
        
        return 50;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 2) {
        
        return self.headerView;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 1) {
        
        XWPlanDateilCell * cell = [tableView dequeueReusableCellWithIdentifier:XWPlanDateilCellID forIndexPath:indexPath];
        cell.model = self.model;
        
        return cell;
    }
    if (indexPath.section == 2) {
        
        XWPlanProgressCell * cell = [tableView dequeueReusableCellWithIdentifier:XWPlanProgressCellID forIndexPath:indexPath];
        cell.model = self.model.scheduleInfo[indexPath.row];
        
        return cell;
    }
    XWPlanSectorCell * cell = [tableView dequeueReusableCellWithIdentifier:XWPlanSectorCellID forIndexPath:indexPath];
    cell.model = self.model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        LearningPlanInfoModel *model = self.model.scheduleInfo[indexPath.row];
        NSString *courseID = model.courseID;
        [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:courseID isAudio:NO] animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end




#pragma XWPlanSectorCell create

@interface XWPlanSectorCell ()

@property (nonatomic,strong)UILabel * planNameLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UILabel * stateLabel;

@property (nonatomic,strong) XWNProgressView * progress;

@end

@implementation XWPlanSectorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)setModel:(LearningPlanModel *)model {
    
    _model = model;
    self.planNameLabel.text = model.palnTitle;
    self.stateLabel.text = [model.status isEqualToString:@"1"] ?@"进行中":[model.status isEqualToString:@"2"]?@"已完成":@"已结束";
    self.progress.percent = [model.schedule floatValue]/100;
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[NSDate dateFormTimestamp:model.startTime withFormat:@"yyyy.MM.dd"],[NSDate dateFormTimestamp:model.endTime withFormat:@"yyyy.MM.dd"]];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

- (void)drawUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.planNameLabel];
    [self addSubview:self.stateLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.progress];
    
    
    [self.planNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.mas_top).offset(25);
        make.height.offset(16);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.planNameLabel.mas_bottom).offset(5);
        make.height.offset(16);
    }];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(20);
        make.height.width.offset(109);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.centerY.equalTo(self.planNameLabel);
        make.width.offset(47);
        make.height.offset(16);
    }];
}

- (XWNProgressView*)progress {
    
    if (!_progress) {
        XWNProgressView *progress = [[XWNProgressView alloc] initWithFrame:CGRectZero];
        _progress = progress;
        progress.arcFinishColor = [UIColor lightGrayColor];//Color(@"#3699FF");
        
        progress.arcUnfinishColor = Color(@"#FFB016");
        progress.arcTitleColor = Color(@"#666666");
        progress.arcBackColor = [UIColor lightGrayColor];//Color(@"#EAEAEA");
        progress.width = 9;
        progress.percent = 0;
        
        progress.fontSize = 24;
    }
    return _progress;
}

- (UILabel *)planNameLabel {
    
    if (!_planNameLabel) {
        UILabel * label = [UILabel createALabelText:@"计划名称" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#323232")];
        _planNameLabel = label;
    }
    return _planNameLabel;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#999999")];
        _timeLabel = label;
    }
    return _timeLabel;
}

- (UILabel *)stateLabel {
    
    if (!_stateLabel) {
        UILabel * label = [UILabel createALabelText:@"进行中" withFont:[UIFont fontWithName:kRegFont size:11] withColor:Color(@"#323232")];
        _stateLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = 2;
        label.clipsToBounds = YES;
        label.layer.borderColor = Color(@"#C4C4C4").CGColor;
    }
    return _stateLabel;
}


@end
