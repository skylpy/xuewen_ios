//
//  XWNotesTableCell.m
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNotesTableCell.h"

@interface XWNotesTableCell ()

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation XWNotesTableCell

#pragma mark - Lazy / Getter
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        [_headImgView rounded:20];
    }
    return _headImgView;
}

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = Color(@"#333333");
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:kRegFont size:14];
        label.text = @"会飞的鱼";
        _nickLabel = label;
    }
    return _nickLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = Color(@"#333333");
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:kRegFont size:13];
        label.text = @"中国中小企业的管理咨询专家、著名培训导师、资深管理顾问，中山大学、南昌大学、宁波科技大学等多所知名大学特聘讲师，多家大型企业常年顾问。";
        label.numberOfLines = 0;
        _contentLabel = label;
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = Color(@"#9C9C9C");
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:kMedFont size:13];
        label.text = @"2018-4-23";
        _timeLabel = label;
    }
    return _timeLabel;
}

#pragma mark - Setter
- (void)setCommentModel:(XWCommentModel *)commentModel{
    _commentModel = commentModel;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_commentModel.pictureAll] placeholderImage:DefaultImage];
    self.nickLabel.text = _commentModel.nickName;
    self.timeLabel.text = [_commentModel.createTime translateDateFormatter:@"yyyy-MM-dd"];
    self.contentLabel.text = _commentModel.comment;
}

- (void)setNoteModel:(XWNotesModel *)noteModel{
    _noteModel = noteModel;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_noteModel.pictureAll] placeholderImage:DefaultImage];
    self.nickLabel.text = _noteModel.nickName;
    self.timeLabel.text = [_noteModel.createTime translateDateFormatter:@"yyyy-MM-dd"];
    self.contentLabel.text = _noteModel.noteContent;
}


#pragma mark - initUI

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

-(void)drawUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.headImgView];
    [self.contentView addSubview:self.nickLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(26);
        make.top.mas_equalTo(self.contentView).offset(8);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImgView.mas_right).offset(18);
        make.centerY.mas_equalTo(self.headImgView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-25);
        make.top.mas_equalTo(self.contentView).offset(22);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(61);
        make.bottom.mas_equalTo(self.contentView).offset(-17);
        make.left.mas_equalTo(self.contentView).offset(26);
        make.right.mas_equalTo(self.contentView).offset(-34);
    }];
    
    
}

@end
