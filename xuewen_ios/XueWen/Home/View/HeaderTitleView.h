//
//  HeaderTitleView.h
//  XueWen
//
//  Created by ShaJin on 2017/12/7.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderTitleView : UICollectionReusableView
- (void)setTitle:(NSString *)title showIcon:(BOOL)showIcon showMore:(BOOL)show target:(id)target action:(SEL)action;
@end
