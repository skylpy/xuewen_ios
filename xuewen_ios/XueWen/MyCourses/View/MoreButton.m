//
//  MoreButton.m
//  XueWen
//
//  Created by ShaJin on 2017/12/7.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MoreButton.h"

@implementation MoreButton
- (void)layoutSubviews{
    CGFloat width = [@"更多" widthWithSize:13];
    self.titleLabel.font = kFontSize(13);
    self.titleLabel.frame = CGRectMake(self.width - 7 - 4  - width, 0, width, 13);
    self.imageView.frame = CGRectMake(self.width - 7 , 0, 7, 12);
    self.imageView.image = LoadImage(@"home_ico_arrow");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
