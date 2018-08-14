//
//  UITableViewCell+Line.h
//  XueWen
//
//  Created by ShaJin on 2018/1/6.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Line)
- (void)setIsFirst:(BOOL)isFirst;
- (void)setIsFirst:(BOOL)isFirst leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpage;
- (void)setIsFirst:(BOOL)isFirst r:(int)r g:(int)g b:(int)b a:(CGFloat)a;
- (void)setIsFirst:(BOOL)isFirst r:(int)r g:(int)g b:(int)b a:(CGFloat)a leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpage;
@end

