//
//  ExamTableView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ExamTableView.h"
#import "QuestionsModel.h"
#import "ExamOptionCell.h"
#import "ExamHeaderView.h"
#import "ExamFooterView.h"
@interface ExamTableView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation ExamTableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.questions[indexPath.section].commited) {
        ExamOptionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!self.questions[indexPath.section].multiSelect) {
            cell.state = kSelectState;
            cell.model.isSelected = YES;
        }else{
            cell.state = (cell.state == kDefaultState) ? kSelectState : kDefaultState;
            cell.model.isSelected = !cell.model.isSelected;
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.questions[indexPath.section].commited) {
        ExamOptionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!self.questions[indexPath.section].multiSelect) {
            cell.state = kDefaultState;
            cell.model.isSelected = NO;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ExamHeaderView *headerView = [[ExamHeaderView alloc] init];
    headerView.title = self.questions[section].title;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self.questions[section].title heightWithWidth:kWidth - 40 size:16] + 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionsOptionModel *option = self.questions[indexPath.section].options[indexPath.row];
    return [option.title heightWithWidth:kWidth - 85 size:15] + 39;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.questions[section].commited && self.questions.count == 1) {
        NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N"];
        NSMutableString *mStr = [NSMutableString stringWithString:@"正确答案"];
        for (int i = 0; i < self.questions[section].options.count; i++) {
            QuestionsOptionModel *option = self.questions[section].options[i];
            if (option.right) {
                [mStr appendFormat:@"  %@",array[i]];
            }
        }
        ExamFooterView *footerView = [ExamFooterView new];
        footerView.title = mStr;
        return footerView;
        
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.questions.count > 1) {
        return 0.1;
    }else{
        return 55;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questions[section].options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExamOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    [cell setModel:self.questions[indexPath.section].options[indexPath.row] hasCommit:self.questions[indexPath.section].commited];
    return cell;
}

#pragma mark- CustomMethod
- (void)commit{
    if (self.questions.count > 0) {
        self.questions[0].commited = YES;
    }
    [self reloadData];
}

#pragma mark- Setter
- (void)setQuestions:(NSArray<QuestionsModel *> *)questions{
    _questions = questions;
    
    [self reloadData];
}

#pragma mark- Getter
#pragma mark- LifeCycle
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.separatorStyle = 0;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[ExamOptionCell class] forCellReuseIdentifier:@"CellID"];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 221 / 255.0, 221 / 255.0, 221 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.width ,0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}
@end
