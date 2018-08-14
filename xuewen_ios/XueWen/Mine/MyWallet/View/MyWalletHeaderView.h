//
//  MyWalletHeaderView.h
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletHeaderView : UIImageView

@property (nonatomic, strong) NSString *money;

- (instancetype)initWithTarget:(id)target backAction:(SEL)backAction detailAction:(SEL)detailAction;

@end
