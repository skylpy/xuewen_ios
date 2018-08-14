//
//  XWHistoryTableCell.m
//  XueWen
//
//  Created by Karron Su on 2018/6/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHistoryTableCell.h"

@interface XWHistoryTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation XWHistoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XWHistoryInfoModel *)model{
    _model = model;
    self.timeLabel.text = _model.creatTime;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分", _model.fraction];
    self.label.text = _model.rangeName;
    if ([_model.rangeName isEqualToString:@"一般"]) {
        self.label.textColor = Color(@"#E91040");
    }else if ([_model.rangeName isEqualToString:@"良好"]){
        self.label.textColor = Color(@"#5D00E9");
    }else if ([_model.rangeName isEqualToString:@"较好"]){
        self.label.textColor = Color(@"#20CE24");
    }else if ([_model.rangeName isEqualToString:@"优秀"]){
        self.label.textColor = Color(@"#00A0E9");
    }else if ([_model.rangeName isEqualToString:@"及格"]){
        self.label.textColor = Color(@"#CF17CD");
    }else if ([_model.rangeName isEqualToString:@"杰出"]){
        self.label.textColor = Color(@"#FEAA17");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
