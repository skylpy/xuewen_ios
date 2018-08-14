//
//  ClassesAllLessionView.m
//  XueWen
//
//  Created by ShaJin on 2017/11/15.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ClassesAllLessionView.h"
#import "CourseModel.h"
@interface ClassesAllLessionView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *firstTableView;
@property (nonatomic, strong) UITableView *secondTableView;
@property (nonatomic, strong) UITableView *thirdTableView;
@property (nonatomic, strong) NSArray<CourseLabelModel *> *firstDataSource;
@property (nonatomic, strong) NSArray<CourseLabelModel *> *secondDataSource;
@property (nonatomic, strong) NSArray<CourseLabelModel *> *thirdDataSource;
@property (nonatomic, strong) NSString *select;

@property (nonatomic, strong) NSArray<CourseLabelModel *> *courseLabelList;

@property (nonatomic, assign) NSInteger firstSelectIndex;
@property (nonatomic, assign) NSInteger secondSelectIndex;
@property (nonatomic, assign) NSInteger thirdSelectIndex;

@end
@implementation ClassesAllLessionView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL dismiss = NO;
    CourseLabelModel *model = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([tableView isEqual:self.firstTableView]) {
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.firstSelectIndex inSection:0]];
        lastCell.backgroundColor = COLOR(238, 238, 238);
        lastCell.textLabel.textColor = COLOR(51, 51, 51);
        self.firstSelectIndex = indexPath.row;
        self.secondSelectIndex = -1;
        self.thirdSelectIndex = -1;
        self.secondDataSource = nil;
        self.thirdDataSource = nil;
        cell.backgroundColor = COLOR(247, 247, 247);
        [self.secondTableView reloadData];
        [self.thirdTableView reloadData];
        [self.secondTableView scrollsToTop];

        model = self.firstDataSource[indexPath.row];
    }else if ([tableView isEqual:self.secondTableView]){
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.secondSelectIndex inSection:0]];
        lastCell.backgroundColor = COLOR(247, 247, 247);
        lastCell.textLabel.textColor = COLOR(51, 51, 51);
        self.secondSelectIndex = indexPath.row;
        self.thirdSelectIndex = -1;
        self.thirdDataSource = nil;
        cell.backgroundColor = [UIColor whiteColor];
        [self.thirdTableView reloadData];
        if (self.thirdDataSource.count > 0) {
            [self.thirdTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        model = self.secondDataSource[indexPath.row];
    }else if ([tableView isEqual:self.thirdTableView]){
        self.secondSelectIndex = indexPath.row;
        dismiss = YES;
        model = self.thirdDataSource[indexPath.row];
    }
    cell.textLabel.textColor = kThemeColor;
    if ([self.delegate respondsToSelector:@selector(allLessionDidSelectLabel:dismiss:)]) {
        [self.delegate allLessionDidSelectLabel:model dismiss:dismiss];
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
    NSInteger count = 0;
    if ([tableView isEqual:self.firstTableView]) {
        count = self.firstDataSource.count ;
    }else if ([tableView isEqual:self.secondTableView]){
        count = self.secondDataSource.count ;
        
    }else if ([tableView isEqual:self.thirdTableView]){
        count = self.thirdDataSource.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    if ([tableView isEqual:self.firstTableView]) {
        cell.textLabel.text = self.firstDataSource[indexPath.row].labelName;
        if (indexPath.row == self.firstSelectIndex) {
            cell.backgroundColor = COLOR(247, 247, 247);
            cell.textLabel.textColor = kThemeColor;
        }else{
            cell.backgroundColor = COLOR(238, 238, 238);
            cell.textLabel.textColor = COLOR(51, 51, 51);
        }
    }else if ([tableView isEqual:self.secondTableView]){
        cell.textLabel.text = self.secondDataSource[indexPath.row].labelName;
        if (indexPath.row == self.secondSelectIndex) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = kThemeColor;
        }else{
            cell.backgroundColor = COLOR(247, 247, 247);
            cell.textLabel.textColor = COLOR(51, 51, 51);
        }
    }else if ([tableView isEqual:self.thirdTableView]){
        cell.textLabel.text = self.thirdDataSource[indexPath.row].labelName;
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.row == self.thirdSelectIndex) {
            cell.textLabel.textColor = kThemeColor;
        }else{
            cell.textLabel.textColor = COLOR(51, 51, 51);
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.selectionStyle = 0;
    return cell;
}

- (instancetype)initWithSelect:(NSString *)select{
    if (self = [super initWithFrame:CGRectMake(0, 45 + kNaviBarH, kWidth, 250)]) {
        self.select = select;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        [self addSubview:self.firstTableView];
        [self addSubview:self.secondTableView];
        [self addSubview:self.thirdTableView];
    }
    return self;
}

- (void)resetData:(NSMutableArray *)mArray withCourses:(NSArray *)courses{
    
}

#pragma mark- Getter
- (UITableView *)firstTableView{
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth / 3.0, self.height) style:UITableViewStylePlain];
        _firstTableView.backgroundColor = COLOR(238, 238, 238);
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        _firstTableView.separatorStyle = 0;
        [_firstTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    }
    return _firstTableView;
}

- (UITableView *)secondTableView{
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(kWidth / 3.0, 0, kWidth / 3.0, self.height) style:UITableViewStylePlain];
        _secondTableView.backgroundColor = COLOR(247, 247, 247);
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.separatorStyle = 0;
        [_secondTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    }
    return _secondTableView;
}

- (UITableView *)thirdTableView{
    if (!_thirdTableView) {
        _thirdTableView = [[UITableView alloc] initWithFrame:CGRectMake(kWidth / 3.0 * 2.0, 0, kWidth, self.height) style:UITableViewStylePlain];
        _thirdTableView.backgroundColor = [UIColor whiteColor];
        _thirdTableView.delegate = self;
        _thirdTableView.dataSource = self;
        _thirdTableView.separatorStyle = 0;
        [_thirdTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    }
    return _thirdTableView;
}

- (NSArray<CourseLabelModel *> *)courseLabelList{
    if (!_courseLabelList) {
        _courseLabelList = [XWInstance shareInstance].courseLabelList;
        for (int i = 0; i < _courseLabelList.count; i++) {
            for (int j = 0; j < _courseLabelList[i].children.count; j++) {
                CourseLabelModel *label = _courseLabelList[i].children[j];
                if ([label.labelName isEqualToString:self.select]) {
                    self.firstSelectIndex   = i;
                    self.secondSelectIndex  = j;
                    self.thirdSelectIndex   = 0;
                    return _courseLabelList;
                }else{
                    for (int k = 0; k < label.children.count; k++) {
                        CourseLabelModel *model = label.children[k];
                        if ([model.labelName isEqualToString:self.select]) {
                            self.firstSelectIndex   = i;
                            self.secondSelectIndex  = j;
                            self.thirdSelectIndex   = k;
                            return _courseLabelList;
                            
                        }
                    }
                }
            }
        }
    }
    self.firstSelectIndex   = 0;
    self.secondSelectIndex  = 0;
    self.thirdSelectIndex   = 0;
    return _courseLabelList;
}

- (NSArray<CourseLabelModel *> *)firstDataSource{
    if (!_firstDataSource) {
        _firstDataSource = self.courseLabelList;
    }
    return _firstDataSource;
}

- (NSArray<CourseLabelModel *> *)secondDataSource{
    if (!_secondDataSource) {

        if (self.firstSelectIndex >= 0) {
            _secondDataSource = self.firstDataSource[self.firstSelectIndex].children;
        }
        
    }
    return _secondDataSource;
}

- (NSArray<CourseLabelModel *> *)thirdDataSource{
    if (!_thirdDataSource) {
        if (self.secondSelectIndex >= 0) {
            _thirdDataSource = self.secondDataSource[self.secondSelectIndex].children;
        }
    }
    
    return _thirdDataSource;
}

@end
