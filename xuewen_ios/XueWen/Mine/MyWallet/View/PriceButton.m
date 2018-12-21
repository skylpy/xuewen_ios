//
//  PriceButton.m
//  XueWen
//
//  Created by ShaJin on 2017/12/7.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "PriceButton.h"
@interface PriceButton()

@property (nonatomic, strong) UIImageView *selectImg;

@end
@implementation PriceButton
- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.selectImg];
    self.selectImg.sd_layout.rightSpaceToView(self,0).bottomSpaceToView(self,0).widthIs(15).heightIs(15);
    self.layer.borderWidth = 1;
}

- (UIImageView *)selectImg{
    if (!_selectImg) {
        _selectImg = [UIImageView new];
        _selectImg.image = LoadImage(@"sortSelected");
    }
    return _selectImg;
}

- (void)setPrice:(NSInteger)price{
    _price = price;
    [self setTitle:[NSString stringWithFormat:@"%ld学币",(long)price] forState:UIControlStateNormal];
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.selectImg.hidden = !isSelect;
    self.layer.borderColor = isSelect ? kThemeColor.CGColor : COLOR(204, 204, 204).CGColor;
    self.titleLabel.textColor = isSelect ? kThemeColor : DefaultTitleAColor;
}
@end
