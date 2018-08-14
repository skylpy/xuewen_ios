//
//  HomeSectionHeaderView.h
//  XueWen
//
//  Created by ShaJin on 2017/12/4.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSectionHeaderView : UITableViewHeaderFooterView

- (void)setTitle:(NSString *)title showMore:(BOOL)show target:(id)target action:(SEL)action;

@end
