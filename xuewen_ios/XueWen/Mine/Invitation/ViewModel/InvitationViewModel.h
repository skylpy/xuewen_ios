//
//  InvitationViewModel.h
//  XueWen
//
//  Created by ShaJin on 2018/3/15.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitationViewModel : NSObject
/** 获取邀请二维码 */
- (void)getInvitationQRViewWithCompleteBlock:(void (^)(UIImage *QRImage,NSString *url))completeBlock;

@end
