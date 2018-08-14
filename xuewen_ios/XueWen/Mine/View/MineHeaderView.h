//
//  MineHeaderView.h
//  XueWen
//
//  Created by Pingzi on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *signLB;
- (instancetype)initWithFrame:(CGRect)frame target:(id)target infoAction:(SEL)infoAction setAction:(SEL)setAction;
- (void)refresh;

@end
