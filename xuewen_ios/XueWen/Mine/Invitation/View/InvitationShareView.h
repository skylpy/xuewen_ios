//
//  InvitationShareView.h
//  XueWen
//
//  Created by ShaJin on 2018/3/9.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "BaseAlertView.h"
@protocol InvitationShareViewDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface InvitationShareView : BaseAlertView

+ (instancetype)shareViewWithDelegate:(id<InvitationShareViewDelegate>)delegate;

@end
