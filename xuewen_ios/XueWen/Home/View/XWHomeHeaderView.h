//
//  XWHomeHeaderView.h
//  XueWen
//
//  Created by Karron Su on 2018/7/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWHomeHeaderView : UIView

- (void)setTitle:(NSString *)title showMoreBtn:(BOOL)show btnAction:(SEL)action target:(id)target iconName:(NSString *)icon;

@end
