//
//  UIImage+VideoImage.h
//  happyselling
//
//  Created by ShaJin on 2017/9/20.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (VideoImage)
// 获取视频在指定时间的截图
+ (UIImage *) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
// 获取视频在第0秒的截图
+ (UIImage *)thumbnailImageForVideo:(NSString *)videoURL;
@end
