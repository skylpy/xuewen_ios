//
//  XWQRCodeView.m
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWQRCodeView.h"

@implementation XWQRCodeView

+ (instancetype)shareCodeView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"QRCodeView" owner:self options:nil] firstObject];
}

- (void)showFromView:(UIView *)superView {
    
    self.frame = CGRectMake(0, superView.frame.size.height-100, kWidth, 100);
    [superView addSubview:self];
}

@end
