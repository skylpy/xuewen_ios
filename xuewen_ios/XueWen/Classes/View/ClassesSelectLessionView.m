//
//  ClassesSelectLessionView.m
//  XueWen
//
//  Created by ShaJin on 2017/11/15.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ClassesSelectLessionView.h"
@interface ClassesSelectLessionView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *select;
@property (nonatomic, strong) NSArray *dataSource;

@end
@implementation ClassesSelectLessionView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = kThemeColor;
    if ([self.delegate respondsToSelector:@selector(selectLessionDidSelect:dismiss:)]) {
        [self.delegate selectLessionDidSelect:cell.textLabel.text dismiss:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = COLOR(51, 51, 51);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.selectionStyle = 0;
    cell.textLabel.textColor = ([cell.textLabel.text isEqualToString:self.select]) ? kThemeColor : COLOR(51, 51, 51);
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

- (instancetype)initWithSelect:(NSString *)select{
    if (self = [super initWithFrame:CGRectMake(0, 45 + kNaviBarH, kWidth, 36 * 3)]) {
        self.select = select;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.dataSource = @[@"全部",@"免费",@"付费"];
        [self addSubview:self.tableView];
    }
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth / 3.0, self.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR(238, 238, 238);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
@end
