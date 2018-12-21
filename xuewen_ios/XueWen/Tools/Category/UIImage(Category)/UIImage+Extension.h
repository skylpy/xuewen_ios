//
//  UIImage+Extension.h
//  Prepare
//
//  Created by Pingzi on 2017/6/6.
//  Copyright © 2017年 张子恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  根据颜色绘制一张纯色Image
 */
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 *  压缩图片
 */
- (NSData *)zip;

// 64base字符串转图片
+ (UIImage *)stringToImage:(NSString *)str;

// 图片转64base字符串
+ (NSString *)imageDataToString:(NSData *)imagedata;
// 图片上画文字
+ (UIImage *)DrawText:(NSString *)text forImage:(UIImage *)image ;
/** 字符串转二维码 */
+ (UIImage *)QRImageWithString:(NSString *)string;
+ (UIImage *)QRImageWithString:(NSString *)string size:(CGFloat)size;
/** 在图片上添加图片 */
- (UIImage *)addImageLogo:(UIImage *)image frame:(CGRect)frame;

/** 压缩图片到指定大小*/
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;
/** view 生成图片*/
- (UIImage *)screenshotForView:(UIView *)view;

//绘制带圆角的视图 （实现要通过GCD）
- (UIImage *)drawCircleImage;

//UIView 转化为Image
+ (UIImage *)imageViewView:(UIView *)view;

@end
