//
//  XWHeaderTitleView.h
//  XueWen
//
//  Created by Karron Su on 2018/4/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWHeaderTitleView : UIView

- (void)setTitle:(NSString *)title showMoreBtn:(BOOL)show btnAction:(SEL)action target:(id)target;

@end
