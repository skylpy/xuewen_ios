//
//  ProjectCell.m
//  XueWen
//
//  Created by ShaJin on 2018/1/24.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ProjectCell.h"

@implementation ProjectCell
- (void)setModel:(ProjectModel *)model{
    [super setModel:model];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:LoadImage(@"default_cover")];
    self.imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(10, 15, 0, 15));
}
@end
