//
//  XWArticleTitleView.m
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWArticleTitleView.h"


@interface XWArticleTitleView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end

@implementation XWArticleTitleView

#pragma mark - Setter
- (void)setModel:(XWArticleContentModel *)model{
    _model = model;
    self.titleLabel.text = _model.title;
    NSString *info = [NSString stringWithFormat:@"来源: %@", _model.wechatname];
    NSString *time = [NSDate dateFormTimestamp:_model.updateTime withFormat:@"yyyy-MM-dd"];
    self.infoLabel.text = [NSString stringWithFormat:@"%@   %@", info, time];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
