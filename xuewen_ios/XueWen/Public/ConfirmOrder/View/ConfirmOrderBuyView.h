//
//  ConfirmOrderBuyView.h
//  XueWen
//
//  Created by ShaJin on 2018/3/7.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderBuyView : UIView

- (void)setCanBuy:(BOOL)canBuy price:(NSString *)price;
- (instancetype)initWithTarget:(id)target action:(SEL)action;

@end
