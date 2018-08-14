//
//  HomeHeaderView.h
//  XueWen
//
//  Created by Pingzi on 2017/11/14.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWGradientView.h"
@interface HomeHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *userNameLB;
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *companyLB;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) XWGradientView *gradientView;

@property (weak, nonatomic) IBOutlet UIButton *headerButton;


@end
