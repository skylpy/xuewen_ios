//
//  XWHomeNTopCell.m
//  XueWen
//
//  Created by Karron Su on 2018/10/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeNTopCell.h"

@interface XWHomeNTopCell()
@property (weak, nonatomic) IBOutlet UIButton *zcjyButton;
@property (weak, nonatomic) IBOutlet UIButton *hygsButton;
@property (weak, nonatomic) IBOutlet UIButton *cjzjButton;

@end

@implementation XWHomeNTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self)
    [[self.zcjyButton rac_signalForControlEvents:UIControlEventTouchUpInside]  subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(homeNTopSelectIndex:)]) {
            
            [self.delegate homeNTopSelectIndex:ZCJYTYPE];
        }
    }];
    
    [[self.hygsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(homeNTopSelectIndex:)]) {
            
            [self.delegate homeNTopSelectIndex:HYGSTYPE];
        }
    }];
    
    [[self.cjzjButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(homeNTopSelectIndex:)]) {
            
            [self.delegate homeNTopSelectIndex:CJZJTYPE];
        }
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
