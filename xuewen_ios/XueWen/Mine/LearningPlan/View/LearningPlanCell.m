//
//  LearningPlanCell.m
//  XueWen
//
//  Created by ShaJin on 2017/12/25.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "LearningPlanCell.h"
#import "LessionProgressCell.h"
#import "LearningPlanModel.h"
@interface LearningPlanCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *titleBackgroungView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *mountLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *line;

@end
@implementation LearningPlanCell
#pragma mark- TableView&&Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LearningPlanInfoModel *model = self.model.scheduleInfo[indexPath.row];
    UIViewController *vc = [UIViewController getCurrentVC];
    [vc.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseID isAudio:NO] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.scheduleInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LessionProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.model = self.model.scheduleInfo[indexPath.row];
    cell.isFirst = indexPath.row == 0;
    cell.isLast = indexPath.row == self.model.scheduleInfo.count - 1;
    return cell;
}

#pragma mark- CustomMethod
- (void)initUI{
    [self.contentView addSubview:self.titleBackgroungView];
    [self.titleBackgroungView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.mountLabel];
    [self.contentView addSubview:self.durationLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.line];
    
    self.titleBackgroungView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightIs(43);
    self.titleLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 15, 0, 15));
    self.line.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,53.5).heightIs(0.5);
    self.tableView.sd_layout.topSpaceToView(self.titleBackgroungView,8).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).bottomSpaceToView(self.line,8);
    NSString *text = @"已完成";
    self.statusLabel.sd_layout.topSpaceToView(self.line,20.5).rightSpaceToView(self.contentView,16).widthIs([text widthWithSize:13]).heightIs(13);
    self.mountLabel.sd_layout.topSpaceToView(self.line,15).leftSpaceToView(self.contentView,14.5).rightSpaceToView(self.statusLabel,15).heightIs(10);
    self.durationLabel.sd_layout.topSpaceToView(self.mountLabel,4.5).leftSpaceToView(self.contentView,14.5).rightSpaceToView(self.statusLabel,15).heightIs(10);
    
    
}

- (void)loadData{
    
}

#pragma mark- Setter
- (void)setModel:(LearningPlanModel *)model{
    _model = model;
    [self.tableView reloadData];
    self.titleLabel.text = model.palnTitle;
    self.mountLabel.text = [NSString stringWithFormat:@"课程：%ld门",(unsigned long)model.scheduleInfo.count];
    self.durationLabel.text = [NSString stringWithFormat:@"时间：%@至%@",model.startTime,model.endTime];
    if ([model.status isEqualToString:@"0"]) {
        self.statusLabel.textColor = DefaultTitleCColor;
        self.statusLabel.text = @"未开始";
    }else if ([model.status isEqualToString:@"1"]){
        self.statusLabel.textColor = COLOR(14, 201, 80);
        self.statusLabel.text = @"进行中";
    }else if ([model.status isEqualToString:@"2"]){
        self.statusLabel.textColor = DefaultTitleBColor;
        self.statusLabel.text = @"已完成";
    }else if ([model.status isEqualToString:@"3"]){
        self.statusLabel.textColor = COLOR(251, 27, 27);
        self.statusLabel.text = @"已过期";
    }
}

#pragma mark- Getter

- (UIView *)titleBackgroungView{
    if (!_titleBackgroungView) {
        _titleBackgroungView = [UIView new];
        _titleBackgroungView.backgroundColor = kThemeColor;
    }
    return _titleBackgroungView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:[UIColor whiteColor] size:14];
    }
    return _titleLabel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LessionProgressCell class] forCellReuseIdentifier:CellID];
        _tableView.separatorStyle = 0;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UILabel *)mountLabel{
    if (!_mountLabel) {
        _mountLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:10];
    }
    return _mountLabel;
}

- (UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:10];
    }
    return _durationLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [UILabel labelWithTextColor:COLOR(14, 201, 80) size:13];
    }
    return _statusLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = COLOR(238, 238, 238);
    }
    return _line;
}
#pragma mark- LifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        ViewRadius(self.contentView, 2);
        self.layer.shadowColor = COLOR(204, 208, 225).CGColor;//设置阴影的颜色
        self.layer.shadowOpacity = 0.2;//设置阴影的透明度
        self.layer.shadowOffset = CGSizeMake(0, 2.5);//设置阴影的偏移量
        [self initUI];
    }
    return self;
}

@end
