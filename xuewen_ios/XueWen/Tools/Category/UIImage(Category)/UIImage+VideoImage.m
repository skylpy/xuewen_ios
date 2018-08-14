//
//  UIImage+VideoImage.m
//  happyselling
//
//  Created by ShaJin on 2017/9/20.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import "UIImage+VideoImage.h"
#import <AVFoundation/AVFoundation.h>
@implementation UIImage (VideoImage)
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

+ (UIImage *)thumbnailImageForVideo:(NSString *)videoURL{
    static NSMutableDictionary *imgDict ;
    if (imgDict) {
        UIImage *image = imgDict[videoURL];
        if (image) {
            return image;
        }
    }else{
        imgDict = [NSMutableDictionary dictionary];
    }
    UIImage *image = [self thumbnailImageForVideo:[NSURL URLWithString:videoURL] atTime:0];
    if (image) {
        [imgDict  setObject:image forKey:videoURL];
    }
    return image;
}
//-(instancetype)initWithVideo:(NSString *)videoURL completBlock:(void(^)())completeBlock
// 根据传入的图片名经转换之后返回本地对应的图片
//+ (UIImage *) imageWithName:(NSString *)imageName{
//    
//}
@end
