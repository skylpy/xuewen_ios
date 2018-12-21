//
//  XWQRCodeView.h
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWQRCodeView : UIView

+ (instancetype)shareCodeView;
- (void)showFromView:(UIView *)superView;
//二维码
@property (weak, nonatomic) IBOutlet UIImageView *rqCodeImage;

@end
