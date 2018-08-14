//
//  ClassesHeaderReusableView.m
//  XueWen
//
//  Created by ShaJin on 2018/1/23.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ClassesHeaderReusableView.h"
@interface ClassesHeaderReusableView()

@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation ClassesHeaderReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        self.imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 15, 8, 15));
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = LoadImage(@"banner3.jpg");
    }
    return _imageView;
}

- (void)setImageURL:(NSString *)imageURL{
    _imageURL = imageURL;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
}
@end
