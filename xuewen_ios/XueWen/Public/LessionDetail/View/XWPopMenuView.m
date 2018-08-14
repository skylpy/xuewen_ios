//
//  XWPopMenuView.m
//  XueWen
//
//  Created by Karron Su on 2018/5/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWPopMenuView.h"


static NSString *const XWpopMenuTableCellID = @"XWpopMenuTableCellID";

@interface XWPopMenuView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) void(^doBlock)(NSInteger selectedIndex);

@end

@implementation XWPopMenuView

#pragma mark - Lazy / Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        [table registerClass:[XWpopMenuTableCell class] forCellReuseIdentifier:XWpopMenuTableCellID];
        table.estimatedRowHeight = 34;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = Color(@"#f2f2f2");
        [table rounded:3];
        _tableView = table;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - LifeCycle

- (instancetype)initWithTitleArray:(NSArray *)titleArray selectedIndex:(NSInteger)selectedIndex doBlock:(void (^)(NSInteger))doBlock dismissBlock:(void (^)(void))dismissBlock{
    if (self = [super init]) {
        self.doBlock = doBlock;
        self.selectedIndex = selectedIndex;
        [self drawUI];
        [self creatDataArrayWith:titleArray];
    }
    return self;
}

#pragma mark - Custom Methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
    [self endEditing:YES];
}

- (void)creatDataArrayWith:(NSArray *)titleArray{
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = (NSString *)obj;
        XWPopMenuModel *model = [[XWPopMenuModel alloc] init];
        model.title = title;
        if (idx == self.selectedIndex) {
            model.selected = YES;
        }else{
            model.selected = NO;
        }
        [self.dataArray addObject:model];
    }];
    [self.tableView reloadData];
}

- (void)dismiss{
    [self removeFromSuperview];
}

- (void)drawUI{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.top.mas_equalTo(self).offset(45);
        make.size.mas_equalTo(CGSizeMake(87, 106));
    }];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWpopMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWpopMenuTableCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XWPopMenuModel *model = (XWPopMenuModel *)obj;
        if (idx == indexPath.row) {
            model.selected = YES;
        }else{
            model.selected = NO;
        }
    }];
    [self.tableView reloadData];
    self.doBlock(indexPath.row);
    [self dismiss];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


@end

#pragma mark - 自定义cell

@interface XWpopMenuTableCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation XWpopMenuTableCell

#pragma mark - Lazy / Getter

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = Color(@"#333333");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        
    }
    return _titleLabel;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

#pragma mark - Setter
- (void)setModel:(XWPopMenuModel *)model{
    _model = model;
    self.titleLabel.text = _model.title;
    if (_model.selected) {
        self.imgView.image = LoadImage(@"icon_select");
    }else{
        self.imgView.image = LoadImage(@"icon_unchecked");
    }
}

#pragma mark - LifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}
#pragma mark - Custom Methods

- (void)drawUI{
    self.backgroundColor = Color(@"#f2f2f2");
    [self addSubview:self.titleLabel];
    [self addSubview:self.imgView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(7);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
}

@end

#pragma mark - 数据Model

@implementation XWPopMenuModel

@end




