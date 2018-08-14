//
//  XWRecordsCell.m
//  XueWen
//
//  Created by aaron on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRecordsCell.h"
#import "XWRecordTitleCell.h"

static NSString * const XWRecordTitleCellID = @"XWRecordTitleCellID";

@interface XWRecordsCell()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UILabel * dateLabel;
@property (nonatomic,strong) UIImageView * iconImage;
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UITableView * tableView;


@end

@implementation XWRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)setModel:(CourseModel *)model {
    _model = model;
    
    [self.tableView reloadData];
}

- (void)setArray:(NSArray *)array {
    
    _array = array;
    self.model = array[0];
    self.dateLabel.text = [NSDate dateFormTimestamp:[NSString stringWithFormat:@"%@",self.model.learningTime] withFormat:@"MM-dd yyyy"];
    [self.tableView reloadData];
}

- (void)drawUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.dateLabel];
    [self addSubview:self.iconImage];
    [self.iconImage addSubview:self.bgView];
    [self addSubview:self.lineView];
    [self addSubview:self.tableView];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.width.offset(60);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_top);
        make.left.equalTo(self.dateLabel.mas_right).offset(10);
        make.width.height.offset(18);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.iconImage);
        make.width.height.offset(14);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.iconImage);
        make.width.offset(1);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_top);
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        UILabel * label = [UILabel createALabelText:@"05-09 2018" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#333333")];
        _dateLabel = label;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (UIView *)bgView {
    
    if (!_bgView) {
        UIView * icon = [UIView new];
        _bgView = icon;
        icon.backgroundColor = [UIColor whiteColor];
        icon.clipsToBounds = YES;
        icon.layer.cornerRadius = 7;
    }
    return _bgView;
}

- (UIImageView *)iconImage {
    
    if (!_iconImage) {
        UIImageView * icon = [UIImageView new];
        _iconImage = icon;
        icon.backgroundColor = Color(@"#3699FF");
        icon.clipsToBounds = YES;
        icon.layer.cornerRadius = 9;
    }
    return _iconImage;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        UIView * lineView = [UIView new];
        _lineView = lineView;
        lineView.backgroundColor = Color(@"#3699FF");
    }
    return _lineView;
}


- (UITableView *)tableView{
    if (!_tableView) {

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:NSClassFromString(@"XWRecordTitleCell") forCellReuseIdentifier:XWRecordTitleCellID];
        
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWRecordTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:XWRecordTitleCellID forIndexPath:indexPath];
    cell.model = self.array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseModel * model = self.array[indexPath.row];
    BOOL isA = [model.courseType isEqualToString:@"1"] ? NO:YES;
    !self.recordsClick?:self.recordsClick(model.hisID,isA);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
