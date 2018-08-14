//
//  UIImageView+Extension.m
//  Prepare
//
//  Created by Pingzi on 2017/6/7.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)


/**
 @param mode when nil is UIViewContentModeScaleToFill
 */
+ (instancetype)creatImageVWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h normalImgName:(NSString *)nIName contentMode:(UIViewContentMode)mode
{
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:nIName];
    imageV.frame = CGRectMake(x, y, w, h);
    imageV.contentMode = mode ? : UIViewContentModeScaleToFill;
    return imageV;
}
@end
