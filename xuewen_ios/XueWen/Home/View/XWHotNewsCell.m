//
//  XWHotNewsCell.m
//  XueWen
//
//  Created by Karron Su on 2018/4/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHotNewsCell.h"

@interface XWHotNewsCell ()

/** 资讯名称*/
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
/** 时间*/
@property (weak, nonatomic) IBOutlet UILabel *timeLab;


@end

@implementation XWHotNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter
- (void)setModel:(XWArticleModel *)model{
    _model = model;
    self.titleLab.text = _model.title;
    self.timeLab.text = [NSString internalFromCreatTime:_model.createTime formatString:@"yyyy-MM-dd"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
