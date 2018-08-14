//
//  InvitationHeaderView.h
//  XueWen
//
//  Created by ShaJin on 2018/3/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitationHeaderView : UIView

@property (nonatomic, copy) void(^CompleteBlock)(NSString *date);

- (void)setCount:(NSInteger)count money:(NSString *)money;

@end
