// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
#import <UIKit/UIKit.h>
@interface UIImage (Resize)

- (UIImage *) croppedImageWithPercentX:(float) xp Y:(float) yp W:(float) wp H:(float) hp;

- (UIImage *) croppedImage:(CGRect) bounds;

- (UIImage *) resizedImage:(CGSize) newSize
      interpolationQuality:(CGInterpolationQuality) quality;

- (UIImage *) resizedAspectFitImage:(CGSize) newSize
               interpolationQuality:(CGInterpolationQuality) quality;

- (UIImage *) resizedImageWithContentMode:(UIViewContentMode) contentMode
                                   bounds:(CGSize) bounds
                     interpolationQuality:(CGInterpolationQuality) quality;

- (UIImage *) resizedImage:(CGSize) newSize
                 transform:(CGAffineTransform) transform
            drawTransposed:(BOOL) transpose
      interpolationQuality:(CGInterpolationQuality) quality;

- (CGAffineTransform) transformForOrientation:(CGSize) newSize;

//- (UIImage *)fixOrientation;
- (UIImage *)fixOrientationToRight;
- (UIImage *)fixOrientationToLeft;

@end
