//
//  XWHotNewsTableCell.m
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHotNewsTableCell.h"

@interface XWHotNewsTableCell ()

/** 文章题目*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 右边图*/
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/** 来源和时间*/
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end

@implementation XWHotNewsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

#pragma mark - Setter
- (void)setModel:(XWArticleContentModel *)model{
    _model = model;
    self.titleLabel.text = _model.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.cover]];
    NSString *info = [NSString stringWithFormat:@"来源: %@", _model.wechatname];
    NSString *time = [NSString internalFromCreatTime:_model.createTime formatString:@"yyyy-MM-dd"];
    self.infoLabel.text = [NSString stringWithFormat:@"%@   %@", info, time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
