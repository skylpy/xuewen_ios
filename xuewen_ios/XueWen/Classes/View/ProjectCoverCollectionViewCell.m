//
//  ProjectCoverCollectionViewCell.m
//  XueWen
//
//  Created by ShaJin on 2018/1/24.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ProjectCoverCollectionViewCell.h"
@interface ProjectCoverCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation ProjectCoverCollectionViewCell
- (void)setImage:(NSString *)image{
    _image = image;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:LoadImage(@"default_cover")];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        self.imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}
@end
