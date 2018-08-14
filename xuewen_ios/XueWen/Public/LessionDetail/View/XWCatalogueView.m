//
//  XWCatalogueView.m
//  XueWen
//
//  Created by Karron Su on 2018/5/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCatalogueView.h"


static NSString *const XWCatalogueTableCellID = @"XWCatalogueTableCellID";


@interface XWCatalogueView () <UITableViewDelegate, UITableViewDataSource>

/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 正在播放/听的课程*/
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) void (^doBlock)(NSInteger selectedIndex);

@property (nonatomic, strong) XWCoursInfoModel *infoModel;

@property (nonatomic, assign) BOOL isAudio;

@end

@implementation XWCatalogueView

#pragma mark - Lazy / Getter
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
        [table registerClass:[XWCatalogueTableCell class] forCellReuseIdentifier:XWCatalogueTableCellID];
        _tableView = table;
    }
    return _tableView;
}

#pragma mark - LifeCycle

- (instancetype)initWithDataArray:(NSMutableArray *)dataArray doBlock:(void (^)(NSInteger))doBlock playIndex:(NSInteger)playIndex infoModel:(XWCoursInfoModel *)infoModel isAudio:(BOOL)isAudio{
    if (self = [super init]) {
        self.infoModel = infoModel;
        self.isAudio = isAudio;
        self.dataArray = dataArray;
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XWAudioNodeModel *model = (XWAudioNodeModel *)obj;
            if (idx == playIndex) {
                model.watchStatus = YES;
            }else{
                model.watchStatus = NO;
            }
        }];
        self.doBlock = doBlock;
        [self drawUI];
    }
    return self;
}

#pragma mark - Custom Methods

- (void)drawUI{
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
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
    
    XWCatalogueTableCell * cell = [tableView dequeueReusableCellWithIdentifier:XWCatalogueTableCellID forIndexPath:indexPath];
    cell.infoModel = self.infoModel;
    cell.model = self.dataArray[indexPath.row];
    cell.isAudio = self.isAudio;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XWAudioNodeModel *model = (XWAudioNodeModel *)obj;
        if (idx == indexPath.row) {
            model.watchStatus = YES;
        }else{
            model.watchStatus = NO;
        }
    }];
    [self.tableView reloadData];
    self.doBlock(indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


@end


#pragma mark - 自定义cell

@interface XWCatalogueTableCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *statusImgView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation XWCatalogueTableCell

#pragma mark - Lazy / Getter

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = Color(@"#333333");
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:kRegFont size:13];
        
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)statusImgView{
    if (!_statusImgView) {
        _statusImgView = [[UIImageView alloc] initWithImage:LoadImage(@"icon_cours_free")];
    }
    return _statusImgView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = Color(@"#B7B7B7");
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:kRegFont size:13];
        _timeLabel = label;
    }
    return _timeLabel;
}

#pragma mark - Setter
- (void)setModel:(XWAudioNodeModel *)model{
    _model = model;
    self.timeLabel.text = _model.totalTime;
    self.titleLabel.text = _model.nodeTitle;
    
    if ([self.infoModel.type isEqualToString:@"1"]) {
        self.statusImgView.hidden = YES;
    }else{
        if ([_model.state isEqualToString:@"1"]) {
            self.statusImgView.hidden = NO;
        }else{
            self.statusImgView.hidden = YES;
        }
    }
    
    if (_model.watchStatus) {
        self.imgView.image = LoadImage(@"icon_playing");
        self.titleLabel.textColor = Color(@"#333333");
    }else{
        if ([_model.play isEqualToString:@"0"]) {
            self.imgView.image = LoadImage(@"icon_waitforplay");
            self.titleLabel.textColor = Color(@"#333333");
        }else{
            self.imgView.image = LoadImage(@"icon_history_play");
            self.titleLabel.textColor = Color(@"#B7B7B7");
        }
    }
}


#pragma mark - LifeCycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self addSubview:self.imgView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.statusImgView];
    [self addSubview:self.titleLabel];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(28);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-36);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-114);
        make.size.mas_equalTo(CGSizeMake(23, 13));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.imgView.mas_right).offset(6);
        make.right.mas_equalTo(self.statusImgView.mas_left).offset(-17);
    }];
}

@end




