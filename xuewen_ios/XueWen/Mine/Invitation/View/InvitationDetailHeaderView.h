//
//  InvitationDetailHeaderView.h
//  XueWen
//
//  Created by ShaJin on 2018/3/20.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 邀请明细头部视图，现整合到
#import <UIKit/UIKit.h>

@interface InvitationDetailHeaderView : UIView

@property (nonatomic, copy) void (^CompleteBlock)(NSString *date);

@end
