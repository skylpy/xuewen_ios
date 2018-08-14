//
//  XWHomeFreeCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeFreeCell.h"
#import "UIButton+WebCache.h"

@interface XWHomeFreeCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation XWHomeFreeCell

#pragma mark - Getter
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleToFill;
        [_imgView rounded:3];
    }
    return _imgView;
}


#pragma mark - lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.separatorInset = UIEdgeInsetsMake(0, kWidth, 0, 0);
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imgView];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(25);
        make.right.mas_equalTo(self).offset(-25);
        make.size.mas_equalTo(CGSizeMake(kWidth-50, (kWidth-50)*0.44));
        make.top.mas_equalTo(self).offset(15);
    }];
    
}

#pragma mark - Setter
- (void)setModel:(XWCourseIndexModel *)model{
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll] placeholderImage:nil];
}

@end
