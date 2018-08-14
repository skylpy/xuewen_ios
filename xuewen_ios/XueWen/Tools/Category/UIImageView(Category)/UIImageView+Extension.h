//
//  UIImageView+Extension.h
//  Prepare
//
//  Created by Pingzi on 2017/6/7.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

/**
 @param mode when nil is UIViewContentModeScaleToFill
 */
+ (instancetype)creatImageVWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h normalImgName:(NSString *)nIName contentMode:(UIViewContentMode)mode;



@end
