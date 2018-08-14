//
//  UIImage+Rotate.m
//  ISBasic
//
//  Created by yoyokko on 8/11/10.
//  Copyright 2010 IntSig. All rights reserved.
//

#import "UIImage+Rotate.h"

@implementation UIImage (Rotate)

// Edited by MKevin:20101216 
// Use Quartz methods instead of UIKit methods. These UIKit methods are declared
// "You should call this function from the main thread of your application only."
// in the documentation.

- (UIImage *) rotateToOrientation:(UIImageOrientation) targetOrientation
{	
	CGImageRef imgRef = self.CGImage;
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	
	CGFloat boundHeight;
	switch(targetOrientation)
	{
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(width, height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformTranslate(transform, bounds.size.width, 0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			//transform = CGAffineTransformMakeTranslation(0.0, width);
			//transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformTranslate(transform, 0, bounds.size.height);
			transform = CGAffineTransformRotate(transform, -M_PI_2);
			//transform = CGAffineTransformMakeTranslation(height, 0.0);
			//transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
            
		default:
            NSLog(@"Can't rotate the image.");
	}
	
	CGContextRef context = CGBitmapContextCreate(NULL, 
                                                 bounds.size.width,
                                                 bounds.size.height, 
                                                 CGImageGetBitsPerComponent(imgRef),
                                                 0, 
                                                 CGImageGetColorSpace(imgRef), 
                                                 CGImageGetBitmapInfo(imgRef));
	
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
	
	
	CGImageRef newImageRef = CGBitmapContextCreateImage(context);
	UIImage * imageCopy = [UIImage imageWithCGImage:newImageRef];
	
	CGContextRelease(context);
	CGImageRelease(newImageRef);
	
	return imageCopy;
}

@end
