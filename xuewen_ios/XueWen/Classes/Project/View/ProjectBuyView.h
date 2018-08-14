//
//  ProjectBuyView.h
//  XueWen
//
//  Created by ShaJin on 2018/1/25.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectBuyView : UIView

/** 优惠价*/
@property (nonatomic, strong) NSString *price;
/** 原价*/
@property (nonatomic, strong) NSString *originalPrice;

- (instancetype)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

@end
