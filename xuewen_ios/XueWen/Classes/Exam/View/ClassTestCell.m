//
//  ClassTestCell.m
//  XueWen
//
//  Created by ShaJin on 2018/1/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ClassTestCell.h"
#import "ExamTableView.h"
@interface ClassTestCell()
@property (nonatomic, strong) ExamTableView *tableView;

@end
@implementation ClassTestCell
- (void)setModel:(QuestionsModel *)model{
    _model = model;
    self.tableView.questions = @[model];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
        self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return self;
}

- (ExamTableView *)tableView{
    if (!_tableView) {
        _tableView = [[ExamTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
@end
